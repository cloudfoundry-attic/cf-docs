---
title: Ruby, Service Bindings
---

### Quick links ###
* [Introduction](#intro)
* [Auto Configuration](#autoconfig)
* [Creating and binding the service](#creating-and-binding)

## <a id='intro'></a>Introduction ##

This guide is for developers who wish to bind a data source to a Ruby application deployed and running on Cloud Foundry.

## <a id='autoconfig'></a>Auto Configuration ##

Cloud Foundry provides auto configuration for Redis, Mongo DB, MySQL, PostgreSQL and RabbitMQ. This means that Cloud Foundry will automatically override connection configuration for any services bound to the application. This is limited to one instance of a service of each type. Making sure the correct gem is added to your Gemfile and the appropriate service is bound to the application should be enough to ensure a connection.

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

## <a id='connecting'></a>Connecting to the service ##

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
@client = MongoClient.new('localhost', 27017)
~~~

Redis

~~~ruby
redis = Redis.new()
~~~

Rabbit (ampq)

~~~ruby
connection = AMQP.connect(:host => '127.0.0.1')
~~~

## <a id='creating-and-binding'></a>Creating and binding the service ##

To create a service issue the following command with vmc and answer the interactive prompts;

<pre class="terminal">
$ vmc create-service
</pre>

To bind the service to the application, use the following vmc command;

<pre class="terminal">
$ vmc bind-service --app [application name] --service [service name]
</pre>

