---
title: Using Bound Services
---

## <a id='environment-variable'></a> Services Environment Variable ##

Binding a service to your application may add credentials to the VCAP\_SERVICES environment variable which are visible to your application process. You can see the contents of VCAP\_SERVICES in several ways.

### View contents of VCAP_SERVICES using CLI 

This command will show all environment variables including VCAP_SERVICES if it is set.

<pre class="terminal">
$ cf files APP_NAME_HERE logs/env.log
</pre>

### View contents of VCAP_SERVICES from your application

Alternatively, you can use code in an application to access the environment variable and either use it, print it, log it, etc.

#### Java

```
System.getenv("VCAP_SERVICES");
```

#### Ruby

```
ENV['VCAP_SERVICES']
```

#### Node.js

```
process.env.VCAP_SERVICES
```

## <a id='example'></a>Example Contents ##

This example shows an example value of VCAP\_SERVICES. In this example, we've created and bound four service instances. One ClearDB, two CloudAMQP, and one Redis Cloud. 

~~~
VCAP_SERVICES=
{
  cleardb-n/a: [
    {
      name: "cleardb-1",
      label: "cleardb-n/a",
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
  cloudamqp-n/a: [
    {
      name: "cloudamqp-6",
      label: "cloudamqp-n/a",
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
  rediscloud-n/a: [
    {
      name: "rediscloud-1",
      label: "rediscloud-n/a",
      plan: "20mb",
      credentials: {
        port: "17546",
        host: "pub-redis-17546.MatanCluster.ec2.garantiadata.com",
        password: "1M5zd3QfWi9nUyya"
      }
    },
  ],
}
~~~

## <a id='libraries'></a>Client Libraries ##

For developer convenience, Cloud Foundry also has libraries for many languages that parse the environment variable and return useful objects. For more detail please see the following pages.

* [Java and the JVM](../deploying-apps/jvm/)
* [Ruby](../deploying-apps/ruby/)
* [Node.js](../deploying-apps/javascript/)


