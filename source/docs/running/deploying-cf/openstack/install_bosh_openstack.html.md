---
Install Bosh using Micro BOSH on OpenStack
---

1. Deploy micro BOSH on OpenStack. See the steps in the previous section (Installing Micro BOSH on a VM)

1. Once your micro BOSH instance is deployed, you can target its Director:

  	$ bosh micro status
		...
		Target         micro (http://11.23.194.100:25555) Ver: 0.3.12 (00000000)

		$ bosh target http://11.23.194.100:25555
		Target set to 'micro (http://11.23.194.100:25555) Ver: 0.3.12 (00000000)'

		$ bosh status
		Updating director data... done

		Target         micro (http://11.23.194.100:25555) Ver: 0.3.12 (00000000)
		UUID           b599c640-7351-4717-b23c-532bb35593f0
		User           admin
		Deployment     not set

### Download a BOSH stemcell

1. List public stemcells with bosh public stemcells

		% mkdir -p ~/stemcells
		% cd stemcells
		% bosh public stemcells --all
    
        +---------------------------------------------+-----------------------------+
        | Name                                        | Tags                        |
        +---------------------------------------------+-----------------------------+
		| bosh-stemcell-0.3.0.tgz                     | vsphere                     |
		| bosh-stemcell-0.4.4.tgz                     | vsphere                     |
		| bosh-stemcell-0.4.7.tgz                     | vsphere                     |
		| bosh-stemcell-0.5.2.tgz                     | vsphere                     |
		| bosh-stemcell-aws-0.5.1.tgz                 | aws                         |
		| bosh-stemcell-aws-0.6.4.tgz                 | aws, stable                 |
		| bosh-stemcell-aws-0.6.7.tgz                 | aws                         |
		| bosh-stemcell-aws-0.7.0.tgz                 | aws, test                   |
		| bosh-stemcell-openstack-0.6.7.tgz           | openstack                   |
		| bosh-stemcell-openstack-kvm-0.7.0.tgz       | openstack, kvm, test        |
		| bosh-stemcell-vsphere-0.6.1.tgz             | vsphere                     |
		| bosh-stemcell-vsphere-0.6.2.tgz             | vsphere                     |
		| bosh-stemcell-vsphere-0.6.3.tgz             | vsphere                     |
		| bosh-stemcell-vsphere-0.6.4.tgz             | vsphere, stable             |
		| bosh-stemcell-vsphere-0.6.7.tgz             | vsphere, stable             |
		| bosh-stemcell-vsphere-0.7.0.tgz             | vsphere, test               |
		| micro-bosh-stemcell-aws-0.6.4.tgz           | aws, micro, stable          |
		| micro-bosh-stemcell-aws-0.7.0.tgz           | aws, micro, test            |
		| micro-bosh-stemcell-aws-0.8.1.tgz           | aws, micro, test            |
		| micro-bosh-stemcell-openstack-0.7.0.tgz     | openstack, micro, test      |
		| micro-bosh-stemcell-openstack-kvm-0.8.1.tgz | openstack, kvm, micro, test |
		| micro-bosh-stemcell-vsphere-0.6.4.tgz       | vsphere, micro, stable      |
		| micro-bosh-stemcell-vsphere-0.7.0.tgz       | vsphere, micro, test        |
		| micro-bosh-stemcell-vsphere-0.8.1.tgz       | vsphere, micro, test        |
		+---------------------------------------------+-----------------------------+

To download use 'bosh download public stemcell <stemcell_name>'.


1. Download a public stemcell. *NOTE, in this case you do not use the micro bosh stemcell.*

		bosh download public stemcell bosh-stemcell-openstack-0.6.7.tgz

1. Upload the downloaded stemcell to micro BOSH.

		bosh upload stemcell bosh-stemcell-openstack-0.6.7.tgz

### Upload a BOSH release ###

1. You can create a BOSH release or use one of the public releases. The following steps show the use of a public release.

		cd /home/bosh_user
		git clone  git@github.com:cloudfoundry/bosh.git

1. Upload a public release from bosh-release

		cd /home/bosh_user/bosh/release/
		bosh upload release releases/bosh-10.yml


### Setup a BOSH deployment manifest and deploy ###

1. Create and setup a BOSH deployment manifest. Look at the sample BOSH manifest in (https://gist.github.com/rsgoodman/4279969) and enter your settings. Assuming you have created a `bosh.yml` in `/home/bosh_user`.

		cd /home/bosh_user
		bosh deployment ./bosh.yml

1. Deploy BOSH

		bosh deploy.

1. Target the newly deployed bosh director. In the sample `bosh.yml`, the bosh director has the ip address 192.0.2.36. So if you target this director with `bosh target http://192.0.2.36:25555` where 25555 is the default BOSH director port.  Your newly installed BOSH instance is now ready for use.
