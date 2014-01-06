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

* Line 55 of `/var/vcap/packages/director/gem_home/gems/bosh_openstack_cpi-1.5.0.pre.978/lib/cloud/openstack/cloud.rb`
* Line 32 of `/var/vcap/packages/registry/gem_home/gems/bosh_registry-1.5.0.pre.978/lib/bosh_registry/instance_manager/openstack.rb`

You must restart service to get the code re-init once you've made the changes.

## GRE Tunnels
If you're using OpenStack's GRE Tunnel networking, the default MTU of 1500 won't allow machines to properly communicate.  Warden is setup out of the box to use that same 1500 MTU, so you'll need to change that.

This is done in the configuration file for your Cloud Foundry deployment.  Simply add the MTU into your dea_next block:

```
dea_next:
  mtu: 1454
```

Use bosh deploy to push these changes out and then reboot your Warden / DEA VM.

## NFS and Cloud Controller

If you get the following error when deploying an app to Cloud Foundry you may have an NFS related issue with the Cloud Controller:

```
The app package is invalid: failed synchronizing resource pool File exists - /var/vcap/nfs/shared
```

To confirm that this is related to a broken/incomplete NFS mount, SSH into the `cloud_controller_ng` job and checking the existence of the `/var/vcap/nfs/shared` folder:

```
$ bosh ssh cloud_controller/0 "ls -l /var/vcap/nfs/shared"
...
ls: cannot access /var/vcap/nfs/shared: Stale NFS file handle"
```

Try the following ideas to resolve this.

1. (Recommended) Restart the `cloud_controller` (or `api`) jobs with the BOSH CLI `bosh restart cloud_controller`
2. Manually recreate the NFS mount on the `cloud_controller` job server:

```
$ bosh ssh cloud_controller/0
root:~# umount /var/vcap/nfs
root:~# mount -t nfs 0.nfs.default.cf.microbosh:/var/vcap/store /var/vcap/nfs
```

Replace `0.nfs.default.cf.microbosh` above with the static IP or DNS host of the job instance running the `debian_nfs_server`.

