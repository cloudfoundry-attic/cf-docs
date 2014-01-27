---
title: Deploying Micro BOSH
---

Installation of BOSH is done using micro BOSH, which is a single VM that
includes all of the BOSH components.
If you want to play around with BOSH, or create a simple development setup, you
can install micro BOSH using the BOSH Deployer.
If you would like to use BOSH in production to manage a distributed system, you
also use the BOSH Deployer, install micro BOSH, and then use it as a means to
deploy the final distributed system on multiple VMs.

A good way to think about this two step process is to consider that BOSH is a
distributed system in itself.
Since BOSH's core purpose is to deploy and manage distributed systems, it makes
sense that we would use it to deploy itself.
On the BOSH team, we gleefully refer to this as [Inception](http://en.wikipedia.org/wiki/Inception).

## <a id="bootstrap"></a>BOSH Bootstrap ##

### <a id="prerequisites"></a>Prerequisites ###

We recommend that you run the BOSH bootstrap from Ubuntu since it is the
distribution used by the BOSH team, and has been thoroughly tested.

Plan to have around 8 GB of free disk space for the bosh_cli if you plan to use it to deploy CF releases.
You'll need around 3 GB free disk space in /tmp

* Install some core packages on Ubuntu that the BOSH deployer depends on.

<pre class="terminal">
$ sudo apt-get -y install libsqlite3-dev genisoimage
</pre>

* Install Ruby and RubyGems. Refer to the [Installing Ruby](/docs/common/install_ruby.html) page for help with Ruby installation.

* Install the BOSH Deployer Ruby gem.

<pre class="terminal">
$ gem install bosh_cli --pre
$ gem install bosh_cli_plugin_micro --pre
</pre>

Once you have installed the deployer, you will be able to use `bosh micro`
commands.
To see help on these type `bosh help micro`

### <a id="config"></a>Configuration ###

BOSH deploys things from a subdirectory under a deployments directory.
So create both and name it appropriately.
In our example we named it micro01.

<pre class="terminal">
	mkdir deployments
	cd deployments
	mkdir micro01
</pre>

BOSH needs a deployment manifest for MicroBOSH.
It must be named `micro_bosh.yml`.
Create one in your new directory following the example below:

~~~yaml
---
name: MicroBOSH01

network:
  ip: <ip_address_you_want_for_microbosh>
  netmask: <netmask_for_the_subnet_you_are_deploying_to>
  gateway: <gateway_for_the_subnet_you_are_deploying_to>
  dns:
  #The micro-bosh VM has the following DNS entries in its /etc/resolv.com, allowing it to resolve, for example, IaaS FQDNs.
  - <ip_for_dns>
  cloud_properties:
    name: <network_name_according_to_vsphere>

resources: # this seems like good sizing for microbosh
   persistent_disk: 16384
   cloud_properties:
      ram: 8192
      disk: 16384
      cpu: 4
cloud:
  plugin: vsphere
  properties:
    agent:
      ntp:
        - <ntp_host_1>
        - <ntp_host_2>
     vcenters:
       - host: <vcenter_ip>
         user: <vcenter_userid>
         password: <vcenter_password>
         datacenters:
           - name: <datacenter_name>
             vm_folder: <vm_folder_name>
             template_folder: <template_folder_name>
             disk_path: <subdir_to_store_disks>
             datastore_pattern: <data_store_pattern>
             persistent_datastore_pattern: <persistent_datastore_pattern>
             allow_mixed_datastores: <true_if_persistent_datastores_and_datastore_patterns_are_the_same>
             clusters:
             - <cluster_name>:
                 resource_pool: <resource_pool_name_optional>

apply_spec:
  properties:
    vcenter:
      host: <vcenter_ip>
      user: <vcenter_userid>
      password: <vcenter_password>
      datacenters:
        - name: <datacenter_name>
          vm_folder: <vm_folder_name>
          template_folder: <template_folder_name>
          disk_path: <subdir_to_store_disks>
          datastore_pattern: <data_store_pattern>
          persistent_datastore_pattern: <persistent_datastore_pattern>
          allow_mixed_datastores: <true_if_persistent_datastores_and_datastore_patterns_are_the_same>
          clusters:
          - <cluster_name>:
              resource_pool: <resource_pool_name_optional>
    dns:
        #The BOSH powerDNS contacts the following DNS server for serving DNS entries from other domains.
        recursor: <ip_for_dns>


~~~

The `apply_spec` provides Micro BOSH with the vCenter settings in order for it
to deploy Cloud Foundry.
It is different than the vCenter you are using to deploy MicroBOSH because
MicroBOSH can deploy to a different vCenter than the one it was deployed to.

If you want to create a role for the BOSH user in vCenter, the privileges are
defined [here](./vcenter_user_privileges.html).

Before you can run micro BOSH deployer, you have to create folders according to
the values in your manifest.

1. Create the vm_folder
1. Create the template_folder
1. Create the disk_path in the appropriate datastores
1. Create the resource_pool (optional)

![vcenter-folders](/images/vcenter-folders.png)
![vcenter-disk-path](/images/vcenter-disk-path.png)

* Datastore Patterns

The datastore pattern above could just be the name of a datastore or some
regular expression matching the datastore name.

If you have a datastore called "vc\_data\_store\_1" and you would like to use
this datastore for both persistent and non persistent disks, your config would
look like this:

~~~yaml
               datastore_pattern: vc_data_store_1
               persistent_datastore_pattern:  vc_data_store_1
               allow_mixed_datastores: true
~~~

If you have two datastores called "vc\_data\_store\_1" and
"vc\_data\_store\_2", and you would like to use both datastore for both
persistent and non persistent disks, your config would look like this:

~~~yaml
               datastore_pattern: vc_data_store_?
               persistent_datastore_pattern:  vc_data_store_?
               allow_mixed_datastores: true
~~~

If you have two datastores called "vnx:1" and "vnx:2", and you would like to
separate your persistent and non persistent disks, your config would look like
this:

~~~yaml
               datastore_pattern: vnx:1
               persistent_datastore_pattern: vnx:2
               allow_mixed_datastores: false
~~~

## <a id="deploy"></a>Deployment ##

Download a BOSH Stemcell:

You will need Internet access for the bosh\_cli to download the stemcells.
You may need to temporarily set the http\_proxy and https\_proxy variables if
you are behind a corporate firewall.
If so, remember to unset it before completing the following steps if your proxy
won't allow contacting the newly micro_bosh vm.

<pre class="terminal">
$ bosh public stemcells
+---------------------------------------------+
| Name                                        |
+---------------------------------------------+
| bosh-stemcell-1657-aws-xen-ubuntu.tgz       |
| bosh-stemcell-1657-aws-xen-centos.tgz       |
| light-bosh-stemcell-1657-aws-xen-ubuntu.tgz |
| light-bosh-stemcell-1657-aws-xen-centos.tgz |
| bosh-stemcell-1657-openstack-kvm-ubuntu.tgz |
| bosh-stemcell-1657-vsphere-esxi-ubuntu.tgz  |
| bosh-stemcell-1657-vsphere-esxi-centos.tgz  |
+---------------------------------------------+
$ bosh download public stemcell bosh-stemcell-XXXX-vsphere-esxi-ubuntu.tgz
</pre>

CD to the deployments directory and set the deployment.
This assumes you named the directory micro01.

<pre class="terminal">
$ cd deployments
$ bosh micro deployment micro01
Deployment set to '/var/vcap/deployments/micro01/micro_bosh.yml'
</pre>

Deploy a stemcell for MicroBOSH.

<pre class="terminal">
$ bosh micro deploy bosh-stemcell-XXXX-vsphere-esxi-ubuntu.tgz
</pre>


### <a id="verify"></a>Checking Status of a Micro BOSH Deploy ###

Target the Microbosh

<pre class="terminal">
bosh target <ip_address_from_your_micro_bosh_manifest:25555>
</pre>

Login with admin/admin.

The `status` command will show the persisted state for a given micro BOSH
instance.

<pre class="terminal">
$ bosh micro status
Stemcell CID   sc-1744775e-869d-4f72-ace0-6303385ef25a
Stemcell name  bosh-stemcell-1341-vsphere-esxi-ubuntu
VM CID         vm-ef943451-b46d-437f-b5a5-debbe6a305b3
Disk CID       disk-5aefc4b4-1a22-4fb5-bd33-1c3cdb5da16f
Micro BOSH CID bm-fa74d53a-1032-4c40-a262-9c8a437ee6e6
Deployment     /home/user/cloudfoundry/bosh/deployments/micro_bosh/micro_bosh.yml
Target         https://192.168.9.20:25555 #IP Address of the Director
</pre>

### <a id="listing"></a>Listing Deployments ###

The `deployments` command prints a table view of `bosh-deployments.yml`:

<pre class="terminal">
$ bosh micro deployments
</pre>

The files in your current directory need to be saved if you later want to be
able to update your micro BOSH instance.
They are all text files, so you can commit them to a git repository to make
sure they are safe in case your bootstrap VM goes away.


### <a id="send-message"></a>Sending Messages to the Micro BOSH Agent ###

The `bosh` CLI can send messages over HTTP to the agent using the `agent`
command.

<pre class="terminal">
$ bosh micro agent ping
"pong"
</pre>

