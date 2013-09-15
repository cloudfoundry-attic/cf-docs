---
title: Troubleshooting Cloud Foundry on OpenStack
---

Here are a few tips that may be helpful if you're looking to deploy Cloud Foundry on OpenStack

## Self Signed SSL Certificates
If you're using Self Signed SSL Certificates to secure your OpenStack installation, Fog (via Excon) will throw exceptions.  Excon requires you to disable SSL verification for Self Signed certs using the following:

```
Excon.defaults[:ssl_verify_peer] = false
```

This is currently being [worked on](https://github.com/cloudfoundry/bosh/issues/420), but until that's complete, you'll want to add the above line to these two locations on the the Cloud Controller VM:

* Line 55 of /var/vcap/packages/director/gem_home/gems/bosh_openstack_cpi-1.5.0.pre.978/lib/cloud/openstack/cloud.rb
* Line 32 of /var/vcap/packages/registry/gem_home/gems/bosh_registry-1.5.0.pre.978/lib/bosh_registry/instance_manager/openstack.rb

You must restart service to get the code re-init once you've made the changes.

## GRE Tunnels
If you're using OpenStack's GRE Tunnel networking, the default MTU of 1500 won't allow machines to properly communicate.  Warden is setup out of the box to use that same 1500 MTU, so you'll need to change that.

This is done in the configuration file for your Cloud Foundry deployment.  Simply add the MTU into your dea_next block:

```
dea_next:
  mtu: 1454
```

Use bosh deploy to push these changes out and then reboot your Warden / DEA VM.