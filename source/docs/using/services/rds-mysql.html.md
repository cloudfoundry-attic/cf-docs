---
title: RDS MySQL
category: marketplace
---

When an instance of this service is created, a database is provisioned on a large multi-tenant instance of Amazon's RDS service. 

### Environment Variables

The format of credentials in the VCAP_SERVICES environment variable

~~~xml
{
  rds_mysql-n/a: [
    {
      name: "rds_mysql-81511",
      label: "rds_mysql-n/a",
      plan: "10mb",
      credentials: {
        name: "db8717310992c439284ed8541d29efcd0",
        hostname: "mysql-service-public.csvbuoabzxev.us-east-1.rds.amazonaws.com",
        host: "mysql-service-public.csvbuoabzxev.us-east-1.rds.amazonaws.com",
        port: 3306,
        user: "utAKPPuX9IOHC",
        username: "utAKPPuX9IOHC",
        password: "pvHZf0HBDBMHp"
      }
    }
  ]
}
~~~ 
