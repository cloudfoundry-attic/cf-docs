---
title: Deploying Cloud Foundry on AWS
---

## <a id='intro'></a> Introduction ##

Cloud Foundry provide tools to simplify the process for deploying an instance of Cloud Foundry to a variety for platforms, including Amazon Web Services. This guide will guide you through using BOSH and cf to deploy Cloud Foundry to Amazon Web Services. Currently this guide is only valid for the us-east-1 availability zone using fragile internal tools that will solidify with time.

## <a id='domain-prep'></a> Prepare a domain ##

The first thing to do is make sure you have a domain available for use with your Cloud Foundry instance. The BOSH AWS boostrapper expects an AWS Route 53 Hosted Zone to exist for the domain. Go to the Route 53 [control panel](https://console.aws.amazon.com/route53) to create a hosted zone.

The bosh AWS bootstrapper currently expects the Cloud Foundry / BOSH installation to be available at a third-level domain, e.g - cloud.mydomain.com. Create a Route53 hosted zone for that domain, copy the reported delegation set when the zone has been created. Add an NS record with your domains registrar for each of the name servers in the zone's delegation set.

<img src="/images/bosh-aws/hostedzone.png" />

## <a id='deployment-env-prep'></a> Prepare the deployment environment ##

Create a working directory and prepare a bundler Gemfile to install the necessary components.

<pre class="terminal">
$ mkdir ~/bosh-deployments
$ cd ~/bosh-deployments
</pre>

Making sure you are running Ruby 1.9.3, install the required RubyGems:

~~~
gem source -a https://s3.amazonaws.com/bosh-jenkins-gems/
gem install bosh_aws_bootstrap --pre
gem install cf bootstrap-cf-plugin admin-cf-plugin
~~~

Next, set environmental variables required for deploying to AWS

Note: for the availability zones - look at https://console.aws.amazon.com/ec2/v2/home?region=us-east-1 and choose zones that are "operating normally".

Create a file called bosh_environment and add the following

~~~
export BOSH_VPC_SUBDOMAIN=cloud
export BOSH_AWS_ACCESS_KEY_ID=your_key_asdv34tdf
export BOSH_DEPLOYMENT_NAME=cloud
export BOSH_WORKSPACE= ~/bosh-deployments
export BOSH_AWS_SECRET_ACCESS_KEY=your_secret_asdf34dfg
export BOSH_MICRO_AMI=ami-d024b6b9
export BOSH_VPC_SECONDARY_AZ=us-east-1a
export BOSH_VPC_PRIMARY_AZ=us-east-1d
~~~

Use "source" to set them for the current shell;

<pre class="terminal">
$ source ~/bosh-deployments/bosh_environment
</pre>

Currently, the standard configuration template is set up for a domain call cloud-app.com, these settings need slight adjustment, edit the file `~/workspace/bosh/bosh_aws_bootstrap/templates/aws_configuration_template.yml.erb`. For example, if cloud-app.com was to change to my-cloud.com

~~~yaml
vpc:
  domain: <%= ENV["BOSH_VPC_SUBDOMAIN"] %>.cloud-app.com

s3:
 - bucket_name: <%= (ENV["BOSH_VPC_SUBDOMAIN"] || raise("Missing ENV variable BOSH_VPC_SUBDOMAIN")) + "-bosh-blobstore" %>
~~~

would change to;

~~~yaml
vpc:
  domain: <%= ENV["BOSH_VPC_SUBDOMAIN"] %>.my-cloud.com

s3:
 - bucket_name: <%= (ENV["BOSH_VPC_SUBDOMAIN"] || raise("Missing ENV variable BOSH_VPC_SUBDOMAIN")) + "my-cloud-bosh-blobstore" %>
~~~

Set the domain and then the bucket name to something unique, this needs to be unique across the entire AWS availability zone.

Run `bosh aws create` to create a gateway, subnets, an RDS database, and a cf_nat_box instance for Cloud Foundry subnet routing.

NOTE: As of April 5 - the gem has a hardcoded domain. Until a new gem is released you must use `~/workspace/bosh/bin/bosh aws create` instead

<pre class="terminal">
$ cd $BOSH_WORKSPACE
$ ~/workspace/bosh/bin/bosh aws create
</pre>

Note: The RDS database creation may take a while.


## <a id='deploy-microbosh'></a> Deploy MicroBOSH ##

Deploy MicroBOSH from the workspace directory. The username and password are both admin (you can change this later).

<pre class="terminal">
$ cd $BOSH_WORKSPACE
$ bosh aws bootstrap micro

WARNING! Your target has been changed to `http://10.10.0.5:25555'!
Deployment set to '~/workspace/bosh/tmp/private-deployments/deployments/micro/micro_bosh.yml'
Deploying new micro BOSH instance `micro/micro_bosh.yml' to `http://10.10.0.5:25555' (type 'yes' to continue): yes

Deploy Micro BOSH
  using existing stemcell (00:00:00)                                                                
  creating VM from ami-345ac05d (00:01:15)                                                          
  waiting for the agent (00:01:34)                                                                  
  create disk (00:00:01)                                                                            
  mount disk (00:00:12)                                                                             
  fetching apply spec (00:00:00)                                                                    
  stopping agent services (00:00:01)                                                                
  applying micro BOSH spec (00:00:26)                                                               
  starting agent services (00:00:00)                                                                
  waiting for the director (00:01:37)                                                               
Done                    11/11 00:05:28                                                              
WARNING! Your target has been changed to `http://54.224.201.39:25555'!
Deployment set to '~/bosh-deployments/deployments/micro/micro_bosh.yml'
Deployed `micro/micro_bosh.yml' to `http://10.10.0.6:25555', took 00:05:28 to complete
Logged in as `admin'
Enter username: admin
Enter password: *****
User `admin' has been created
Logged in as `admin'
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
  Manifest  ~/bosh-deployments/deployments/micro/micro_bosh.yml
</pre>

## <a id='deploy-cloudfoundry'></a> BOSH Deploy Cloud Foundry ##

Cloud Foundry can now be deployed using the cf 'bootstrap' plug-in. Run the bootstrap command with cf through bundler.

<pre class="terminal">
$ bundle exec cf bootstrap aws
</pre>

This process can take some time, especially during it's first run when it compiles all the jobs for the first time. When Cloud Foundry has installed it should be possible to target the install with cf and login as the admin user with the user name 'admin' and the password 'the\_admin\_pw'.

As the admin of the installation and before it's possible to push a test application it is important to create an initial organization and space. Create the organization first;

<pre class="terminal">
$ cf create-org test-org
Creating organization test-org... OK
Switching to organization test-org... OK

There are no spaces in test-org.
You may want to create one with create-space.

target: http://ccng.cloud.xxxxxx.xx
organization: test-org
</pre>

As the help text indicates, there are no spaces for 'test-org', create one with the create-space command;

<pre class="terminal">
$ cf create-space development
Creating space development... OK
Adding you as a manager... OK
Adding you as a developer... OK
</pre>

Tell cf to target the space by using the 'target' command with the --ask-space switch

<pre class="terminal">
$ cf target --ask-space
Switching to space development... OK

target: http://ccng.cloud.xxxxxx.xx
organization: test-org
space: development
</pre>

## <a id='deploy-notes'></a> BOSH Deployment Notes ##

Once Cloud Foundry has been deployed using the bootstrap cf plugin there will be several files left in the $BOSH_WORKSPACE folder;

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

For more information with regard to managing organizations, spaces and users, go to the [cf](../../../using/managing-apps/cf) page

