---
title: Validate your OpenStack
---

This page aims to help you validate your target OpenStack in preparation for installing bosh and deploying Cloud Foundry.

## Access to OpenStack API ##

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

## Create a large volume ##

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

