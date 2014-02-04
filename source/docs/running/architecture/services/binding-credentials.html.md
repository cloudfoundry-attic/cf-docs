---
title: Binding Credentials
---

If your service is bindable, it means that in response to the bind API call, you will return credentials which can be consumed by an application. Cloud Foundry writes these credentials to the environment variable [VCAP_SERVICES](../../../using/deploying-apps/environment-variable.html). In some cases buildpacks will write a subset of these credentials to other environment variables that frameworks may expect.

Please choose from the following list of credential fields if possible. You can provide additional fields as needed, but if any of these fields meet your needs you should use them. This convention allows developers to provide buildpacks and libraries which either parse VCAP_SERVICES and deliver useful objects to applications, or which actually configure applications themselves with a service connection.

**Important: if you provide a service which supports a connection string, you should provide at least the `uri` key; as mentioned you may provide discrete credential fields in addition. Buildpacks and application libraries use the `uri` key.**

| credentials   | description |
|---------------|-------------|
| uri           | Connection string of the form `dbtype://username:password@hostname:port/name`, where `dbtype` is mysql, postgres, mongodb, amqp, etc. |
| hostname      | The FQDN of the server host |
| port          | The port of the server host |
| name          | Name of the service instance; database name |
| vhost         | Name of the messaging server virtual host (replacement for `name` specific to AMQP providers) |
| username      | Server user |
| password      | Server password |

Here's an example output of `ENV['VCAP_SERVICES']`. Note that ClearDB chooses to return both discrete credentials, a uri, as well as another field. CloudAMQP chooses to return just the uri, and RedisCloud returns only discrete credentials.

<pre class="highlight xml">
VCAP_SERVICES=
{
  cleardb-dev-n/a: [
    {
      name: "cleardb-dev-1",
      label: "cleardb-dev-n/a",
      plan: "spark",
      credentials: {
        name: "ad_c6f4446532610ab",
        hostname: "us-cdbr-east-03.cleardb.com",
        port: "3306",
        username: "b5d435f40dd2b2",
        password: "ebfc00ac",
        uri: "mysql://b5d435f40dd2b2:ebfc00ac@us-cdbr-east-03.cleardb.com:3306/ad_c6f4446532610ab",
        jdbcUrl: "jdbc:mysql://b5d435f40dd2b2:ebfc00ac@us-cdbr-east-03.cleardb.com:3306/ad_c6f4446532610ab"
      }
    }
  ],
  cloudamqp-dev-n/a: [
    {
      name: "cloudamqp-dev-6",
      label: "cloudamqp-dev-n/a",
      plan: "lemur",
      credentials: {
        uri: "amqp://ksvyjmiv:IwN6dCdZmeQD4O0ZPKpu1YOaLx1he8wo@lemur.cloudamqp.com/ksvyjmiv"
      }
    }
    {
      name: "cloudamqp-dev-9dbc6",
      label: "cloudamqp-dev-n/a",
      plan: "lemur",
      credentials: {
        uri: "amqp://vhuklnxa:9lNFxpTuJsAdTts98vQIdKHW3MojyMyV@lemur.cloudamqp.com/vhuklnxa"
      }
    }
  ],
  rediscloud-dev-n/a: [
    {
      name: "rediscloud-dev-1",
      label: "rediscloud-dev-n/a",
      plan: "20mb",
      credentials: {
        port: "17546",
        host: "pub-redis-17546.MatanCluster.ec2.garantiadata.com",
        password: "1M5zd3QfWi9nUyya"
      }
    },
  ],
}
</pre>
                  
