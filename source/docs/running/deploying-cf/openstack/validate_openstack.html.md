---
title: Validate your OpenStack Instance
---

This page aims to help you validate your target OpenStack in preparation for installing BOSH and deploying Cloud Foundry.

You will need a running OpenStack environment. Note that only [Folsom](https://wiki.openstack.org/wiki/ReleaseNotes/Folsom) and [Grizzly](https://wiki.openstack.org/wiki/ReleaseNotes/Grizzly) OpenStack releases are supported.

## <a id="api_access"></a>Can access the OpenStack APIs for your instance of OpenStack? ##

You can verify that you have your OpenStack API credentials and can make API calls. Credentials are a combination of your user name, password, and which tenant (or project) your cloud is running under. Some providers also require you to set the region.

Create a `~/.fog` file and copy the below content:

<pre class="yaml">
:openstack:
  :openstack_auth_url:  http://HOST_IP:5000/v2.0/tokens
  :openstack_api_key:   PASSWORD
  :openstack_username:  USERNAME
  :openstack_tenant:    PROJECT_NAME
  :openstack_region:    REGION # Optional
</pre>

NOTE: you need to include `/v2.0/tokens` in the auth URL above.

Install the `fog` application in your terminal, and run it in interactive mode:

<pre class="terminal">
$ gem install fog
$ fog openstack
>> Compute[:openstack].servers
[]
</pre>

The `[]` is an empty array in Ruby. You might see a long list of servers being displayed if your OpenStack tenancy/project already contains provisioned servers.

Note: it is recommended that you deploy BOSH and Cloud Foundry in a dedicated tenancy. Its easier to keep track of the servers, volumes, security groups and networks that you create. It also allows you to manage user access.

There is more information on [OpenStack API docs](http://docs.openstack.org/api/quick-start/content/).

## <a id="metadata_service"></a> Can access OpenStack metadata service from within a virtual machine? ##

According to [the OpenStack Documentation](http://docs.openstack.org/grizzly/openstack-compute/admin/content/metadata-service.html), the Compute service uses a special metadata service to enable virtual machine instances to retrieve instance-specific data.  The default stemcell for use with BOSH uses the [cloud-init scripts](https://help.ubuntu.com/community/CloudInit) to retrieve this metadata for each instance of a virtual machine that OpenStack manages.

You will need to ensure that virtual machines you boot in your OpenStack environment can access the metadata service at http://169.254.169.254.  

From your OpenStack dashboard, create an VM and open the console into it (the "Console" tab on its "Instance Detail" page). Wait for the terminal to appear and login.

Then execute the curl command to access the above URL.  You should see a list of dates similar to the figure below.

<pre class="terminal">
$ curl http://169.254.169.254

1.0
2007-01-19
2007-03-01
2007-08-29
2007-10-10
2007-12-15
2008-02-01
2008-09-01
2009-04-04

</pre>

If you do not see the output above, please consult the OpenStack documentation (or the documentation for your OpenStack distribution) to diagnose and resolve networking issues.

## <a id="api_access"></a> Can invoke large number of API calls? ##

Your OpenStack might have API throttling (devstack enables throttling by default) which may mean that BOSH requests to OpenStack fail dramatically, or perhaps fail temporarily (whilst waiting for the API throttle to expire).

Try the following to see if you may be affected by API throttling:

<pre class="terminal">
$ gem install fog
>> 100.times { p Compute[:openstack].servers }
</pre>

If you are running **devstack**, add the following to your `localrc` and at the end of this page you will recreate your devstack without API throttling:

<pre class="bash">
API_RATE_LIMIT=False
</pre>

## <a id="volumes"></a> Can create a large volume? ##

The [devstack](http://devstack.org/) OpenStack distributions defaults to a very small total volume size (5G). Alternately, your tenancy/project might have only been granted a small quota for volume sizes.

Verify that you can create a 30G volume:

<pre class="terminal">
$ gem install fog
$ fog openstack
>> size = 30
>> v = Compute[:openstack].volumes.create(size: size, name: 'test', description: 'test')
>> v.reload
>> v.status
"available"

>> v.destroy
</pre>

If `v.status` displays `"error"` then you need to ask your OpenStack administrator for a larger quota. 

If you are running **devstack**, add the following to your `localrc` and at the end of this page you will recreate your devstack with a larger volume backing file:

<pre class="bash">
VOLUME_BACKING_FILE_SIZE=70000M
</pre>

## <a id="cloud-image"></a> Can upload and deploy an Ubuntu 12.04 64-bit Server Cloud Image? ##

BOSH uses [Stemcells](/docs/running/bosh/components/stemcell.html) as the basis for virtual machine instances that it deploys to various cloud providers.  For the OpenStack cloud provider, the BOSH stemcell is based on Ubuntu 12.04 64-bit Server.  If you cannot upload this image to the Glance Image Service in your instance of OpenStack, the BOSH director will also have trouble when it tries to upload the stemcell.  Similarly, if you cannot boot a virtual machine from this instance, and connect to it via SSH, BOSH will also have trouble doing the same.  Additionally, you will want to check that the underlying hardware that runs your OpenStack is compatible with running a 64-bit operating system.

To check that your OpenStack is compatible with Ubuntu 10.04 64-bit Server, you will need to download the image to your Glance Image Service, and then separately boot the image as an instance in OpenStack.

To download the image to your Glance Image Service, perform the following steps:

1.  Login to your OpenStack dashboard.
2.  In the menu on the left-hand side, click <em>Images & Snapshots</em>.
3.  You should see a list of images.  Click <em>Create Image</em>.
4.  For <em>Name</em>, enter <em>Ubuntu Server 64-bit</em>.
5.  For <em>Image Location</em>, enter <em>http://cloud-images.ubuntu.com/lucid/current/lucid-server-cloudimg-amd64-disk1.img</em>.
6.  For <em>Format</em>, select <em>QCOW2 - QEMU Emulator</em>.
7.  For <em>Minimum Disk</em>, enter 5GB.
8.  For <em>Minimum Ram</em>, enter 1024MB.
9.  Click <em>Create Image</em>.

Depending on your server's internet connection, the image may take some time to download.

To check that you can successfully boot the image, perform the following steps:

1.  

## <a id="internet"></a> Can access the Internet from within instances? ##

Your deployment of Cloud Foundry will need outbound access to the Internet (for example, the Ruby buildpack will run `bundle install` on users' applications to fetch RubyGems). You can verify now that your OpenStack is configured correctly to allow outbound access to the Internet.

From your OpenStack dashboard, create an VM and open the console into it (the "Console" tab on its "Instance Detail" page). Wait for the terminal to appear and login.

<pre class="terminal">
$ curl google.com
...
&lt;H1>301 Moved&lt;/H1>
The document has moved
...
</pre>

If you do not see the output above, please consult the OpenStack documentation (or the documentation for your OpenStack distribution) to diagnose and resolve networking issues.

If you are running **devstack**, perhaps check that you have an `eth0` and `eth1` network interface when running `ifconfig`. If you only have `eth1` perhaps try adding the following lines to your `localrc` file before recreating your devstack:

<pre class="bash">
PUBLIC_INTERFACE=eth1
FLAT_INTERFACE=eth0
</pre>
