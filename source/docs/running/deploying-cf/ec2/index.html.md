---
title: Deploying Cloud Foundry on EC2
---

The following instructions take you through the entire process of pushing Cloud Foundry to Amazon Web Services. An alternative / simpler approach is to use Dr. Nic's [bosh-cloudfoundry](https://github.com/StarkAndWayne/bosh-cloudfoundry).

##Prerequisites##

To get started with BOSH on AWS you need:

1. An AWS VPC Account
3. A Mac or *NIX computer
4. The [BOSH CLI](../../bosh/setup/index.html)

## Micro BOSH Stemcells##

+ We have published micro BOSH stemcells for download. When you are ready to use the BOSH deployer download a micro BOSH stemcell.

Download a micro BOSH stemcell.


		% bosh public stemcells
		+---------------------------------------+--------------------------------------------------+
		| Name 	                                | Tags                                             |
		+---------------------------------------+--------------------------------------------------+
		| bosh-stemcell-aws-0.6.4.tgz           | aws, stable                                      |
		| bosh-stemcell-vsphere-0.6.4.tgz       | vsphere, stable                                  |
		| bosh-stemcell-vsphere-0.6.7.tgz       | vsphere, stable                                  | 
		| micro-bosh-stemcell-aws-0.6.4.tgz     | aws, micro, stable                               |
		| micro-bosh-stemcell-vsphere-0.6.4.tgz	| vsphere, micro, stable                           |
		+---------------------------------------+--------------------------------------------------+

To download use `bosh download public stemcell <stemcell_name>` as shown below
	
	% bosh download public stemcell micro-bosh-stemcell-aws-0.6.4.tgz

##Deploying Micro BOSH##

To deploy Micro Bosh on AWS you will need to prepare resources from the cloud infrastructure managed by AWS for use by BOSH.