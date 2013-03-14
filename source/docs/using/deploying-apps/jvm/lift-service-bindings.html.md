---
title: Lift - Service Bindings
---

## <a id='intro'></a>Introduction ##

This guide shows how to adapt the standard example lift application to use a bound service on Cloud Foundry.

## <a id='drivers'></a>Drivers ##

First, add the appropriate drivers to the project. Add the MySQL dependency via Maven in the pom.xml file;

~~~xml

<dependencies>
    
  <dependency>
    <groupId>mysql</groupId>
    <artifactId>mysql-connector-java</artifactId>
    <version>5.1.6</version>
  </dependency>

  ...

</dependencies>
~~~

## <a id='default-properties'></a>Default properties ##

Edit ./src/main/resources/props/default.props and add the configuration for a local instance of MySQL, the configuration below is for a development instance of MySQL where for localhost, the root password is not set. 

~~~
db.class=com.mysql.jdbc.Driver
db.url=jdbc:mysql://localhost/lift_hello_world?user=root
~~~

Test the configuration by having maven clean the project and then run Jetty;

<pre class="terminal">
$ mvn clean jetty:run
</pre>

The application should be available at http://127.0.0.1:8080/

## <a id='auto'></a>Deployment using automatic service configuration ##

Use maven to create a web archive release of the application;

<pre class="terminal">
$ mvn package
</pre>

This creates a file in the target folder, in this example, the file is called lift\_hello\_world-1.0.war. Deploy it to Cloud Foundry using the path option to point to the archive file, remembering to create a MySQL service for the application;

<pre class="terminal">
$ vmc push lift-hello-world --path=./target/lift_hello_world-1.0.war
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

Create services for application?> y

1: blob 0.51
2: mongodb 2.0
3: mysql 5.1
4: postgresql 9.0
5: rabbitmq 2.4
6: redis 2.2
7: redis 2.4
8: redis 2.6
What kind?> 3

Name?> mysql-ed53e

Creating service mysql-ed53e... OK
Binding mysql-ed53e to lift-hello-world... OK
Create another service?> n

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

## <a id='manual'></a>Deployment using manual service configuration ##

To manually configure the database connection using a bound service in Scala, a few more dependencies need to be added to the project, add the following to the repositories node of pom.xml

~~~xml
  <repository>
    <id>springsource-milestones</id>
    <name>SpringSource Milestones Proxy</name>
    <url>https://oss.sonatype.org/content/repositories/springsource-milestones</url>
  </repository>
    
  <repository>
    <id>org.springframework.maven.milestone</id>
    <name>Spring Framework Maven Milestone Repository</name>
    <url>http://maven.springframework.org/milestone</url>
  </repository>
~~~

Add the following dependencies to the dependencies node;

~~~xml
  <dependency>
    <groupId>spring</groupId>
    <artifactId>spring-core</artifactId>
    <version>1.0.2</version>
  </dependency>

  <dependency>
    <groupId>org.cloudfoundry</groupId>
    <artifactId>cloudfoundry-runtime</artifactId>
    <version>${org.cloudfoundry-version}</version>
  </dependency>
~~~

Note the org.cloudfoundry-version property in the last dependency, this needs to be added to the project/properties node;

~~~xml
<properties>
  ...
  <org.cloudfoundry-version>0.8.2</org.cloudfoundry-version>
</properties>
~~~

Now set the Connection Manager in ./src/main/scala/bootstrap/liftweb/Boot.scala, import the following namespaces first.

~~~scala
  import org.cloudfoundry.runtime.env._
  import org.cloudfoundry.runtime.service.relational._
  import scala.collection.JavaConversions._
~~~

Then replace the existing code at the start of the boot method with the following. This will use the cloudfoundry-runtime library to find the correct service using the set name at the start of the code and then create and set the connection manager for the project.

~~~scala
  val serviceName = "lift-db"
  val service = new CloudEnvironment().getServices().toList.find { service => service.get("name") == serviceName }
  val creds = service.get("credentials").asInstanceOf[java.util.LinkedHashMap[String, Object]]

  val password = Box[String](creds.get("password").toString)
  val username = Box[String](creds.get("username").toString)
  val url = "jdbc:mysql://" + creds.get("host") + ":" + creds.get("port") + "/" + creds.get("name")
  val driver = "com.mysql.jdbc.Driver"

  val vendor = new StandardDBVendor(driver, url, username, password)

  LiftRules.unloadHooks.append(vendor.closeAllConnections_! _)
  DB.defineConnectionManager(DefaultConnectionIdentifier, vendor)
~~~

Re-package the application

<pre class="terminal">
$ mvn clean package
</pre>

Then push back to Cloud Foundry

<pre class="terminal">
$ vmc push lift-hello-world --path=./target/lift_hello_world-1.0.war
</pre>