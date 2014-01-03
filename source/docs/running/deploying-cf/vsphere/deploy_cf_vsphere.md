---
title: Deploying Cloud Foundry with BOSH
---

This guide describes the process for deploying Cloud Foundry to a vSphere environment using BOSH.

## <a id="prerequisites"></a>Prerequisites ##

* BOSH should be deployed. See the steps in the [previous section](deploying_bosh_with_micro_bosh.html).

## <a id="target"></a>Target New BOSH Director ##

Target the Director of the deployed BOSH using `bosh target` and the IP address of the Director.

<pre class='terminal'>
$ bosh target 172.20.134.52
$ bosh status
Updating director data... done

Director
  Name      your-director
  URL       http://172.20.134.52:25555
  Version   0.7 (release:fb1aebb0 bosh:20f2ca20)
  User      admin
  UUID      2250612f-f0e4-41b3-b1b2-3d730e9011a7
  CPI       vsphere
  dns       disabled

Deployment
  not set
</pre>

## <a id="upload-stemcell"></a>Upload a Stemcell ##

The Director needs a stemcell in order to deploy Cloud Foundry. Use the existing public stemcell in your `~/stemcells` directory.

<pre class="terminal">
$ bosh upload stemcell ~/stemcells/bosh-stemcell-latest-vsphere-esxi-ubuntu.tgz
Verifying stemcell...
File exists and readable                                     OK
Using cached manifest...
Stemcell properties                                          OK

Stemcell info
-------------
Name:    bosh-vsphere-esxi-ubuntu
Version: 1029

Checking if stemcell already exists...
No

Uploading stemcell...
bosh-vsphere-esxi-ubuntu: 100% |ooooooooooooooooooooooooooooooooooooooo| 277.1MB  78.8MB/s 		Time: 00:00:03

Director task 1

Update stemcell
extracting stemcell archive (00:00:06)
verifying stemcell manifest (00:00:00)
checking if this stemcell already exists (00:00:00)
uploading stemcell bosh-vsphere-esxi-ubuntu/1029 to the cloud (00:01:08)
save stemcell: bosh-vsphere-esxi-ubuntu/1029 (sc-a85ab3dc-8d3d-4228-83d0-5be2436a1886) (00:00:00)
Done                    5/5 00:01:14
Task 1 done
Started		2012-09-26 10:14:26 UTC
Finished	2012-09-26 10:15:40 UTC
Duration	00:01:14

Stemcell uploaded and created
</pre>

## <a id="get-release"></a>Get a Cloud Release ##

For this exercise, we'll use a release from the public repository:

<pre class="terminal">
$ git clone git@github.com:cloudfoundry/cf-release.git
$ cd cf-release
$ bosh upload release releases/appcloud-129.yml # use the highest number available - inspecting the files in this directory
</pre>

You'll see a flurry of output as BOSH configures and uploads release components.

<!---  Gabi and Matt stopped here until Monday :) -->

## <a id="create-manifest"></a>Create a Cloud Deployment Manifest ##

For the purpose of this tutorial, we'll use a sample [deployment manifest](http://docs.cloudfoundry.com/docs/running/deploying-cf/vsphere/cloud-foundry-example-manifest.html).

Keep in mind that a manifest of this size requires significant virtual hardware resources to run. According to the manifest file, you ideally need 72 vCPUs, 200GB of RAM, and 1 TB of storage. The more IOPS you can throw at the deployment, the better.

Use the BOSH CLI to set your current deployment. This example assumes your deployment manifest file is in `~/deployments`.

<pre class="terminal">
$ bosh deployment ~/deployments/cloudfoundry.yml
Deployment set to '/home/user/deployments/cloudfoundry.yml'
</pre>

## <a id="deploy"></a>Deploy Cloud Foundry ##

Now deploy Cloud Foundry using `bosh deploy`. This example shows only part of the expected output:

<pre class="terminal">
$ bosh deploy
    Getting deployment properties from director...
	Unable to get properties list from director, trying without it...
	Compiling deployment manifest...
	Cannot get current deployment information from director, possibly a new deployment
    Please review all changes carefully
      Deploying <filename>.yml' to dev124'(type 'yes' to continue): yes
    Director task 31
    Preparing deployment
        binding deployment (00:00:00)
        binding releases (00:00:00)
        binding existing deployment (00:00:00)
        binding resource pools (00:00:00)
    binding stemcells (00:00:00)
    binding templates (00:00:00)
    binding unallocated VMs (00:00:01)
    binding instance networks (00:00:00)
    Done                    8/8 00:00:01        Preparing package compilation
    finding packages to compile (00:00:00)
    Done                    1/1 00:00:00
