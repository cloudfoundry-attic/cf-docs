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

Create a deployments directory with a subdirectory for your particular deployment. For example, `~/deployments/cf-example`. In the particular deployment's sub-directory, create a file named `Gemfile` with the following contents:

~~~
source 'https://rubygems.org'

ruby "1.9.3"

gem "bosh_cli_plugin_aws"
~~~

<pre class="terminal">
$ cd ~/deployments/cf-example
~/deployments/cf-example$ bundle install
</pre>

Next, set environment variables required for deploying to AWS. Create a file called `bosh_environment` and add the following, changing the value for each line to suit your configuration:

~~~
export BOSH_VPC_DOMAIN=mydomain.com
export BOSH_VPC_SUBDOMAIN=cloud # Pick something more unique than 'cloud' to work around a temporary shortcoming of the tool
export BOSH_AWS_ACCESS_KEY_ID=AWS_ACCESS_KEY_ID
export BOSH_AWS_SECRET_ACCESS_KEY=AWS_SECRET_ACCESS_KEY
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
~/deployments/cf-example$ source bosh_environment
</pre>

Run `bosh aws create` to create a VPC Internet Gateway, VPC subnets, 3 RDS databases, and a NAT VM for Cloud Foundry subnet routing. The command does not require user input, so start it and grab a coffee at the trendiest place across town! This command will generate receipt files that will be used later when deploying Cloud Foundry (`aws_rds_receipt.yml` and `aws_vpc_receipt.yml`)

<pre class="terminal">
~/cf$ bundle exec bosh aws create
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
~/deployments/cf-example$ bundle exec bosh aws bootstrap micro

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

The command will prompt for a username and password. Choose a username and password that you are going to use later to access your micro bosh installation. 

After Micro BOSH has been deployed succesfully, you can check its status:

<pre class="terminal">
~/deployments/cf-example$ bundle exec bosh status

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

## <a id='upload-stemcell'></a>Upload a Stemcell##

Get the list of available public stemcells.

