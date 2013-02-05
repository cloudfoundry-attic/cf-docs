---
title: Play, Getting Started
---

### Quick links ###
* [Introduction](#intro)
* [Prerequisites](#prerequisites)
* [Creating a Sample Project](#sample-project)
* [Deploying Your Application](#deploying)
* [Next Steps - Binding a service](#next-steps)

## <a id='intro'></a>Introduction ##

Cloud Foundry supports Play 2.0 as a first-class framework. Play is a lightweight, stateless, web-friendly framework for Java and Scala. Developers can leverage this event-driven non-blocking IO architecture to build highly scalable applications. This guide explains how to get a Play 2.0 application up and running on Cloud Foundry.

## <a id='prerequesites'></a>Prerequesites ##

To complete this quickstart guide, you need to fulfill the following prerequisites;

* A Cloud Foundry account, you can sign up [here](https://my.cloudfoundry.com/signup)
* [Java JDK >= 6](http://www.oracle.com/technetwork/java/javase/downloads/jdk7-downloads-1880260.html)
* [Play 2.0](http://www.playframework.org/download)
* The [VMC](../../managing-apps/) command line tool 

## <a id='sample-project'></a>Creating a Sample Project ##

Start off by creating a new Play application;

<pre class="terminal">
$ play new hello-world
       _            _ 
 _ __ | | __ _ _  _| |
| '_ \| |/ _' | || |_|
|  __/|_|\____|\__ (_)
|_|            |__/ 
             
play! 2.0.2, http://www.playframework.org

The new application will be created in /Users/danhigham/Projects/play/hello-world

What is the application name? 
> hello-world

Which template do you want to use for this new application? 

  1 - Create a simple Scala application
  2 - Create a simple Java application
  3 - Create an empty project

> 1

OK, application hello-world is created.

Have fun!
</pre>

Select the "Create a simple application" option for whichever language you prefer, Scala or Java.

To test the application localy, start the local development server by calling the Play run command;

<pre class="terminal">
$ play run
</pre>

Browse to [http://localhost:9000](http://localhost:9000) to view the applications index action on the Application controller.

## <a id='deploying'></a>Deploying Your Application ##

Deploying to Cloud Foundry is straight forward, but as Play uses the Java runtime, a compiled version of the application is need for deployment. Compile the application in to a distributable binary using the 'dist' command, like so;

<pre class="terminal">
$ play redist
[info] Loading project definition from /Users/danhigham/Projects/play/hello-world/project
[info] Set current project to hello-world (in build file:/Users/danhigham/Projects/play/hello-world/)
[info] Updating {file:/Users/danhigham/Projects/play/hello-world/}hello-world...
[info] Done updating.                                                                  
[info] Compiling 6 Scala sources and 1 Java source to /Users/danhigham/Projects/play/hello-world/target/scala-2.9.1/classes...
[info] Packaging /Users/danhigham/Projects/play/hello-world/target/scala-2.9.1/hello-world_2.9.1-1.0-SNAPSHOT.jar ...
[info] Done packaging.

Your application is ready in /Users/danhigham/Projects/play/hello-world/dist/hello-world-1.0-SNAPSHOT.zip

[success] Total time: 12 s, completed Feb 4, 2013 2:39:26 PM
</pre>

Note the penultimate line, specifying the location of distributable zip file. Making sure you are logged in to CloudFoundry, you can deploy, specifying the path of the zip using the 'path' option.

<pre class="terminal">
$ vmc push --path=/Users/danhigham/Projects/play/hello-world/dist/hello-world-1.0-SNAPSHOT.zip
Name> play-hello-world

Instances> 1

1: play
2: other
Framework> play

1: java
2: java7
3: other
Runtime> 2

1: 64M
2: 128M
3: 256M
4: 512M
5: 1G
6: 2G
7: 4G
8: 8G
9: 16G
Memory Limit> 256M

Creating play-hello-world... OK

1: play-hello-world.cloudfoundry.com
2: none
URL> play-hello-world.cloudfoundry.com

Updating play-hello-world... OK

Create services for application?> n

Bind other services to application?> n

Save configuration?> n

Uploading play-hello-world... OK
Starting play-hello-world... OK
Checking play-hello-world... OK
</pre>

If all goes well, you application should be available at the url you specified during the push.

## <a id='next-steps'></a>Next steps - Binding a service ##

Binding and using a service with Play 2.0 is covered [here](./play-service-bindings.html)