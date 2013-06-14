---
title: Install Cloud Foundry on OpenStack
---

In this page you will run Cloud Foundry on OpenStack.

## Requirements ##

It is assumed that you have [validated your OpenStack](validate_openstack.html.md) and [have a bosh running](deploying_microbosh.html).

Confirm in your local terminal that you have the bosh CLI installed and is targeting your bosh:

<pre class="terminate">
$ bosh status
Config
             /Users/drnic/.bosh_config

Director
  Name       firstbosh
  URL        https://1.2.3.4:25555
  Version    1.5.0.pre.3 (release:49d2d498 bosh:49d2d498)
  User       admin
  UUID       7a462ebe-bdb7-4e7c-b096-c42736XXXXXX
  CPI        openstack
  dns        enabled (domain_name: microbosh)
  compiled_package_cache disabled

Deployment
  not set
</pre>

## Upload bosh release ##

To deploy Cloud Foundry, your bosh needs to be given the bosh release it will use. This includes all the packages and jobs. The Cloud Foundry bosh release includes dozens of jobs and almost 100 packages. Enforcing consistency and guaranteed output of a deployment is one of the reasons we prefer bosh for deploying a complex system like Cloud Foundry.

You can now create and upload the Cloud Foundry bosh release ([cf-release](https://github.com/cloudfoundry/cf-release)).

[Follow these instructions.](../common/cf-release.html)

Confirm that you have a release "appcloud" uploaded:

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
$ wget http://bosh-jenkins-artifacts.s3.amazonaws.com/last_successful_bosh-stemcell-openstack.tgz
$ bosh upload stemcell last_successful_bosh-stemcell-openstack.tgz
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

## Create deployment manifest ##

