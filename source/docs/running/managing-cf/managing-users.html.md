---
title: Managing Users
---

This document is a temporary description for Cloud Foundry operators and dev / ops professionals interested in managing users in a new Cloud Foundry installation. This process is unrefined, and will improve with direct cf user management in the near future.

You may refer to [the UAA admin guide](https://github.com/cloudfoundry/uaa/blob/master/docs/Sysadmin-Guide.rst), [other UAA documentation](https://github.com/cloudfoundry/uaa/tree/master/docs) for additional details,
or to the [UAA introduction](../architecture/uaa.html.html)

## <a id='creating-admin-users'></a> Creating Admin Users ##

1. Refer to your deployment manifest for the uaa:admin:client_secret. Refer to this [manifest](../deploying-cf/vsphere/cloud-foundry-example-manifest.html) as an example.

2. Install the UAA CLI, `uaac`:
<pre class="terminal">
$ gem install cf-uaac
</pre class="terminal">

3. Target your UAA and obtain a token for the admin client:
<pre class="terminal">
$ uaac target uaa.[your-domain].com
$ uaac token client get admin -s [admin-client-secret]
</pre class="terminal">

3. Check sufficient permissions for admin to create account, in particular scim.write, if not add this permission and renew token:
<pre class="terminal">
$ uaac contexts
[...]
  scope: password.write clients.write clients.read scim.read uaa.admin clients.secret
$ uaac client update admin --authorities "password.write clients.write clients.read scim.read uaa.admin clients.secret scim.write"
$ uaac token delete
$ uaac token client get admin
</pre class="terminal">

4. Create an admin user and add them to the admin group:
<pre class="terminal">
$ uaac user add [admin-username] -p [admin-password] --emails [admin-user-email-address]
$ uaac member add cloud_controller.admin [admin-username]
</pre class="terminal">

## <a id='creating-users'></a> Creating Users ##

1. Use the credentials of an admin user created using uaac as above, or refer to your deployment manifest for the email and password of an admin user. The user will be under the `uaa: scim` section. Refer to the bottom of this [manifest](../deploying-cf/vsphere/cloud-foundry-example-manifest.html) as an example.

2. Create a new user:
<pre class="terminal">
$ cf login [admin-user-email-address]
...
$ cf create-user [user-email-address]
...
</pre class="terminal">

## <a id='changing-passwords'></a> Changing Passwords ##

1. Use the credentials of an admin user created using uaac as above, or refer to your deployment manifest for the email and password of an admin user. The user will be under the `uaa: scim` section. Refer to the bottom of this [manifest](../deploying-cf/vsphere/cloud-foundry-example-manifest.html) as an example.

2. Change a user password:
<pre class="terminal">
$ uaac password set [user-email-address]
</pre class="terminal">

3. Tell the user their temporary new password and ask them to change it using the following commands:
<pre class="terminal">
$ cf target api.[your-domain].com
$ cf login --username EMAIL --password PASSWORD
$ cf passwd --password PASSWORD
</pre class="terminal">
