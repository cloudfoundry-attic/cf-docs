---
title: Adding Login Server to Cloud Foundry BOSH deployment
---

Core Cloud Foundry includes a Login Server component that can be used as a single-sign on (SSO) service for applications. 

![login server](https://www.evernote.com/shard/s3/sh/1a205138-16e9-4bb4-b3db-22484108ea58/13e9230d134f99f03f82f160a50d2e83/deep/0/Cloud%20Foundry%20%5BBETA%5D.png)

See the section "Configuration" below for configuring the links "Forgot Password" and "Create an account". These features are not implemented by Login Server; and require that you have a user-facing dashboard/console/portal to allow users to create accounts and request passwords be reset.

## Disable Login Server

If you are not using Login Server then you must explicitly disable it in your deployment file:

~~~ yaml
properties:
  login:
    enabled: false
~~~

## Adding Login Server

The Login Server is already included in the [published cf-release](cf-release.html) and updates are distributed with each update of Core Cloud Foundry.

To add the Login Server to your running Cloud Foundry deployment, you make some changes to the following sections:

* `properties`
* `jobs`
* `resource_pools`

Update the `properties` section with the `properties.login` and `properties.uaa.clients.login` sections below:

~~~ yaml
properties:
  login:
    enabled: true
    url: http://login.mycloud.com
    protocol: http
    links:
      home: http://me.mycloud.com
      passwd: http://me.mycloud.com
      signup: http://me.mycloud.com

  uaa:
    clients:
      ...
      login:
        id: login
        override: true
        autoapprove: true
        authorities: oauth.login
        authorized-grant-types: authorization_code,client_credentials,refresh_token
        scope: openid
        secret: c1oudc0wc1oudc0w
~~~

Next, add an extra job `login` to run the login server template:

~~~ yaml
- name: login
  template:
    - login
  instances: 1
  resource_pool: small
  networks:
    - name: default
      default: [dns, gateway]
~~~

Next, increase the resource pool referenced by the `login` job (`small` in the example above).

Finally, run the BOSH deployment command:

<pre class="terminal">
bosh deploy
</pre>

The Login Server will be available at http://login.mycloud.com (as specified in `properties.login.url` above).

## Configuring

The links "Forgot Password" and "Create an account" should be configured. These features are not implemented by Login Server; and require that you have a user-facing dashboard/console/portal to allow users to create accounts and request passwords be reset.

By default, if the `properties.login.links` section is omitted these links will reference the public https://console.run.pivotal.io/ portal service. This is very confusing to your users. As such you must configure these links to your own dashboard/console.

