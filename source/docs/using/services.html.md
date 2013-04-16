---
title: Cloud Foundry Services
---

## <a id='viewing-services'></a> Viewing Available Services ##

After targeting and logging into Cloud Foundry using [cf](/docs/using/managing-apps/cf/index.html), you can view what services are available using:

<pre class="terminal">
$ cf info --services
</pre>

This will result in a list of services that can be bound to your applications. The following is an example of those services on a private beta install of Cloud Foundry.

<pre class="terminal">
$ cf info --services
Getting services... OK

service      version   provider        plans                        description                     
mongodb      n/a       mongolab-dev    free, large, medium, small   Cloud hosted and managed MongoDB
mongodb      2.2       core            200                          MongoDB NoSQL database          
mysql        5.5       core            100, 200, cfinternal         MySQL database                  
postgresql   9.2       core            200                          PostgreSQL database (vFabric)   
rabbitmq     3.0       core            200                          RabbitMQ message queue          
redis        2.6       core            200                          Redis key-value store            
</pre>

<i>Note: This is an example. These services may not be available on the Cloud Foundry service you target.</i>

## <a id='creating-services'></a> Creating a Services ##

Use these commands to create and bind a service to your app.

<pre class="terminal">
$ cf create-service
1: mongodb n/a, via mongolab-dev
2: mongodb 2.2
3: mysql 5.5
4: postgresql 9.2
5: rabbitmq 3.0
6: redis 2.6
7: redis n/a, via redistogo-dev
8: smtp n/a, via sendgrid-dev
What kind?> 3

Name?> mysql-a0a77

1: 100: Shared service instance, 10MB storage, 2 connections
2: 200: Dedicated server, shared VM, 256MB memory, 2.5GB storage, 30 connections
Which plan?> 2

Creating service mysql-a0a77... OK
</pre>

## <a id='binding'></a> Binding to a Service ##

You can bind an existing service to an existing application as follows:

<pre class="terminal">
$ cf bind-service
1: my-app
Which application?> 1

1: mysql-a0a77
Which service?> 1

Binding mysql-a0a77 to my-app... OK
</pre>

How you utilize a service in the context of your application depends on the framework you employ. Refer to the [Deploying Apps](../deploying-apps/index.html) section for instructions on deploying and binding your apps to services.