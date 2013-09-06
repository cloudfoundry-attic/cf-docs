---
title: BOSH DB
---

BOSH contains a postgres database which is used to maintain state for three main processes:
* BOSH Core
* PowerDNS
* OpenStack Registry

## BOSH Core ##
Every deployment of BOSH sets up the following schema in its db.

![bosh-db-schema](/images/bosh/bosh-db-schema.png)

## PowerDNS ##
If you've choosen to deploy the PowerDNS component of BOSH, then the following schema is created in the same bosh db.

![powerdns-db-schema](/images/bosh/powerdns-db-schema.png)

## Registry ##
If you've choosen to deploy the registry component of BOSH (required if deploying to OpenStack), then the following schema is created in the same bosh db.

![registry-db-schema](/images/bosh/registry-db-schema.png)