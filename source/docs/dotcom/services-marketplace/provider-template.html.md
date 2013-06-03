---
title: Your Service
category: marketplace
---

Some description of what the service is good for.

## <a id='managing-services'></a>Managing Services ##

[Manage Services from the Command Line](/docs/using/services/managing-services.html)

## <a id='integration'></a>Integrating the Service With Your App ###

If your service is bindable, what is the format of the credentials stored in the VCAP_SERVICES environment variable?

~~~xml
{
  service-foo-n/a: [
    {
      name: "service-foo-75efc",
      label: "service-foo-n/a",
      plan: "example-plan",
      credentials: {
        host: "foo.example.com"
        port: "1234"
        dbname: "asdfjasdf"
        username: "QvsXMbJ2rK",
        password: "HCDVOYluTv"
      }
    }
  ]
}
~~~

### Spring
Framework-specific integration techniques. 

### Rails
Framework-specific integration techniques. 

### Node.js
Framework-specific integration techniques. 

## <a id='using'></a>Using the Service ##

How to use the service.

## <a id='sample-app'></a>Sample Applications ##

Links and documentation for a sample app which a Cloud Foundry user could use to see the value of your service.

## <a id='support'></a>Support ##

[Contacting Service Providers for Support](contacting-service-providers-for-support.html)

Provider Support Instructions

## <a id='external-links'></a>External Links ##

* Provider URL
* Provider-hosted documentation URL

