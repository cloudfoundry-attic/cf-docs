---
title: Deploying BOSH with Micro BOSH
---

This guide describes the process for deploying BOSH as an application using micro BOSH.

## <a id="prerequisites"></a>Prerequisites ##

### <a id="microbosh"></a>Micro BOSH ###

Micro BOSH should be deployed and targeted. See the steps in [Deploying Micro BOSH](deploying_microbosh.html).

### <a id="stemcell"></a>BOSH Stemcell ###

A BOSH Stemcell should be uploaded to the Micro BOSH. See the steps in [Uploading a BOSH Stemcell](uploading_bosh_stemcell.html).

### <a id="openstack_floating_ip"></a>OpenStack Floating IPs ###

Allocate two new OpenStack Floating IP to your project. We will use it to access our Bosh Director and PowerDNS instances from outside of our network.

## <a id="deploy_bosh"></a>Deploying BOSH ##

### <a id="create_release"></a>Create BOSH Release ###

Download the BOSH [source code](https://github.com/cloudfoundry/bosh):

<pre class="terminal">
cd ~/bosh-workspace
git clone git://github.com/cloudfoundry/bosh.git
</pre>

Create a new development BOSH Release:

<pre class="terminal">
cd ~/bosh-workspace/bosh
bundle install --local
bundle exec rake release:create_dev_release
</pre>

This command will output:

    bosh create release --force
    Syncing blobs...

    Building DEV release
    ---------------------------------

    ....

    Release version: 13.1-dev
    Release manifest: /Users/frodenas/bosh-workspace/bosh/release/dev_releases/bosh-13.1-dev.yml

###  <a id="upload_release"></a>Upload BOSH Release ###

Upload the BOSH Release generated previously to the Micro BOSH Director:

<pre class="terminal">
bosh upload release /Users/frodenas/bosh-workspace/bosh/release/dev_releases/bosh-13.1-dev.yml
</pre>

This command will output:

    Verifying release...
    File exists and readable                                     OK
    Extract tarball                                              OK
    Manifest exists                                              OK
    Release name/version                                         OK

    ...

    Release has been created
      bosh/13.1-dev (00:00:00)
    Done                    1/1 00:00:00

    Task 2 done
    Started		2013-06-17 13:02:32 UTC
    Finished	2013-06-17 13:02:41 UTC
    Duration	00:00:09

    Release uploaded

To confirm that the BOSH Release has been loaded into your BOSH Director use the `bosh releases` command:

    +------+-----------+-------------+
    | Name | Versions  | Commit Hash |
    +------+-----------+-------------+
    | bosh | 13.1-dev  | 60c4acca+   |
    +------+-----------+-------------+
    (*) Currently deployed
    (+) Uncommitted changes

    Releases total: 1

### <a id="manifest_file"></a>Create manifest file ###

Using the `deployments` directory we created when we [deployed Micro BOSH](deploying_microbosh.html#manifest_file), create a `bosh-openstack` subdirectory:

<pre class="terminal">
mkdir -p ~/bosh-workspace/deployments/bosh-openstack
cd ~/bosh-workspace/deployments/bosh-openstack
</pre>

If you are using nova-network, copy the `dynamic` BOSH example manifest file:

<pre class="terminal">
cp ~/bosh-workspace/bosh/release/examples/bosh-openstack-dynamic.yml bosh-openstack.yml
</pre>

If you are using the new [OpenStack Networking](http://www.openstack.org/software/openstack-networking/) service, copy the `manual` BOSH example manifest file:

<pre class="terminal">
cp ~/bosh-workspace/bosh/release/examples/bosh-openstack-manual.yml bosh-openstack.yml
</pre>

Adapt the `bosh-openstack.yml` file to your environment settings. Search for the tag `# CHANGE`:

* The `director_uuid` option set the [Bosh Director](/docs/running/bosh/components/director.html) to use. We will use the Micro Bosh Director UUID. You can get it running the command `bosh status`.
* The `instance_type` option set the OpenStack flavor used for the compilation vms (at the `compilation` section) and jobs vms (at the `resource_pools` section). The `flavor_name` **must** have ephemeral disk (check the [validate your OpenStack](validate_openstack.html#ephemeral) guide).
* The `allocated_floating_ip_1` and `allocated_floating_ip_2` allows us to associate a floating IP adress to the Director and PowerDNS instances and **must** be a previously allocated floating ips (check the [prerequisites](#openstack_floating_ip) section).
* The `dns.recursor` option set the IP address of the [recursor](http://en.wikipedia.org/wiki/Domain_Name_System#Recursive_and_caching_name_server) to query in case PowerDNS can't resolve a hostname. We will use the `microbosh_ip_address`.
* The `auth_url` option set your [OpenStack identity](http://www.openstack.org/software/openstack-shared-services/) server.
* The `username`, `api_key` and `tenant` options sets your OpenStack credentials.
* The `region` option is optional, and allows you to set the OpenStack region to be used.
* The `default_security_groups` option set the security groups used by vms, and **must** be existing security groups. We will use the `microbosh_security_group` we created when we [deployed Micro Bosh](deploying_microbosh.html#openstack_security_groups).
* The `default_key_name` option set the key pair used by vms and **must** be an existing keypair. We will use the `microbosh_keypair` we created when we [deployed Micro Bosh](deploying_microbosh.html#openstack_keypairs).

If you are using the new [OpenStack Networking](http://www.openstack.org/software/openstack-networking/) component, you must also adapt the below settings:

* The `range` option sets the IP range to use. `subnet_cidr` **must** be a [CIDR](http://en.wikipedia.org/wiki/Classless_Inter-Domain_Routing) belonging to one of the network subnets set in `net_id`.
* The `gateway` option sets subnet gateway.
* The `reserved` option sets the range of IP addresses (starting at `first_reserved_ip_address` and ending at `last_reserved_ip_address`) that are reserved (so BOSH/OpenStack will not use them when assigning dynamically IP to vms).
* The `static` option sets range of IP addresses (starting at `first_ip_address_for_vms` and ending at `last_ip_address_for_vms`) that are reserved to be set statically at the jobs section (so BOSH/OpenStack will not use them when assigning dynamically IP to vms).
* The `net_id` option sets the OpenStack network to use. `network_uuid` **must** be an existing Network UUID (you can list your OpenStack networks using the command `quantum net-list`).
* The `ip_address_for_natsl`, `ip_address_for_redis`, `ip_address_for_postgres`, `ip_address_for_powerdns`, `ip_address_for_blobstore`, `ip_address_for_director`, `ip_address_for_registry` and `ip_address_for_health_monitor` sets the IP address to assign to each job. These IP addresses **must** in the range of IP addresses set previously in the  `static` option.

### <a id="deploy"></a>Deploy BOSH ###

Set the BOSH deployment file to use:

<pre class="terminal">
bosh deployment ~/bosh-workspace/deployments/bosh-openstack/bosh-openstack.yml
</pre>

This command will output:

    Deployment set to `/Users/frodenas/bosh-workspace/deployments/bosh-openstack/bosh-openstack.yml'

Deploy the Full BOSH:

<pre class="terminal">
bosh deploy
</pre>

This command will output:

    Getting deployment properties from director...
    Unable to get properties list from director, trying without it...
    Compiling deployment manifest...
    Cannot get current deployment information from director, possibly a new deployment
    Please review all changes carefully
    Deploying `bosh-openstack.yml' to `microbosh-openstack' (type 'yes' to continue): yes

    Director task 3

    Preparing deployment
      binding deployment (00:00:00)
      binding releases (00:00:00)
      binding existing deployment (00:00:00)
      binding resource pools (00:00:00)
      binding stemcells (00:00:00)
      binding templates (00:00:00)
      binding properties (00:00:00)
      binding unallocated VMs (00:00:00)
      binding instance networks (00:00:00)
    Done                    9/9 00:00:00

    Preparing package compilation

    Compiling packages
      mysqlclient/0.1-dev (00:03:58)
      genisoimage/2 (00:04:37)
      powerdns/2 (00:00:07)
      postgres/2 (00:00:20)
      libpq/2 (00:05:30)
      nginx/2.1-dev (00:01:50)
      redis/3 (00:01:10)
      ruby/3 (00:04:23)
      health_monitor/5.1-dev (00:01:10)
      registry/0.1-dev (00:01:29)
      nats/3 (00:00:40)
      director/11.1-dev (00:02:06)
    Done                    12/12 00:11:59

    Preparing DNS
      binding DNS (00:00:00)
    Done                    1/1 00:00:00

    Creating bound missing VMs
      common/0 (00:02:38)
      common/1 (00:03:04)
      common/2 (00:03:55)
      common/4 (00:02:49)
      common/5 (00:02:54)
      common/3 (00:05:33)
      common/6 (00:02:39)
      common/7 (00:03:15)
    Done                    8/8 00:08:32

    Binding instance VMs
      postgres/0 (00:00:01)
      nats/0 (00:00:01)
      redis/0 (00:00:01)
      powerdns/0 (00:00:01)
      blobstore/0 (00:00:01)
      registry/0 (00:00:01)
      director/0 (00:00:01)
      health_monitor/0 (00:00:01)
    Done                    8/8 00:00:03

    Preparing configuration
      binding configuration (00:00:00)
    Done                    1/1 00:00:00

    Updating job nats
      nats/0 (canary) (00:00:16)
    Done                    1/1 00:00:16

    Updating job redis
      redis/0 (canary) (00:00:18)
    Done                    1/1 00:00:16

    Updating job postgres
      postgres/0 (canary) (00:01:27)
    Done                    1/1 00:01:27

    Updating job powerdns
      powerdns/0 (canary) (00:00:28)
    Done                    1/1 00:00:28

    Updating job blobstore
      blobstore/0 (canary) (00:00:30)
    Done                    1/1 00:00:30

    Updating job director
      director/0 (canary) (00:01:33)
    Done                    1/1 00:01:33

    Updating job registry
      registry/0 (canary) (00:00:32)
    Done                    1/1 00:00:32

    Updating job health_monitor
      health_monitor/0 (canary) (00:00:30)
    Done                    1/1 00:00:30

    Task 3 done
    Started		2013-06-17 20:31:46 UTC
    Finished	2013-06-17 20:57:52 UTC
    Duration	00:26:06

    Deployed `bosh-openstack.yml' to `microbosh-openstack'

To confirm that the BOSH has been deployed use the `bosh deployments` command:

    +------------------+------------------+---------------------------------+
    | Name             | Release(s)       | Stemcell(s)                     |
    +------------------+------------------+---------------------------------+
    | bosh-openstack   | bosh/13.83-dev   | bosh-openstack-kvm-ubuntu/1029  |
    +------------------+------------------+---------------------------------+

    Deployments total: 1

## <a id="test_bosh"></a>Testing your BOSH ##

### <a id="bosh_target"></a>Set target ###

To set your BOSH target use the `target` command:

<pre class="terminal">
bosh target &lt;bosh_ip_address&gt;
</pre>

This command will ask for the admin credentials. Enter `admin` when prompted for both `username` and `password`.

    Target set to `bosh'
    Your username: admin
    Enter password: *****
    Logged in as `admin'

### <a id="bosh_create_user"></a>Create a new user ###

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

### <a id="bosh_status"></a>Check status ###

To check the status of your BOSH use the `status` command:

<pre class="terminal">
bosh status
</pre>

This command will output:

    Config
                 /Users/frodenas/.bosh_config

    Director
      Name       bosh
      URL        https://<bosh_ip_address>:25555
      Version    1.5.0.pre.3 (release:60c4acca bosh:60c4acca)
      User       frodenas
      UUID       7e72cdbe-95dc-451c-b0d0-28ee6d99d6bd
      CPI        openstack
      dns        enabled (domain_name: bosh)
      compiled_package_cache disabled

    Deployment
      not set

### <a id="bosh_ssh"></a>SSH ###

If you want to ssh to any of your BOSH vms, first check the job names using the `bosh vms` command:

    Deployment `bosh-openstack'

    Director task 4

    Task 4 done

    +------------------+---------+---------------+---------------------------------+
    | Job/index        | State   | Resource Pool | IPs                             |
    +------------------+---------+---------------+---------------------------------+
    | blobstore/0      | running | common        | <ip_address_for_blobstore>      |
    | director/0       | running | common        | <ip_address_for_director>       |
    | health_monitor/0 | running | common        | <ip_address_for_health_monitor> |
    | nats/0           | running | common        | <ip_address_for_nats>           |
    | redis/0          | running | common        | <ip_address_for_redis>          |
    | postgres/0       | running | common        | <ip_address_for_postgres>       |
    | powerdns/0       | running | common        | <ip_address_for_powerdns>       |
    | registry/0       | running | common        | <ip_address_for_registry>       |
    +------------------+---------+---------------+---------------------------------+

    VMs total: 8

You can ssh using the `bosh ssh jobname/index` command.

Then you can sudo to get root privileges (default password for root user is `c1oudc0w`). All BOSH data is located at `/var/vcap` directory.

If you want to change the default root password, add this section at the [manifest](#manifest_file) file before deploying BOSH:

~~~yaml
env:
  bosh:
    password: <hash_password>
~~~

* `hash_password` **must** be a [sha-512](https://en.wikipedia.org/wiki/SHA-2) hashed password (You can generate it using the [mkpasswd](https://www.mkpasswd.net/) utility).

## <a id="delete_bosh"></a>Deleting your BOSH ##

If you want to delete your BOSH deployment, target your Micro BOSH and set the BOSH deployment file:

<pre class="terminal">
bosh target <microbosh_ip_address>
bosh deployment ~/bosh-workspace/deployments/bosh-openstack/bosh-openstack.yml
</pre>

Then use the `delete deployment` command:

<pre class="terminal">
bosh delete deployment bosh-openstack
</pre>

This command will output:

    You are going to delete deployment `bosh-openstack'.

    THIS IS A VERY DESTRUCTIVE OPERATION AND IT CANNOT BE UNDONE!

    Are you sure? (type 'yes' to continue): yes

    Director task 5

    Deleting instances
      powerdns/0 (00:00:48)
      nats/0 (00:00:50)
      redis/0 (00:00:36)
      blobstore/0 (00:00:27)
      registry/0 (00:00:17)
      health_monitor/0 (00:00:18)
      postgres/0 (00:05:13)
      director/0 (00:05:05)
    Done                    8/8 00:05:55

    Removing deployment artifacts
      detach stemcells (00:00:00)
      detaching releases (00:00:00)
    Done                    3/3 00:00:00

    Deleting properties
      delete DNS records (00:00:01)
      destroy deployment (00:00:00)
    Done                    0/0 00:00:01

    Task 5 done
    Started		2013-06-17 22:14:48 UTC
    Finished	2013-06-17 22:20:44 UTC
    Duration	00:05:56

    Deleted deployment `bosh-openstack'
