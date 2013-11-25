---
title: Run a Local Cloud Foundry Instance
---

In the previous release of Cloud Foundry, Micro Cloud Foundry was a useful tool for Cloud Foundry developers or anyone with a need to run a local instance of Cloud Foundry. Micro Cloud Foundry has not been upgraded for Cloud Foundry v2.  

For Cloud Foundry v2 users, there are a few ways to establish a local Cloud Foundry environment in a single VM:

## bosh-lite

bosh-lite uses Vagrant and a Warden BOSH CPI to deploy Cloud Foundry in a VM. A single VM is created using Vagrant, then each Cloud Foundry component is deployed in its own Warden container using BOSH. bosh-lite supports VMware Fusion, Virtualbox, and AWS. 

See https://github.com/cloudfoundry/bosh-lite for more information and usage instructions. 

## cf\_nise\_installer

cf\_nise\_installer provisions and runs a local Cloud Foundry instance, either on a physical machine or a Vagrant VM, using the BOSH packaging structure.  Nise BOSH is a lightweight BOSH emulator, and is a good option if your goal is to learn about using BOSH to deploy Cloud Foundry. cf\_nise\_installer with Vagrant supports Virtualbox only. 

See https://github.com/nttlabs/nise_bosh for more information about the Nise BOSH project and https://github.com/yudai/cf_nise_installer for more information about using Nise BOSH to install Cloud Foundry.

## cf-vagrant-installer

cf-vagrant-installer uses Vagrant and Chef to provision a virtual machine and load Cloud Foundry components. The Vagrant installer is a good option if your primary goal is an environment for exploring Cloud Foundry components and functionality. cf-vagrant-installer supports VMware Fusion, VMware Workstation, and Virtualbox. 

See https://github.com/Altoros/cf-vagrant-installer and [Installing Cloud Foundry on Vagrant](http://blog.cloudfoundry.com/2013/06/27/installing-cloud-foundry-on-vagrant/).

