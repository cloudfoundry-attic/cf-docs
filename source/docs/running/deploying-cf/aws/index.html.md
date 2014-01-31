---
title: Deploying Cloud Foundry on AWS
---

There are several paths you can choose to deploy Cloud Foundry with BOSH upon AWS.

## <a id='bootstrap-vpc'></a>Bootstrap upon AWS VPC ##

The BOSH &amp; Cloud Foundry Runtime teams maintain a bootstrapping tool to deploy Cloud Foundry within AWS VPC.

Note, this tutorial deploys Cloud Foundry to the VPC flavor of AWS, rather than the explicit EC2 flavor of AWS.  This is the production choice for running Cloud Foundry currently. There are two reasons:

* Additional security offered by network isolation
* Static IPs are used for service discovery

Follow the [tutorial](/docs/running/deploying-cf/bootstrap-aws-vpc/).

This is the solution used by Pivotal to deploy and operate their [hosted Cloud Foundry solution](http://run.pivotal.io).

## <a id='low-level-ec2'></a>Step-by-step upon AWS EC2 ##

To learn many of the steps of deploying Cloud Foundry on BOSH by following this low-level, step-by-step tutorial for AWS EC2.

Follow the [tutorial](/docs/running/deploying-cf/aws-ec2/).

Note, this tutorial deploys Cloud Foundry to the EC2 flavor of AWS, rather than the explicit VPC flavor of AWS.  This is not a production choice for running Cloud Foundry current due to:

* Use of BOSH's internal PowerDNS for service discover, which has a single point of failure in its backend PostgreSQL server.

AWS EC2 VMs cannot have a pre-allocated IP address (called a static IP). Unless a BOSH deployment manages its own service discovery solution, say with ETCD, a BOSH deployment must explicit document in advance where each service (a BOSH job) is running. One option is to use AWS Elastic IPs. Another is to use BOSH's handy internal DNS feature. The latter is the method documented in this tutorial.

The PowerDNS implemented in BOSH is backed by PostgreSQL. If the PostgreSQL server stops operating then PowerDNS stops operating and jobs within each BOSH deployment become unable to discover each other. It may not happen very often and it may be a satisfactory risk for you.

## <a id='low-level-ec2'></a>Bootstrap upon AWS EC2 ##

There is a community tool [bosh-bootstrap](https://github.com/cloudfoundry-community/bosh-bootstrap "cloudfoundry-community/bosh-bootstrap · GitHub") that automates most of the steps in the "Step-by-step upon AWS EC2" tutorial above.
