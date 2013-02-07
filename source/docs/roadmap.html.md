---
title: Cloud Foundry Roadmap
---

Updated in early Feb, 2013. 

Post questions about our roadmap [here](https://groups.google.com/a/cloudfoundry.org/forum/?fromgroups#!forum/vcap-dev).

## February 2013

* Preview of Team Edition with [Micro Cloud Foundry](http://cloudfoundry.github.com/docs/running/micro_cloud_foundry/).
* Move to [GitHub Pull Requests](https://groups.google.com/a/cloudfoundry.org/d/msg/vcap-dev/61ziGuPATDs/iD_dz96lwIcJ) for all repositories, stop using Gerrit
* Preview of new consolidated documentation (You're looking at it!)

## April 2013

### Team Edition production release

#### Updated [Router](https://github.com/cloudfoundry/gorouter)
* Implemented in Go, no longer using nginx
* Load tested with 4x better performance
* WebSocket support

#### Updated [Cloud Controller](https://github.com/cloudfoundry/cloud_controller_ng) supporting the Cloud Foundry API 2.0
* Self-organizing teams with Organizations and Spaces
* Team collaboration support for apps and services
* Custom domain management
* User management and permissions
* Add support for MySQL for the Cloud Controller database
* Blob storage now supports local directories or s3
* Quota enforcement - operators enforce limits on resource consumption
  * number of apps
  * amount of memory
  * number and type of services
* Usage events - useful for auditing and billing use cases

#### Updated [DEA](https://github.com/cloudfoundry/dea_ng)
* New support for Heroku-inspired buildpacks
  * Easier to bring languages and containers to the platform
  * Self-contained buildpacks do not require code changes in multiple Cloud Foundry components
  * Builds on the MIT licensed Heroku buildpack ecosystem
  * Use the curated buildpacks, fork and make changes, or build your own
* Improved application isolation with Linux containers
* Staging happens on DEA’s instead of the separate Stager component
  * Environment variable changes do not require restaging

#### Updated [Services](https://github.com/cloudfoundry/vcap-services/tree/master/ng)
* Updated versions
  * MongoDB 2.2
  * MySQL 5.5
  * Postgres 9.1
  * RabbitMQ 2.8
  * Redis 2.6
* New large capacity services
* New service instance isolation options
  * Run service instances in Linux containers on the same instance for high-density and security
  * Run instances in separate VMs for maximum isolation
* Snapshots - user managed snapshots, restore, download, 

#### Updated [Health Manager](https://github.com/cloudfoundry/health_manager)
*  Significantly improved performance

#### Team Edition Web Portal (Enterprise Offering)
* Web-based user interface for Cloud Foundry
* Manage users, applications, services, domains
* Review and manage usage

#### Updated [User Account and Authentication](https://github.com/cloudfoundry/uaa) Service (UAA)
* Simplified bootstrapping
* User managed approvals and revocations

#### Amazon Web Services ease-of-use
* Simplified deployment
  * Answer a few questions, supply your AWS credentials, get a full multi-node deployment
* BOSH support for DHCP
* BOSH support for AWS VPC networks


