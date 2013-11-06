---
title: Memcachier
---

The Easiest, Most Advanced Managed Memcache.

## <a id='managing'></a>Managing Services ##

[Managing services from the command line](../../../using/services/managing-services.html)

### Creating a Service Instance ##

An instance of this service can be provisioned via the CLI with the following command:

<pre class="terminal">
$ cf create-service memcachier
</pre>
    
### Binding Your Service Instance ##

Bind the service instance to your app with the following command:
    
<pre class="terminal">
$ cf bind-service 
</pre>

## <a id='using'></a>Using Service Instances with your Application ##

See [Using Service Instances with your Application](../../adding-a-service.html#using) and [VCAP_SERVICES Environment Variable](../../../using/deploying-apps/environment-variable.html).

Format of credentials in `VCAP_SERVICES` environment variable.

~~~xml
{
  memcachier-n/a: [
    {
      name: "memcachier-1234",
      label: "memcachier-n/a",
      tags: [
        "caching"
      ],
      plan: "dev",
      credentials: {
        servers: "mc4.dev.ec2.memcachier.com:11211",
        username: "3668cf",
        password: "bf12d43795"
      }
    }
  ]
}
~~~

### Spring

### Rails

### Node.js

## <a id='sample-app'></a>Sample Applications ##

## <a id='dashboard'></a>Dashboard ##

## <a id='support'></a>Support ##

[Contacting Service Providers for Support](../contacting-service-providers-for-support.html)

* https://memcachier.zendesk.com/

## <a id='external-links'></a>External Links ##

* https://www.memcachier.com/
* https://www.memcachier.com/documentation

