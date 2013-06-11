---
title: Ruby - CF-Runtime
---

## <a id='intro'></a>Introduction ##

The 'cf-runtime' gem provides helper functions to allow easy configuration of connections to any service that is bound to an application. 

## <a id='prerequisites'></a>Prerequisites ##

This library is a Ruby gem, the only pre-requisite is that you have Ruby installed. For more details on how to install Ruby with RVM or rbenv see the [Installing Ruby](/docs/common/install_ruby.html) page.

## <a id='connecting-to-a-named-service'></a>Connecting to a named service ##

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

## <a id='connecting-to-one-instance'></a>Connecting to the only instance of a service ##

If only one instance of a particular service type is bound to an application, you don't even need to specify it's name to create a client;

~~~ruby

require 'cfruntime'
connection = CFRuntime::MongoClient.create 
db = connection.db

~~~

This example finds the ONLY MongoDB instance bound to the application and retrieve a client for it. If there is more than one instance of the service type, the library will raise an error or type ArgumentError. Again, all the classes mentioned above respond this way to the 'create' method.

## <a id='obtaining-connection-properties'></a>Obtaining connection properties ##

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

## <a id='other-hand-methods'></a>Other handy methods ##

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
