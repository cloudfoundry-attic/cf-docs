---
title: Ruby - Service Bindings
---

## <a id='intro'></a>Introduction ##

This guide is for developers who wish to bind a data source to a Ruby application deployed and running on Cloud Foundry.

## <a id='creating-and-binding'></a>Creating and binding the service ##

To create a service issue the following command with cf and answer the interactive prompts;

<pre class="terminal">
$ cf create-service
</pre>

To bind the service to the application so that Cloud Foundry associates the service and your app, use the following cf command;

<pre class="terminal">
$ cf bind-service --app [application name] --service [service name]
</pre>

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

You can use the cf-autoconfig gem. This option is appropriate only for applications with a single service and only works for Redis, Mongo DB, MySQL, PostgreSQL and RabbitMQ.

You can configure your application manually. Use this option if you want more control over how your application connects to the service. We recommend manual configuration. It's not as easy as the automatic configuration, but it provides you greater control and flexibility.

## <a id='autoconfig'></a>Auto Configuration ##

To use auto configuration, simply include the following line in your Gemfile.

~~~ruby
gem 'cf-autoconfig'
~~~

As with any change to your Gemfile, be sure to run `bundle install` to generate an updated Gemfile.lock.

The auto configuration will overwrite your database connection information in your application. So, for example, if you are writing a Rails application, cf-autoconfig will overwrite your database.yml file.
If you don't want your database.yml file to be overwritten, you need to configure your services manually.

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

## <a id='troubleshooting'></a>Troublshooting ##

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


