---
title: Installing Micro BOSH, BOSH and Cloud Foundry on AWS
---

The main goal of this document is to guide someone with minimal experience through an end to end deployment of Cloud Foundry (CF) running on AWS EC2.This includes guided installation of CLI tools locally, installation of Micro BOSH, deployment of BOSH from Micro BOSH on AWS and deployment of CF from BOSH on AWS.

  <pre class='warning'>
  **WARNING**:  About production use - Currently on AWS we have to use BOSH DNS which requres a single VM implementation of PostgreSQL.
  This leaves us with a not very fault tolerant DNS situation. Without a reliable DNS situation you'll need to use static IP's for
  communicating between internal VM's. That situation is not detailed here as the scope of this document is to get you up and running as quickly as is currently possible
  </pre>


In order to setup and deploy a full CF release via BOSH there are 9 major steps:

Review the [Glossary](/docs/running/deploying-cf/aws-ec2/glossary.html) for any unfamiliar terms

1. [Create an AWS Account](http://goo.gl/MaAybK) This step is only necessary if you don’t already have an AWS account.

1. [Local preparation for Micro BOSH deployment](/docs/running/deploying-cf/aws-ec2/local_bosh.html)

1. [Configuring AWS for Micro BOSH](/docs/running/deploying-cf/aws-ec2/configure_aws_micro_bosh.html)

1. [Deployment of Micro BOSH on AWS](/docs/running/deploying-cf/aws-ec2/deploy_aws_micro_bosh.html)

1. [Configuring AWS for BOSH](/docs/running/deploying-cf/aws-ec2/configure_aws_bosh.html)

1. [Deployment of BOSH on AWS](/docs/running/deploying-cf/aws-ec2/deploy_aws_bosh.html)

1. [Configuring AWS for CF](/docs/running/deploying-cf/aws-ec2/configure_aws_cf.html)

1. [Deployment of CF on AWS](/docs/running/deploying-cf/aws-ec2/deploy_aws_cf.html)

1. [Example apps deployed on CF](/docs/running/deploying-cf/aws-ec2/example_apps.html)


For advanced or support topics:

* [Destroying a deployment](/docs/running/deploying-cf/aws-ec2/destroying_deployments.html)