---
title: Spring - Getting started
---

### Quick links ###
* [Introduction](#intro)
* [Prerequisites](#prerequisites)
* [Packaging a Sample Project](#sample-project)
* [Deploying Your Application](#deploying)
* [Next Steps - Binding services](#next-steps)

## <a id='intro'></a>Introduction ##

This guide explains how to deploy a Java application using Spring Framework to Cloud Foundry. It assumes a basic knowledge and understanding of Spring Framework. For help getting started with Spring Framework, see the [Spring Framework web site](http://www.springsource.org/get-started).

## <a id='prerequisites'></a>Prerequisites ##

* A Cloud Foundry account, you can sign up [here](https://my.cloudfoundry.com/signup)
* One of the following tools for deploying an application to Cloud Foundry:
    * The [vmc](../../managing-apps/vmc) command-line tool 
    * [Spring Tool Suite](../../managing-apps/sts)
    * A build tool with a [Cloud Foundry plugin](../../managing-apps/build-tools)

This guide will use the vmc command-line tool in all examples. 

## <a id='sample-project'></a>Packaging a Sample Project ##

A Spring application is typically packaged as a `.war` file for deployment to Cloud Foundry. If an application can be packaged as a `.war` file and deployed to Apache Tomcat, then it should also run on Cloud Foundry without changes (provided it uses Cloud Foundry database and services - more on that [later](./spring-service-bindings.html)). 

*find an example of a Spring app, describe checking out, building, and packaging*

## <a id='deploying'></a>Deploying Your Application ##

## <a id='next-steps'></a>Binding a Service ##

For more information on binding to services, see [Spring - Service Bindings](./spring-service-bindings.html).
