---
title: BOSH Components - Stemcell
---

A Stemcell is a VM template with an embedded [BOSH Agent](agent.html.md) The Stemcell used for Cloud Foundry is a standard Ubuntu distribution.
Stemcells are uploaded using the [BOSH CLI](#bosh-cli) and used by the [BOSH Director](director.html.md) when creating VMs through the Cloud Provider Interface.
When the Director creates a VM through the CPI, it will pass along configurations for networking and storage, as well as the location and credentials for the [Message Bus](messaging.html.md) and the [Blobstore](blobstore.html.md).
