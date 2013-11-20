---
title: Deploying BOSH with Micro BOSH
---

This guide describes the process for deploying BOSH as an application using micro BOSH. 

## <a id="prerequisites"></a>Prerequisites ##

* Micro BOSH should be deployed. See the steps in the [previous section](deploying_micro_bosh.html)

## <a id="target"></a>Target Micro BOSH ##

Once your micro BOSH instance is deployed, you can target its Director:

<pre class="terminal">
$ bosh micro status
...
Target         micro (http://11.23.194.100:25555) Ver: 0.3.12 (00000000)

$ bosh target 11.23.194.100
Target set to 'your-micro-BOSH'
Your username: admin
Enter password: *****
Logged in as 'admin'

$ bosh status
Updating director data... done
Config
             /home/user/.bosh_config

Director
  Name       your-micro-BOSH
  URL        http://11.23.194.100:25555
  Version    1.5.0.pre.980 (release:95f2cf42 bosh:95f2cf42)
  User       admin
  UUID       729b6100-4035-4b35-ab9a-cf8299719fe3
  CPI        vsphere
  dns        enabled (domain_name: microbosh)
  compiled_package_cache disabled
  snapshots  disabled

Deployment
  not set
</pre>

*Note*: Create a new user using `bosh create user` which overrides the default username and password.

## <a id="download-stemcell"></a>Download a BOSH Stemcell ##

List public stemcells with the `bosh public stemcells` command:

<pre class="terminal">
$ mkdir -p ~/stemcells
$ cd ~/stemcells
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
</pre>

Download a public stemcell. *Note*: if you have already downloaded a stemcell to deploy your micro BOSH, you can use that one.

<pre class="terminal">
$ bosh download public stemcell bosh-stemcell-XXXX-vsphere-esxi-ubuntu.tgz
</pre>

Upload the downloaded stemcell to micro BOSH.

<pre class="terminal">
$ bosh upload stemcell bosh-stemcell-XXXX-vsphere-esxi-ubuntu.tgz
</pre>

You can see the uploaded stemcells (on your Micro BOSH) by using `bosh stemcells`:

<pre class="terminal">
$ bosh stemcells

+-------------------------------+---------+-----------------------------------------+
| Name                          | Version | CID                                     |
+-------------------------------+---------+-----------------------------------------+
| bosh-vsphere-esxi-ubuntu      | 1365    | sc-c43d6d06-53b9-47dc-8830-b4e280684a9a |
+-------------------------------+---------+-----------------------------------------+
</pre>

## <a id="upload-release"></a>Upload a BOSH release ##

<pre class="terminal">
$ wget http://bosh-jenkins-artifacts.s3.amazonaws.com/release/bosh-XXXX.tgz
$ bosh upload release bosh-XXXX.tgz
</pre>

## <a id="deploy"></a>Setup a BOSH Deployment Manifest and Deploy ##

Create and setup a BOSH deployment manifest. Look at the [BOSH example manifest](./bosh-example-manifest.html). 

Deploy BOSH. (the following assumes your manifest is named `bosh.yml` in `/home/bosh_user`).

<pre class="terminal">
$ cd /home/bosh_user
$ bosh deployment bosh.yml
		
Deployment set to `/home/bosh_user/bosh.yml'

$ bosh deploy

Getting deployment properties from director...
Unable to get properties list from director, trying without it...
Compiling deployment manifest...
Cannot get current deployment information from director, possibly a new deployment
Please review all changes carefully
Deploying `bosh.yml' to `your-micro-BOSH' (type 'yes' to continue): yes

Director task 5

Preparing deployment
  binding deployment (00:00:00)                                                                     
  binding releases (00:00:00)                                                                       
  binding existing deployment (00:00:00)                                                            
  binding resource pools (00:00:00)                                                                 
  binding stemcells (00:00:00)                                                                      
  binding templates (00:00:00)                                                                      
  binding unallocated VMs (00:00:00)                                                                
  binding instance networks (00:00:00)                                                              
Done                    8/8 00:00:00                                                                

Preparing package compilation
  finding packages to compile (00:00:00)                                                            
Done                    1/1 00:00:00                                                                

Preparing DNS
  binding DNS (00:00:00)                                                                            
Done                    1/1 00:00:00                                                                

Creating bound missing VMs
  small/0 (00:00:50)                                                                                
  small/4 (00:01:02)                                                                                
  small/1 (00:01:19)                                                                                
  small/2 (00:01:22)                                                                                
  small/3 (00:01:24)                                                                                
  director/0 (00:01:26)                                                                             
Done                    6/6 00:01:26
</pre>

*Note*: There will be a lot of status information in addition to the above output.

## <a id="verify"></a>Verification ##

The example BOSH director has the IP address `172.20.134.52`. Targeting this director with `bosh target 172.20.134.52` will verify a successful installation.

<pre class="terminal">
$ bosh target 172.20.134.52
Target set to 'your-director'
Your username: admin	
Enter password: *****
Logged in as `admin'
</pre>

