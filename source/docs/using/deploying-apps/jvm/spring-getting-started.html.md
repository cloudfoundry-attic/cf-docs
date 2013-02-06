---
title: Spring - Getting started
---

### Quick links ###
* [Introduction](#intro)
* [Prerequisites](#prerequisites)
* [Packaging a Sample Project](#sample-project)
* [Deploying Your Application](#deploying)
* [Next Steps - Binding services](#next-steps)

## <a id='intro'></a>Introduction ##

This guide explains how to deploy a simple Java application using Spring Framework to Cloud Foundry. It assumes a basic knowledge and understanding of Spring Framework. For help getting started with Spring Framework, see the [Spring Framework web site](http://www.springsource.org/get-started).

## <a id='prerequisites'></a>Prerequisites ##

* A Cloud Foundry account, you can sign up [here](https://my.cloudfoundry.com/signup)
* The [vmc](../../managing-apps/vmc) command-line tool 
* The [Maven](http://maven.apache.org/) build tool
* The [Git](http://git-scm.com/downloads) command-line tool

There are other options for building, packaging, and managing applications in Cloud Foundry. See the [Managing Apps](../../managing-apps/) section to see the full list of options. 

## <a id='sample-project'></a>Packaging a Sample Project ##

The [Cloud Foundry Samples](https://github.com/cloudfoundry-samples) repository on GitHub contains a simple Spring Framework [sample application](https://github.com/cloudfoundry-samples/springmvc-hibernate-template). The following steps will show how to download, build, and package this sample application for deploying to Cloud Foundry. 

First, download a copy of the code for the application by cloning the GitHub repository using the `git` command-line tool:

<pre class="terminal">
$ git clone https://github.com/cloudfoundry-samples/springmvc-hibernate-template
$ cd springmvc-hibernate-template
</pre>

A Spring application is typically packaged as a `.war` file for deployment to Cloud Foundry. If an application can be packaged as a `.war` file and deployed to Apache Tomcat, then it should also run on Cloud Foundry without changes (provided it uses Cloud Foundry database and services - more on that [later](./spring-service-bindings.html)). For this sample, Maven will be used to build and package the application to a `.war` file:

<pre class="terminal">
$ mvn package
</pre>

After this step, there should be a `springmvc31-1.0.0.war` file in the `target` directory. 

## <a id='deploying'></a>Deploying Your Application ##

With vmc, target your desired Cloud Foundry instance and login:

<pre class="terminal">
$ vmc target api.cloudfoundry.com
Setting target to https://api.cloudfoundry.com... OK

$ vmc login
target: https://api.cloudfoundry.com

Email> *********
Password> *******

Authenticating... OK
</pre>

Then use vmc to push the application, providing answers to the prompts as shown below (note that you must use a name other than "springmvc31" in the `vmc push` command, since that application name has already been used on cloudfoundry.com):

<pre class="terminal">
$ vmc push springmvc31 --path target/springmvc31-1.0.0.war
Instances> 1

1: spring
2: other
Framework> spring

1: java
2: java7
3: other
Runtime> 2

1: 64M
2: 128M
3: 256M
4: 512M
5: 1G
Memory Limit> 512M

Creating springmvc31... OK

1: springmvc31.cloudfoundry.com
2: none
URL> springmvc31.cloudfoundry.com

Updating springmvc31... OK

Create services for application?> y

1: blob 0.51
2: mongodb 2.0
3: mysql 5.1
4: postgresql 9.0
5: rabbitmq 2.4
6: redis 2.6
7: redis 2.4
8: redis 2.2
What kind?> 4

Name?> spring-postgres 

Creating service spring-postgres... OK
Binding spring-postgres to springmvc31... OK
Create another service?> y

1: blob 0.51
2: mongodb 2.0
3: mysql 5.1
4: postgresql 9.0
5: rabbitmq 2.4
6: redis 2.4
7: redis 2.2
8: redis 2.6
What kind?> 8

Name?> spring-redis

Creating service spring-redis... OK
Binding spring-redis to springmvc31... OK
Create another service?> n

Bind other services to application?> n

Save configuration?> y

Saving to manifest.yml... OK
Uploading springmvc31... OK
Using manifest file manifest.yml

Starting springmvc31... OK
Checking springmvc31... OK
</pre>

After the application is pushed successfully, it should be available to view at the URL specified when performing the push.

## <a id='next-steps'></a>Binding a Service ##

For more information on binding to services, see [Spring - Service Bindings](./spring-service-bindings.html).
