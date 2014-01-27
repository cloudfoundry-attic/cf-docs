---
title: Glossary
---

## Inceptions

There will be 3 "inceptions" that will occur starting with your local computer.

### Micro Inception

Local computer creates a Micro BOSH server.

### BOSH Inception

Local computer creates a full BOSH Release set of servers.

### Cloud Foundry (CF) Inception

Local computer is used to create a set of Cloud Foundry servers from a CF release.

## Elements

Every inception utilizes four elements: Stemcell, Release and Deployment Manifest, BOSH CLI and Security Groups.

### Stemcell

A stemcell is a specific operating system image containing a preinstalled agent and associated package bits to support the running of a server.  There are two types of stemcells that we will be using, one for the MicroBOSH and one for the BOSH and CF servers. Stemcells are not interchangeable and are hypervisor specific.

### Deployment Manifest

The deployment manifest is a YAML (.yml) file which prescribes the parameters by which the next server in the inception will be configured.  During the first step we create a deployment manifest file on the computer which prescribes the configuration of one of the following: Micro BOSH, BOSH or CF servers.

### Release

This file contains references to all the packages available to the stemcell.  Like the Deployment Manifest this is a YAML (yml) file and is deployed from the local server to the BOSH server.

### BOSH CLI

The BOSH CLI is a tool which allows you to consume the stemcell and control an inception of bosh.

### Security Groups

At each inception additional ports need to be opened on AWS for pieces of the architecture to talk to each other.

## Local System

The local system used as an example within this document is a OSX laptop. This does not need to be the case, any Linux/Unix/Windows system should do. The details of using these other systems are outside of the scope of this document.