</pre>

## <a id="verfy"></a>Verify the Deployment ##

Execute the `bosh vms` command to see all the vas deployed.

Output of this command will similar to the listing below. Make sure the "State" of all the jobs is "running".

<pre class="terminal">
$ bosh vms
Deployment `cloudfoundry'

Director task 30


Task 30 done

+-----------------------------+---------+----------------+---------------+
| Job/index                   | State   | Resource Pool  | IPs           |
+-----------------------------+---------+----------------+---------------+
| acm/0                       | running | infrastructure | 192.168.9.38  |
| acmdb/0                     | running | infrastructure | 192.168.9.37  |
| backup_manager/0            | running | infrastructure | 192.168.9.120 |
| ccdb_postgres/0             | running | infrastructure | 192.168.9.32  |
| cloud_controller/0          | running | infrastructure | 192.168.9.213 |
| cloud_controller/1          | running | infrastructure | 192.168.9.214 |
| collector/0                 | running | infrastructure | 192.168.9.210 |
| dashboard/0                 | running | infrastructure | 192.168.9.211 |
| dea/0                       | running | deas           | 192.168.9.186 |
| dea/1                       | running | deas           | 192.168.9.187 |
| dea/2                       | running | deas           | 192.168.9.188 |
| dea/3                       | running | deas           | 192.168.9.189 |
| debian_nfs_server/0         | running | infrastructure | 192.168.9.30  |
| hbase_master/0              | running | infrastructure | 192.168.9.44  |
| hbase_slave/0               | running | infrastructure | 192.168.9.41  |
| hbase_slave/1               | running | infrastructure | 192.168.9.42  |
| hbase_slave/2               | running | infrastructure | 192.168.9.43  |
| health_manager/0            | running | infrastructure | 192.168.9.163 |
| login/0                     | running | infrastructure | 192.168.9.162 |
| mongodb_gateway/0           | running | infrastructure | 192.168.9.222 |
| mongodb_node/0              | running | infrastructure | 192.168.9.60  |
| mongodb_node/1              | running | infrastructure | 192.168.9.61  |
| mysql_gateway/0             | running | infrastructure | 192.168.9.221 |
| mysql_node/0                | running | infrastructure | 192.168.9.51  |
| mysql_node/1                | running | infrastructure | 192.168.9.52  |
| nats/0                      | running | infrastructure | 192.168.9.31  |
| opentsdb/0                  | running | infrastructure | 192.168.9.34  |
| postgresql_gateway/0        | running | infrastructure | 192.168.9.192 |
| postgresql_node/0           | running | infrastructure | 192.168.9.90  |
| postgresql_node/1           | running | infrastructure | 192.168.9.91  |
| rabbit_gateway/0            | running | infrastructure | 192.168.9.191 |
| rabbit_node/0               | running | infrastructure | 192.168.9.80  |
| rabbit_node/1               | running | infrastructure | 192.168.9.81  |
| redis_gateway/0             | running | infrastructure | 192.168.9.190 |
| redis_node/0                | running | infrastructure | 192.168.9.70  |
| redis_node/1                | running | infrastructure | 192.168.9.71  |
| router/0                    | running | infrastructure | 192.168.9.101 |
| router/1                    | running | infrastructure | 192.168.9.102 |
| serialization_data_server/0 | running | infrastructure | 192.168.9.123 |
| service_utilities/0         | running | infrastructure | 192.168.9.121 |
| services_nfs/0              | running | infrastructure | 192.168.9.50  |
| services_redis/0            | running | infrastructure | 192.168.9.72  |
| stager/0                    | running | infrastructure | 192.168.9.215 |
| stager/1                    | running | infrastructure | 192.168.9.216 |
| syslog_aggregator/0         | running | infrastructure | 192.168.9.33  |
| uaa/0                       | running | infrastructure | 192.168.9.212 |
| uaadb/0                     | running | infrastructure | 192.168.9.35  |
| vblob_gateway/0             | running | infrastructure | 192.168.9.193 |
| vblob_node/0                | running | infrastructure | 192.168.9.110 |
| vcap_redis/0                | running | infrastructure | 192.168.9.36  |
+-----------------------------+---------+----------------+---------------+
VMs total: 50
</pre>

The Cloud Foundry deployment should now be ready to use. You can now follow the instructions in the [Using](/docs/using/index.html) section of these docs to install the [cf](/docs/using/managing-apps/cf/index.html) command-line tool and push an application.
