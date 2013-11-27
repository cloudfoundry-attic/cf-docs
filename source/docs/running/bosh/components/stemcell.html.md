---
title: Stemcell
---

A Stemcell is a VM template with an embedded [BOSH Agent](agent.html). The Stemcell used for Cloud Foundry is a standard Ubuntu 10.04 LTS distribution, but BOSH also produces stemcells for CentOS 6.4 on some IaaS providers. Stemcells are uploaded using the [BOSH CLI](#bosh-cli) and used by the [BOSH Director](director.html) when creating VMs through the Cloud Provider Interface.

When the Director creates a VM through the CPI, it uses the machine image from the stemcell, and passes along configurations for networking and storage, as well as the location and credentials for the [Message Bus](messaging.html) and the [Blobstore](blobstore.html). The agent inside the VM invokes the Director when it boots and is provided settings and additional software that should be configured on the VM as specified by the jobs in the deployment manifest.