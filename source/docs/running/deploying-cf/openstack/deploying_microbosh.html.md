---
title: Deploying Micro BOSH
---

Installation of BOSH is done using micro BOSH, which is a single VM that includes all of the [BOSH components](/docs/running/bosh/components/index.html). If you want to play around with BOSH, or create a simple development setup, you can install micro BOSH using the BOSH Deployer. If you would like to use BOSH in production to manage a distributed system, you also use the BOSH Deployer, install micro BOSH, and then use it as a means to deploy the final distributed system on multiple VMs.

A good way to think about this two step process is to consider that BOSH is a distributed system in itself. Since BOSH's core purpose is to deploy and manage distributed systems, it makes sense that we would use it to deploy itself. On the BOSH team, we gleefully refer to this as [Inception](http://en.wikipedia.org/wiki/Inception).

## <a id="prerequisites"></a>Prerequisites ##

### <a id="bosh_cli"></a>BOSH CLI ###

Install the [BOSH CLI](/docs/running/bosh/setup/index.html).

### <a id="openstack_services"></a>OpenStack Services ###

Micro BOSH needs a running OpenStack environment. Only [Folsom](https://wiki.openstack.org/wiki/ReleaseNotes/Folsom) and [Grizzly](https://wiki.openstack.org/wiki/ReleaseNotes/Grizzly) OpenStack releases are supported.

You will need access to these OpenStack services:

* [Identity](http://www.openstack.org/software/openstack-shared-services/): Micro BOSH will authenticate your credentials trought the identity server and get the endpoint URLs for other OpenStack services.
* [Compute](http://www.openstack.org/software/openstack-compute/): Micro BOSH will boot new vms, assign floating IPs to vm, and create and attach volumes to vms.
* [Image](http://www.openstack.org/software/openstack-shared-services/): Micro BOSH will update new images (called [BOSH Stemcells](/docs/running/bosh/components/stemcell.html) in BOSH terminology).

Although the new [OpenStack Networking](http://www.openstack.org/software/openstack-networking/) service is not required, it is recommended if you want to deploy complex distributed systems.

### <a id="openstack_security_groups"></a>OpenStack Security Groups ###

Ensure that you have created the [Security Groups required](/docs/running/deploying-cf/common/security_groups.html).

The ports required for bosh are:

* All ports (from `1` to `65535`) where the source group is the current security group
* Port `22` from source 0.0.0.0/0 (CIDR): Used for inbound SSH access
* Port `53` from source 0.0.0.0/0 (CIDR): Used for inbound DNS requests
* Port `4222` from source 0.0.0.0/0 (CIDR): Used by [NATS](/docs/running/bosh/components/messaging.html)
* Port `6868` from source 0.0.0.0/0 (CIDR): Used by [BOSH Agent](/docs/running/bosh/components/agent.html)
* Port `25250` from source 0.0.0.0/0 (CIDR): Used by [BOSH Blobstore](/docs/running/bosh/components/blobstore.html)
* Port `25555` from source 0.0.0.0/0 (CIDR): Used by [BOSH Director](/docs/running/bosh/components/director.html)
* Port `25777` from source 0.0.0.0/0 (CIDR): Used by BOSH Registry

### <a id="openstack_keypairs"></a>OpenStack Key pairs ###

Create or import a new OpenStack keypair, name it ie `microbosh`. Store the private key in a well know location, as we will need it to deploy Micro BOSH.

### <a id="openstack_validate"></a>Validate your OpenStack ###

[Validate](validate_openstack.html) your target OpenStack environment in preparation for installing Micro BOSH.

## <a id="deploy_microbosh"></a>Deploying Micro BOSH ##

### <a id="manifest_file"></a>Create manifest file ###

Create a `deployments` directory to store your deployment manifest files:

<pre class="terminal">
mkdir -p ~/bosh-workspace/deployments/microbosh-openstack
cd ~/bosh-workspace/deployments/microbosh-openstack
</pre>

Create a `micro_bosh.yml` file and copy the below content:

~~~yaml
---
name: microbosh-openstack

logging:
  level: DEBUG

network:
  type: manual
  vip: <allocated_floating_ip> # Optional
  ip: <static_ip>
  cloud_properties:
    net_id: <network_uuid>

resources:
  persistent_disk: 16384
  cloud_properties:
    instance_type: <flavor_name>

cloud:
  plugin: openstack
  properties:
    openstack:
      auth_url: http://<identity_server>:5000/v2.0
      username: <username>
      api_key: <password>
      tenant: <tenant>
      region: <region> # Optional
      default_security_groups: ["ssh", "bosh"]
      default_key_name: <microbosh_keypair>
      private_key: <path_to_microbosh_keypar_private_key>

apply_spec:
  properties:
    director:
      max_threads: 3
    hm:
      resurrector_enabled: true
    ntp:
      - 0.north-america.pool.ntp.org
      - 1.north-america.pool.ntp.org
~~~

Adapt the `micro_bosh.yml` file to your environment settings:

#### <a id="network_properties"></a>Network properties ####

This section sets the network configuration for your Micro BOSH.

If you are using nova-network, adapt the network section with below settings:

~~~yaml
network:
  type: dynamic
  vip: <allocated_floating_ip> # Optional
~~~

* The `vip` option is optional, and allows you to associate a floating IP adress to the Micro Bosh vm in case you want to access it from outside of the vm network. If set, `allocated_floating_ip` **must** be a previously allocated floating ip.

If you are using the new [OpenStack Networking](http://www.openstack.org/software/openstack-networking/) component, adapt the network section with below settings:

1. If your network has DHCP enabled, you can let OpenStack pick an IP address:

~~~yaml
network:
  type: dynamic
  vip: <allocated_floating_ip> # Optional
  cloud_properties:
    net_id: <network_uuid>
~~~

* The `vip` option is optional, and allows you to associate a floating IP adress to the Micro Bosh vm in case you want to access it from outside of the vm network. If set, `allocated_floating_ip` **must** be a previously allocated floating ip.
* The `net_id` option sets the OpenStack network to use. `network_uuid` **must** be an existing Network UUID (you can list your OpenStack networks using the command `quantum net-list`).

1. If you want to set the Micro Bosh IP address manually:

~~~yaml
network:
  type: manual
  vip: <allocated_floating_ip> # Optional
  ip: <static_ip>
  cloud_properties:
    net_id: <network_uuid>
~~~

* The `vip` option is optional, and allows you to associate a floating IP adress to the Micro Bosh vm in case you want to access it from outside of the vm network. If set, `allocated_floating_ip` **must** be a previously allocated floating ip.
* The `ip` option sets the IP address to assign to the Micro BOSH vm. `static_ip` **must** be an IP address belowing to the IP range of one of the network subnets set in `net_id`.
* The `net_id` option sets the OpenStack network to use. `network_uuid` **must** be an existing Network UUID (you can list your OpenStack networks using the command `quantum net-list`).

#### <a id="resources_properties"></a>Resources properties ####

This section sets the resources configuration for your Micro Bosh.

~~~yaml
resources:
  persistent_disk: 16384
  cloud_properties:
    instance_type: <flavor_name>
~~~

* The `persistent_disk` indicates that a new 16Gb volume will be created and attached to the Micro BOSH vm. On this disk, Micro BOSH will store the data, so in case you reboot or when upgrading the Micro BOSH vm, no data will be lost.
* The `instance_type` set the OpenStack flavor used for the Micro BOSH vm. The `flavor_name` **must** have ephemeral disk (check the [validate your OpenStack](validate_openstack.html#ephemeral) guide)

#### <a id="cloud_properties"></a>Cloud properties ####

This section sets the cloud configuration for your Micro BOSH.

~~~yaml
cloud:
  plugin: openstack
  properties:
    openstack:
      auth_url: http://<identity_server>:5000/v2.0
      username: <username>
      api_key: <password>
      tenant: <tenant>
      region: <region> # Optional
      default_security_groups: ["default", <microbosh_security_group>]
      default_key_name: <microbosh_keypair>
      private_key: <path_to_microbosh_keypar_private_key>
~~~

* The `auth_url` option set your [OpenStack identity](http://www.openstack.org/software/openstack-shared-services/) server.
* The `username`, `api_key` and `tenant` options sets your OpenStack credentials.
* The `region` option is optional, and allows you to set the OpenStack region to be used.
* The `default_security_groups` option set the security groups used by Micro BOSH. The `microbosh_security_group` **must** be an existing security group (check the [prerequisites](#openstack_security_groups) section).
* The `default_key_name` and `private_key` options sets the key pair used by Micro BOSH. The `microbosh_keypair` **must** be an existing keypair (check the [prerequisites](#openstack_keypairs) section).

#### <a id="apply_spec_properties"></a>Apply Spec properties ####

This section sets the specification configuration for your Micro BOSH.

~~~yaml
apply_spec:
  properties:
    director:
      max_threads: 3
    hm:
      resurrector_enabled: true
    ntp:
      - 0.north-america.pool.ntp.org
      - 1.north-america.pool.ntp.org
~~~

* The `properties` option allows you to add or override the settings to be applied to your Micro BOSH (by default it will use the [micro](https://github.com/cloudfoundry/bosh/blob/master/release/micro/openstack.yml) apply spec).

In this example we add/override several properties:

* `director.max_threads` sets the number of concurrent threads Micro BOSH [director](/docs/running/bosh/components/director.html) will use to perform some actions (ie: the number of parallel `create vm` tasks), so set this option according to your OpenStack environment (if not set, the default is 32 concurrent threads).
* `hm.resurrector_enabled` enables the [BOSH Health Monitor](/docs/running/bosh/components/health-monitor.html) resurrector plugin. This plugin will lookup for jobs in a down state, and will try to resurrect (bring up) them.
* `ntp` sets the [Internet Time Servers](http://www.ntp.org/) to be used to synchronize the clocks of new vms.

### <a id="download_stemcell"></a>Download Micro BOSH stemcell ###

Create a `stemcells` directory to store your stemcell files:

<pre class="terminal">
mkdir -p ~/bosh-workspace/stemcells
cd ~/bosh-workspace/stemcells
</pre>

Download the latest OpenStack Micro BOSH stemcell:

<pre class="terminal">
$ bosh public stemcells
+---------------------------------------------+
| Name                                        |
+---------------------------------------------+
| bosh-stemcell-1365-aws-xen-ubuntu.tgz       |
| light-bosh-stemcell-1365-aws-xen-ubuntu.tgz |
| bosh-stemcell-1365-openstack-kvm-ubuntu.tgz |
| bosh-stemcell-1365-vsphere-esxi-ubuntu.tgz  |
| bosh-stemcell-1365-vsphere-esxi-centos.tgz  |
+---------------------------------------------+
To download use `bosh download public stemcell <stemcell_name>'. For full url use --full.

$ bosh download public stemcell bosh-stemcell-XXXX-openstack-kvm-ubuntu.tgz
</pre>

### <a id="deploy"></a>Deploy Micro BOSH ###

Set the Micro BOSH deployment file to use:

<pre class="terminal">
cd ~/bosh-workspace/deployments
bosh micro deployment microbosh-openstack
</pre>

This command will output:

    WARNING! Your target has been changed to `https://<microbosh_ip_address>:25555'!
    Deployment set to '~/bosh-workspace/deployments/microbosh-openstack/micro_bosh.yml'

Deploy the Micro BOSH:

<pre class="terminal">
bosh micro deploy ~/bosh-workspace/stemcells/bosh-stemcell-XXXX-openstack-kvm-ubuntu.tgz
</pre>

This command will output:

    Deploying new micro BOSH instance `microbosh-openstack/micro_bosh.yml' to `https://<microbosh_ip_address>:25555' (type 'yes' to continue): yes

    Verifying stemcell...
    File exists and readable                                     OK
    Manifest not found in cache, verifying tarball...
    Read tarball                                                 OK
    Manifest exists                                              OK
    Stemcell image file                                          OK
    Writing manifest to cache...
    Stemcell properties                                          OK

    Stemcell info
    -------------
    Name:    bosh-openstack-kvm-ubuntu
    Version: 1029


    Deploy Micro BOSH
      unpacking stemcell (00:00:02)
      uploading stemcell (00:00:35)
      creating VM from 04a1bdfe-4479-492e-8622-54380032a13a (00:01:21)
      waiting for the agent (00:01:20)
      create disk (00:00:05)
      mount disk (00:00:14)
      stopping agent services (00:00:01)
      applying micro BOSH spec (00:00:16)
      starting agent services (00:00:00)
      waiting for the director (00:00:15)
    Done                    11/11 00:04:19
    WARNING! Your target has been changed to `https://<microbosh_ip_address>:25555'!
    Deployment set to '~/bosh-workspace/deployments/microbosh-openstack/micro_bosh.yml'
    Deployed `microbosh-openstack/micro_bosh.yml' to `https://<microbosh_ip_address>:25555', took 00:04:19 to complete

### <a id="troubleshooting"></a>Troubleshooting ###

If for some reason the deploy process gets stucked or fails, you can check the log file located at `~/bosh-workspace/deployments/microbosh-openstack/bosh_micro_deploy.log`:

    # Logfile created on 2013-06-14 13:02:00 +0200 by logger.rb/31641
    I, [2013-06-14T13:02:00.661999 #11533] [0x12b6ff0]  INFO -- : No existing deployments found (will save to /Users/frodenas/deployments/bosh-deployments.yml)
    I, [2013-06-14T13:02:26.993498 #13692] [0x366ff0]  INFO -- : No existing deployments found (will save to /Users/frodenas/deployments/bosh-deployments.yml)
    I, [2013-06-14T13:03:10.489924 #13692] [0x366ff0]  INFO -- : bosh_registry is ready on port 25889
    I, [2013-06-14T13:03:13.135552 #13692] [0x366ff0]  INFO -- : Loading yaml from /tmp/d20130614-13692-15wkgqb/sc-20130614-13692-7eo4zq/stemcell.MF
    I, [2013-06-14T13:03:19.602096 #13692] [create_stemcell(/tmp/d20130614-13692-15wkgqb/sc-20130614-13692-7eo4zq/image...)]  INFO -- : Creating new image...
    I, [2013-06-14T13:03:19.602298 #13692] [create_stemcell(/tmp/d20130614-13692-15wkgqb/sc-20130614-13692-7eo4zq/image...)]  INFO -- : Extracting stemcell file to `/tmp/d20130614-13692-15wkgqb/d20130614-13692-2sfodm'...

    ...

    D, [2013-06-14T13:07:36.134753 #13692] [0x366ff0] DEBUG -- : Waiting for director to be ready: #<Errno::ECONNREFUSED: Connection refused - connect(2) (https://<microbosh_ip_address>:25555)>
    I, [2013-06-14T13:07:36.171820 #13692] [0x366ff0]  INFO -- : Director is ready: {"name"=>"microbosh-openstack", "uuid"=>"fd581363-02cd-41c6-8bed-87780391cff7", "version"=>"1.5.0.pre.3 (release:bef17df0 bosh:bef17df0)", "user"=>nil, "cpi"=>"openstack", "features"=>{"dns"=>
    {"status"=>true, "extras"=>{"domain_name"=>"microbosh"}}, "compiled_package_cache"=>{"status"=>false, "extras"=>{"provider"=>nil}}}

## <a id="test_microbosh"></a>Testing your Micro BOSH ##

### <a id="microbosh_target"></a>Set target ###

To set your Micro BOSH target use the `target` command:

<pre class="terminal">
bosh target &lt;microbosh_ip_address&gt;
</pre>

This command will ask for the admin credentials. Enter `admin` when prompted for both `username` and `password`.

    Target set to `microbosh-openstack'
    Your username: admin
    Enter password: *****
    Logged in as `admin'

### <a id="microbosh_create_user"></a>Create a new user ###

To create a new user use the `create user` command:

<pre class="terminal">
bosh create user
Enter new username: frodenas
Enter new password: ********
Verify new password: ********
User `frodenas' has been created
</pre>

Then you can login with the new user credentials:

<pre class="terminal">
bosh login
Your username: frodenas
Enter password: ********
Logged in as `frodenas'
</pre>

The `admin` user will be deleted.

### <a id="microbosh_status"></a>Check status ###

To check the status of your Micro BOSH use the `status` command:

<pre class="terminal">
bosh status
</pre>

This command will output:

    Config
                 /Users/frodenas/.bosh_config

    Director
      Name       microbosh-openstack
      URL        https://<microbosh_ip_address>:25555
      Version    1.5.0.pre.3 (release:bef17df0 bosh:bef17df0)
      User       frodenas
      UUID       fd581363-02cd-41c6-8bed-87780391cff7
      CPI        openstack
      dns        enabled (domain_name: microbosh)
      compiled_package_cache disabled

    Deployment
      not set

### <a id="microbosh_ssh"></a>SSH ###

You can ssh to your Micro BOSH vm using the private key set at the [cloud properties](#cloud_properties) section of your Micro BOSH deployment file:

<pre class="terminal">
ssh -i &lt;path_to_microbosh_keypar_private_key&gt; vcap@&lt;microbosh_ip_address&gt;
</pre>

Then you can sudo to get root privileges (default password for root user is `c1oudc0w`). All BOSH data is located at `/var/vcap` directory.

If you want to change the default root password, add this section at the [manifest](#manifest_file) file before deploying Micro BOSH:

~~~yaml
env:
  bosh:
    password: <hash_password>
~~~

* `hash_password` **must** be a [sha-512](https://en.wikipedia.org/wiki/SHA-2) hashed password (You can generate it using the [mkpasswd](https://www.mkpasswd.net/) utility).

## <a id="delete_microbosh"></a>Deleting your Micro BOSH ##

If you want to delete your Micro BOSH environment (vm, persistent disk and stemcell) use the `micro delete` command:

<pre class="terminal">
cd ~/bosh-workspace/deployments
bosh micro delete
</pre>

This command will output:

    You are going to delete micro BOSH deployment `microbosh-openstack'.

    THIS IS A VERY DESTRUCTIVE OPERATION AND IT CANNOT BE UNDONE!

    Are you sure? (type 'yes' to continue): yes

    Delete micro BOSH
      stopping agent services (00:00:01)
      unmount disk (00:00:06)
      detach disk (00:00:06)
      delete disk (00:02:25)
      delete VM (00:00:10)
      delete stemcell (00:00:03)
    Done                    7/7 00:02:53
    Deleted deployment 'microbosh-openstack', took 00:02:53 to complete
