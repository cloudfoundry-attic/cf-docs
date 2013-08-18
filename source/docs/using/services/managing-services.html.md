---
title: Managing Services
---

## <a id='viewing-services'></a> View Available Services ##

After targeting and logging into Cloud Foundry using [cf](/docs/using/managing-apps/cf/index.html), you can view what services are available:

<pre class="terminal">
$ cf services --marketplace
</pre>

This command displays a list of services that can be bound to your applications. The following is an example of those services on a private beta install of Cloud Foundry.

<pre class="terminal">
$ cf services --marketplace
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

## <a id='create'></a>Create a Service ##

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

## <a id='bind'></a>Bind a Service ##

Binding a service to your application adds credentials for the service instance to the VCAP_SERVICES environment variable. In most cases these credentials are unique to the binding; another app bound to the same service instance would receive different credentials. You may need to restart your application for it to recognize the change. 

How your app leverages the contents of environment variables may depend on the framework you employ. Refer to the [Deploying Apps](/docs/using/deploying-apps/index.html) section for more information.

You can bind an existing service to an existing application as follows:

<pre class="terminal">
$ cf bind-service
1: my-app
Which application?> 1

1: mysql-a0a77
Which service?> 1

Binding mysql-a0a77 to my-app... OK
</pre>

## <a id='unbind'></a>Unbind a Service ##

Unbinding a service removes the credentials created for your application from the VCAP_SERVICES environment variable. You may need to restart your application for it to recognize the change. 

<pre class="terminal">
$ cf unbind-service
1: my-app
Which application?> 1

1: mysql-a0a77
Which service?> 1

Unbinding mysql-a0a77 from my-app... OK
</pre>

## <a id='delete'></a>Delete a Service ##

Deleting a service unprovisions the service instance and deletes *all data* along with the service instance. 

<pre class="terminal">
$ cf delete-service
1: mysql-a0a77
Which service?> 1

Really delete mysql-a0a77?> y

Deleting mysql-a0a77... OK
</pre>
