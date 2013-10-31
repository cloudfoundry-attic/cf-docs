---
title: Memcached Cloud
---

Some description of what the service is good for.

## <a id='managing'></a>Managing Services ##

[Managing services from the command line](../../../using/services/managing-services.html)

### Creating a Service Instance ##

An instance of this service can be provisioned via the CLI with the following command:

<pre class="terminal">
$ cf create-service service-foo
</pre>
    
### Binding Your Service Instance ##

* Include this section only if your service is bindable. *

Bind the service instance to your app with the following command:
    
<pre class="terminal">
$ cf bind-service 
</pre>

## <a id='using'></a>Using Service Instances with your Application ##

* Include this section only if your service is bindable. What is the format of the credentials stored in the VCAP_SERVICES environment variable? *

See [Using Service Instances with your Application](../../adding-a-service.html#using) and [VCAP_SERVICES Environment Variable](../../../using/deploying-apps/environment-variable.html).

Format of credentials in `VCAP_SERVICES` environment variable.

~~~xml
memcachedcloud-n/a: [
  {
    name: "memcachedcloud-1234",
    label: "memcachedcloud-n/a",
    tags: [
      "caching"
    ],
    plan: "freebeta",
    credentials: {
      username: "memcachedcloud-1234",
      servers: "pub-memcache-12218.us-east-1-4.3.ec2.garantiadata.com:12218",
      password: "wqoES8kkHHhpWxFF"
    }
  }
]
~~~

### Spring
Framework-specific integration techniques. 

### Rails
Framework-specific integration techniques. 

### Node.js
Framework-specific integration techniques. 

## <a id='sample-app'></a>Sample Applications ##

Links and documentation for a sample app which a Cloud Foundry user could use to see the value of your service.

## <a id='dashboard'></a>Dashboard ##

What users can do with your dashboard.

## <a id='support'></a>Support ##

[Contacting Service Providers for Support](../contacting-service-providers-for-support.html)

Provider Support Instructions

## <a id='external-links'></a>External Links ##

* Provider URL
* Provider-hosted documentation URL

