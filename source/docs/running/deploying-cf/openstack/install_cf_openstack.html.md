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

