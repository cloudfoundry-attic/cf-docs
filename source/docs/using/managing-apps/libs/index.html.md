---
title: API and Libraries
---

Cloud Foundry's Cloud Controller component implements a REST API for querying and managing a Cloud Foundry environment. The full REST API is documented in the [reference section](/docs/reference/cc-api.html) of this site.

There are libraries available that provide language-specific bindings to the Cloud Controller REST API.

* Java client library (vcap-java-client)

* Ruby gem (cfoundry)

  CFoundry is the same library that is used to provide cf with it's interface to a Cloud Foundry instance. See the [RubyDoc](http://rubydoc.info/gems/cfoundry) page for a full API breakdown. For an introduction to using this library to manage applications on Cloud Foundry see [Using the CFoundry Ruby Gem to manage applications](./ruby-cfoundry.html)

* Node.js module (cf-runtime)
    * see http://blog.cloudfoundry.com/2012/08/21/new-runtime-module-for-node-js-applications/

