---
title: Deploying BOSH with Micro BOSH
---

# Deploy BOSH as an application using micro BOSH. #

1. Deploy micro BOSH. See the steps in the [previous section](deploying_micro_bosh.html)

1. Once your micro BOSH instance is deployed, you can target its Director:

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

		Director
  			Name      your-micro-BOSH
  			URL       http://11.23.194.100:25555
  			Version   0.5.2 (release:ffed4d4a bosh:21e0b0bc)
  			User      admin
  			UUID      729b6100-4035-4b35-ab9a-cf8299719fe3
  			CPI       vsphere

		Deployment
  			not set

_Note: Create a new user using `bosh create user` which overrides the default username / password_

### Download a BOSH stemcell

1. List public stemcells with bosh public stemcells

		$ mkdir -p ~/stemcells
		$ cd ~/stemcells
		$ bosh public stemcells

		+---------------------------------------+------------------------+
		| Name                                  | Tags                   |
		+---------------------------------------+------------------------+
		| bosh-stemcell-aws-0.6.4.tgz           | aws, stable            |
		| bosh-stemcell-vsphere-0.6.4.tgz       | vsphere, stable        |
		| bosh-stemcell-vsphere-0.6.7.tgz       | vsphere, stable        |
		| micro-bosh-stemcell-aws-0.6.4.tgz     | aws, micro, stable     |
		| micro-bosh-stemcell-vsphere-0.6.4.tgz | vsphere, micro, stable |
		+---------------------------------------+------------------------+
		To download use `bosh download public stemcell <stemcell_name>'. For full url use --full.


1. Download a public stemcell. *NOTE, in this case you do not use the micro bosh stemcell.*

		$ bosh download public stemcell bosh-stemcell-vsphere-0.6.7.tgz 

1. Upload the downloaded stemcell to micro BOSH.

		$ bosh upload stemcell bosh-stemcell-vsphere-0.6.7.tgz

1. You can see the uploaded stemcells (on your Micro BOSH) by using `bosh stemcells`

		$ bosh stemcells

		+---------------+---------+-----------------------------------------+
		| Name          | Version | CID                                     |
		+---------------+---------+-----------------------------------------+
		| bosh-stemcell | 0.6.7   | sc-1033810d-f3ff-42b5-8d39-58cb035638fc |
		+---------------+---------+-----------------------------------------+

### Upload a BOSH release ###

1. Rather than creating a new release, we will use the public release from in the [local setup instructions](../bosh/setup/index.html).

		$ cd ~/bosh-release
		$ bosh upload release releases/bosh-11.yml


### Setup a BOSH deployment manifest and deploy ###

1. Create and setup a BOSH deployment manifest. Look at the [BOSH example manifest](../../bosh/reference/bosh-example-manifest.html). 

1. Deploy bosh. (the following assumes your manifest is named `bosh.yml` in `/home/bosh_user`).

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

_Note: There will be a lot of status information in addition to the above output_

### Verification 

1. The example bosh director has the ip address 172.20.134.52. Targeting this director with `bosh target 172.20.134.52` will verify a successful installation.

		bosh target 172.20.134.52
		Target set to 'your-director'
		Your username: admin	
		Enter password: *****
		Logged in as `admin'
