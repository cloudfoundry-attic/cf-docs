---
title: API and Libraries
---

### REST API ###

Cloud Foundry's Cloud Controller component implements a REST API for querying and managing a Cloud Foundry environment. The full REST API is documented in the [reference section](/docs/reference/cc-api.html) of this site.

There are libraries available that provide language-specific bindings to the Cloud Controller REST API.

### Java client library (vcap-java-client) ###

The vcap-java-client library provides a Java API for interacting with a Cloud Foundry instance. This library is used by the [Cloud Foundry Maven plugin](../build-tools/maven.html), the [Cloud Foundry Gradle plugin](../build-tools/gradle.html), the [Cloud Foundry STS integration](../ide/sts.html), and other Java-based tools. 

For information about using this library, see the [Java Cloud Foundry Library](./java-client.html) page.

### Ruby gem (cfoundry) ###

CFoundry is the same library that is used to provide [cf](/docs/using/managing-apps/cf/index.html) with its interface to a Cloud Foundry instance. See the [RubyDoc](http://rubydoc.info/gems/cfoundry) page for a full API breakdown. 

For an introduction to using this library to manage applications on Cloud Foundry see the [CFoundry Ruby Gem](./ruby-cfoundry.html) page.

