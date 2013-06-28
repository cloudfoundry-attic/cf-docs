---
title: Run a Local Cloud Foundry Instance
---
In the previous release of Cloud Foundry, Micro Cloud Foundry was a useful tool for Cloud Foundry developers or anyone with a need to run a local instance of Cloud Foundry. Micro Cloud Foundry has not been upgraded for Cloud Foundry v2.  


For  Cloud Foundry v2 users, there are two ways to establish a local Cloud Foundry environment:

* cf-vagrant-installer uses Chef to provision a Vagrant virtual machine and load Cloud Foundry components. The Vagrant installer is a good option if your primary goal is an environment for exploring Cloud Foundry components and functionality.  See  https://github.com/Altoros/cf-vagrant-installer.

* Nise BOSH also provisions and runs a local Cloud Foundry instance, either on a physical machine or a Vagrant VM, but uses the BOSH packaging structure.  Nise BOSH is a lightweight BOSH emulator, and is a good option if your goal is to learn about using BOSH to  deploy Cloud Foundry. See https://github.com/nttlabs/nise_bosh.


