---
title: Java and the JVM
---

Cloud Foundry supports most JVM-based frameworks such as Java Spring, Grails, Scala Lift, and Play.
If your application can be packaged as a `.war` file and deployed to Apache Tomcat,
then it should also run on Cloud Foundry without changes.
However, before you can deploy, you need to compile your application.

## <a id='package'></a>Package ##

If you are using Spring or Lift, you can use maven:

<pre class="terminal">
$ mvn package
</pre>

If you are using play:

<pre class="terminal">
$ play redist
</pre>

If you are using Grails:

<pre class="terminal">
$ grails prod war
</pre>

## <a id='deploy'></a> Deploy ##

How you deploy your `.war` depends on the Cloud Foundry you are targeting. For run.pivotal.io, you can follow the Getting Started document [here](../../getting-started.html).

## <a id='Binding Services'></a> Binding Services ##

There are three ways of binding services in JVM based languages.

| Binding Strategy		| Description    		| 
| :------------------- 	|:--------------------	| 
| Auto-Reconfiguration	|  For databases only. Cloud Foundry creates a service connection for you.				| 
| `cfruntime`     		| Creates an object with the location and settings of your services. Set your service connections based on the values in that object.    		| 
| ** Manual **      	| Use Cloud Foundry Environment Variables to set your service connections. |

How you employe these strategies depends on the framework you are using.

* [Lift Service Bindings](../services/lift-service-bindings.html)
* [Grails Service Bindings](../services/grails-service-bindings.html)
* [Spring Service Bindings](../services/spring-service-bindings.html)


