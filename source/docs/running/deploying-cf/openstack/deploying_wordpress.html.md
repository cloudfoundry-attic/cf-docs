---
title: Deploying Wordpress using Micro BOSH
---

This guide describes the process for deploying [Wordpress](http://wordpress.org/) as an application using Micro BOSH.

## <a id="prerequisites"></a>Prerequisites ##

### <a id="microbosh"></a>Micro BOSH ###

Micro BOSH should be deployed and targeted. See the steps in [Deploying Micro BOSH](deploying_microbosh.html).

### <a id="stemcell"></a>BOSH Stemcell ###

A BOSH Stemcell should be uploaded to the Micro BOSH. See the steps in [Uploading a BOSH Stemcell](uploading_bosh_stemcell.html).

### <a id="openstack_security_groups"></a>OpenStack Security Groups ###

Create a new OpenStack security group, name it ie `wordpress`, and open the following ports:

* All ports (from `1` to `65535`) where the source group is the current security group
* Port `80` from source 0.0.0.0/0 (CIDR): Used by Wordpress webserver

### <a id="openstack_floating_ip"></a>OpenStack Floating IPs ###

Allocate a new OpenStack Floating IP to your project. We will use it to access our Wordpress application from outside of our network.

## <a id="deploy_wordpress"></a>Deploying Wordpress ##

###  <a id="upload_release"></a>Upload Wordpress Release ###

Download the [BOSH sample release](https://github.com/cloudfoundry/bosh-sample-release):

<pre class="terminal">
mkdir -p ~/bosh-workspace/releases
cd ~/bosh-workspace/releases
git clone git://github.com/cloudfoundry/bosh-sample-release.git
</pre>

Upload the BOSH sample release to the Micro BOSH Director:

<pre class="terminal">
cd ~/bosh-workspace/releases/bosh-sample-release
bosh upload release ~/bosh-workspace/releases/bosh-sample-release/releases/wordpress-2.yml
</pre>

This command will output:

    Copying packages
    ----------------

    ...

    Release has been created
      wordpress/2 (00:00:00)
    Done                    1/1 00:00:00

    Task 6 done
    Started		2013-06-18 12:20:12 UTC
    Finished	2013-06-18 12:20:14 UTC
    Duration	00:00:02

    Release uploaded


To confirm that the BOSH sample release has been loaded into your BOSH Director use the `bosh releases` command:

    +-----------+----------+-------------+
    | Name      | Versions | Commit Hash |
    +-----------+----------+-------------+
    | wordpress | 2        | unknown     |
    +-----------+----------+-------------+
    (+) Uncommitted changes

    Releases total: 1

### <a id="manifest_file"></a>Create manifest file ###

Using the `deployments` directory we created when we [deployed Micro BOSH](deploying_microbosh.html#manifest_file), create a `wordpress-openstack` subdirectory:

<pre class="terminal">
mkdir -p ~/bosh-workspace/deployments/wordpress-openstack
cd ~/bosh-workspace/deployments/wordpress-openstack
</pre>

If you are using nova-network, copy the `dynamic` Wordpress example manifest file:

<pre class="terminal">
cp ~/bosh-workspace/releases/bosh-sample-release/examples/wordpress-openstack-dynamic.yml wordpress-openstack.yml
</pre>

If you are using the new [OpenStack Networking](http://www.openstack.org/software/openstack-networking/) service, copy the `manual` Wordpress example manifest file:

<pre class="terminal">
cp ~/bosh-workspace/releases/bosh-sample-release/examples/wordpress-openstack-manual.yml wordpress-openstack.yml
</pre>

Adapt the `wordpress-openstack.yml` file to your environment settings. Search for the tag `# CHANGE`:

* The `director_uuid` option set the [Bosh Director](/docs/running/bosh/components/director.html) to use. We will use the Micro Bosh Director UUID. You can get it running the command `bosh status`.
* The `instance_type` option set the OpenStack flavor used for the compilation vms (at the `compilation` section) and jobs vms (at the `resource_pools` section). The `flavor_name` **must** have ephemeral disk (check the [validate your OpenStack](validate_openstack.html#ephemeral) guide).
* The `security_groups` option set the security groups used by vms, and **must** be existing security groups. We will use the `microbosh_security_group` we created when we [deployed Micro Bosh](deploying_microbosh.html#openstack_security_groups) and the `wordpress_security_group` we created [previously](#openstack_security_groups).
* The `allocated_floating_ip` allows us to associate a floating IP adress to the Wordpress webserver and **must** be a previously allocated floating ip (check the [prerequisites](#openstack_floating_ip) section).

If you are using the new [OpenStack Networking](http://www.openstack.org/software/openstack-networking/) component, you must also adapt the below settings:

* The `range` option sets the IP range to use. `subnet_cidr` **must** be a [CIDR](http://en.wikipedia.org/wiki/Classless_Inter-Domain_Routing) belonging to one of the network subnets set in `net_id`.
* The `gateway` option sets subnet gateway.
* The `reserved` option sets the range of IP addresses (starting at `first_reserved_ip_address` and ending at `last_reserved_ip_address`) that are reserved (so BOSH/OpenStack will not use them when assigning dynamically IP to vms).
* The `static` option sets range of IP addresses (starting at `first_ip_address_for_vms` and ending at `last_ip_address_for_vms`) that are reserved to be set statically at the jobs section (so BOSH/OpenStack will not use them when assigning dynamically IP to vms).
* The `net_id` option sets the OpenStack network to use. `network_uuid` **must** be an existing Network UUID (you can list your OpenStack networks using the command `quantum net-list`).
* The `network` option at the `nfs_server` properties set the NFS clients allowed to access to the NFS server. In order to simplify the example we will use the `subnet_cidr` set previously, but we can use any [Machine Name Format](http://manpages.ubuntu.com/manpages/lucid/man5/exports.5.html).
* The `ip_address_for_mysql`, `ip_address_for_nfs`, `ip_address_for_wordpress` and `ip_address_for_nginx` sets the IP address to assign to each job. These IP addresses **must** in the range of IP addresses set previously in the  `static` option.

### <a id="deploy"></a>Deploy Wordpress ###

Set the Wordpress deployment file to use:

<pre class="terminal">
bosh deployment ~/bosh-workspace/deployments/wordpress-openstack/wordpress-openstack.yml
</pre>

This command will output:

    Deployment set to `/Users/frodenas/bosh-workspace/deployments/wordpress-openstack/wordpress-openstack.yml'

Now deploy Wordpress:

<pre class="terminal">
bosh deploy
</pre>

This command will output:

    Getting deployment properties from director...
    Unable to get properties list from director, trying without it...
    Compiling deployment manifest...
    Cannot get current deployment information from director, possibly a new deployment
    Please review all changes carefully
    Deploying `wordpress-openstack.yml' to `microbosh-openstack' (type 'yes' to continue): yes

    Director task 7

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
      wordpress/1 (00:02:28)
      nginx/1 (00:03:52)
      debian_nfs_server/1 (00:00:04)
      common/1 (00:00:05)
      mysql/1 (00:00:21)
      mysqlclient/1 (00:00:06)
      apache2/1 (00:03:12)
      php5/1 (00:04:16)
    Done                    8/8 00:09:56

    Preparing DNS
      binding DNS (00:00:00)
    Done                    1/1 00:00:00

    Creating bound missing VMs
      common/0 (00:02:57)
      common/2 (00:03:57)
      common/1 (00:03:59)
      common/3 (00:01:51)
    Done                    4/4 00:04:48

    Binding instance VMs
      nfs/0 (00:00:01)
      mysql/0 (00:00:01)
      wordpress/0 (00:00:01)
      nginx/0 (00:00:01)
    Done                    4/4 00:00:02

    Preparing configuration
      binding configuration (00:00:00)
    Done                    1/1 00:00:00

    Updating job mysql
      mysql/0 (canary) (00:00:42)
    Done                    1/1 00:00:42

    Updating job nfs
      nfs/0 (canary) (00:00:30)
    Done                    1/1 00:00:30

    Updating job wordpress
      wordpress/0 (canary) (00:01:47)
    Done                    1/1 00:01:47

    Updating job nginx
      nginx/0 (canary) (00:00:27)
    Done                    1/1 00:00:27

    Task 7 done
    Started		2013-06-18 17:56:16 UTC
    Finished	2013-06-18 18:14:55 UTC
    Duration	00:18:39

    Deployed `wordpress-openstack.yml' to `microbosh-openstack'

To confirm that the Wordpress has been deployed use the `bosh deployments` command:

    +---------------------+-------------+--------------------------------+
    | Name                | Release(s)  | Stemcell(s)                    |
    +---------------------+-------------+--------------------------------+
    | wordpress-openstack | wordpress/2 | bosh-openstack-kvm-ubuntu/1029 |
    +---------------------+-------------+--------------------------------+

    Deployments total: 1

You can also check the jobs deployed and their state using the `bosh vms` command:

    Director task 8

    Task 8 done

    +-------------+---------+---------------+-------------------------------------------------+
    | Job/index   | State   | Resource Pool | IPs                                             |
    +-------------+---------+---------------+-------------------------------------------------+
    | mysql/0     | running | common        | <ip_address_for_mysql>                          |
    | nfs/0       | running | common        | <ip_address_for_nfs>                            |
    | nginx/0     | running | common        | <ip_address_for_nginx>, <allocated_floating_ip> |
    | wordpress/0 | running | common        | <ip_address_for_wordpress>                      |
    +-------------+---------+---------------+-------------------------------------------------+

    VMs total: 4

## <a id="delete_bosh"></a>Deleting Wordpress ##

If you want to delete your Wordpress deployment, set first the Wordpress deployment file:

<pre class="terminal">
bosh deployment ~/bosh-workspace/deployments/wordpress-openstack/wordpress-openstack.yml
</pre>

Then use the `delete deployment` command:

<pre class="terminal">
bosh delete deployment wordpress-openstack
</pre>

This command will output:

    You are going to delete deployment `wordpress-openstack'.

    THIS IS A VERY DESTRUCTIVE OPERATION AND IT CANNOT BE UNDONE!

    Are you sure? (type 'yes' to continue): yes

    Director task 9

    Deleting instances
      mysql/0 (00:00:50)
      wordpress/0 (00:00:53)
      nfs/0 (00:00:55)
      nginx/0 (00:00:19)
    Done                    4/4 00:01:09

    Removing deployment artifacts
      detach stemcells (00:00:00)
      detaching releases (00:00:00)
    Done                    3/3 00:00:00

    Deleting properties
      delete DNS records (00:00:00)
      destroy deployment (00:00:00)
    Done                    0/0 00:00:00

    Task 9 done
    Started		2013-06-18 18:17:02 UTC
    Finished	2013-06-18 18:18:11 UTC
    Duration	00:01:09

    Deleted deployment `wordpress-openstack'
