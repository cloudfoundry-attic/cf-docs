---
title: Using Bound Services
---

## <a id='environment-variable'></a> Services Environment Variable ##

Binding a service to your application may add credentials to the VCAP_SERVICES environment variable that is visible to the application process. You can see the contents of the VCAP_SERVICES environment variable in the following ways.

<pre class="terminal">
$ cf files APP_NAME_HERE logs/env.log
</pre>

This command will show all environment variables including VCAP_SERVICES if it is set.

Alternatively, you can use code in an application to access the environment variables and either use it, print it, log it, etc.

Java:

```
System.getenv( "VCAP_SERVICES");
```

Ruby:

```
ENV['VCAP_SERVICES']
```

Node.js:

```
process.env.VCAP_SERVICES
```

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

For developer convenience, Cloud Foundry also has libraries for many languages that parse the environment variable and return useful objects. For more detail please see LINK HERE.
