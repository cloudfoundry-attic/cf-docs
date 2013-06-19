---
title: Configure Service Connections for Ruby Applications
---

This page has information about how to configure a Ruby application that is deployed and running on Cloud Foundry to connect to a bound service.

## <a id='options'></a>Options for Configuring Ruby Apps for Services ##

There are several methods for configuring a Ruby application to connect to a service:

* Create a connection object --- You can use the `cfruntime` gem to create a service connection object. This is the recommended approach, as it gives you more control over how the application connects to the service.

* For a database application, you can define the connect in `database.yml` --- You can parse the `VCAP_SERVICES` environment variable, which contains connection information for all services bound to your application, and update the `database.yml` file for your application. 

* Autoconfiguration -- You can autoconfigure the application with the `cf-autoconfig` gem, if: (1) the application runs on the Rails framework, (2) the type of service bound to the application is PostgreSQL or MySQL, and (3) not more than one relational database service instance is bound to the application. 

     **Note:** Auto-configuration overwrites the database connection information in an application's `database.yml` file -- if this is unacceptable, configure your service manually, rather than using autoconfiguration.  


## <a id='prereq'></a>Prerequisites ##

Ensure that the application includes the correct adapter gem in the Gemfile:

<table>
  <tr>
    <th>Service type</th><th>Alias</th>
  </tr>
  <tr><td>MySQL</td><td><a href="https://github.com/brianmario/mysql2">mysql2</a></td></tr>
  <tr><td>MongoDB</td><td><a href="http://mongomapper.com/">mongo_mapper</a> (ORM), <a href="https://github.com/mongodb/mongo-ruby-driver">mongo</a></td></tr>
  <tr><td>RabbitMQ</td><td><a href="https://github.com/ruby-amqp/amqp">ampq</a></td></tr>
  <tr><td>Postgres</td><td><a href="https://rubygems.org/gems/pg">pg</a></td></tr>
  <tr><td>Redis</td><td><a href="https://github.com/redis/redis-rb">redis</a></td></tr>
</table>

Run `bundle install` to generate an updated `Gemfile.lock`.

For the manual configuration methods, Ruby must be installed. For instructions on how to install Ruby with RVM or rbenv see [Installing Ruby](/docs/common/install_ruby.html).

## <a id='manual'></a>Manual Configuration with cfruntime</a> ##

This approach to configuring a Ruby application for a service entails updating the application to obtain service connection data using the `cf-runtime` gem.   
The `cf-runtime` gem provides helper functions that ease configuration of connections to any service bound to an application.


### <a id='connecting-to-a-named-service'></a>Connect to a Named Service ###

To create a connection from a named service, use the `create_from_svc` method of the client class for the service type.  The table below lists the connection classes in the cf-runtime library by service type; you can call `create_from_svc` from any of the client classes.

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

**Example 1**

To create a connection for a MySQL instance named 'mysql-test':

~~~ruby

require 'cfruntime'
client = CFRuntime::Mysql2Client.create_from_svc 'mysql-test'

~~~

**Example 2**

To create a connection for a MongoDB instance named 'mongo-test':

~~~ruby

require 'cfruntime'
client = CFRuntime::MongoClient.create_from_svc 'mysql-test'

~~~

### <a id='connecting-to-one-instance'></a>Connect to Only Instance of a Service ###

If only one instance of a particular service type is bound to an application, you do not need to specify its name to create a client, for example:

~~~ruby

require 'cfruntime'
connection = CFRuntime::MongoClient.create
db = connection.db

~~~

The example above finds the only MongoDB instance bound to the application and retrieves a client for it. If there is more than one instance of the service type, the library will raise an error or type ArgumentError. All of the connection classes listed above respond this way to the `create` method.

### <a id='obtaining-connection-properties'></a>Get Connection Data with cfruntime ###

