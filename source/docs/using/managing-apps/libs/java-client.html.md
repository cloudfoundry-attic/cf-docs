---
title: Java Cloud Foundry Client
---

## <a id='intro'></a>Introduction ##

This is a guide to using the Java Cloud Foundry client library to manage an account on a Cloud Foundry instance.

## <a id='getting'></a>Getting the Library ##

The Java Cloud Foundry library is available in the Spring Framework milestone repository. The library can be added as a dependency to Maven or Gradle project using the following information. 

### <a id='maven'></a>Maven ###

To use the Java client in a Maven project, you first need to add the Spring Framework milestone repository to your `pom.xml` file. Add the repository in a `<repository>` section like this: 

~~~xml
  <repositories>
    <repository>
      <id>repository.springframework.milestone</id>
      <name>Spring Framework Milestone Repository</name>
      <url>http://repo.springsource.org/milestone</url>
    </repository>
  </repositories>
~~~

After adding the repository, the dependency can be added to your `pom.xml` as follows:

~~~xml
  <dependencies>
    <dependency>
      <groupId>org.cloudfoundry</groupId>
      <artifactId>cloudfoundry-client-lib</artifactId>
      <version>0.8.5</version>
    </dependency>
  </dependencies>
~~~ 

### <a id='gradle'></a>Gradle ###

To use the Java client in a Gradle project, add the Spring Framework milestone repository to your `build.gradle` file, along with the dependency, like this: 

~~~groovy
repositories {
  mavenCentral()
  mavenRepo url:'http://repo.springframework.org/milestone/'
}

dependencies {
  compile 'org.cloudfoundry:cloudfoundry-client-lib:0.8.4'
} 
~~~

## <a id='sample'></a>Sample Code ##

The following is a very simple sample application that connects to a Cloud Foundry instance, logs in, and displays some information about the Cloud Foundry account. When running the program, provide the Cloud Foundry target (i.e. http://api.run.pivotal.io) along with a valid user name and password as command-line parameters. 

~~~java 
package org.cloudfoundry.sample;

import org.cloudfoundry.client.lib.CloudCredentials;
import org.cloudfoundry.client.lib.CloudFoundryClient;
import org.cloudfoundry.client.lib.domain.CloudApplication;
import org.cloudfoundry.client.lib.domain.CloudService;

import java.net.URI;
import java.net.URL;

public class JavaSample {
    public static void main(String[] args) {
        String target = args[0];
        String user = args[1];
        String password = args[2];

        CloudCredentials credentials = new CloudCredentials(user, password);
        CloudFoundryClient client = new CloudFoundryClient(credentials, getTargetURL(target));
        client.login();
        
        System.out.println("\nSpaces:");
        for (CloudSpace space : client.getSpaces()) {
            System.out.println(space.getName() + ":" + space.getOrganization().getName());
        }

        System.out.println("\nApplications:");
        for (CloudApplication app : client.getApplications()) {
            System.out.println(app.getName());
        }

        System.out.println("\nServices");
        for (CloudService service : client.getServices()) {
            System.out.println(service.getName() + ":" + service.getLabel());
        }
    }

    private static URL getTargetURL(String target) {
        try {
            return new URI(target).toURL();
        } catch (Exception e) {
            System.out.println("The target URL is not valid: " + e.getMessage());
        }
        System.exit(1);
        return null;
    }
}
~~~

For more details on the Java API, view the [source on GitHub](https://github.com/cloudfoundry/vcap-java-client/tree/master/cloudfoundry-client-lib). The [domain package](https://github.com/cloudfoundry/vcap-java-client/tree/master/cloudfoundry-client-lib/src/main/java/org/cloudfoundry/client/lib/domain) shows the objects that can be queried and inspected.  

The source for the [Cloud Foundry Maven plugin](https://github.com/cloudfoundry/vcap-java-client/tree/master/cloudfoundry-maven-plugin) is also a good example of using the Java client library. 
