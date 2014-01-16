---
title: Deploying Community Services
---

Here's how we would add an example service (PostgreSQL) to your Cloud Foundry 
deployment. 
All users will be able to provision PostgreSQL databases and bind them to their 
applications (see [Using Services](/docs/using/services/index.html)).

The following services can be added to your Cloud Foundry by following the 
techniques on this page:

* elastic search
* memcached
* mongodb
* postgresql
* rabbitmq
* redis
* vlob


## Status of document

This page is written to support the 
[cf-services-contrib-release](https://github.com/cloudfoundry/cf-services-contrib-release) project, for the [v1 release](https://github.com/cloudfoundry/cf-services-contrib-release/releases/tag/v1). 
Please consult the project for any newer versions that have not yet been 
documented here.

## Terminology

**Note:** One change in terminology has been made in Cloud Foundry v2. 
Service Gateways are now called Service Brokers, but unfortunately the term 
gateway still can be found in some source code and filenames. 
Wherever you see gateway in the context of Cloud Foundry Services, bear in mind 
that it's actually a broker. 
Apologies for the confusion, and thank you for your understanding during the 
transition.

* service gateway - advertises a catalog of services and plans to cloud controller, responsible for orphan management, and brokers user requests to provision, bind, unbind and un-provision service instances
* service node - performs local instantiation, destruction and maintenance of service instances on a specific VM
* service instance - a dedicated running server of a service, running inside a warden container; or a specific database of a shared running server (PostgreSQL)
* [warden](../../architecture/warden.html) - Cloud Foundry's container technology
* job - a server running within a bosh deployment
* job template - the description of a single component - perhaps comprised of one or more running processes. For example, this could be a service gateway or service node. One or more job templates can be collocated in a single running job instance.

## What will happen ##

By the end of this page, you will have two additional VMs provisioned within 
your cloud.

They will be deployed within a dedicated bosh deployment (rather than add the 
configuration and VMs into your existing Cloud Foundry deployment).

The example below should work for either AWS EC2 or OpenStack (if you have 
image flavors `m1.small` and `m1.medium`) but modifications (networking) may be 
required for other Cloud Providers. 
You may need to adjust the resource pools in your deployment file to select 
available instance flavors/cloud properties.

One of the VMs will be running a shared PostgreSQL server that will be made 
available to the applications running on your Cloud Foundry. 
PostgreSQL databases can be allocated within this shared server (via `cf 
create-service`) and bound (via `cf bind-service`) to applications. 
This VM will also be running a Cloud Foundry component, the `postgresql_node_ng` job template ([source](https://github.com/cloudfoundry/cf-release/tree/master/jobs/postgresql_node_ng)), this manages the PostgreSQL server on behalf of Cloud Foundry. 
It connects to the rest of Cloud Foundry via a `postgresql_gateway`.

The `postgresql_gateway` job ([source](https://github.com/cloudfoundry/cf-release/tree/master/jobs/postgresql_gateway)) runs on the second VM being added. 
Each different type of service being included in a Cloud Foundry deployment 
needs a dedicated gateway process.

Each service node can support a single "plan".

## Requirements ##

The requirements are:

* the ability to provision two additional VMs, and one new persistent disk/volume
* bosh running and configured for the target cloud account
* base stemcell uploaded to bosh
* bosh CLI installed
* git installed

## Upload final release of services

<pre class="terminal">
$ git clone https://github.com/cloudfoundry/cf-services-contrib-release.git
$ cd cf-services-contrib-release
$ bosh upload release releases/cf-services-contrib-1.yml
</pre>

## Create a deployment file

Download the [example deployment file](https://raw.github.com/cloudfoundry/cf-services-contrib-release/master/examples/dns-postgresql.yml) for running a PostgreSQL service. For other services, 
see the example deployment file that [includes all services](https://raw.github.com/cloudfoundry/cf-services-contrib-release/master/examples/dns-all.yml).

In the following sections we will review the deployment file and make the 
following edits to your deployment file:

* set your bosh director's UUID
* run the `postgresql_gateway_ng` job template in a dedicated `gateways` job instance
* run the `postgresql_node_ng` job templates in one or more `postgresql_service_node` job instances (scale as necessary)
* update the resource pool to match the required resources (for the gateway and service node jobs)
* grant the service gateway access to your Cloud Controller & UAA
* describe the service plan that the service node will provide

### Bosh director UUID

To protect you from accidentally deploying the wrong deployment file to the 
wrong bosh, each deployment file includes a `director_uuid` field. 
That is, the deployment file is mapped to a specific bosh director.

To find your bosh UUID, run:

<pre class="terminal">
$ bosh status
Director
  Name       firstbosh
  URL        https://1.2.3.4:25555
  Version    1.5.0.pre.877 (release:eee90e5e bosh:eee90e5e)
  User       admin
  UUID       2d19fdbc-7f1f-4a99-9c39-f024717b97e3
  CPI        openstack
  dns        enabled (domain_name: microbosh)
  compiled_package_cache disabled
  snapshots  disabled
</pre>

The UUID is `2d19fdbc-7f1f-4a99-9c39-f024717b97e3` in the example above.

Now edit your deployment file to specify this UUID:

```
director_uuid: 2d19fdbc-7f1f-4a99-9c39-f024717b97e3
```

### Target Cloud Foundry

There are two locations in the deployment file where you need to change 
`mycloud.com` for your Cloud Foundry's root domain. 
Search and replace the following:

* `api.mycloud.com`
* `uaa.mycloud.com`

The service gateways announce themselves to the Cloud Controller via the first 
domain. 
It verifies that it has authorization to do so via the UAA, the second domain.

### Service Gateways

Your PostgreSQL-only deployment file includes a job to run the gateway for 
PostgreSQL service.

Replace `mycloud.com` and `SERVICES_PASSWORD` with your base domain and your 
services user password (see below).

<pre class="yaml">
jobs:
  - name: service_gateways
    release: cf-services-contrib
    template:
      - postgresql_gateway_ng
    instances: 1
    resource_pool: common
    networks:
      - name: default
        default: [dns, gateway]
    properties:
      uaa_client_id: "cf"
      uaa_endpoint: http://uaa.mycloud.com
      uaa_client_auth_credentials:
        username: services
        password: SERVICES_PASSWORD
</pre>

The job-specific properties above are the UAA credentials to allow the gateway 
to authenticate with the UAA. 
No other job instance needs these credentials.

To find the `uaa_client_auth_credentials.password` value, look in your bosh 
deployment file for Cloud Foundry for a section that describes your `services` 
user:

<pre class="yaml">
# from Cloud Foundry deployment file:
properties:
  ...
  uaa:
    ...
    scim:
      userids_enabled: true
      users:
      - admin|PASSWORD|scim.write,scim.read,openid,cloud_controller.admin,uaa.admin,password.write
      - services|SERVICES_PASSWORD|scim.write,scim.read,openid,cloud_controller.admin
</pre>

In the [all services deployment file example](https://raw.github.com/cloudfoundry/cf-services-contrib-release/master/examples/dns-all.yml) you can see how all the service gateways can be run on 
the same `gateways` job instance.

### PostgreSQL service node

PostgreSQL itself - the actual database that provides PostgreSQL to 
applications - runs on a job instance running the [postgresql\_node\_ng](https://github.com/cloudfoundry/cf-services-contrib-release/tree/master/jobs/postgresql_node_ng) job template. 
Your deployment file describes this with the `postgresql_service_node` reproduced below.

<pre>
jobs:
- name: postgresql_service_node
  release: cf-services-contrib
  template: postgresql_node_ng
  instances: 1
  resource_pool: common
  networks:
    - name: default
      default: [dns, gateway]
  persistent_disk: 10000
  properties:
    postgresql_node:
      plan: default
</pre>

There are two configurable aspects.

* `persistent_disk` - instructs how big (Mb) a persistent disk should be assigned to each `postgresql_node` VM; this is shared amongst all PostgreSQL databases running on each VM
* `properties.postgresql_node.plan` - determines which of the service plans to support on this node

In this tutorial we will configure one service plan (in the next section) 
called `default`. 
Therefore, we are specifying this `postgresql_node` service 
node to use that service plan.

Each service node can only support a single service plan.

The persistent disk size can be changed later - thanks to the power of bosh - 
and applied via `bosh deploy`.

### Configure a service plan

Your deployment file contains a single service plan, called `default`.

<pre>
# In your services deployment file:
properties:
  ...
  service_plans:
    postgresql:
      default:
        job_management:
          high_water: 1400
          low_water: 100
        configuration:
          lifecycle:
            enable: false

  postgresql_node:
    supported_versions: ["9.2"]
    default_version: "9.2"
    password: c1oudc0wc1oudc0w

  postgresql_gateway:
    cc_api_version: v2
    token: SOME_AUTH_TOKEN_STRING
    default_plan: default
    supported_versions: ["9.2"]
    version_aliases:
      current: "9.2"
</pre>

NOTE: as of writing, the `high_water` & `low_water` values are arbitrary and 
are not used by any services.

Support for backups will be documented in future, in this deployment file it is 
disabled.

If you want to allow your users to provision older versions of PostgreSQL, then 
you can extend the `supported_versions: ["9.2"]` arrays to include the other PostgreSQL versions to support. 
Each version you specify will launch its own PostgreSQL 'postmaster' to support 
those versions, all running on the same node.

## Deploy

Your deployment file is now ready, your bosh has the `cf-services-contrib-release` description of all the services, gateways and 
nodes, and it also has a base stemcell used for each provisioned job instance. 
You can now deploy the services and they will add themselves into your Cloud 
Foundry deployment once they are running:

<pre class="terminal">
$ bosh deployment path/to/deployment/file.yml
$ bosh deploy
</pre>

## Authorize new service gateway

Before you can use the services to provision/bind service instances via the 
`cf` CLI, you must authorize each service gateway with the Cloud Controller:

<pre class="terminal">
$ cf create-service-auth-token
Label> postgresql

Token> SOME_AUTH_TOKEN_STRING
</pre>

The "Token" value is from `postgresql_gateway.token` in the deployment file.

## Verify and provision

<pre class="terminal">
$ cf services --marketplace
Getting services... OK

service      version   provider   plans     description
postgresql   9.2       core       default   PostgreSQL database (vFabric)

$ cf create-service --version 9.2 --plan default --provider core --name test
</pre>