`cfruntime`  provides a utility method for obtaining connection properties. Using the `CFRuntime::CloudApp` class, the `service_props` method can be called passing in either the name of a service type or the name of a service instance. For example, to retrieve connection details from a MySQL service:

~~~ruby

require 'cfruntime'
service_props = CFRuntime::CloudApp.service_props 'mysql'

~~~

The table below lists the alias for each service type.

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

A service name can also be passed to `service_props` to get details of a particular instance.

### <a id='other-hand-methods'></a>Useful cfruntime Methods ###

The table below lists other useful methods in the`CFRuntime::Cloudapp` class.


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

## <a id='manual'></a>Define Connection in Configuration File ##

For a Ruby database application, you can configure the database connection information in the application's `database.yml` file. You can determine the connection details from the `VCAP_SERVICES` environment variable, which  contains JSON describing all the services bound to your application and the credentials you need to connect to them. When you bind a service to an application with the `cf bind-service` command, cf writes the service connection details to the `VCAP_SERVICES` environment variable. 

In Ruby, you can read the contents of `VCAP_SERVICES` with `ENV`.

For example:

~~~ruby

my_services = JSON.parse(ENV['VCAP_SERVICES'])

~~~

To obtain the credentials from the VCAP\_SERVICES JSON, you need to know the string to use as a key for the hash.

You can use `cf services` to list the available services to find the correct string.

For example:

<pre class="terminal">
  cf services
  Getting services in production... OK

  name           service           provider      version   plan     bound apps
  myservice      elephantsql       elephantsql   n/a       turtle   myapp

</pre>

The general format of this string is *provider-version*.
In this case the provider is "elephantsql" and the version is "n/a" so the hash key is "elephantsql-n/a".

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

To configure a Rails application, you would change your `database.yml` to use
erb syntax to programmatically set the connection values using the credentials
information from VCAP_SERVICES.

If you are using the ElephantSQL Postgres service, your `database.yml` file might look like:

~~~

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

If you are not using Active Record or another ORM and are instead instantiating your adapter client directly, your code would like something like this:

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

Your code may vary from the example above, depending on the key in your VCAP_SERVICES environmentvariable and syntax for instantiating your database adapter client.


## <a id='autoconfig'></a>Auto-Configuration ##


To use autoconfiguration, include this line in your Gemfile:

~~~ruby
gem 'cf-autoconfig'
~~~

After modifying the Gemfile, run `bundle install` to generate an updated `Gemfile.lock`.



## <a id='database-migration'></a>Create and Populate Database Tables ##

Before you can use your database for the first time, you must run a migration script to create the tables and insert any seed data.

If you are using Rails, you would usually set up your database schema by running a command like:

<pre class="terminal">
  $ bundle exec rake db:create db:migrate
</pre>

The same process is required for your application on Cloud Foundry.
You provide the command for running the migration script when you push the application, using the 'cf push --command` option. For example:

<pre class="terminal">
  $ cf push --command "bundle exec rake db:create db:migrate" myapp
</pre>

If you are using a cf manifest.yml file, be sure to use the `--reset` flag to override the command setting in the manifest.

After migrating your database, push your application again to set the start command back.

To set the start command back to the default, use this command:

<pre class="terminal">
  $ cf push --command "" myapp
</pre>

If you want to set a custom start command, include the PORT environment variable.
For example:

<pre class="terminal">
  $ cf push --command 'bundle exec rackup -p$PORT' myapp
</pre>

## <a id='troubleshooting'></a>Troubleshooting ##

If you have trouble connecting to your service, run the `cf logs` command to view log messages and see the values of the environment
variables available to your application. `cf logs` command results include the value of the VCAP_SERVICES envioronment variable, for example:

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

If you encounter the error "a fatal error has occurred. Please see the Bundler troubleshooting documentation", update your version of bundler and run `bundle install` again.

<pre class="terminal">
  $ gem update bundler
  $ gem update --system
  $ bundle install
</pre>


