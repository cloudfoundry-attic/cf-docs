---
title: Deploying Cloud Foundry on AWS
---

  <table style="width: 64%;"><tr><td>
  **WARNING**: The command `bosh aws destroy` destroys all S3 buckets, all instances, all everything in your AWS account. Do not use this command unless everything in your AWS account, including stuff that has nothing to do with Cloud Foundry, is expendable.
  </td></tr></table>


Cloud Foundry tools simplify the process of deploying a Cloud Foundry instance to a variety of platforms, including Amazon Web Services. The following sections guide you through using BOSH and cf to deploy Cloud Foundry to Amazon Web Services.

## <a id='domain-prep'></a> Prepare a Domain ##

The first thing to do is to pick a DNS domain name for your Cloud Foundry instance. If you pick *cloud.mydomain.com*, your applications will be available as *app-name.cloud.mydomain.com*.

Create an AWS Route 53 Hosted Zone for your domain at the [Route 53 control panel](https://console.aws.amazon.com/route53). The control panel shows you a "delegation set" - a list of addresses to which you must delegate DNS authority for your domain. If your domain is *cloud.mydomain.com*, each address in the delegation set should become an NS record in the DNS server for *mydomain.com*.

<img src="/images/bosh-aws/hostedzone.png" />

## <a id='deployment-env-prep'></a> Prepare the Deployment Environment ##

Ruby 1.9.3 and git (1.8 or later) are prerequisites for the following steps. After you install Ruby and git, install the `bundler` RubyGem:

<pre class="terminal">
$ gem install bundler
</pre>

Create a working directory from which to deploy the environment. For example, `$HOME/cf`. In that directory, create a file named `Gemfile` with the following contents:

~~~
source 'https://rubygems.org'

ruby "1.9.3"

gem "bootstrap-cf-plugin", :git => "git://github.com/cloudfoundry/bootstrap-cf-plugin"

gem "bosh_cli_plugin_aws"
~~~

Install the latest release of the bootstrap plugin.

<pre class="terminal">
$ cd $HOME/cf
~/cf$ bundle install
</pre>

Next, set environment variables required for deploying to AWS. Create a file called `bosh_environment` and add the following, changing the value for each line to suit your configuration:

~~~
export BOSH_VPC_DOMAIN=mydomain.com
export BOSH_VPC_SUBDOMAIN=cloud # Pick something more unique than 'cloud' to work around a temporary shortcoming of the tool
export BOSH_AWS_ACCESS_KEY_ID=your_key_asdv34tdf
export BOSH_AWS_SECRET_ACCESS_KEY=your_secret_asdf34dfg
export BOSH_AWS_REGION=us-east-1
export BOSH_VPC_SECONDARY_AZ=us-east-1a # see note below
export BOSH_VPC_PRIMARY_AZ=us-east-1d   # see note below
~~~

*Note:* `BOSH_VPC_DOMAIN` and `BOSH_VPC_SUBDOMAIN` must correspond to the DNS domain name you set up when configuring Route 53. The values shown above correspond to the earlier Route 53 example of *cloud.mydomain.com*.

*Note:* Now only deployment to `us-east-1` region is supported by next
steps. For MicroBOSH deploy please review [following guide](https://gist.github.com/danhigham/5804252).

Choose availability zones that are listed as "operating normally" on
the [AWS Console Status Health Section](https://console.aws.amazon.com/ec2/v2/home?region=us-east-1)
for your region.

Use `source` to set them for the current shell:

<pre class="terminal">
~/cf$ source bosh_environment
</pre>

Run `bosh aws create` to create a VPC Internet Gateway, VPC subnets, 3 RDS databases, and a NAT VM for Cloud Foundry subnet routing. The command does not require user input, so start it and grab a coffee at the trendiest place across town!

<pre class="terminal">
~/cf$ bosh aws create
Executing migration CreateKeyPairs
allocating 1 KeyPair(s)
Executing migration CreateVpc
. . .
details in S3 receipt: aws_rds_receipt and file: aws_rds_receipt.yml
Executing migration CreateS3
creating bucket xxxx-bosh-blobstore
creating bucket xxxx-bosh-artifacts
</pre>

**Note:** RDS database creation may take 20+ minutes to finish.


## <a id='deploy-microbosh'></a> Deploy Micro BOSH ##

Deploy Micro BOSH from the workspace directory, using the `bosh aws bootstrap micro` command:

<pre class="terminal">
~/cf$ bosh aws bootstrap micro

WARNING! Your target has been changed to `https://10.10.0.6:25555'!
Deployment set to '/Users/pivotal/cf/deployments/micro/micro_bosh.yml'
Deploying new micro BOSH instance `micro/micro_bosh.yml' to `https://10.10.0.6:25555' (type 'yes' to continue): yes

Deploy Micro BOSH
  using existing stemcell (00:00:00)
. . .
Deployed `micro/micro_bosh.yml' to `https://10.10.0.6:25555', took 00:04:57 to complete
Logged in as `admin'
Enter username: foo
Enter password: ***
User `foo' has been created
Logged in as `foo'
User `hm' has been created
Logged in as `hm'
</pre>

After Micro BOSH has been deployed succesfully, you can check its status:

<pre class="terminal">
~/cf$ bosh status

Updating director data... done

Config
             ~/.bosh_config

Director
  Name       micro-xxxx
  URL        https://x.x.x.x:25555
  Version    1.5.0.pre.xxx (release:xxxxx bosh:xxxxx)
  User       hm
  UUID       xxxxxx-xxxx-xxxx-xxxx-xxxxxxxx
  CPI        aws
  dns        enabled (domain_name: microbosh)
  compiled_package_cache disabled

Deployment
  Manifest   ~/cf/deployments/micro/micro_bosh.yml
</pre>

## <a id='deploy-cloudfoundry'></a>Deploy Cloud Foundry ##

Cloud Foundry can now be deployed using the `bundle exec cf bootstrap aws` command from the bootstrap-cf-plugin gem.

<pre class="terminal">
~/cf$ bundle exec cf bootstrap aws
</pre>

This process can take some time (2-3 hours), especially during its first run when all the jobs are compiled for the first time. When the bootstrap has finished installing Cloud Foundry, it should be possible to target the install with cf and login as an administrator with the user name `admin` and the password `the_admin_pw`.

If this command fails, it's *usually possible to rerun it again*.  You can also rerun it to deploy the latest version of CF, unless there are changes to the resources created in the "bosh aws create" step above (in which case it should fail).

If this command fails with the following error -  **Error 400007: `service_gateways/0' is not running after update** - your networking is probably not set up correctly. You can check that with the following command (substituting your own subdomain and domain):

<pre class="terminal">
~/cf$ curl api.subdomain.domain/info
</pre>

If that is successful it should return the information as json. Otherwise, check your networking. *Tip* - make sure your domain has an NS record for your subdomain.

This bootstrap command runs two phases: first, several BOSH commands are executed and then several CF commands are executed. At the end of the process, you have the following primitives:

+ 2 BOSH releases: cf-release and cf-services-release, each pulled from the latest "green" release-candidate branch in github.
+ The latest "green" BOSH stemcell, downloaded from our CI server.
+ 2 already-deployed BOSH deployments: CF core and CF services, backed by generated manifest files described below.
+ 2 CF admin user accounts with randomly-generated passwords (find in cf-shared-secrets.yml).
+ A default CF organization called "bootstrap-org".
+ A default CF space called "bootstrap-space".
+ CF service-auth-tokens allowing CF core to authenticate to CF services.

At this point your "cf" command-line tool is targeted to your CF deployment and you are authenticated as the admin user, meaning _you're ready to push an app_!

## <a id='deploy-notes'></a> BOSH Deployment Notes ##

Once Cloud Foundry has been deployed using the bootstrap cf plugin, there will be several files left in the `$HOME/cf` folder:

<table>
  <tr><th>File</th><th>Purpose</th></tr>
  <tr>
    <td>cf-aws.yml</td>
    <td>BOSH manifest file for Cloud Foundry that was used to deploy to AWS. You can use this file to redeploy the Cloud Foundry instance again. For more information, see <a href="">managing BOSH deployments</a>.</td>
  </tr>
  <tr>
    <td>cf-services-aws.yml</td>
    <td>BOSH manifest file for Cloud Foundry services.
  </tr>
  <tr>
    <td>cf-shared-secrets.yml</td>
    <td>Shared secrets file for usernames and passwords used in various Cloud Foundry components.</td>
  </tr>
  <tr>
    <td>director.key and director.pem</td>
    <td>Self-signed SSL certificate used to encrypt the connection between BOSH CLI and Micro BOSH.</td>
  </tr>
  <tr>
    <td>elb-cfrouter.key and elb-cfrouter.pem</td>
    <td>Self-signed SSL certificate installed on the AWS ELB that fronts the Cloud Foundry routing layer.</td>
  </tr>
  <tr>
    <td>aws_rds_receipt.yml, aws_route53_receipt.yml, aws_vpc_receipt.yml</td>
    <td>At the end of the MicroBOSH bootstrapping procedure, these 'receipt' files are written to provide data used to template the manifest file used for deploying Cloud Foundry.</td>
  </tr>
</table>

For more information about managing organizations, spaces, and users, go to the [cf](../../../using/managing-apps/cf/index.html) page.

## <a id='destroy-environment'></a>Destroying the AWS Environment ##
  <table style="width: 70%;"><tr><td>
    **WARNING**: The command `bosh aws destroy` destroys all S3 buckets, all instances, **all everything** in your AWS account. Do not use this command unless everything in your AWS account, including stuff that has nothing to do with Cloud Foundry, is expendable.
  </td></tr></table>
  
You also want to cleanup any YAML artifacts that are no longer valid:

<pre class="terminal">
~/cf$ bosh aws destroy
~/cf$ rm -f *.yml
</pre>
