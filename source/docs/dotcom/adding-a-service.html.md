---
title: Getting Started - Adding a Service
---

Cloud Foundry allows you to deploy applications without worrying about configuration headaches, making it faster and easier to build, test, deploy and scale your app.

This guide walks you through binding and using services at run.pivotal.io. It assumes you have pushed an application to run.pivotal.io. If you haven't done, that, you might consider going through our guide, [Getting Started](getting-started.html). 

## <a id='services'></a>Set Up Your Service(s) ##

If your application depends on an external service such as MySQL or Redis you will need to configure it. `cf` will ask you if you want to do this, however you should set up your services before you deploy your application.

You can provision services with the `cf create-service` command.

<pre class="terminal">
  $ cf create-service
  1: cleardb n/a, via cleardb
  2: cloudamqp n/a, via cloudamqp
  3: elephantsql n/a, via elephantsql
  4: mongolab n/a, via mongolab
  5: rediscloud n/a, via garantiadata
  6: treasuredata n/a, via treasuredata
  What kind?>
</pre>

After you choose the service provider, `cf` will ask you to name your service. You can use any series of alpha-numeric characters ([a-z], [A-Z], [0-9]) plus hyphens (-) or underscores (_).

Once you have your services set up, you need to configure your application to use the correct credentials for your service. The credentials are created for you and are accessible through the VCAP_SERVICES environment variable that Cloud Foundry sets within your runtime context.

The VCAP_SERVICES environment variable holds a JSON string with the connection details. You need to read the JSON and extract out the username and password.

## Ruby on Rails

You set your database connection information for a Rails app in the database.yml file.
If you were using elephantsql-n/a Here's how
~~~yml

<%
  db = JSON.parse(ENV['VCAP_SERVICES'])["elephantsql-n/a"]
  credentials = db.first["credentials"]
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