<pre class="terminal">
~/deployments/cf-example$ bundle exec bosh public stemcells
+---------------------------------------------+
| Name                                        |
+---------------------------------------------+
| bosh-stemcell-1657-aws-xen-ubuntu.tgz       |
| bosh-stemcell-1657-aws-xen-centos.tgz       |
| light-bosh-stemcell-1657-aws-xen-ubuntu.tgz |
| light-bosh-stemcell-1657-aws-xen-centos.tgz |
| bosh-stemcell-1657-openstack-kvm-ubuntu.tgz |
| bosh-stemcell-1657-vsphere-esxi-ubuntu.tgz  |
| bosh-stemcell-1657-vsphere-esxi-centos.tgz  |
+---------------------------------------------+
To download use `bosh download public stemcell &lt;stemcell_name&gt;'. For full url use --full.
</pre>

Download the latest ubuntu aws stemcell.

<pre class="terminal">
~/deployments/cf-example$ bundle exec bosh download public stemcell bosh-stemcell-1657-aws-xen-ubuntu.tgz
</pre>

Upload the stemcell to the bosh director.

<pre class="terminal">
~/deployments/cf-example$ bosh upload stemcell ./bosh-stemcell-1657-aws-xen-ubuntu.tgz
</pre>

## <a id='create-a-stub'></a>Create a Deployment Stub##

Cloud Foundry can now be deployed.

Create a stub file called `cf-aws-stub.yml` for spiff, we'll use this in a moment to generate a BOSH manifest for our CF deployment.

<pre class="terminal">
---
name: cf-example
director_uuid: 80be9b46-435f-41db-96a4-453f8d59f53c
releases:
  - name: cf
    version: latest

properties:
  template_only:
    aws:
      access_key_id: PLACEHOLDER-ACCESS-KEY-ID
      secret_access_key: PLACEHOLDER-SECRET-KEY
      availability_zone: us-east-1a # Change this if you'd like to
      availability_zone2: us-east-1b # Change this if you'd like to
      subnet_ids:
        cf1: PLACEHOLDER-SUBNET-FOR-AZ1
        cf2: PLACEHOLDER-SUBNET-FOR-AZ2

  domain: PLACEHOLDER-DOMAIN

  nats:
    user: PLACEHOLDER-NATS-USER
    password: PLACEHOLDER-NATS-PASSWORD

  cc:
    db_encryption_key: PLACEHOLDER-CC-DB-ENCRYPTION-KEY
    bulk_api_password: PLACEHOLDER-BULK-API-PASSWORD
    staging_upload_password: PLACEHOLDER-STAGING-UPLOAD-PASSWORD
    staging_upload_user: PLACEHOLDER-STAGING-UPLOAD-USER

  uaa:
    scim:
      users:
      - admin|the_admin_pw|scim.write,scim.read,openid,cloud_controller.admin         #change if you like
      - services|the_services_pw|scim.write,scim.read,openid,cloud_controller.admin   #change if you like
    admin:
      client_secret: PLACEHOLDER-UAA-ADMIN-CLIENT-SECRET
    jwt:
      signing_key: PLACEHOLDER-UAA-JWT-SIGNING-KEY
      verification_key: PLACEHOLDER-UAA-JWT-VERIFICATION-KEY
    clients:
      login:
        secret: PLACEHOLDER-UAA-CLIENTS-LOGIN-SECRET
      developer_console:
        secret: PLACEHOLDER-UAA-CLIENTS-DEVELOPER-CONSOLE-SECRET
      app-direct:
        secret: PLACEHOLDER-UAA-CLIENTS-APP-DIRECT-SECRET
      support-services:
        secret: PLACEHOLDER-UAA-CLIENTS-SUPPORT-SERVICES-SECRET
      servicesmgmt:
        secret: PLACEHOLDER-UAA-CLIENTS-SERVICESMGMT-SECRET
      space-mail:
        secret: PLACEHOLDER-UAA-CLIENTS-SPACE-MAIL-SECRET
    batch:
      username: PLACEHOLDER-UAA-BATCH-USERNAME
      password: PLACEHOLDER-UAA-BATCH-PASSWORD
    cc:
      client_secret: PLACEHOLDER-UAA-CC-CLIENT-SECRET

  uaadb: PLACEHOLDER_UAADB_PROPERTIES
  ccdb: PLACEHOLDER_CCDB_PROPERTIES

  router:
    status:
      user: PLACEHOLDER-ROUTER-STATUS-USER
      password: PLACEHOLDER-ROUTER-STATUS-PASSWORD

  dea_next:
    disk_mb: 400001
    memory_mb: 6656

  loggregator_endpoint:
    shared_secret: PLACEHOLDER-LOGGREGATOR-SECRET
</pre>

Replace placeholders with the approriate data:

- `PLACEHOLDER-DIRECTOR-UUID` - the bosh director UUID. You can get it by running `bundle exec bosh status`.

- `PLACEHOLDER-ACCESS-KEY-ID` and `PLACEHOLDER-SECRET-KEY` - AWS access key id and secret key. You can use the same ones as you used in the `bosh_environment` file above, or generate new ones.

- `PLACEHOLDER-AWS-AVAILABILITY-ZONE` and `PLACEHOLDER-AWS-AVAILABILITY-ZONE2` - `BOSH_VPC_PRIMARY_AZ` and `BOSH_VPC_SECONDARY_AZ` from the `bosh_environment` file above.

- `PLACEHOLDER-SUBNET-FOR-AZ1` and `PLACEHOLDER-SUBNET-FOR-AZ2` - Look in `~/deployments/cf-example/aws_vpc_receipt.yml` (this file was generated when you ran `bosh aws create`).  They are under 'subnets' 'cf1' and 'cf2'.

- `PLACEHOLDER-DOMAIN` - `BOSH_VPC_SUBDOMAIN.BOSH_VPC_DOMAIN` from the `bosh_environment` file above (hosted domain created in route 53).

- `PLACEHOLDER-UAADB-PROPERTIES`, `PLACEHOLDER-CCDB-PROPERTIES` - copy these from `~/deployments/cf-example/aws_rds_receipt.yml` 

Generate secure keys for the following placeholders:

- `PLACEHOLDER-NATS-USER`

- `PLACEHOLDER-NATS-PASSWORD`

- `PLACEHOLDER-CC-DB-ENCRYPTION-KEY`

- `PLACEHOLDER-BULK-API-PASSWORD`

- `PLACEHOLDER-CC-STAGING-UPLOAD-USER`

- `PLACEHOLDER-CC-STAGING-UPLOAD-PASSWORD`

- `PLACEHOLDER-UAA-ADMIN-CLIENT-SECRET`

- `PLACEHOLDER-UAA-CLIENTS-LOGIN-SECRET`

- `PLACEHOLDER-UAA-CLIENTS-DEVELOPER-CONSOLE-SECRET`

- `PLACEHOLDER-UAA-CLIENTS-APP-DIRECT-SECRET`

- `PLACEHOLDER-UAA-CLIENTS-SUPPORT-SERVICES-SECRET`

- `PLACEHOLDER-UAA-CLIENTS-SERVICESMGMT-SECRET`

- `PLACEHOLDER-UAA-CLIENTS-SPACE-MAIL-SECRET`

- `PLACEHOLDER-UAA-BATCH-USERNAME`

- `PLACEHOLDER-UAA-BATCH-PASSWORD`

- `PLACEHOLDER-UAA-CC-CLIENT-SECRET`

- `PLACEHOLDER-ROUTER-STATUS-USER`

- `PLACEHOLDER-ROUTER-STATUS-PASSWORD`

- `PLACEHOLDER-LOGGREGATOR-SECRET`


Generate RSA key pair for:

- `PLACEHOLDER-UAA-JWT-SIGNING-KEY` and `PLACEHOLDER-UAA-JWT-VERIFICATION-KEY`

You can also replace the users username/password in uaa->scim->users list.


## <a id='deploy-cloudfoundry'></a>Deploy Cloud Foundry##

Clone `cf-release` into a convenient location, e.g. `~/releases/cf-release`

<pre class="terminal">
~/releases$ git clone https://github.com/cloudfoundry/cf-release.git
</pre>

Update cf-release submodules. You can use helper script `update` in cf-release. 

<pre class="terminal">
~/releases$ cd cf-release
~/releases/cf-release$ ./update
</pre>

Install spiff using instructions from the [Spiff Readme](https://github.com/cloudfoundry-incubator/spiff).

Generate a BOSH deployment manifest:

<pre class="terminal">
~/releases/cf-release$ ./generate_deployment_manifest aws templates/cf-minimal-dev.yml ~/deployments/cf-example/cf-aws-stub.yml > ~/deployments/cf-example/cf.yml
</pre>

Deploy CF using BOSH.

<pre class="terminal">
~/releases/cf-release$ bundle install
</pre>

Check that you are still targetted at your new bosh director.
<pre class="terminal">
~/releases/cf-release$ bundle exec bosh target
Current target is https://x.x.x.x:25555 (micro-xxxxxx)
</pre>
If this doesn't match then name of your deployed micro bosh you can target director using IP from `~/deployments/micro/micro_bosh.yml`.

Set your deployment to the generated manifest
<pre class="terminal">
~/releases/cf-release$ bundle exec bosh deployment ~/deployments/cf-example/cf.yml
</pre>

Create a Cloud Foundry release. It will prompt you for a development release name.  You can use `cf` which was specified in deployment manifest under releases->name.

<pre class="terminal">
~/releases/cf-release$ bundle exec bosh create release
</pre>

Upload the generated release to the BOSH director.

<pre class="terminal">
~/releases/cf-release$ bundle exec bosh upload release
</pre>

Deploy the uploaded Cloud Foundry release.

<pre class="terminal">
~/releases/cf-release$ bundle exec bosh deploy
</pre>

This process can take some time (2-3 hours), especially during its first run when all the jobs are compiled for the first time. If `bosh deploy` fails, it's *usually possible to rerun it again*. 

To test Cloud Foundry installation test the API endpoint.

<pre class="terminal">
~/releases/cf-release$ curl api.subdomain.domain/info
</pre>

If that is successful it should return the information as json. Otherwise, check your networking. *Tip* - make sure your domain has an NS record for your subdomain.

At this point it should be possible to target the install with [gcf](https://github.com/cloudfoundry/cli) and login as an administrator with the user name `admin` and the password `the_admin_pw` used in the deployiment manifest under uaa->scim->users. For more information about managing organizations, spaces, and users and applications go to the [gcf](https://github.com/cloudfoundry/cli) page.

If you want to update your deploy of cf-release to reflect changes in the cf-release directory you can run `bosh create release && bosh upload release && bosh deploy` again. If you only have changes in your manifest you can just run `bosh deploy`. 

## <a id='deploy-cloudfoundry-services'></a>Deploy Cloud Foundry Services##

If you want your Cloud Foundry to be able to provision services you would need to deploy services release. Check the instructions on how to create a service broker [here](http://docs.cloudfoundry.com/docs/running/architecture/services/writing-service.html).

You also might be interested in checking out [community managed services release](https://github.com/cloudfoundry/cf-services-contrib-release).

## <a id='destroy-environment'></a>Destroying the AWS Environment ##
  <table style="width: 70%;"><tr><td>
    **WARNING**: The command `bosh aws destroy` destroys all S3 buckets, all instances, **all everything** in your AWS account. Do not use this command unless everything in your AWS account, including stuff that has nothing to do with Cloud Foundry, is expendable.
  </td></tr></table>
  
You also want to cleanup any YAML artifacts that are no longer valid:

<pre class="terminal">
~/deployments/cf-example$ bundle exec bosh aws destroy
~/deployments/cf-example$ rm -f *.yml
</pre>
