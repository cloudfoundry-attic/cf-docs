---
title: Service Connector
---
Service Connector (formerly known as Service Broker), is meant to be a manual solution for the general use case of external services. Service Connector doesn’t do automated provisioning. It only delivers credentials for pre-provisioned external service instances to Cloud Foundry deployed applications.

###Example Workflow
Note that terminal output below are mockups.

<ol>
<li>An Oracle DBA creates a database on the server and provides credentials for the database instance to a Cloud Foundry operator.</li>
<li>The Cloud Foundry operator logs into a Service Broker using the Service Broker CLI and configures the broker to advertise a service offering to be known as oracle-db1. Cloud Foundry developers will then see the offering from the command line.
<pre class="terminal">
$ cf services --marketplace
Getting services... OK

service      version   provider        plans                        description                     
mysql        5.5       core            100, 200, 250                MySQL database                  
oracle-db1   n/a       n/a             n/a                          Oracle database for Team XYZ        
rabbitmq     3.0       core            100, 200, 250, 300           RabbitMQ message queue          
redis        2.6       core            100, 200, 250, 300           Redis key-value store     
</pre>
</li>      

<li>A developer can then create an instance of the service and see a service instance provisioned in their space. Note that the service instance has been pre-provisioned by the Oracle DBA; creating a service instance in this case simply updates some tables in cloud controller. 
<pre class="terminal">
$ cf create-service oracle-db1
Name?> oracle-db1-3d1c3

1: default
Which plan?> 1

Creating service oracle-db1-3d1c3... OK

$ cf services
Getting services in development... OK

name             service    provider   version   plan    bound apps
rabbitmq-275fa   rabbitmq   core       3.0       200     none      
oracle-db1-3d1c3 oracle-db1 n/a        n/a       default none
</pre>
</li>

<li>The developer can then bind their app to the service instance. As provisioning isn't automated and new credentials aren't created each time an app is bound to the service instance, the same credentials will be used for every bound app.
<pre class="terminal">
$ cf bind-service oracle-db1-3d1c3
1: dev-app
Which application?> 1

Binding oracle-db1-3d1c3 to dev-app... OK
</pre>
</li>
</ol>

###Architecture
Service Brokers are separate jobs analogous to Service Gateways. A dedicated CLI is used to authenticate with a broker to configure it with service offerings. Brokers do not currently support multiple users or roles, nor is UAA used for authentication. Credentials are configured per broker. 

Multiple brokers can be deployed, and each can be configured with multiple offerings. Offerings advertised by brokers actually represent service instances which have been pre-provisioned out of band. Brokers register offerings with Cloud Controller. When used with legacy cloud controller, simple ACLs can be configured on the broker to limit what users offerings are available to. CCNG does not currently have support for service ACLs so offerings are available to all users. 

###Source Code
[Service Broker](https://github.com/cloudfoundry/vcap-services/tree/master/service_broker)


