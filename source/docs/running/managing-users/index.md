---
title: Managing Users
---

This document is a temporary description for Cloud Foundry operators and dev / ops professionals interested in managing users in a new Cloud Foundry installation. This process is unrefined, and will improve with direct vmc user management in the near future.

## Creating admin users

1. Refer to your deployment manifest for the uaa:admin:client_secret

2. Install the UAA CLI, uaac
<pre class="terminal">
$ gem install cf-uaac
</pre class="terminal">

3. Target your UAA and obtain a token for the admin client
<pre class="terminal">
$ uaac target <your uaa url>
$ uaac token client get admin -s <admin client_secret>
</pre class="terminal"> 

4. Create an admin user and add them to the admin group
<pre class="terminal">
$ uaac user add <username> -p <password> --emails <email address>
$ uaac member add cloud_controller.admin <username>
</pre class="terminal">

## Creating users

1. Refer to your deployment manifest for the email and password of an admin user. The user will be under the `uaa: scim` section. Refer to the bottom of this [example manifest](../deploying-cf/vsphere/cloud-foundry-example-manifest.html) as an example.

2. Create a new user with the username and password in the manifest.
<pre class="terminal">
$ vmc login your-admin@domain.com
...
$ create-user user@domain.com
...
</pre>

3. Make the user an admin
</pre class="terminal">

To be continued.
