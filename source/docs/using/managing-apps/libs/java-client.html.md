---
title: Cloud Foundry Java Client Library
---

## <a id='intro'></a>Introduction ##

This is a guide to using the Cloud Foundry Java Client Library to manage an account on a Cloud Foundry instance.

## <a id='getting'></a>Getting the Library ##

The Cloud Foundry Java Client Library is available in Maven Central. The library can be added as a dependency to Maven or Gradle project using the following information. 

### <a id='maven'></a>Maven ###

The `cloudfoundry-client-lib` dependency can be added to your `pom.xml` as follows:

~~~xml
  <dependencies>
    <dependency>
      <groupId>org.cloudfoundry</groupId>
      <artifactId>cloudfoundry-client-lib</artifactId>
      <version>1.0.0</version>
    </dependency>
  </dependencies>
~~~ 

### <a id='gradle'></a>Gradle ###

To use the Java client library in a Gradle project, add the `cloudfoundry-client-lib` dependency to your `build.gradle` file:

~~~groovy
repositories {
  mavenCentral()
}

dependencies {
  compile 'org.cloudfoundry:cloudfoundry-client-lib:1.0.0'
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

For more details on the Cloud Foundry Java Client Library, view the [source on GitHub](https://github.com/cloudfoundry/cf-java-client/tree/master/cloudfoundry-client-lib). The [domain package](https://github.com/cloudfoundry/cf-java-client/tree/master/cloudfoundry-client-lib/src/main/java/org/cloudfoundry/client/lib/domain) shows the objects that can be queried and inspected.  

The source for the [Cloud Foundry Maven plugin](https://github.com/cloudfoundry/cf-java-client/tree/master/cloudfoundry-maven-plugin) is also a good example of using the Java client library. 
