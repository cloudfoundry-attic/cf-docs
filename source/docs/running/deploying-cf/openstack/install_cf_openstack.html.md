---
title: Install Cloud Foundry on OpenStack
---

In this page you will run Cloud Foundry on OpenStack.

NOTE: These instructions are for v138 release of Cloud Foundry. For newer versions of Cloud Foundry, [please let us know](https://github.com/cloudfoundry/cf-docs/issues/new) if this documentation continues to work or needed some changes.

## What will happen ##

At the end of this page, three `m1.medium` VMs will be running in your OpenStack environment running Cloud Foundry.

You will be able to target it using your own DNS, login, and upload a simple application.

For example, you will be able to:

<pre class="terminal">
$ cf target api.mycloud.com
$ cf login admin
Password> c1oudc0w  (unless you change it in the deployment manifest below)
$ git clone https://github.com/cloudfoundry-community/cf_demoapp_ruby_rack.git
$ cd cf_demoapp_ruby_rack
$ cf push
$ open http://hello.mycloud.com
Hello World!
</pre>

## Requirements ##

It is assumed that you have [validated your OpenStack](validate_openstack.html.md) and [have a bosh running](deploying_microbosh.html).

It is also required that you have provisioned a floating IP address (`2.3.4.5` in the examples below) and setup your DNS to map `*` records to this IP address. For example, if you were using `mycloud.com` domain as the base domain for your Cloud Foundry, you need a `*` A record for this zone mapping to `2.3.4.5`.

Confirm in your local terminal that you have the bosh CLI installed and is targeting your bosh:

<pre class="terminate">
$ bosh status
Config
             /Users/drnic/.bosh_config

Director
  Name       firstbosh
  URL        https://1.2.3.4:25555
  Version    1.5.0.pre.939 (release:930f73f5 bosh:930f73f5)
  User       admin
  UUID       18bbfe79-6ccf-4020-b1c7-6f19d67a8c9c
  CPI        openstack
  dns        enabled (domain_name: microbosh)
  compiled_package_cache disabled

Deployment
  not set
</pre>

You will use the `UUID` value above later on this page.

You have two flavors setup **with ephemeral disks**:

* `m1.small` - for example, 1 CPU, 2G RAM, 20G ephemeral disk
* `m1.medium` - for example, 2 CPU, 4G RAM, 20G ephemeral disk

You have two security groups:

* `default`
* `cf` - opens all ports (until further understanding of what ports are required for each job of Cloud Foundry)

## Upload bosh release ##

To deploy Cloud Foundry, your bosh needs to be given the bosh release it will use. This includes all the packages and jobs. The Cloud Foundry bosh release includes dozens of jobs and almost 100 packages. Enforcing consistency and guaranteed output of a deployment is one of the reasons we prefer bosh for deploying a complex system like Cloud Foundry.

You can now create and upload the Cloud Foundry bosh release ([cf-release](https://github.com/cloudfoundry/cf-release)).

[Follow these instructions.](../common/cf-release.html)

Confirm that you have a release "cf" uploaded:

<pre class="terminate">
$ bosh releases

+----------+------------+-------------+
| Name     | Versions   | Commit Hash |
+----------+------------+-------------+
| appcloud | 131.1-dev  | de134222+   |
+----------+------------+-------------+
(*) Currently deployed

Releases total: 1
</pre>

## Upload a base stemcell ##

A cloud provider needs a base image to provision VMs/servers. Bosh explicitly requires that the base image includes the [Agent](../../bosh/components/agent.html). Therefore, we use specific base images which are known to have a bosh agent installed. These base images are called `bosh stemcells`.

To download the latest bosh stemcell and upload it to your bosh:

<pre class="terminate">
$ wget http://bosh-jenkins-artifacts.s3.amazonaws.com/bosh-stemcell/openstack/latest-bosh-stemcell-openstack.tgz
$ bosh upload stemcell latest-bosh-stemcell-openstack.tgz
</pre>

Confirm that you have at least one bosh stemcell loaded into your bosh:

<pre class="terminate">
$ bosh stemcells

+---------------+---------+--------------------------------------+
| Name          | Version | CID                                  |
+---------------+---------+--------------------------------------+
| bosh-stemcell | 703     | 51c86e1d-2439-45a7-9f8d-870c7f64c61b |
+---------------+---------+--------------------------------------+

Stemcells total: 1
</pre>

## Create a minimal deployment manifest ##

The next step towards deploying Cloud Foundry is to create a `deployment manifest`. This is a YAML file that describes exactly what will be included in the next deployment. This includes:

* the VMs to be created
* the persistent disks to be attached to different VMs
* the networks and IP addresses to be bound to each VM
* the one or more job templates from the bosh release to be applied to each VM
* the custom properties to be applied into configuration files and scripts for each job template

A deployment manifest can describe 10,000 VMs using a complex set of Quantum subnets all the way down to one or more VMs without any complex inter-networking. You can specify one job per VM or colocate multiple jobs for small deployments.

There are many different parts of Cloud Foundry that can be deployed. In this section, only the bare basics will be deployed that allow user applications to be run that do not require any services. The minimal set of jobs to be included are:

* `dea`
* `cloud_controller_ng`
* `gorouter`
* `nats`
* `postgres`
* `health_manager_next`
* `debian_nfs_server` (see below for using Swift as the droplet blobstore)
* `uaa`
* `login`

There are different ways that networking can be configured. If your OpenStack has Quantum running, then you can use advanced compositions of subnets to isolate and protect each job, thus providing greater security. In this section, no advanced networking will be used.

Only a single public floating IP is required. Replace your allocated floating IP with `2.3.4.5` below.

### Initial manifest for OpenStack ###

Create a `deployments` folder and create `deployments/cf.yml` with the initial manifest displayed below.

<pre class="terminal">
$ mkdir deployments
$ wget https://gist.github.com/drnic/5785295/raw/ff779dfe7acb7a6caba7bddeafa32b029a17c0d7/cf-openstack-dns-small.yml -O deployments/cf.yml
</pre>

<script src="https://gist.github.com/drnic/5785295.js"></script>

### Replace values with your values ###

In your `deployments/cf.yml`, replace the following values:

* `YOUR-BOSH-UUID` - with the UUID from running `bosh status`
* `2.3.4.5` - with your floating IP address
* `mycloud.com` (many instances) - with your root DNS
* `c1oudc0w` (many instances) - with a common password used within the system (also the initial `admin` user password)

## Deploying your own Cloud Foundry ##

In this section, your bosh will be instructed to provision 4 VMs (specified in the manifest), binding the router to your floating IP address (which you have already registered with your DNS provider for the `*.mycloud.com` A record), and running the minimal, useful set of jobs mentioned above. In the following section, you well deploy a sample application!

First, target your bosh CLI to your manifest file. Use either:

<pre class="terminal">
$ bosh deployment cf
$ bosh deployment deployments/cf.yml
</pre>

The former use case attempts to find a file `deployments/NAME.yml`. That is, it is an abbreviated version of the latter use case above.

Then, we upload the deployment manifest to your bosh and instruct it to "deploy" your Cloud Foundry service.

<pre class="terminal">
$ bosh deploy
</pre>

### What is happening now? ###

The first time you deploy a bosh release it will compile every package that it needs for your deployment. You will see something like:

<pre class="terminal">
Compiling packages
buildpack_cache/0.1-dev, git/1,...  |                        | 0/26 00:00:32  ETA: --:--:--         
</pre>

And later...

<pre class="terminal">
Compiling packages
  insight_agent/2 (00:01:01)                                                                        
  buildpack_cache/0.1-dev (00:01:56)                                                                
  rootfs_lucid64/0.1-dev (00:02:04)                                                                 
  mysqlclient/3 (00:00:03)                                                                          
git/1, golang/1, imagemagick/2,...  |ooo                     | 4/26 00:02:15  ETA: 00:04:04         
</pre>

If you visit your OpenStack dashboard, you will see a number of VMs have been provisioned. Each of these VMs is being assigned a single package to compile. When it completes, it uploads the compiled binaries and libraries for that package into the bosh blobstore. These compiled packages can be used over and over and never need compilation again.

Finally, the initial compilation of packages ends (after about 15 minutes in the example below):

<pre class="terminal">
  ...
  cloud_controller_ng/12.1-dev (00:01:09)                                                           
  warden/25.1-dev (00:00:45)                                                                        
  dea_next/15.1-dev (00:01:31)                                                                      
  imagemagick/2 (00:15:07)                                                                          
Done                    26/26 00:15:07                                                              
</pre>

Next it boots the 4 VMs mentioned in the deployment manifest above (see the `resource_pools` [section](https://gist.github.com/drnic/5785295#file-cf-openstack-dns-small-yml-L34-L51)):

<pre class="terminal">
Creating bound missing VMs
  medium/0 (00:00:40)                                                                               
  medium/1 (00:00:42)                                                                               
  small/0 (00:00:42)                                                                                
  small/1 (00:00:45)                                                                                
Done                    4/4 00:00:45                                                                
</pre>

Finally it assigns each VM a job (which is a list of one or more job templates from the [cf-release bosh release jobs folder](https://github.com/cloudfoundry/cf-release/tree/master/jobs))

<pre class="terminal">
Binding instance VMs
  core/0 (00:00:01)                                                                                 
  uaa/0 (00:00:01)                                                                                  
  api/0 (00:00:01)                                                                                  
  dea/0 (00:00:01)                                                                                  
Done                    4/4 00:00:01                                                                

Preparing configuration
  binding configuration (00:00:01)                                                                  
Done                    1/1 00:00:01                                                                

Updating job core
core/0 (canary)                     |oooooooooooooooooooo    | 0/1 00:01:09  ETA: --:--:--
</pre>

First the `core` job is started.

The ordering of the jobs within the deployment manifest - core, uaa, api, dea - is deliberate. It determines the order that the job VMs are started.

DEAs (job `dea`) need the NATS (job `core`) and the Cloud Controller (job `api`). The Cloud Controller needs the UAA (job `uaa`). The Cloud Controller and the UAA need a PostgreSQL database (job `core`).

So the deployment manifest is written to start `core` first, then `uaa`, then `api` (`cloud_controller` and the `gorouter`), and finally the `dea`.

When the deployment is finished:

<pre class="terminal">
Updating job core
  core/0 (canary) (00:01:04)                                                                        
Done                    1/1 00:01:04                                                                

Updating job uaa
  uaa/0 (canary) (00:00:47)                                                                         
Done                    1/1 00:00:47                                                                

Updating job api
  api/0 (canary) (00:01:50)                                                                         
Done                    1/1 00:01:50                                                                

Updating job dea
  dea/0 (canary) (00:01:21)                                                                         
Done                    1/1 00:01:21
</pre>

## Running example application on Cloud Foundry ##

You can now target and push your first example application, as per the promise at the top of the page.

First, target the Cloud Foundry, create an Organization, and create the first Space within that organization:

<pre class="terminal">
$ gem install cf
$ cf target api.mycloud.com
$ cf login admin
Password> c1oudc0w  (unless you change it in the deployment manifest below)

$ cf create-org demo
Creating organization demo... OK
Switching to organization demo... OK
There are no spaces. You may want to create one with create-space.

$ cf create-space development
Creating space development... OK
Adding you as a manager... OK
Adding you as a developer... OK
Space created! Use `cf switch-space development` to target it.

$ cf switch-space development
Switching to space development... OK

target: http://api.mycloud.com
organization: demo
space: development
</pre>

Finally, clone an example application (that doesn't require any database services) and push it to deploy:

<pre class="terminal">
$ git clone https://github.com/cloudfoundry-community/cf_demoapp_ruby_rack.git
$ cd cf_demoapp_ruby_rack
$ bundle
$ cf push
cf push
Using manifest file manifest.yml

Custom startup command> <strong>none</strong>

Creating hello... OK

1: hello
2: none
Subdomain> <strong>hello</strong>

1: mycloud.com
2: none
Domain> <strong>mycloud.com</strong>

Creating route hello.mycloud.com... OK
Binding hello.mycloud.com to hello... OK
Uploading hello... OK
Starting hello... OK
-----> Downloaded app package (4.0K)
Installing ruby.
-----> Using Ruby version: ruby-1.9.2
-----> Installing dependencies using Bundler version 1.3.2
       Running: bundle install --without development:test --path vendor/bundle --binstubs vendor/bundle/bin --deployment
       Fetching gem metadata from https://rubygems.org/..........
       Installing rack (1.5.2)
       Using bundler (1.3.2)
       Your bundle is complete! It was installed into ./vendor/bundle
       Cleaning up the bundler cache.
-----> Uploading staged droplet (24M)
-----> Uploaded droplet
Checking hello...
Staging in progress...
  0/1 instances: 1 starting
  0/1 instances: 1 starting
  0/1 instances: 1 starting
  1/1 instances: 1 running
OK


$ open hello.mycloud.com
Hello World!
</pre>

Success!
