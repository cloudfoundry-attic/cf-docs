---
title: Managing Users
---

This document is a temporary description for Cloud Foundry operators and dev / ops professionals interested in managing users in a new Cloud Foundry installation. This process is unrefined, and will improve with direct vmc user management in the near future.

## Creating admin users

1. Refer to your deployment manifest for the email and password of an admin user. The user will be under the `uaa: scim` section. Refer to the bottom of this [example manifest](../bosh/reference/cloud-foundry-example-manifest.html) as an example.

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
