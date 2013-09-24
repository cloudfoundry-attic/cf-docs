---
title: ClearDB
---

## <a id='managing-services'></a>Managing Services ##

[Managing Services](../../../using/services/index.html)

## <a id='integration'></a>Integrating the Service With Your App ###

Format of credentials in VCAP_SERVICES

~~~xml
{
  cleardb-dev-n/a: [
    {
      name: "cleardb-dev-ebf69",
      label: "cleardb-dev-n/a",
      plan: "spark",
      credentials: {
        jdbcUrl: "jdbc:mysql://bb76fcb43f807b:6776566b@us-cdbr-aws-east-105.cleardb.net:3306/ad_033c9629217c759",
        uri: "mysql://bb76fcb43f807b:6776566b@us-cdbr-aws-east-105.cleardb.net:3306/ad_033c9629217c759?reconnect=true",
        name: "ad_033c9629217c759",
        hostname: "us-cdbr-aws-east-105.cleardb.net",
        host: "us-cdbr-aws-east-105.cleardb.net",
        port: "3306",
        user: "bb76fcb43f807b",
        username: "bb76fcb43f807b",
        password: "6776566b"
      }
    }
  ]
}
~~~

## Sample Application

https://github.com/scottfrederick/spring-music

## <a id='support'></a>Support ##

[Contacting Service Providers for Support](../contacting-service-providers-for-support.html)

## <a id='external-links'></a>External Links ##

* http://www.cleardb.com/

