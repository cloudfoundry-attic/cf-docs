---
title: Install Cloud Foundry on OpenStack
---

In this page you will run Cloud Foundry on OpenStack.

NOTE: These instructions are for v138 release of Cloud Foundry. For newer versions of Cloud Foundry, [please let us know](https://github.com/cloudfoundry/cf-docs/issues/new) if this documentation continues to work or needed some changes.

## What will happen ##

At the end of this page, eight `m1.medium` VMs will be running in your OpenStack environment running Cloud Foundry.

You will be able to target it using your own DNS, login, and upload a simple application.

For example, you will be able to:

<pre class="terminal">
$ cf target api.mycloud.com
$ cf login admin
Password> c1oudc0w  (unless you change it in the deployment file below)
$ git clone https://github.com/cloudfoundry-community/cf_demoapp_ruby_rack.git
$ cd cf_demoapp_ruby_rack
$ cf push
$ open http://hello.mycloud.com
Hello World!
</pre>

## Requirements ##

It is assumed that you have [validated your OpenStack](validate_openstack.html) and [have a bosh running](deploying_microbosh.html).

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

+------+----------+-------------+
| Name | Versions | Commit Hash |
+------+----------+-------------+
| cf   | 138      | adca9c45    |
+------+----------+-------------+
</pre>

## Upload a base stemcell ##

A cloud provider needs a base image to provision VMs/servers. Bosh explicitly requires that the base image includes the [Agent](../../bosh/components/agent.html). Therefore, we use specific base images which are known to have a bosh agent installed. These base images are called `bosh stemcells`.

To upload the latest bosh stemcell to your bosh:

<pre class="terminate">
$ wget http://bosh-jenkins-artifacts.s3.amazonaws.com/bosh-stemcell/openstack/bosh-stemcell-latest-openstack-kvm-ubuntu.tgz
$ bosh upload stemcell bosh-stemcell-latest-openstack-kvm-ubuntu.tgz
</pre>

*Note* There has been [a report on the vcap-dev mailing list](https://www.pivotaltracker.com/story/show/62108468) that cf-release v147 and other releases through v150 are incompatible with some latest verisons of openstack-kvm-ubuntu stemcell. The one that works for the user reporting the issue is [1256](https://bosh-jenkins-artifacts.s3.amazonaws.com/bosh-stemcell/openstack/bosh-stemcell-1256-openstack-kvm-ubuntu.tgz).

Confirm that you have at least one bosh stemcell loaded into your bosh:

<pre class="terminate">
$ bosh stemcells

+--------------------------------+---------+-----------------------------------------+
| Name                           | Version | CID                                     |
+--------------------------------+---------+-----------------------------------------+
| bosh-openstack-kvm-ubuntu      | 1055    | sc-f66fc9db-150d-4e2e-b78f-ad4ab7fc7ad1 |
+--------------------------------+---------+-----------------------------------------+

Stemcells total: 1
</pre>

## Other preparation

OpenStack uses security groups for restricting/allowing ports to a set of servers.

You need to create a security group `cf`:

* allow all ports to talk to all ports of servers using the same `cf` security group
* allow port 22 for administrator SSH access
* allow 80 for HTTP traffic (primarily for the router)

## Create a minimal deployment file ##

The next step towards deploying Cloud Foundry is to create a `deployment file`. This is a YAML file that describes exactly what will be included in the next deployment. This includes:

* the VMs to be created
* the persistent disks to be attached to different VMs
* the networks and IP addresses to be bound to each VM
* the one or more job templates from the bosh release to be applied to each VM
* the custom properties to be applied into configuration files and scripts for each job template

A deployment file can describe 10,000 VMs using a complex set of Quantum subnets all the way down to one or more VMs without any complex inter-networking. You can specify one job per VM or colocate multiple jobs for small deployments.

There are many different parts of Cloud Foundry that can be deployed. In this section, only the bare basics will be deployed that allow user applications to be run that do not require any services. The minimal set of jobs to be included are:

* `dea`
* `cloud_controller_ng`
* `gorouter`
* `nats`
* `postgres`
* `health_manager_next`
* `debian_nfs_server` (see below for using Swift as the droplet blobstore)
* `uaa`

There are different ways that networking can be configured. If your OpenStack has Quantum running, then you can use advanced compositions of subnets to isolate and protect each job, thus providing greater security. In this section, no advanced networking will be used.

Only a single public floating IP is required. Replace your allocated floating IP with `2.3.4.5` below.

### Initial manifest for OpenStack ###

Create a `~/bosh-workspace/deployments/cf` folder and create `~/bosh-workspace/deployments/cf/demo.yml` with the initial deployment file displayed below.

TODO, change the following at the top of the file:

* replace `DIRECTOR_UUID` with the UUID from `bosh status`
* replace `2.3.4.5` with the floating IP you allocated above
* replace `root_domain` value with a DNS, say `mycloud.com` that has `*.mycloud.com` mapped to your IP; defaults to using http://xip.io service for DNS
* replace the `common_password`; even better is to put in lots of different passwords and tokens throughout the deployment file

Further, note that you need to have configured the "cf-public" and "cf-private" security groups as outlined in [these instructions](../common/security-groups.html).

~~~
---
<%
director_uuid = "DIRECTOR_UUID"
protocol = "http"
cf_release = "141"
ip_address = "2.3.4.5"
common_password = "c1oudc0wc1oudc0w"
root_domain = "#{ip_address}.xip.io"
deployment_name = "cf-demo"
%>
name: <%= deployment_name %>
director_uuid: <%= director_uuid %>

releases:
 - name: cf
   version: <%= cf_release %>

compilation:
  workers: 3
  network: default
  reuse_compilation_vms: true
  cloud_properties:
    instance_type: m1.small

update:
  canaries: 1
  canary_watch_time: 30000-300000
  update_watch_time: 30000-300000
  max_in_flight: 4

networks:
  - name: floating
    type: vip
    cloud_properties: {}
  - name: default
    type: dynamic
    cloud_properties:
      security_groups:
      - cf-public
      - cf-private

resource_pools:
  - name: common
    network: default
    size: 8
    stemcell:
      name: bosh-openstack-kvm-ubuntu
      version: latest
    cloud_properties:
      instance_type: m1.small

  - name: large
    network: default
    size: 1
    stemcell:
      name: bosh-openstack-kvm-ubuntu
      version: latest
    cloud_properties:
      instance_type: m1.large

jobs:
  - name: nats
    template:
      - nats
    instances: 1
    resource_pool: common
    networks:
      - name: default
        default: [dns, gateway]

  - name: syslog_aggregator
    template:
      - syslog_aggregator
    instances: 1
    resource_pool: common
    persistent_disk: 65536
    networks:
      - name: default
        default: [dns, gateway]

  - name: postgres
    template:
      - postgres
    instances: 1
    resource_pool: common
    persistent_disk: 65536
    networks:
      - name: default
        default: [dns, gateway]
    properties:
      db: databases

  - name: nfs_server
    template:
      - debian_nfs_server
    instances: 1
    resource_pool: common
    persistent_disk: 65536
    networks:
      - name: default
        default: [dns, gateway]

  - name: uaa
    template:
      - uaa
    instances: 1
    resource_pool: common
    networks:
      - name: default
        default: [dns, gateway]

  - name: cloud_controller
    template:
      - cloud_controller_ng
    instances: 1
    resource_pool: common
    networks:
      - name: default
        default: [dns, gateway]
    properties:
      ccdb: ccdb

  - name: router
    template:
      - gorouter
    instances: 1
    resource_pool: common
    networks:
      - name: default
        default: [dns, gateway]
      - name: floating
        static_ips:
          - <%= ip_address %>

  - name: health_manager
    template:
      - health_manager_next
    instances: 1
    resource_pool: common
    networks:
      - name: default
        default: [dns, gateway]

  - name: dea
    template: 
     - dea_next
    instances: 1
    resource_pool: large
    networks:
      - name: default
        default: [dns, gateway]

properties:
  domain: <%= root_domain %>
  system_domain: <%= root_domain %>
  system_domain_organization: "demo"
  app_domains:
    - <%= root_domain %>
  support_address: http://support.<%= root_domain %>
  description: "Cloud Foundry v2 sponsored by Pivotal"

  networks:
    apps: default
    management: default

  ssl:
    skip_cert_verify: true

  nats:
    address: 0.nats.default.<%= deployment_name %>.microbosh
    machines: [ 0.nats.default.<%= deployment_name %>.microbosh ]
    port: 4222
    user: nats
    password: <%= common_password %>
    authorization_timeout: 10

  router:
    port: 8081
    status:
      port: 8080
      user: gorouter
      password: <%= common_password %>

  dea: &dea
    memory_mb: 4096
    disk_mb: 16384
    directory_server_protocol: <%= protocol %>
    mtu: 1454

  dea_next: *dea

  syslog_aggregator:
    address: 0.syslog-aggregator.default.<%= deployment_name %>.microbosh
    port: 54321

  nfs_server:
    address: 0.nfs-server.default.<%= deployment_name %>.microbosh
    network: "*.<%= deployment_name %>.microbosh"
    idmapd_domain: dfw2

  debian_nfs_server:
    no_root_squash: true

  databases: &databases
    db_scheme: postgres
    address: 0.postgres.default.<%= deployment_name %>.microbosh
    port: 5524
    roles:
      - tag: admin
        name: ccadmin
        password: <%= common_password %>
      - tag: admin
        name: uaaadmin
        password: <%= common_password %>
    databases:
      - tag: cc
        name: ccdb
        citext: true
      - tag: uaa
        name: uaadb
        citext: true

  ccdb: &ccdb
    db_scheme: postgres
    address: 0.postgres.default.<%= deployment_name %>.microbosh
    port: 5524
    roles:
      - tag: admin
        name: ccadmin
        password: <%= common_password %>
    databases:
      - tag: cc
        name: ccdb
        citext: true

  ccdb_ng: *ccdb

  uaadb:
    db_scheme: postgresql
    address: 0.postgres.default.<%= deployment_name %>.microbosh
    port: 5524
    roles:
      - tag: admin
        name: uaaadmin
        password: <%= common_password %>
    databases:
      - tag: uaa
        name: uaadb
        citext: true

  cc_api_version: v2

  cc: &cc
    logging_level: debug
    srv_api_uri: <%= protocol %>://api.<%= root_domain %>
    cc_partition: default
    db_encryption_key: <%= common_password %>
    bootstrap_admin_email: "frodenas@gopivotal.com"
    bulk_api_password: <%= common_password %>
    uaa_resource_id: cloud_controller
    staging_upload_user: upload
    staging_upload_password: <%= common_password %>
    resource_pool:
      resource_directory_key: cc-resources
      fog_connection:
        provider: Local
        local_root: /var/vcap/nfs/shared
    packages:
      app_package_directory_key: cc-packages
    droplets:
      droplet_directory_key: cc-droplets
    quota_definitions:
      default:
        memory_limit: 10240
        total_services: 100
        non_basic_services_allowed: true
        total_routes: 1000
        trial_db_allowed: true

  ccng: *cc

  login:
    enabled: false
  
  uaa:
    url: <%= protocol %>://uaa.<%= root_domain %>
    no_ssl: <%= protocol == "http" %>
    catalina_opts: -Xmx768m -XX:MaxPermSize=256m
    resource_id: account_manager
    jwt:
      signing_key: |
        -----BEGIN RSA PRIVATE KEY-----
        MIICXAIBAAKBgQDHFr+KICms+tuT1OXJwhCUmR2dKVy7psa8xzElSyzqx7oJyfJ1
        JZyOzToj9T5SfTIq396agbHJWVfYphNahvZ/7uMXqHxf+ZH9BL1gk9Y6kCnbM5R6
        0gfwjyW1/dQPjOzn9N394zd2FJoFHwdq9Qs0wBugspULZVNRxq7veq/fzwIDAQAB
        AoGBAJ8dRTQFhIllbHx4GLbpTQsWXJ6w4hZvskJKCLM/o8R4n+0W45pQ1xEiYKdA
        Z/DRcnjltylRImBD8XuLL8iYOQSZXNMb1h3g5/UGbUXLmCgQLOUUlnYt34QOQm+0
        KvUqfMSFBbKMsYBAoQmNdTHBaz3dZa8ON9hh/f5TT8u0OWNRAkEA5opzsIXv+52J
        duc1VGyX3SwlxiE2dStW8wZqGiuLH142n6MKnkLU4ctNLiclw6BZePXFZYIK+AkE
        xQ+k16je5QJBAN0TIKMPWIbbHVr5rkdUqOyezlFFWYOwnMmw/BKa1d3zp54VP/P8
        +5aQ2d4sMoKEOfdWH7UqMe3FszfYFvSu5KMCQFMYeFaaEEP7Jn8rGzfQ5HQd44ek
        lQJqmq6CE2BXbY/i34FuvPcKU70HEEygY6Y9d8J3o6zQ0K9SYNu+pcXt4lkCQA3h
        jJQQe5uEGJTExqed7jllQ0khFJzLMx0K6tj0NeeIzAaGCQz13oo2sCdeGRHO4aDh
        HH6Qlq/6UOV5wP8+GAcCQFgRCcB+hrje8hfEEefHcFpyKH+5g1Eu1k0mLrxK2zd+
        4SlotYRHgPCEubokb2S1zfZDWIXW3HmggnGgM949TlY=
        -----END RSA PRIVATE KEY-----
      verification_key: |
        -----BEGIN PUBLIC KEY-----
        MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDHFr+KICms+tuT1OXJwhCUmR2d
        KVy7psa8xzElSyzqx7oJyfJ1JZyOzToj9T5SfTIq396agbHJWVfYphNahvZ/7uMX
        qHxf+ZH9BL1gk9Y6kCnbM5R60gfwjyW1/dQPjOzn9N394zd2FJoFHwdq9Qs0wBug
        spULZVNRxq7veq/fzwIDAQAB
        -----END PUBLIC KEY-----
    cc:
      client_secret: <%= common_password %>
    admin:
      client_secret: <%= common_password %>
    batch:
      username: batch
      password: <%= common_password %>
    client:
      autoapprove:
        - cf
    clients:
      cf:
        override: true
        authorized-grant-types: password,implicit,refresh_token
        authorities: uaa.none
        scope: cloud_controller.read,cloud_controller.write,openid,password.write,cloud_controller.admin,scim.read,scim.write
        access-token-validity: 7200
        refresh-token-validity: 1209600
      admin:
        secret: <%= common_password %>
        authorized-grant-types: client_credentials
        authorities: clients.read,clients.write,clients.secret,password.write,scim.read,uaa.admin
    scim:
      userids_enabled: true
      users:
      - admin|<%= common_password %>|scim.write,scim.read,openid,cloud_controller.admin,uaa.admin,password.write
      - services|<%= common_password %>|scim.write,scim.read,openid,cloud_controller.admin
~~~

NOTE again: this is a deployment file that is known to work with v141 of Cloud Foundry.

## Deploying your own Cloud Foundry ##

In this section, your bosh will be instructed to provision 9 VMs (specified in the manifest), binding the router to your floating IP address, and running the minimal, useful set of jobs mentioned above. In the subsequent section, you well deploy a sample application to your Cloud Foundry

First, target your bosh CLI to your manifest file. Use either:

<pre class="terminal">
$ bosh deployment ~/bosh-workspace/deployments/cf/demo.yml
</pre>

Then, we upload the deployment file to your bosh and instruct it to "deploy" your Cloud Foundry service.

<pre class="terminal">
$ bosh deploy
</pre>

### What is happening now? ###

The first time you deploy a bosh release it will compile every package that it needs for your deployment. You will see something like:

<pre class="terminal">
Compiling packages
buildpack_cache/2,...  |                        | 0/23 00:00:32  ETA: --:--:--
</pre>

And later...

<pre class="terminal">
  Compiling packages
    buildpack_cache/2 (00:02:39)
    insight_agent/2 (00:02:49)
    nginx/9 (00:00:49)
golang/2, gorouter/10,...  |ooo                     | 4/23 00:02:15  ETA: 00:04:04
</pre>

If you visit your OpenStack dashboard, you will see a number of VMs have been provisioned. Each of these VMs is being assigned a single package to compile. When it completes, it uploads the compiled binaries and libraries for that package into the bosh blobstore. These compiled packages can be used over and over and never need compilation again.

Finally, the initial compilation of packages ends (after about 15 minutes in the example below):

<pre class="terminal">
  ...
  login/19 (00:00:37)
  uaa/30 (00:00:38)
  dea_next/22 (00:00:51)
Done                    23/23 00:09:16
</pre>

Next it boots the 9 VMs mentioned in the deployment file above:

<pre class="terminal">
Creating bound missing VMs
  common/1 (00:01:49)
  common/0 (00:02:53)
  common/2 (00:03:31)
  common/3 (00:01:53)
  common/5 (00:01:32)
  common/4 (00:02:10)
  common/6 (00:01:51)
  common/7 (00:01:07)
  large/0 (00:01:54)
Done                    9/9 00:07:34
</pre>

Finally it assigns each VM a job (which is a list of one or more job templates from the [cf-release bosh release jobs folder](https://github.com/cloudfoundry/cf-release/tree/master/jobs))

<pre class="terminal">
Binding instance VMs
  nats/0 (00:00:01)
  postgres/0 (00:00:01)
  nfs_server/0 (00:00:01)
  syslog_aggregator/0 (00:00:01)
  uaa/0 (00:00:01)
  health_manager/0 (00:00:01)
  router/0 (00:00:01)
  cloud_controller/0 (00:00:01)
  dea/0 (00:00:01)
Done                    9/9 00:00:04

Preparing configuration
  binding configuration (00:00:01)
Done                    1/1 00:00:01

Updating job syslog_aggregator
syslog_aggregator/0 (canary)       |oooooooooooooooooooo    | 0/1 00:01:09  ETA: --:--:--
</pre>

First the `syslog_aggregator` job is started.

The ordering of the jobs within the deployment file is deliberate. It determines the order that the job VMs are started. The later jobs may have dependencies on the earlier jobs already running.

DEAs (job `dea`) need the NATS (job `nats`) and the Cloud Controller (job `cloud_controller`). The Cloud Controller needs the UAA (job `uaa`). The Cloud Controller and the UAA need a PostgreSQL database (job `postgres`).

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
Password> c1oudc0w  (unless you change it in the deployment file below)

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
