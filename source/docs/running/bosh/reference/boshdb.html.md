---
title: BOSH DB
---

BOSH contains a postgres database which is used to maintain state for three main processes:

* BOSH Core (20 tables): All information releated to releases, deployments, stemcells and more.
* PowerDNS (3 tables): Used for the PowerDNS component to provide DNS resolution for BOSH's deployments.
* Registry (6 tables): Used for maintaining an IaaS (e.g. OpenStack) world view of the VMs/resources that BOSH allocates for its deployments.

All of these tables exist in the same bosh database.

## BOSH Core ##
Every deployment of BOSH sets up the following schema in its db.

![bosh-db-schema](/images/bosh/bosh-db-schema.png)

## PowerDNS ##
If you've choosen to deploy the PowerDNS component of BOSH, then the following schema is created in the same bosh db.

![powerdns-db-schema](/images/bosh/powerdns-db-schema.png)

## Registry ##
If you've choosen to deploy the registry component of BOSH (required if deploying to OpenStack), then the following schema is created in the same bosh db.

![registry-db-schema](/images/bosh/registry-db-schema.png)

## Blobstore ##
The following tables contain links to the blobstore