---
title: Deploying Micro BOSH
---

Installation of BOSH is done using micro BOSH, which is a single VM that includes all of the BOSH components. If you want to play around with BOSH, or create a simple development setup, you can install micro BOSH using the BOSH Deployer. If you would like to use BOSH in production to manage a distributed system, you also use the BOSH Deployer, install micro BOSH, and then use it as a means to deploy the final distributed system on multiple VMs.

A good way to think about this two step process is to consider that BOSH is a distributed system in itself. Since BOSH's core purpose is to deploy and manage distributed systems, it makes sense that we would use it to deploy itself. On the BOSH team, we gleefully refer to this as [Inception](http://en.wikipedia.org/wiki/Inception).

## <a id="bootstrap"></a>BOSH Bootstrap ##

### <a id="prerequisites"></a>Prerequisites ###

We recommend that you run the BOSH bootstrap from Ubuntu since it is the distribution used by the BOSH team, and has been thoroughly tested.

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

Once you have installed the deployer, you will see some extra commands appear after typing `bosh` on your command line.

*Note*: The `bosh micro` commands should be run within a micro BOSH deployment directory.

<pre class="terminal">
$ bosh help micro
  aws bootstrap micro
      rm deployments dir, creates a deployments/micro/micro_bosh.yml and deploys the microbosh

  micro
      show micro bosh sub-commands

  micro agent <args>
      Send agent messages

      Message Types:

      start - Start all jobs on MicroBOSH

      stop - Stop all jobs on MicroBOSH

      ping - Check to see if the agent is responding

      drain TYPE SPEC - Tell the agent to begin draining
        TYPE - One of 'shutdown', 'update' or 'status'.
        SPEC - The drain spec to use.

      state [full] - Get the state of a system
        full - Get additional information about system vitals

      list_disk - List disk CIDs mounted on the system

      migrate_disk OLD NEW - Migrate a disk
        OLD - The CID of the source disk.
        NEW - The CID of the destination disk.

      mount_disk CID - Mount a disk on the system
        CID - The cloud ID of the disk to mount.

      unmount_disk CID - Unmount a disk from the system
        CID - The cloud ID of the disk to unmount.

  micro apply <spec>
      Apply spec

  micro delete
      Delete micro BOSH instance (including persistent disk)

  micro deploy [<stemcell>] [--update] [--update-if-exists]
      Deploy a micro BOSH instance to the currently selected deployment
      --update                              update existing instance
      --update-if-exists                    create new or update existing instance

  micro deployment [<name>]
      Choose micro deployment to work with, or display current deployment

  micro deployments
      Show the list of deployments

  micro status
      Display micro BOSH deployment status  
</pre>

### <a id="config"></a>Configuration ###

For a minimal vSphere configuration example, see [here](https://github.com/cloudfoundry/bosh/blob/master/bosh_cli_plugin_micro/spec/assets/test-bootstrap-config.yml). Note that `disk_path` is `BOSH_Deployer` rather than `BOSH_Disks`. A datastore folder other than `BOSH_Disks` is required if your vCenter hosts other Directors. The `disk_path` folder needs to be created manually. Also, your configuration should live inside a `deployments` directory and follow the convention of having a `$name` subdir containing `micro_bosh.yml`, where `$name` is your deployment name.

For example:

<pre class="terminal">
$ find deployments -name micro_bosh.yml
deployments/vcs01/micro_bosh.yml
deployments/dev32/micro_bosh.yml
deployments/dev33/micro_bosh.yml
</pre>

Deployment state is persisted to `<current directory>/bosh-deployments.yml`.

### <a id="config-vcenter"></a>vCenter Configuration ###

The vCenter configuration section looks like the following:

~~~yaml
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
                   resource_pool: <resource_pool_name>
~~~

If you want to create a role for the BOSH user in vCenter, the privileges are defined [here](./vcenter_user_privileges.html).

Before you can run micro BOSH deployer, you have to do the following within vCenter:

1. Create the vm_folder
1. Create the template_folder
1. Create the disk_path in the appropriate datastores
1. Create the resource_pool

Resource pool is optional. Without a resource pool the cluster property looks like:

~~~yaml
               persistent_datastore_pattern: <datastore_pattern>
               allow_mixed_datastores: <true_if_persistent_datastores_and_datastore_patterns_are_the_same>
               clusters:
               - <cluster_name>
~~~

The datastore pattern above could just be the name of a datastore or some regular expression matching the datastore name.

If you have a datastore called "vc_data_store_1" and you would like to use this datastore for both persistent and non persistent disks, your config would look like:

~~~yaml
               datastore_pattern: vc_data_store_1
               persistent_datastore_pattern:  vc_data_store_1
               allow_mixed_datastores: true
~~~

If you have 2 datastores called "vc_data_store_1", "vc_data_store_2" and you would like to use both datastore for both persistent and non persistent disks, your config would look like:

~~~yaml
               datastore_pattern: vc_data_store_?
               persistent_datastore_pattern:  vc_data_store_?
               allow_mixed_datastores: true
~~~

If you have 2 datastores called "vnx:1" and "vnx:2", and you would like to separate your persistent and non persistent disks, your config would look like:

~~~yaml
               datastore_pattern: vnx:1
               persistent_datastore_pattern: vnx:2
               allow_mixed_datastores: false
~~~

## <a id="deploy"></a>Deployment ##

Download a BOSH Stemcell:

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

$ bosh download public stemcell bosh-stemcell-XXXX-vsphere-esxi-ubuntu.tgz
</pre>

Set the micro BOSH Deployment using:

<pre class="terminal">
$ cd /var/vcap/deployments
$ bosh micro deployment dev33
Deployment set to '/var/vcap/deployments/dev33/micro_bosh.yml'
</pre>

Deploy a new micro BOSH instance:

<pre class="terminal">
$ bosh micro deploy bosh-stemcell-XXXX-vsphere-esxi-ubuntu.tgz
</pre>

Update an existing micro BOSH instance. The existing persistent disk will be attached to the new VM:

<pre class="terminal">
$ bosh micro deploy bosh-stemcell-XXXX-vsphere-esxi-ubuntu.tgz --update
</pre>

### <a id="delete"></a>Deleting a Micro BOSH Deployment ###

The `delete` command will delete the VM, Stemcell, and persistent disk:

<pre class="terminal">
$ bosh micro delete
</pre>

### <a id="verify"></a>Checking Status of a Micro BOSH Deploy ###

The `status` command will show the persisted state for a given micro BOSH instance.

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

The files in your current directory need to be saved if you later want to be able to update your micro BOSH instance. They are all text files, so you can commit them to a git repository to make sure they are safe in case your bootstrap VM goes away.

### <a id="apply-spec"></a>Applying a Specification ###

The micro-bosh-stemcell includes an embedded `apply_spec.yml`. This command can be used to apply a different spec to an existing instance. The `apply_spec.yml` properties are merged with your Deployment's `network.ip` and `cloud.properties.vcenters` properties.

<pre class="terminal">
$ bosh micro apply apply_spec.yml
</pre>

### <a id="send-message"></a>Sending Messages to the Micro BOSH Agent ###

The `bosh` CLI can send messages over HTTP to the agent using the `agent` command.

<pre class="terminal">
$ bosh micro agent ping
"pong"
</pre>

