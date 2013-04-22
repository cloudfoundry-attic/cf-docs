---
title: Deploying Cloud Foundry on AWS
---

  <br />
  <table style="width: 70%;"><tr><td>
  NOTE: As of mid April, 2013 the AWS bootstrap is a moving target / too fragile to be useful. Expect revised and stable instructions in mid May.
  </td></tr></table>

  <table style="width: 70%;"><tr><td>
  WARNING: BOSH AWS DESTROY will kill all S3 buckets, all instances, all everything in your AWS account. Do not use this command unless everything in your AWS account, including stuff that has nothing to do with Cloud Foundry, is expendable.
  </td></tr></table>

## <a id='intro'></a> Introduction ##

Cloud Foundry provide tools to simplify the process for deploying an instance of Cloud Foundry to a variety for platforms, including Amazon Web Services. This guide will guide you through using BOSH and vmc to deploy Cloud Foundry to Amazon Web Services.

## <a id='domain-prep'></a> Prepare a domain ##

The first thing to do is make sure you have a domain available for use with your Cloud Foundry instance. The BOSH AWS boostrapper expects an AWS Route 53 Hosted Zone to exist for the domain. Go to the Route 53 [control panel](https://console.aws.amazon.com/route53) to create a hosted zone.

The bosh AWS bootstrapper currently expects the Cloud Foundry / BOSH installation to be available at a third-level domain, e.g - cloud.mydomain.com. Create a Route53 hosted zone for that domain, copy the reported delegation set when the zone has been created. Add an NS record with your domains registrar for each of the name servers in the zone's delegation set.

<img src="/images/bosh-aws/hostedzone.png" />

## <a id='deployment-env-prep'></a> Prepare the deployment environment ##

Install the latest development release of vmc and also the admin plugin.

<pre class="terminal">
$ gem install vmc --pre
$ gem install admin-vmc-plugin
</pre>

Create a working directory and clone the BOSH repository, this will become the working folder for all BOSH deployments.

<pre class="terminal">
$ cd ~/workspace
$ git clone git@github.com:cloudfoundry/bosh.git bosh
$ cd bosh
$ bundle install --binstubs --local
$ mkdir -p tmp/deployments-aws
$ cd tmp/deployments-aws
</pre>

Next, set environmental variables required for deploying to AWS

Note: for the availability zones - look at https://console.aws.amazon.com/ec2/v2/home?region=us-east-1 and choose zones that are "operating normally".

Create a file called bosh_environment and add the following, changing the value for each line to suit your configuration

~~~
export BOSH_VPC_DOMAIN=mydomain.com 
export BOSH_VPC_SUBDOMAIN=cloud
export BOSH_AWS_ACCESS_KEY_ID=your_key_asdv34tdf
export BOSH_WORKSPACE= ~/workspace/bosh/tmp/deployments-aws
export BOSH_AWS_SECRET_ACCESS_KEY=your_secret_asdf34dfg
export BOSH_VPC_SECONDARY_AZ=us-east-1a
export BOSH_VPC_PRIMARY_AZ=us-east-1d
export PATH=~/workspace/bosh/bin:$PATH
~~~

Use "source" to set them for the current shell;

<pre class="terminal">
$ source ~/workspace/bosh/tmp/deployments-aws/bosh_environment
</pre>

Run `bosh aws create` to create a gateway, subnets, an RDS database, and a cf_nat_box instance for Cloud Foundry subnet routing.

<pre class="terminal">
$ bosh aws create
</pre>

Note: The RDS datbase creation may take a while.

<pre class="terminal">
$ alias bosh='bundle exec bosh'
$ cd $BOSH_WORKSPACE
$ bosh aws create
</pre>

## <a id='deploy-microbosh'></a> Deploy MicroBOSH ##

Deploy MicroBOSH from the workspace directory;

<pre class="terminal">
$ cd $BOSH_WORKSPACE
$ bosh aws bootstrap micro

WARNING! Your target has been changed to `http://10.10.0.5:25555'!
Deployment set to '~/workspace/bosh/tmp/private-deployments/deployments/micro/micro_bosh.yml'
Deploying new micro BOSH instance `micro/micro_bosh.yml' to `http://10.10.0.5:25555' (type 'yes' to continue): yes

Deploy Micro BOSH
  using existing stemcell (00:00:00)                                                                
  creating VM from ami-9027b9f9 (00:00:39)                                                          
Waiting for the agent               |oooo                    | 2/11 00:01:23  ETA: 00:02:14   
</pre>

After MicroBOSH has been deployed succesfully, check it's status;

<pre class="terminal">
$ bosh status

Updating director data... done

Director
  Name      micro-cloud
  URL       http://x.x.x.x.x:25555
  Version   1.5.0.pre2 (release:48d80686 bosh:48d80686)
  User      admin
  UUID      c7a404fd-bcf8-4eed-ac14-10c162386de6
  CPI       aws
  dns       enabled (domain_name: microbosh)
  compiled_package_cachedisabled

Deployment
  Manifest  ~/workspace/bosh/tmp/private-deployments/deployments/micro/micro_bosh.yml
</pre>

## <a id='deploy-cloudfoundry'></a> BOSH Deploy Cloud Foundry ##

Cloud Foundry can now be deployed using the vmc 'bootstrap' plug-in. Run the bootstrap command with vmc through bundler.

<pre class="terminal">
$ bundle exec vmc bootstrap aws
</pre>

This process can take some time, especially during it's first run when it compiles all the jobs for the first time. When Cloud Foundry has installed it should be possible to target the install with vmc and login as the admin user with the user name 'admin' and the password 'the\_admin\_pw'.

As the admin of the installation and before it's possible to push a test application it is important to create an initial organization and space. Create the organization first;

<pre class="terminal">
$ vmc create-org test-org
Creating organization test-org... OK
Switching to organization test-org... OK


There are no spaces in test-org.
You may want to create one with create-space.

target: http://ccng.cloud.xxxxxx.xx
organization: test-org
</pre>

As the help text indicates, there are no spaces for 'test-org', create one with the create-space command;

<pre class="terminal">
$ vmc create-space development
Creating space development... OK
Adding you as a manager... OK
Adding you as a developer... OK
</pre>

Tell vmc to target the space by using the 'target' command with the --ask-space switch

<pre class="terminal">
$ vmc target --ask-space
Switching to space development... OK

target: http://ccng.cloud.xxxxxx.xx
organization: test-org
space: development
</pre>

## <a id='deploy-notes'></a> BOSH Deployment Notes ##

Once Cloud Foundry has been deployed using the bootstrap vmc plugin there will be several files left in the $BOSH_WORKSPACE folder;

<table>
  <tr><th>File</th><th>Purpose</th></tr>
  <tr>
    <td>cf-aws.yml</td>
    <td>This is the BOSH manifest file for Cloud Foundry that was used to deploy to AWS. You can use this file to re-deploy the Cloud Foundry instance again. For more information, see <a href="">managing BOSH deployments</a></td>
  </tr>
  <tr>
    <td>aws_rds_receipt.yml, aws_route53_receipt.yml, aws_vpc_receipt.yml</td>
    <td>At the end of the MicroBOSH bootstrapping procedure these 'receipt' files are written to provide data used to template the manifest file used for deploying Cloud Foundry</td>
  </tr>
</table>

For more information with regard to managing organizations, spaces and users, go to the [vmc](../../../using/managing-apps/vmc) page

