---
title: Deploy Grails, Groovy, Java, Play Framework, Spring Boot, and Servlet Applications
---
Cloud Foundry can deploy a number of different JVM-based artifact types.  For a more detailed explaination of what it supports, please see the [Java Buildpack documentation][d].  For more details about using Cloud Foundry see the [Getting Started Guide][a].

## <a id='grails'></a>Grails ##
Grails packages applications into WAR files for deployment into a Servlet container.  To build the WAR file and deploy it, run the following:

<pre class="terminal">
$ grails prod war
$ cf push <application-name> --path target/&lt;application-name&gt;-&lt;application-version&gt;.war
</pre>


## <a id='groovy'></a>Groovy ##
Groovy applications based on both [Ratpack][r] and a simple collection of files are supported.

### <a id='grails'></a>Ratpack ###
Ratpack packages applications into two different styles; Cloud Foundry supports the `distZip` style.  To build the ZIP and deploy it, run the following:

<pre class="terminal">
$ gradle distZip
$ cf push <application-name> --path build/distributions/&lt;application-name&gt;.zip
</pre>

### <a id='raw-groovy'></a>Raw Groovy ###
Groovy applications that are made up of a [single entry point][g] plus any supporting files can be run without any other work.  To deploy them, run the following:

<pre class="terminal">
$ cf push <application-name>
</pre>

## <a id='java-main'></a>Java Main ##
Java applications with a `main()` method can be run provided that they are packaged as [self-executable JARs][j].

### <a id='java-main-maven'></a>Maven ###
A Maven build can create a self-exectuable JAR.  To build and deploy the JAR, run the following:

<pre class="terminal">
$ mvn package
$ cf push <application-name> --path target/&lt;application-name&gt;-&lt;application-version&gt;.jar
</pre>

### <a id='java-main-gradle'></a>Gradle ###
A Gradle build can create a self-exectuable JAR.  To build and deploy the JAR, run the following:

<pre class="terminal">
$ gradle build
$ cf push <application-name> --path build/libs/&lt;application-name&gt;-&lt;application-version&gt;.jar
</pre>

## <a id='play-framework'></a>Play Framework ##
The [Play Framework][p] packages applications into two differenty styles; Cloud Foundry supports both the `staged` and `dist` styles.  To build the `dist` style and deploy it, run the following:

<pre class="terminal">
$ play dist
$ cf push <application-name> --path target/universal/&lt;application-name&gt;-&lt;application-version&gt.zip
</pre>

## <a id='spring-boot-cli'></a>Spring Boot CLI ##
[Spring Boot][s] can run applications [comprised entirely of POGOs][b].  To deploy then, run the following:

<pre class="terminal">
$ spring grab *.groovy
$ cf push <application-name>
</pre>

## <a id='servlet'></a>Servlet ##
Java applications can be packaged as Servlet applications.

### <a id='servlet-maven'></a>Maven ###
A Maven build can create a Servlet WAR.  To build and deploy the WAR, run the following:

<pre class="terminal">
$ mvn package
$ cf push <application-name> --path target/&lt;application-name&gt;-&lt;application-version&gt;.war
</pre>

### <a id='servlet-gradle'></a>Gradle ###
A Gradle build can create a Servlet WAR.  To build and deploy the JAR, run the following:

<pre class="terminal">
$ gradle build
$ cf push <application-name> --path build/libs/&lt;application-name&gt;-&lt;application-version&gt;.war
</pre>

## <a id='services'></a>Binding to Services ##
Information about binding apps to services can be found on the following pages:

* [Service Bindings for Grails Applications](/docs/using/services/grails-service-bindings.html)
* [Service Bindings for Play Framework Applications](/docs/using/services/play-framework-service-bindings.html)
* [Service Bindings for Spring Applications](/docs/using/services/spring-service-bindings.html)

-----

[a]: ../../../dotcom/getting-started.html
[b]: https://github.com/cloudfoundry/java-buildpack/blob/master/docs/container-spring_boot_cli.md
[d]: https://github.com/cloudfoundry/java-buildpack#additional-documentation
[g]: https://github.com/cloudfoundry/java-buildpack/blob/master/docs/container-groovy.md
[j]: https://github.com/cloudfoundry/java-buildpack/blob/master/docs/container-java_main.md
[p]: http://www.playframework.com
[r]: http://www.ratpack.io
[s]: http://projects.spring.io/spring-boot/
