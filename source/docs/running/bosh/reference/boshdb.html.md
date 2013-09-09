---
title: BOSH Database
---

BOSH contains a database which is used to maintain state for three main processes:

* BOSH Core (20 tables): All information related to releases, deployments, stemcells and more
* PowerDNS (3 tables): Used for the PowerDNS component to provide DNS resolution for BOSH's deployments
* Registry (6 tables): Used for maintaining an IaaS (e.g. OpenStack) world view of the VMs/resources that BOSH allocates for its deployments

These tables can co-exist in a single database or they can be separated into their own.

## BOSH Core ##
Every deployment of BOSH sets up the following schema in its database.

![bosh-db-schema](/images/bosh/bosh-db-schema.png)

## PowerDNS ##
If you've chosen to deploy the PowerDNS component of BOSH, then the following schema is created.

![powerdns-db-schema](/images/bosh/powerdns-db-schema.png)

## Registry ##
If you've chosen to deploy the registry component of BOSH (required if deploying to OpenStack or AWS), the following schema is created.

![registry-db-schema](/images/bosh/registry-db-schema.png)

## Blobstore ##
The following tables link to BOSH's blobstore component:

* compiled_packages
* packages
* log_bundles
* templates