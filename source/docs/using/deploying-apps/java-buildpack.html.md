---
title: About the Java Buildpack  
---
## <a id='design-doc'></a>Java Buildpack Documentation ##

For information about using, configuring, and extending the Cloud Foundry Java buildpack, see https://github.com/cloudfoundry/java-buildpack.

For information about the software installed by the Java buildpack, see the following section.

## <a id='software-versions'></a>Software Installed by the Java Buildpack ##

The table below lists:

* **Resource** --- The software installed by the Cloud Foundry Java buildpack, when appropriate.
* **Available Versions** --- The versions of each software resource that are available from the buildpack.
* **Installed by Default** --- The version of each software resource that is installed by default. See https://github.com/cloudfoundry/java-buildpack/blob/master/docs/util-repositories.md#version-wildcards for an explanation of the format used to indicate the version in hte "Installed by Default" column. 
* **To Install a Different Version** --- How to change the buildpack to install a different version of a software resource.

 This page was last updated on July 23, 2013

|Resource |Available Versions |Installed by Default| To Install a Different Version |
| --------- | --------- | --------- |--------- |
|OpenJDK | 1.6, 1.7, and 1.8 |1.7.0_+ |Fork the buildpack and edit the `version` property in `config/openjdk.yml`. |
|Groovy |1.5.0 - 2.1.6 |2.1.+ |Fork the buildpack and edit the `version` property in `config/groovy.yml`. |
|Tomcat |6.0.0 - 7.0.42 |7.0.+ |Fork the buildpack and edit the `version` property in `config/tomcat.yml`. |
|Play |Play is compiled into the application |n/a |Install a different version of Play and recompile the application.|
|Auto-configuration JAR for Spring auto-configuration (Note: This is the same JAR as for Play auto-configuration) |0.6.8 - 0.7.1 |0.+ |Fork the buildpack and edit the `version` property in `config/playautoreconfiguration.yml`  |
|Auto-configuration JAR for Play auto-configuration (NB. this is the same JAR as for Spring auto-configuration) |0.6.8 - 0.7.1 | 0.+|Fork the buildpack and edit the `version` property in `config/playautoreconfiguration.yml` |

