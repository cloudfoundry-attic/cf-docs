---
title: Lift - Getting started
---

## <a id='intro'></a>Introduction ##

This guide illustrates how to create a lift application and deploy it to Cloud Foundry. This guide assumes Java 6 or 7 and Maven are already installed and working.

## <a id='intro'></a>Create a test application ##

Create a test project with maven;

<pre class="terminal">

$ mvn archetype:generate \
  -DarchetypeGroupId=net.liftweb \
  -DarchetypeArtifactId=lift-archetype-basic_2.9.1 \
  -DarchetypeVersion=2.4-M5 \
  -DarchetypeRepository=http://scala-tools.org/repo-snapshots \
  -DremoteRepositories=http://scala-tools.org/repo-snapshots \
  -DgroupId=com.company \
  -DartifactId=lift_hello_world \
  -Dversion=1.0
</pre>

Maven should download any dependencies and create a Lift application. The application can be tested localy by having Maven clean the build and start Jetty.

<pre class="terminal">
$ cd lift_hello_world
$ mvn clean jetty:run
[INFO] Scanning for projects...
[INFO]
[INFO] ------------------------------------------------------------------------
[INFO] Building lift_hello_world Project 1.0
[INFO] ------------------------------------------------------------------------
[INFO]
[INFO] --- maven-clean-plugin:2.4.1:clean (default-clean) @ lift_hello_world ---
[INFO]
[INFO] >>> maven-jetty-plugin:6.1.25:run (default-cli) @ lift_hello_world >>>
[INFO]
[INFO] --- maven-resources-plugin:2.5:resources (default-resources) @ lift_hello_world ---

...

15:54:37.000 [main] INFO  net.liftweb.mapper.Schemifier - ALTER TABLE users ADD CONSTRAINT users_PK PRIMARY KEY(id)
15:54:37.068 [main] INFO  net.liftweb.mapper.Schemifier - CREATE INDEX users_email ON users ( email )
15:54:37.071 [main] INFO  net.liftweb.mapper.Schemifier - CREATE INDEX users_uniqueid ON users ( uniqueid )
15:54:37.072 [main] DEBUG net.liftweb.mapper.Schemifier - Executing DDL statements
15:54:37.073 [main] DEBUG net.liftweb.mapper.Schemifier - Running afterSchemifier on table users
15:54:37.074 [main] DEBUG net.liftweb.db.ProtoDBVendor - Released connection. poolSize=1
2013-03-12 15:54:37.153:INFO::Started SelectChannelConnector@0.0.0.0:8080
[INFO] Started Jetty Server
[INFO] Starting scanner at interval of 5 seconds.
</pre>

The application should be available at http://127.0.0.1:8080

## <a id='intro'></a>Deploying to Cloud Foundry ##

Deploying is as simple as creating a web archive with Maven and pushing the output with CF;

<pre class="terminal">
$ mvn package
$ cf push --path=./target/lift_hello_world-1.0.war
Name> lift-hello-world

Instances> 1

1: lift
2: other
Framework> lift

1: java
2: java7
3: other
Runtime> 1

1: 64M
2: 128M
3: 256M
4: 512M
5: 1G
6: 2G
7: 4G
8: 8G
9: 16G
Memory Limit> 512M

Creating lift-hello-world... OK

1: lift-hello-world.cloudfoundry.com
2: none
Domain> lift-hello-world.cloudfoundry.com

Updating lift-hello-world... OK

Create services for application?> n

Bind other services to application?> n

Save configuration?> n

Uploading lift-hello-world... OK
Starting lift-hello-world... OK
Checking lift-hello-world...
  0/1 instances: 1 starting
  0/1 instances: 1 starting
  0/1 instances: 1 starting
  1/1 instances: 1 running
OK
</pre>

In this example, the application was deployed to http://lift-hello-world.cloudfoundry.com

