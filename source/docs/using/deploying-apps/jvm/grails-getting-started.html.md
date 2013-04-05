---
title: Grails - Getting started
---

## <a id='intro'></a>Introduction ##

[Grails](http://grails.org/) is a framework for rapidly developing web applications that can be deployed to any Java servlet container, such as Tomcat. Based on the dynamic language [Groovy](http://groovy.codehaus.org/) and the [Spring Framework](http://www.springsource.org/), it brings the paradigm of Convention over Configuration to the Java platform with the expressiveness of a Java-like dynamic language.

## <a id='prerequisites'></a>Prerequisites ##

To complete this quickstart guide, you need to fulfill the following prerequisites;

* A Cloud Foundry account, you can sign up [here](https://my.cloudfoundry.com/signup)
* [Java JDK](http://www.oracle.com/technetwork/java/javase/downloads/jdk7-downloads-1880260.html) 6 or later
* [Grails](http://grails.org/Installation) 2.2.0 or later
* The [cf](../../managing-apps/cf) command line tool

## <a id='sample-project'></a>Creating a Sample Project ##

First, move to a directory that will contain the sample project. Use the `grails` command to create the project, then move into the new project directory:

<pre class="terminal">
$ grails create-app hello-world
| Created Grails Application at ./hello-world
$ cd hello-world
</pre>

Once in the new project directory, test the app to make sure it compiles and starts locally:

<pre class="terminal">
$ grails run-app
| Compiling 116 source files

| Server running. Browse to http://localhost:8080/hello-world
</pre>

Browse to the provided URL [http://localhost:8080/hello-world](http://localhost:8080/hello-world). You should see some basic information about the application. Press Control-C to stop the application.

## <a id='deploying'></a>Deploying Your Application ##

To prepare the application for deployment to Cloud Foundry, compile and package the application into a war file. The created application includes a database migration plugin, which requires a directory to exist in the project before a war file can be created. Create an empty directory for the migration plugin and then package the app using the `grails war` commmand:

<pre class="terminal">
$ mkdir grails-app/migrations
$ grails prod war
| Done creating WAR target/hello-world-0.1.war
</pre>

After running this command, a war file sould be created at the location shown in the output. Making sure you are logged in to Cloud Foundry, you can deploy the application using the `cf` command and specifying the path to the war file using the `--path` option.

<pre class="terminal">
$ cf push --path=target/hello-world-0.1.war
Name> grails-hello-world

Instances> 1

1: 64M
2: 128M
3: 256M
4: 512M
5: 1G
6: 2G
Memory Limit> 512M

Creating grails-hello-world... OK

1: grails-hello-world.cloudfoundry.com
2: none
URL> grails-hello-world.cloudfoundry.com

Updating grails-hello-world... OK

Create services for application?> n

Save configuration?> n

Uploading grails-hello-world... OK
Starting grails-hello-world... OK
Checking grails-hello-world... OK
</pre>

Note that you will need to provide a different URL than the one in the example, since the URL must be unique on Cloud Foundry. If all goes well, you application should be available at the URL specified during the push.

## <a id='next-steps'></a>Next steps - Binding a service ##

Binding and using a service with Grails is covered [here](./grails-service-bindings.html)

