---
title: Ruby - Service Bindings
---

This guide is for developers who wish to bind a data source to a Ruby application deployed and running on Cloud Foundry.

## <a id='connecting'></a>Connecting Your Application to Your New Service ##

In order to use your new service, you need to configure your application to connect to it.

First, make sure that your application includes the correct adapter gem in your Gemfile:

<pre>
Service Type      Gem

MySQL             <a href="https://github.com/brianmario/mysql2">mysql2</a>
PostgreSQL        <a href="https://rubygems.org/gems/pg">pg</a>
MongoDB           <a href="http://mongomapper.com/">mongo_mapper</a> (ORM), <a href="https://github.com/mongodb/mongo-ruby-driver">mongo</a>
Redis             <a href="https://github.com/redis/redis-rb">redis</a>
Rabbit            <a href="https://github.com/ruby-amqp/amqp">ampq</a>

</pre>

Be sure to run `bundle install` to generate an updated Gemfile.lock.

Next, tell your application how to connect to the service.
There are two ways to do this.

* You can use the cf-autoconfig gem. For Ruby applications, this option is appropriate only for applications if: (1) the application runs on the Rails framework, (2) the type of service bound to the application is PostgreSQL or MySQL, and (3) not more than one relational database service instance is bound to the application. 

     **Note:** Auto-configuration overwrites the database connection information in an application's `database.yml` file -- if this is unacceptable, configure your service manually, rather than using auto-configuration.  
     
* You can configure your application manually. Use this option if you want more control over how your application connects to the service. We recommend manual configuration. It's not as easy as the automatic configuration, but it provides you greater control and flexibility.

## <a id='autoconfig'></a>Auto Configuration ##

To use auto configuration, simply include the following line in your Gemfile.

~~~ruby
gem 'cf-autoconfig'
~~~

As with any change to your Gemfile, be sure to run `bundle install` to generate an updated Gemfile.lock.


## <a id='cf-runtime'></a>CF Runtime Gem ##

The 'cf-runtime' gem provides helper functions to allow easy configuration of connections to any service that is bound to an application.

### <a id='prerequisites'></a>Prerequisites ###

This library is a Ruby gem, the only pre-requisite is that you have Ruby installed. For more details on how to install Ruby with RVM or rbenv see the [Installing Ruby](/docs/common/install_ruby.html) page.

### <a id='connecting-to-a-named-service'></a>Connecting to a named service ###

To create a connection from a named service, use the 'create_from_svc' method of the desired client class. For example, connecting to a MySQL instance name 'mysql-test';

~~~ruby

require 'cfruntime'
client = CFRuntime::Mysql2Client.create_from_svc 'mysql-test'

~~~

To do the same for a MongoDB instance called 'mongo-test';

~~~ruby

require 'cfruntime'
client = CFRuntime::MongoClient.create_from_svc 'mysql-test'

~~~

Notice the code is the same but the class for the client is different, the following table shows the service type and it's corresponding connection class in the cf-runtime library, all of which you can call 'create_from_svc' against.

<table>
  <tr>
    <th>Service type</th><th>CF-Runtime class</th>
  </tr>
  <tr><td>MySQL</td><td>CFRuntime::Mysql2Client</td></tr>
  <tr><td>MongoDB</td><td>CFRuntime::MongoClient</td></tr>
  <tr><td>RabbitMQ</td><td>CFRuntime::AMQPClient or CFRuntime::CarrotClient</td></tr>
  <tr><td>Postgres</td><td>CFRuntime::PGClient</td></tr>
  <tr><td>Redis</td><td>CFRuntime::RedisClient</td></tr>
  <tr><td>Blob</td><td>CFRuntime::AWSS3Client</td></tr>
</table>

### <a id='connecting-to-one-instance'></a>Connecting to the only instance of a service ###

If only one instance of a particular service type is bound to an application, you don't even need to specify it's name to create a client;

~~~ruby

require 'cfruntime'
connection = CFRuntime::MongoClient.create
db = connection.db

~~~

This example finds the ONLY MongoDB instance bound to the application and retrieve a client for it. If there is more than one instance of the service type, the library will raise an error or type ArgumentError. Again, all the classes mentioned above respond this way to the 'create' method.

### <a id='obtaining-connection-properties'></a>Obtaining connection properties ###

CF-Runtime also provides a utility method for obtaining connection properties. Using the CFRuntime::CloudApp class, the method service_props can be called passing in either the name of a service type or the actual name of a service instance. For example, to retrieve connection details from a MySQL service;

~~~ruby

require 'cfruntime'
service_props = CFRuntime::CloudApp.service_props 'mysql'

~~~

Service type names / aliases are as follows;

<table>
  <tr>
    <th>Service type</th><th>Alias</th>
  </tr>
  <tr><td>MySQL</td><td>mysql</td></tr>
  <tr><td>MongoDB</td><td>mongodb</td></tr>
  <tr><td>RabbitMQ</td><td>rabbitmq</td></tr>
  <tr><td>Postgres</td><td>postgresql</td></tr>
  <tr><td>Redis</td><td>redis</td></tr>
  <tr><td>Blob</td><td>blob</td></tr>
</table>

A service name can also be passed to 'service_props' to get details of a particular instance.

### <a id='other-hand-methods'></a>Other handy methods ###

The CFRuntime::Cloudapp class provides some other handy methods;


