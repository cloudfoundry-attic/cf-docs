---
title: Validate your OpenStack
---

This page aims to help you validate your target OpenStack in preparation for installing bosh and deploying Cloud Foundry.

## Can access your OpenStack API? ##

You can verify that you have your OpenStack API credentials and can make API calls. Credentials are a combination of your user name, password, and what tenant (or project) your cloud is running under.

Create a `~/.fog` file:

<pre class="yaml">
:openstack:
  :openstack_auth_url:  http://HOST_IP:5000/v2.0/tokens
  :openstack_api_key:   PASSWORD
  :openstack_username:  USERNAME
  :openstack_tenant:    PROJECT_NAME
</pre>

NOTE: you need to include `/v2.0/tokens` in the auth URL above.

Install the `fog` application in your terminal, and run it in interactive mode:

<pre class="terminal">
$ gem install fog
$ fog openstack
>> OpenStack.servers
[]
</pre>

The `[]` is an empty array in Ruby. You might see a long list of servers being displayed if your OpenStack tenancy/project already contains provisioned servers.

Note: it is recommended that you deploy bosh and Cloud Foundry in a dedicated tenancy. Its easier to keep track of the servers, volumes, security groups and networks that you create. It also allows you to manage user access.

There is more information on [OpenStack API docs](http://docs.openstack.org/api/quick-start/content/).

## Can invoke large number of API calls? ##

Your OpenStack might have API throttling (devstack enables throttling by default) which may mean that bosh requests to OpenStack fail dramatically, or perhaps fail temporarily (whilst waiting for the API throttle to expire).

Try the following to see if you may be affected by API throttling:

<pre class="terminal">
$ gem install fog
>> 100.times { p OpenStack.servers }
</pre>

If you are running **devstack**, add the following to your `localrc` and at the end of this page you will recreate your devstack without API throttling:

<pre class="bash">
API_RATE_LIMIT=False
</pre>

## Can create a large volume? ##

The [devstack](http://devstack.org/) OpenStack distributions defaults to a very small total volume size (5G). Alternately, your tenancy/project might have only been granted a small quota for volume sizes.

Verify that you can create a 30G volume:

<pre class="terminal">
$ gem install fog
$ fog openstack
>> size = 30
>> v = OpenStack.volumes.create(size: size, name: 'test', description: 'test')
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

## <a id="ephemeral"></a>Do instance flavors have ephemeral storage? ##

Bosh can only use flavors that are available to you, but it requires that you only use flavors that have an ephemeral disk.

To see the list of available flavors that have ephemeral disks:

<pre class="terminal">
$ fog openstack
>> OpenStack.flavors.select {|s| s.ephemeral > 0}.map(&:name)
["m1.small", "m1.medium", "m1.microbosh"]
</pre>

You can create flavors using the `nova` tool. For example, to create an `m1.small` with 1 CPU, 2G RAM and 20G ephemeral disk:

<pre class="terminal">
$ nova flavor-create m1.small 2 2048 20 1 --ephemeral 20 --rxtx-factor 1 --is-public true
</pre>

## Can access the Internet from within instances? ##

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


