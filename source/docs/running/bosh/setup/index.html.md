---
title: Local Setup
---

# BOSH CLI #

BOSH CLI is a command line interface used to interact with MicroBOSH and BOSH. 
Before we can use MicroBOSH or BOSH we need to install BOSH Command Line Interface.

## Installing BOSH Command Line Interface ##

The following steps install BOSH CLI on Ubuntu 12.04.1 LTS. You can install on either a physical or Virtual Machine.

### Install Ruby ###

Ruby can be installed using either rbenv or rvm. Please refer to the following documents for more details

1. [Install ruby using rvm](../common/install_ruby_rvm.html)
2. [Install ruby using rbenv](../common/install_ruby_rbenv.html)


### Install Local BOSH and BOSH Releases ###

1. Install the BOSH CLI

		gem install bosh_cli

_Note : run `rbenv rehash`command if you used rbenv to install ruby_
		
		bosh --version

1. Clone the BOSH and bosh-release repositories using git

		git clone git@github.com:cloudfoundry/bosh.git

		git clone git@github.com:cloudfoundry/bosh-release.git

_Note : we will be using an old commit from the bosh-release repository during a transition to new release functionality_

1. Get release 11 from a branch of bosh-release

		cd bosh-release
		git checkout 9e0b649da80a563ba64229069299c57f72ab54ad

1. Continue by deploying to your infrastructure referring to one of the following sections

- ec2 (coming soon)
- [OpenStack](../deploying-cf/openstack/index.html)
- [vcloud](../deploying-cf/vcloud/index.html)
- [vsphere](../deploying-cf/vsphere/index.html)



