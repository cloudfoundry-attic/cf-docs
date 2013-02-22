---
title: Ruby, Service Bindings
---

### Quick links ###
* [Introduction](#intro)
* [Creating and binding the service](#creating-and-binding)
* [Auto Configuration](#autoconfig)
* [Connecting to the service (Auto configuration)](#connecting-auto)
* [VCAP_SERVICES Environmental Variables](#env-vars)
* [Connecting to the service (Manual configuration)](#connecting-manual)
* [Connecting Rails (Auto configuration)](#rails-auto)
* [Connecting Rails (Manual configuration)](#rails-manual)

## <a id='intro'></a>Introduction ##

This guide is for developers who wish to bind a data source to a Ruby application deployed and running on Cloud Foundry.

## <a id='creating-and-binding'></a>Creating and binding the service ##

To create a service issue the following command with vmc and answer the interactive prompts;

<pre class="terminal">
$ vmc create-service
</pre>

To bind the service to the application, use the following vmc command;

<pre class="terminal">
$ vmc bind-service --app [application name] --service [service name]
</pre>

## <a id='autoconfig'></a>Auto Configuration ##

Cloud Foundry provides auto configuration for Redis, Mongo DB, MySQL, PostgreSQL and RabbitMQ. This means that Cloud Foundry will automatically override connection configuration for any services bound to the application. 
This is limited to one instance of a service of each type and is only really appropriate for development use, it's generally better practice, in production to use the connection details provided by the VCAP_SERVICES environment variables (covered later).

To enable auto configuration, include the following line in your Gemfile

~~~ruby
gem 'cf-autoconfig', :require => 'cfautoconfig'
~~~

Also add the correct gem for your service and make sure the appropriate service is bound to the application. 

Assuming you are using Bundler to manage gem dependencies and depending on which service you plan to bind to your application, you need to make sure the correct gem is included in the project and the bundle has been updated. 

<pre>
Service Type      Gem

MySQL             <a href="https://github.com/brianmario/mysql2">mysql2</a>
PostgreSQL        <a href="https://rubygems.org/gems/pg">pg</a>
MongoDB           <a href="http://mongomapper.com/">mongo_mapper</a> (ORM), <a href="https://github.com/mongodb/mongo-ruby-driver">mongo</a>

Redis             <a href="https://github.com/redis/redis-rb">redis</a>
Rabbit            <a href="https://github.com/ruby-amqp/amqp">ampq</a>
</pre>

Add the gems for the bound services and update the bundle

<pre class="terminal">
$ bundle update
</pre>

## <a id='connecting-auto'></a>Connecting to the service (Auto configuration) ##

When using an autoconfigured service it should be sufficient to deploy the application in the same state as it is for development. So, for example, if connecting to a MySQL instance, in development the connection may look like this;

~~~ruby
client = Mysql2::Client.new(:host => "localhost", :username => "root")
~~~

When deployed to production, even though the connection is set for a local instance, it is overriden to connect to the bound instance of MySQL. For the sake of brevity, here follow examples of other service types;

PostgreSQL

~~~ruby
conn = PG.connect( dbname: 'localdbname' )
~~~

Mongo 

~~~ruby
client = MongoClient.new('localhost', 27017)
~~~

Redis

~~~ruby
redis = Redis.new()
~~~

Rabbit (ampq)

~~~ruby
connection = AMQP.connect(:host => '127.0.0.1')
~~~

## <a id='env-vars'></a>VCAP_SERVICES Environmental Variables ##

As mentioned before, auto configuration is not particularly appropriate for a production environment. There are overheads involved in configuring connections automatically, it is far better to configure them directly.
When a service is bound to an application, enviromental variables become available to the application that describe the connections available.

Setting the connection for your service is as simple as reading the values from the environmental variable VCAP_SERVICES using 'ENV', examples for each service are shown below;

MySQL - ENV["mysql-5.1"][0]

~~~json
{
  "mysql-5.1": [
    {
      "name": "mysql-adeb7",
      "label": "mysql-5.1",
      "plan": "free",
      "tags": [
        "relational",
        "mysql-5.1",
        "mysql"
      ],
      "credentials": {
        "name": "d7e35ab8839384283a39a50ccc15b2b16",
        "hostname": "172.30.48.30",
        "host": "172.30.48.30",
        "port": 3306,
        "user": "uB8UU9ypglJQz",
        "username": "uB8UU9ypglJQz",
        "password": "pHXtkygIrogQA"
      }
    }
  ]
}
~~~

RabbitMQ - ENV["rabbitmq-2.4"][0]

~~~json
{ 
  "rabbitmq-2.4": [
    {
      "name": "rabbitmq-baa85",
      "label": "rabbitmq-2.4",
      "plan": "free",
      "tags": [
        "message-queue",
        "amqp",
        "rabbitmq-2.4",
        "rabbitmq"
      ],
      "credentials": {
        "name": "b45b0423-dcab-4c65-b277-e8e6064be0ce",
        "hostname": "172.30.48.108",
        "host": "172.30.48.108",
        "port": 10055,
        "vhost": "v941f54bc62264ecdac6cf65976c65fd5",
        "username": "uIBTXkZzoUox4",
        "user": "uIBTXkZzoUox4",
        "password": "p4gM2O60JrSNZ",
        "pass": "p4gM2O60JrSNZ",
        "url": "amqp://uIBTXkZzoUox4:p4gM2O60JrSNZ@172.30.48.108:10055/v941f54bc62264ecdac6cf65976c65fd5"
      }
    }
  ]
}
~~~

Redis - ENV["redis-2.6"][0]

~~~json
{
  "redis-2.6": [
    {
      "name": "redis-6b10d",
      "label": "redis-2.6",
      "plan": "free",
      "tags": [
        "key-value",
        "nosql",
        "redis-2.6",
        "redis"
      ],
      "credentials": {
        "hostname": "172.30.48.41",
        "host": "172.30.48.41",
        "port": 5162,
        "password": "d3150626-10d9-4910-8ae5-90670b2cc936",
        "name": "bf0f470b-0418-4088-a3a3-8520508e3e41"
      }
    }
  ]
}
~~~

MongoDB - ENV["mongodb-2.0"][0]

~~~json
{
  "mongodb-2.0": [
    {
      "name": "mongodb-3894a",
      "label": "mongodb-2.0",
      "plan": "free",
      "tags": [
        "nosql",
        "document",
        "mongodb-2.0",
        "mongodb"
      ],
      "credentials": {
        "hostname": "172.30.48.66",
        "host": "172.30.48.66",
        "port": 25219,
        "username": "702f1d22-eb33-4b9b-b46c-fa58ce2d062a",
        "password": "238083e0-152d-4a97-800d-1f35cd0163e4",
        "name": "f5ffcb64-eca3-45f8-b3bb-e0d90a389fdc",
        "db": "db",
        "url": "mongodb://702f1d22-eb33-4b9b-b46c-fa58ce2d062a:238083e0-152d-4a97-800d-1f35cd0163e4@172.30.48.66:25219/db"
      }
    }
  ]
}
~~~

PostgreSQL - ENV["postgresql-9.0"][0]

~~~json
{
  "postgresql-9.0": [
    {
      "name": "postgresql-e7870",
      "label": "postgresql-9.0",
      "plan": "free",
      "tags": [
        "relational",
        "postgresql-9.0",
        "postgresql"
      ],
      "credentials": {
        "name": "d2c96bd9b1c54479cabdb9d887e881c23",
        "host": "172.30.48.127",
        "hostname": "172.30.48.127",
        "port": 5432,
        "user": "u55b9102d75dc487c9d147c46b7c3c4be",
        "username": "u55b9102d75dc487c9d147c46b7c3c4be",
        "password": "p595dddcca41343d29d25186ee6fe6f94"
      }
    }
  ]
}
~~~

## <a id='connecting-manual'></a>Connecting to the service (Manual configuration) ##

Creating a connection to a bound service using environmental variables is a simple task. For example, for a MySQL connection;

~~~ruby

mysql_dbs = JSON.parse(ENV['VCAP_SERVICES'])["mysql-5.1"]
credentials = mysql_dbs.first["credentials"]

mysql_creds = {
  :host => credentials["host"],
  :username => credentials["username"],
  :password => credentials["password"],
  :database => credentials["name"],
  :port => credentials["port"]
}

client = Mysql2::Client.new mysql_creds

~~~
## <a id='rails-auto'></a>Connecting Rails (Auto configuration) ##

Making sure the correct gem for the bound service is included in the Gemfile and the following gem also;

~~~ruby
gem 'cf-autoconfig', :require => 'cfautoconfig'
~~~

When you push the application to Cloud Foundry, the connection should be configured automatically.


## <a id='rails-manual'></a>Connecting Rails (Manual configuration) ##

Configuring ActiveRecord to read values from ENV is straight forward. For example, to use MySQL, modify config/database.yml to look use values from ENV;

~~~yaml

<%
  mysql_dbs = JSON.parse(ENV['VCAP_SERVICES'])["mysql-5.1"]
  credentials = mysql_dbs.first["credentials"]
%>

production:
  adapter: mysql2
  encoding: utf8
  reconnect: false
  pool: 5
  host: <%= credentials["host"] %>
  username: <%= credentials["username"] %>
  password: <%= credentials["password"] %>
  database: <%= credentials["database"] %>
  port: <%= credentials["port"] %>

~~~


