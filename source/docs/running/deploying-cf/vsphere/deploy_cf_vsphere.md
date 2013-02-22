# Deploy Cloud Application Platform - Cloud Foundry #

These instructions follow the steps taken in the [deploying BOSH with Micro BOSH](deploying_bosh_with_micro_bosh.html) section.
 
## Target New BOSH Director ##

<pre class='terminal'>
$ bosh target 172.20.134.52 #IP address of BOSH Director
$ bosh status
</pre>

~~~
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
~~~

## Upload Stemcell ##

The Director needs a stemcell in order to deploy Cloud Foundry. Use the existing public stemcell in your `~/stemcells` directory. Do not use the Micro BOSH stemcell.

<pre class="terminal">
$ bosh upload stemcell ~/stemcells/bosh-stemcell-vsphere-0.6.7.tgz
</pre>

~~~
	Verifying stemcell...
	File exists and readable                                     OK
	Using cached manifest...
	Stemcell properties                                          OK

	Stemcell info
	-------------
	Name:    bosh-stemcell
	Version: 0.6.7

	Checking if stemcell already exists...
	No

	Uploading stemcell...
	bosh-stemcell: 100% |ooooooooooooooooooooooooooooooooooooooo| 277.1MB  78.8MB/s 		Time: 00:00:03

	Director task 1

	Update stemcell
	extracting stemcell archive (00:00:06)
	verifying stemcell manifest (00:00:00)                                                         
	checking if this stemcell already exists (00:00:00)                                               
	uploading stemcell bosh-stemcell/0.6.4 to the cloud (00:01:08)                                    
	save stemcell: bosh-stemcell/0.6.4 (sc-a85ab3dc-8d3d-4228-83d0-5be2436a1886) (00:00:00)           
	Done                    5/5 00:01:14                                                                
	Task 1 done
	Started		2012-09-26 10:14:26 UTC
	Finished	2012-09-26 10:15:40 UTC
	Duration	00:01:14

	Stemcell uploaded and created
~~~


## Get Cloud Release ##

For this exercise, we'll use a release from the public repository:

<pre class="terminal">
$ git clone git@github.com:cloudfoundry/cf-release.git
$ cd cf-release
$ bosh upload release releases/appcloud-129.yml # use the highest number available - inspecting the files in this directory
</pre>

You'll see a flurry of output as BOSH configures and uploads release components.

<!---  Gabi and Matt stopped here until Monday :) -->

## Create Cloud Deployment Manifest ##

For the purpose of this tutorial, we'll use a sample [deployment manifest]( https://github.com/cloudfoundry/oss-docs/blob/master/bosh/samples/cloudfoundry.yml )

Keep in mind that a manifest of this size requires significant virtual hardware resources to run. According to the manifest file, you ideally need 72 vCPUs, 200GB of RAM, and 1 TB of storage. The more IOPS you can throw at the deployment, the better.

Use the BOSH CLI to set your current deployment. If you placed your deployment manifest yml in ~/deployments, run the following command: 

+ `bosh deployment ~/deployments/cloudfoundry.yml`

   `Deployment set to '/home/user/deployments/cloudfoundry.yml'`


## Deploy ##

Let's summarize what we accomplished in this section -- we mirrored the steps we used to deploy BOSH. We targeted our new BOSH Director (running as part of a distributed BOSH,) uploaded a stemcell to the Director, uploaded a public cloud application platform release to the Director, configured a deployment manifest, and set the deployment manifest as the current deployment using the BOSH CLI. 

Now you get to watch your vCenter light up with tasks:

+ `bosh deploy`

Output of the above command is pretty long and is partially listed below                           
 
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



# Verification #

You watched your vCenter hard at work and followed the deployment logs, and now the job has finished. How do you verify that your platform is indeed functional?

+ execute the `bosh vms` command again to see all the vas deployed

Output of this command will similar to the listing below, make sure  State of all the Jobs is running.	

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




+ At this point, you've crossed over from `bosh` territory to `vmc`. The `vmc` tool will allow you to push a sample app to your cloud application platform instance and test its functionality.

## Install VMC ##

VMC is the command line tool that will allow you to interact with your cloud application platform. You should be able to run VMC from any other machine that will allow you to install Ruby gems.  

1. Follow the [directions listed here](http://docs.cloudfoundry.com/tools/vmc/installing-vmc.html#installing-vmc-procedure) to install VMC.

## Build Sample App ##

1. Install the Sinatra web framework for Ruby: `gem install sinatra`

1. Write a [sample Sinatra application](http://docs.cloudfoundry.com/tools/vmc/installing-vmc.html#creating-a-simple-sinatra-application) 

## Deploy Sample App ##

*Note* There is one step you will need to add to the instructions listed below. You will need to add a user through vmc after running the `vmc target` command. 

To add a user, run `vmc add-user` and follow the on-screen prompts to create a user.

1. Follow [these instructions](http://docs.cloudfoundry.com/tools/vmc/installing-vmc.html#verifying-the-installation-by-deploying-a-sample-application) to push the sample Sinatra app to your cloud application platform


1. Visit the URL of your application, as provided during the `vmc push` operation, to verify that it works.

*Hint: In the case where you get JSON 404 errors when you try to use vmc to target your api, the best course of action is to use `bosh ssh` to connect to your router VM. The file `router.log` will likely show you if the router bound itself to a different IP address. This is indicative of possible configuration errors in your deployment manifest and/or problems with your external DNS configuration. More [here](https://github.com/cloudfoundry/vcap/issues/37).*

*What is the URL for the target? This is specified in the deployment manifest under the cc: component. It is given as the srv_api_uri: property.

*Where do you specify 'yourdomain.com' in the deployment? In the deployment manifest, there is a `domain: ` property. Put your domain here.

*Do you need DNS configured for your CF instance? Yes. The easiest way to set this up is with a wildcard DNS entry that points to your domain. The router component of CF will take care of routing requests to the correct apps. The wild card DNS entry needs to point to the IP where router is running.s


# Summary #

In this document, we installed the BOSH CLI, deployed a Micro BOSH instance, used Micro BOSH to deploy BOSH (inception,) and used BOSH to deploy a cloud application platform. 


There are also Google Groups for both [bosh-dev](https://groups.google.com/a/cloudfoundry.org/group/bosh-dev/topics?lnk) and [bosh-users](https://groups.google.com/a/cloudfoundry.org/group/bosh-users/topics)

