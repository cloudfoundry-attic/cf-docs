---
title: Hardware Requirement 
---

This page shows the recommended hardware requirement for installing BOSH and Cloud Foundry on vSphere.

## Hardware Components ##

* Physical servers to install ESXi and vCenter
* Storage servers
* L3 switch to create a Private network
* Firewall for Routing and Security

## Physical servers ##

The hardware requirements depends on the size of the RAM and CPUs allocated for each of the VMs. Values below are only indicative.

### ESXi host servers: Server 1 and 2 ###

*Note*: configuration is for each of the machines

##### Minimum Specs

* 4 CPUs: Intel Xeon E5620 @ 2.40 GHz, 2 cores per CPU
* At least 4 NIC cards
* 60 GB RAM

##### Recommended Spec

* 8 CPUs Intel Xeon E5620 @ 2.40 GHz, 2 cores per CPU
* At least 4 NIC cards or Dual HBA Cards for Fiber Channel per host
* 80 GB RAM running in Tri-Channel Memory Support (Multiples of 6)

### vCenter Server ###

This could run Windows natively or on top of a ESXi host in a VM.

##### Minmum Specs

* 1 CPUs Intel Xeon E5620, 4 cores per CPU
* 8 GB RAM
* 256 GB hard disk

##### Recommended Specs

* 2 CPUs Intel Xeon E5620, 4 cores per CPU
* 8 GB RAM
* 2 x 256 GB hard disk

### Storage ###

A minimum of 1 TB of Network storage is required. This could be SAN based storage or EMC VNX based storage.
Ethernet or Fiber Channel; should support Jumbo Frames.

### Switch ###

##### Min Specs

* L2 switch with 24 ports.

##### Recommended Specs

* L3 switch with 48 ports and 100 GB RAM
* 12 CPUs Intel Xeon E5649 @ 2.53 GHz

