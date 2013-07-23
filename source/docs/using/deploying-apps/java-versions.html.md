---
title: Java Buildpack Software Versions 
---

This page lists:

* The software installed by the Cloud Foundry Java buildpack when appropriate.
* Versions of each software resource that are available from the buildpack.
* The version of each software resource that is installed by default. See https://github.com/cloudfoundry/java-buildpack/blob/master/docs/util-repositories.md#version-wildcards for an explanation of the format used to indicate the version in hte "Installed by Default" column. 
* How to change the buildpack to install a different version of a software resource.

 This page was last updated on July 23, 2013

|Resource |Available Versions |Installed by Default| How to Change |
| --------- | --------- | --------- |--------- |
|OpenJDK | 1.6, 1.7, and 1.8 |1.7.0_+ |Fork the buildpack and edit the `version` property in `config/openjdk.yml`. |
|Groovy |1.5.0 - 2.1.6 |2.1.+ |Fork the buildpack and edit the `version` property in `config/groovy.yml`. |
|Tomcat |6.0.0 - 7.0.42 |7.0.+ |Fork the buildpack and edit the `version` property in `config/tomcat.yml`. |
|Play |Play is compiled into the application |n/a |Install a different version of Play and recompile the application.|
|Auto-reconfiguration JAR for Spring auto-reconfiguration (Note: This is the same JAR as for Play auto-reconfiguration) |0.6.8 - 0.7.1 |0.+ |Fork the buildpack and edit the `version` property in `config/playautoreconfiguration.yml`  |
|Auto-reconfiguration JAR for Play auto-reconfiguration (NB. this is the same JAR as for Spring auto-reconfiguration) |0.6.8 - 0.7.1 | 0.+|Fork the buildpack and edit the `version` property in `config/playautoreconfiguration.yml` |

