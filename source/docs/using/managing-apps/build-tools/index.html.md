---
title: Build Tool Integration
---

It is possible to deploy application using a couple of different JVM build tools - Maven and Gradle.

> **The Gradle and Maven plugins will be updated in the coming weeks to support Cloud Foundry v2, including support for organizations, spaces, and custom buildpacks.**

## <a id='gradle'></a>Gradle ##

Gradle is a build tool that automates the building, testing, publishing, and deployment of software packages, generated static websites, generated documentation, and more.

The gradle-cf-plugin adds Cloud Foundry-oriented tasks to a Gradle project. 

### <a id="gradle-install"></a> Install the plugin ###

An example Gradle project with the Cloud Foundry plugin installed looks something like this (build.gradle):

~~~

buildscript {
  repositories {
    mavenCentral()
    maven { url "http://repo.springsource.org/libs-milestone-s3-cache" }
  }
  dependencies {
    classpath group: 'org.gradle.api.plugins', name: 'gradle-cf-plugin', version: '0.2.0'
  }
}

apply plugin: 'cloudfoundry'

cloudfoundry {
  username = 'jondoe@gmail.com'
  password = 'mypassword'
  application = 'test_grails_app'
  framework = 'grails'
  file = new File('/path/to/app.war')
  uris = ['http://grails-test.cloudfoundry.com']
}

~~~

After you add the plugin, running the tasks command should include the following output:

<pre class="terminal">

$ gradle tasks
:tasks

------------------------------------------------------------
All tasks runnable from root project
------------------------------------------------------------

CloudFoundry tasks
------------------
cf-add-service - Creates a service, optionally bound to an application
cf-add-user - Registers a new user
cf-apps - Lists applications on the cloud
cf-bind - Binds a service to an application
cf-delete-app - Deletes an application from the cloud
cf-delete-service - Deletes a service from the cloud
cf-delete-user - Deletes a user account. Uses the current credentials!
cf-info - Displays information about the target CloudFoundry platform
cf-login - Logs in then out to verify credentials
cf-push - Pushes an application to the cloud
cf-restart - Starts an application
cf-start - Starts an application
cf-status - Returns information about an application deployed on the cloud
cf-stop - Stops an application
cf-unbind - Unbinds a service from an application
cf-update - Updates an application which is already deployed

Help tasks
----------
dependencies - Displays all dependencies declared in root project 'hello-world'.
dependencyInsight - Displays the insight into a specific dependency in root project 'hello-world'.
help - Displays a help message
projects - Displays the sub-projects of root project 'hello-world'.
properties - Displays the properties of root project 'hello-world'.
tasks - Displays the tasks runnable from root project 'hello-world' (some of the displayed tasks may belong to subprojects).

To see all tasks and more detail, run with --all.

BUILD SUCCESSFUL

Total time: 2.543 secs
</pre>

From this point it should be possible to carry out most tasks available as part of cf from within Gradle. For more information on configuration options within Gradle, take a look at the gradle-cf-plugin project on Github - https://github.com/melix/gradle-cf-plugin.

## <a id='maven'></a>Maven ##


Using the cf-maven-plugin plugin, you can deploy an application directly from Maven. This is useful as it means being able to store the Cloud Foundry application manifest in pom.xml.

### <a id='maven-install'></a>Install the Plugin ###

Add the following to the `plugins` node of your `pom.xml`:

~~~xml
<plugin>
  <groupId>org.cloudfoundry</groupId>
  <artifactId>cf-maven-plugin</artifactId>
  <version>1.0.0.M4</version>
  <configuration>
      <server>mycloudfoundry-instance</server>
      <target>http://api.cloudfoundry.com</target>
      <url>hello-java-maven.cloudfoundry.com</url>
      <framework>lift</framework>
      <memory>256</memory>
  </configuration>
</plugin>
~~~

Set the server name, the target address of the Cloud Foundry server, the intended url of the application and memory allocation.

Add the following to the pluginRepositories node:

~~~xml
<pluginRepository>
    <id>repository.springframework.maven.milestone</id>
    <name>Spring Framework Maven Milestone Repository</name>
    <url>http://maven.springframework.org/milestone</url>
</pluginRepository>
~~~

Create a file in ~/.m2/settings.xml or if the file exists, edit and add:

~~~xml

<settings>
    ...
    <servers>
        ...
        <server>
          <id>mycloudfoundry-instance</id>
          <username>demo.user@vmware.com</username>
          <password>s3cr3t</password>
        </server>
    </servers>
    ...
</settings>
~~~

Set the server/id node to correspond to the server name set in the pom.xml file and also set the username and password for the desired account.

Then use Maven to package and deploy.

<pre class="terminal">
$ mvn clean package
$ mvn cf:push
</pre>

