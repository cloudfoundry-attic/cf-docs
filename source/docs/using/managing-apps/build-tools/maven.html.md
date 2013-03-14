---
title: Maven
---

## <a id='intro'></a>Introduction ##

Using the "cf-maven-plugin" plugin, it's possible to deploy an application directly from Maven. This is useful as it means being able to store the Cloud Foundry application manifest in pom.xml.

## <a id='install-the-plugin'></a>Install the plugin ##

Add the following to the plugins node of pom.xml;

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

Add the following to the pluginRepositories node;

~~~xml
<pluginRepository>
    <id>repository.springframework.maven.milestone</id>
    <name>Spring Framework Maven Milestone Repository</name>
    <url>http://maven.springframework.org/milestone</url>
</pluginRepository>
~~~

Create a file at ~/.m2/settings.xml or if the file exists, edit and add;

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

Then use maven to package and deploy!

<pre class="terminal">
$ mvn clean package
$ mvn cf:push
</pre>

