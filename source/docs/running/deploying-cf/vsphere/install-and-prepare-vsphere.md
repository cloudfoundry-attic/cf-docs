---
title: Install and Prepare vSphere Cluster
---

Before starting a Cloud Foundry deployment, a vSphere cluster must be set up. This guide will use a minimal configuration to setup the cluster:

1. 2 servers to install ESXi (x core processor , y GB Ram : x and y depend on the hardware config chosen)
2. 1 server to install vCenter (this can also be a VM in any of the ESXi servers)
3. Storage server (SAN is recommended but you can also use other storages like openfiler)
4. Switch 
5. Network: IP ranges at least 100 IPs

## <a id="install"></a>Install ESXi and vCenter ##

Follow the standard ESXi and vCenter installation process. After installation your ESXi will look like the image below:

![esxi](/images/running/deploying-cf/vsphere/esxi5.png)

## <a id="prepare"></a>Prepare vCenter for Cloud Foundry Deployment ##

### <a id="prepare-datacenter"></a>Create a Datacenter ###

In vCenter, go to `Hosts and Clusters` then click on `Create a Datacenter`. A new datacenter will be created in the left panel. Give a suitable name and press the Enter key. 

![datacenter](/images/running/deploying-cf/vsphere/datacenter.png)

### <a id="prepare-cluster"></a>Create a Cluster ###

Next, create a cluster and add ESXi hosts to the cluster.

1. Select the datacenter created in the step above.
2. Click on the `Create a cluster` link.
3. The `New cluster wizard` will open. Give a suitable name to the cluster, click Next and follow the wizard.

Once finished, you can see the new cluster created in the left panel.

![cluster1](/images/running/deploying-cf/vsphere/cluster1.png)

### <a id="prepare-pool"></a>Create a Resource Pool ###

Create a resource pool.

### <a id="prepare-hosts"></a>Add the ESXi hosts to the cluster ###

1. Select the cluster created in the step above.
2. Click on the `Add a Host` link.
3. The `Add host wizard` will appear. Give the IP address/hostname and login credentials for the ESXi host. Click Next and follow the wizard.

Once you finish you can see the newly added host in the left panel.

![host1](/images/running/deploying-cf/vsphere/add_host.png)

## <a id="folders"></a>Create the Folders for VMs, Templates and Disk Path ##

Micro BOSH and BOSH use predefined locations for VMs, templates and disk path that you will define in the deployment manifest.

### <a id="folders-vm"></a>Create the VM and Templates Folder ###

1. Click on Inventory, `Select Vms and Templates`.
2. Select the datacenter created in the step above.
3. Click on the `New folder` icon on the top of the left panel to create new folder.
4. Create four folders as follows:
   * `MicroBOSH\_VMs` and `MicroBOSH\_Templates` (for Micro BOSH)
   * `CF\_VMs` and `CF\_Templates` (for BOSH)

![vms_and_folders](/images/running/deploying-cf/vsphere/vms_templates.png)

### <a id="folders-disk"></a>Create the Disk Path ###

1. Click on Inventory, then `Datastore and Datastore Clusters`.
2. Right click the datastore in which you want to store the disks of VMs. Select `Browse Datastore`. The datastore will open in a new window.
3. Click on the `Create new folder` on the top the window to create new folder.
4. Create 2 folders as follows:
   * `MicroBOSH\_Disks` (for Micro BOSH)
   * `CF\_Disks` (for BOSH)

![datastore1](/images/running/deploying-cf/vsphere/datastore.png)

## <a id="summary"></a>Summary ##

The vSphere 5.x cluster is ready for Cloud Foundry deployment.

