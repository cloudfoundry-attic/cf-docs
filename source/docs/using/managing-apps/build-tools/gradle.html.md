---
title: Gradle
---

## <a id="intro"></a> Introduction ##

Gradle is a build tool, that can "automate the building, testing, publishing, deployment and more of software packages or other types of projects such as generated static websites, generated documentation or indeed anything else."

There is a plugin that adds Cloud Foundry oriented tasks to a gradle project, called "gradle-cf-plugin".

## <a id="intro"></a> Adding the plugin ##

An example Gradle project with the Cloud Foundry plugin installed looks something like this (build.gradle);

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

After adding the plugin, running the tasks command should include the following output;

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

From this point it should be possible to carry out most tasks available as part of vmc from within Gradle. For more information on configuration options within Gradle, take a look at the gradle-cf-plugin project on Github - https://github.com/melix/gradle-cf-plugin