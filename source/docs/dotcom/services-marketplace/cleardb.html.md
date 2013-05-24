---
title: ClearDB
category: marketplace
---

### Environment Variable

Format of credentials in VCAP_SERVICES

~~~xml
{
  "cleardb-dev-n/a": [
    {
      "name": "cleardb-dev-17a04",
      "label": "cleardb-dev-n/a",
      "plan": "spark",
      "credentials": {
        "jdbcUrl": "jdbc:mysql://b9952c027c0c39:c4788197@us-cdbr-aws-east-105.cleardb.net:3306/ad_0ee3fbeb35bdf0c",
        "mysqlUrl": "mysql://b9952c027c0c39:c4788197@us-cdbr-aws-east-105.cleardb.net:3306/ad_0ee3fbeb35bdf0c",
        "name": "ad_0ee3fbeb35bdf0c",
        "hostname": "us-cdbr-aws-east-105.cleardb.net",
        "host": "us-cdbr-aws-east-105.cleardb.net",
        "port": "3306",
        "user": "b9952c027c0c39",
        "username": "b9952c027c0c39",
        "password": "c4788197"
      }
    }
  ]
}
~~~

## Sample Application

https://github.com/scottfrederick/spring-music