<table>
  <tr>
    <th>Method</th><th>Purpose</th>
  </tr>
  <tr><td>CFRuntime::CloudApp.host</td><td>Returns the host name of the VM running the application</td></tr>
  <tr><td>CFRuntime::CloudApp.port</td><td>Returns the port number assigned to the application</td></tr>
  <tr><td>CFRuntime::CloudApp.service_names</td><td>Returns a list of the service names bound to the application</td></tr>
  <tr><td>CFRuntime::CloudApp.service_names_of_type</td><td>Returns a list of the service names of a particular type that are bound to the application</td></tr>
  <tr><td>CFRuntime::CloudApp.running_in_cloud?</td><td>Returns a boolean value, indicating if the application is running on a Cloud Foundry instance</td></tr>
</table>

## <a id='manual'></a>Manual Configuration ##

We recommend manually configuring your application to connect to services.
Doing so gives you more control and more flexibility.

To configure your connection, you'll use the VCAP\_SERVICES environment variable.
VCAP\_SERVICES contains JSON describing all the services bound to your application and the credentials you need to connect to them.

In Ruby, you can read the entire contents of VCAP\_SERVICES with "ENV" and parse it into a JSON object.
For example:

~~~ruby

my_services = JSON.parse(ENV['VCAP_SERVICES'])

~~~

To pull out the credentials from the VCAP\_SERVICES JSON, first you need to know the string to use as a key for the hash.
You can use `cf services` to list the available services to find the correct string.

For example:

<pre class="terminal">
  cf services
  Getting services in production... OK

  name           service           provider      version   plan     bound apps
  myservice      elephantsql       elephantsql   n/a       turtle   myapp

</pre>

The general format of this string is *provider-version*.
In this case the provider is "elephantsql" and the version is "n/a" so the hash key will be "elephantsql-n/a".

Given this example, you can pull the credentials for your service with these ruby statements:

~~~ruby
  db = JSON.parse(ENV['VCAP_SERVICES'])["elephantsql-n/a"]
  credentials = db.first["credentials"]
  host = credentials["host"]
  username = credentials["username"]
  password = credentials["password"]
  database = credentials["database"]
  port = credentials["port"]
~~~

To configure your Rails application, you would change your database.yml to use
erb syntax to programmatically set the connection values using the credentials
information from VCAP_SERVICES.

If you were using the ElephantSQL Postgres service, your database.yml file might look like:

~~~yaml

<%
  mydb = JSON.parse(ENV['VCAP_SERVICES'])["elephantsql-n/a"]
  credentials = mydb.first["credentials"]
%>

production:
  adapter: pg
  encoding: utf8
  reconnect: false
  pool: 5
  host: <%= credentials["host"] %>
  username: <%= credentials["username"] %>
  password: <%= credentials["password"] %>
  database: <%= credentials["database"] %>
  port: <%= credentials["port"] %>

~~~

If you are not using Active Record or another ORM and are instead instantiating your adapter client
directly, you would write your code something like this:

~~~ruby

mysqldb = JSON.parse(ENV['VCAP_SERVICES'])["cleardb-n/a"]
credentials = {
  :host => credentials["host"],
  :username => credentials["username"],
  :password => credentials["password"],
  :database => credentials["name"],
  :port => credentials["port"]
}

client = Mysql2::Client.new credentials

~~~

Note that your actual code may be different depending on the key in your VCAP_SERVICES environment
variable and syntax for instantiating your database adapter client.

## <a id='database-migration'></a>Database Migrations ##

Before you can use your database for the first time, you need to run a migration script to
create the tables and insert any seed data.

If you are using Rails, you would usually set up your database schema by running a command
like:

<pre class="terminal">
  $ bundle exec rake db:create db:migrate
</pre>

You still need to do this with your application on Cloud Foundry.
You'll use the `cf push --command` flag.
For example:

<pre class="terminal">
  $ cf push --command "bundle exec rake db:create db:migrate" myapp
</pre>

If you are using a cf manifest.yml file, be sure to use the --reset flag to override
the command setting in the manifest.

Once you have migrated your database, you will then need to push your application a second time
to set the start command back.

To set the start command back to the default, use this command:

<pre class="terminal">
  $ cf push --command "" myapp
</pre>

If you want to set a custom start command, you'll need
to include the PORT environment variable.
For example:

<pre class="terminal">
  $ cf push --command 'bundle exec rackup -p$PORT' myapp
</pre>

## <a id='troubleshooting'></a>Troubleshooting ##

If you have trouble connecting to your service, use the `cf logs` command.
It not only displays a log, it also shows you the value of all the environment
variables available to your application including VCAP_SERVICES as shown
in the example below:

<pre class="terminal">
  $ cf logs myapp
  Reading logs/console.log... OK
  Starting console on port 64868...

  Reading logs/env.log... OK
  VCAP_SERVICES={
    "elephantsql-n/a":[{
      "name":"elephant-postgres",
      "label":"elephantsql-n/a",
      "plan":"turtle",
      "credentials":{"uri":"postgres://username:password@server.example.com:5432/uniqid"}}]
  }
  ...more environment variables and values will show here...

  Reading logs/staging_task.log... OK
  ...output from the staging process displayed here...

  Reading logs/console.log
  ...output from running the application displayed here...
  --
</pre>

If you encounter the error "a fatal error has occurred. Please see the Bundler troubleshooting documentation" try updating your version of bundler and then running bundle install again.

<pre class="terminal">
  $ gem update bundler
  $ gem update --system
  $ bundle install
</pre>


