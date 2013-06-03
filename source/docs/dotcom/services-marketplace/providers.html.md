---
title: Documentation for Service Providers
category: 
---

## <a id='integration'></a>Integrating With Cloud Foundry ##

Cloud Foundry has partnered with AppDirect for services integration with our public PaaS. Service providers interested in adding their service to the Cloud Foundry Marketplace should contact [Nima Badiey](mailto:nbadiey@gopivotal.com) for more information. 

Documentation on AppDirect's API for Cloud Foundry can be found here:
http://info.appdirect.com/developer/docs/cloud-foundry/

## <a id='google-group'></a>Google Group ##

Join our Google Group to receive announcements regarding integration with Cloud Foundry.
https://groups.google.com/forum/?hl=en&fromgroups#!forum/cloud-foundry-partners

## <a id='docs'></a>Documentation ##

Service providers should feel enabled to manage their own documentation. Clone the [cf-docs repo](https://github.com/cloudfoundry/cf-docs) and issue pull requests to update your Marketplace Services documentation page. 

Your documentation page should reside in `source/docs/dotcom/services-marketplace`.

We've provided a template to get you started. Please include the Managing Services and Support sections with links we've included; feel free to add additional information as appropriate. If your service is bindable, you'll want to include the section on Environment Variables. 

[Provider Documentation Template](provider-template.html)

## <a id='sample-apps'></a>Sample Apps ##

Providing a sample application that works out of the box provides an excellent user experience. Developers can validate that your service works as expected, and the sample app should provide a code example for how to integrate an application with your service. There are two ways we recommend publishing your sample application:

1. You can host your sample app in your own repo, and we can fork it into https://github.com/cloudfoundry-samples
2. You can send us the code for your app and we can add a new repo to https://github.com/cloudfoundry-samples

## <a id='binding-credentials'></a>Binding Credentials ##

If your service is bindable, it means that in response to the bind API call, you will return credentials which can be consumed by an application. We write these credentials to the environment variable VCAP_SERVICES.

Please choose from these credentials if possible. You can provide fields in addition, or if the credential you return is not covered by any of these fields. This convention allows us to provide end user developers with libraries which parse VCAP_SERVICES and delivers credentials to applications more easily. You can provide `uri` or the individual credential fields, or both. 

| credentials   | description |
|---------------|-------------|
| uri           | Connection string of the form `dbtype://username:password@hostname:port/name`, where `dbtype` is mysql, postgres, mongodb, amqp, etc. |
| hostname      | The FQDN of the server host |
| port          | The port of the server host |
| name          | Name of the service instance; database name |
| vhost         | Name of the messaging server virtual host (replacement for `name` specific to AMQP providers) |
| username      | Server user |
| password      | Server password |

Here's an example output of `ENV['VCAP_SERVICES']`

~~~
VCAP_SERVICES=
{
  cloudamqp-dev-n/a: [
    {
      name: "cloudamqp-dev-scoen-20130531-6",
      label: "cloudamqp-dev-n/a",
      plan: "lemur",
      credentials: {
        uri: "amqp://ksvyjmiv:IwN6dCdZmeQD4O0ZPKpu1YOaLx1he8wo@lemur.cloudamqp.com/ksvyjmiv"
      }
    }
  ],
  mongolab-dev-n/a: [
    {
      name: "mongolab-dev-scoen-20130531-6",
      label: "mongolab-dev-n/a",
      plan: "sandbox",
      credentials: {
        uri: "mongodb://cloudfoundry-test_bqkvngl4_3k2gnf7l_c4kirupj:93912c28-1a89-4971-ac30-91cc22faab99@ds035147.mongolab.com:35147/cloudfoundry-test_bqkvngl4_3k2gnf7l"
      }
    }
  ],
  rediscloud-dev-n/a: [
    {
      name: "rediscloud-dev-scoen-20130531-6",
      label: "rediscloud-dev-n/a",
      plan: "20mb",
      credentials: {
        port: "19020",
        hostname: "pub-redis-19020.MatanCluster.ec2.garantiadata.com",
        password: "zAgbWI0wXrkv0eTQ"
      }
    }
  ],
  cleardb-dev-n/a: [
    {
      name: "cleardb-dev-588f5",
      label: "cleardb-dev-n/a",
      plan: "spark",
      credentials: {
        jdbcUrl: "jdbc:mysql://b76eb73e350753:ba16d1be@us-cdbr-east-03.cleardb.com:3306/ad_45ef93ced8dbd86",
        uri: "mysql://b76eb73e350753:ba16d1be@us-cdbr-east-03.cleardb.com:3306/ad_45ef93ced8dbd86",
        name: "ad_45ef93ced8dbd86",
        hostname: "us-cdbr-east-03.cleardb.com",
        port: "3306",
        username: "b76eb73e350753",
        password: "ba16d1be"
      }
    }
  ]
}
~~~
