---
title: Key Facts About Application Deployment
---


This page summarizes key Cloud Foundry features and behaviors related to application deployment.

## <a id='push-process'></a>The Cloud Foundry Push Process ##

You initiate the deployment of an application using the Cloud Foundry CLI `cf push` command. In Cloud Foundry documentation, the deployment process is often referred to as “pushing an application”.

When you push an application, Cloud Foundry performs a variety of staging tasks, which at a high level, consist of finding a container to run the application, provisioning the container with the appropriate software and system resources, starting one or more instances of the application, and storing the expected state of the application in the Cloud Controller database.  

The staging process flow is illustrated on [How Applications Are Staged](/docs/running/architecture/how-applications-are-staged.html).


##<a id='buildpacks'></a>Buildpack Support for Runtimes and Frameworks ##

Cloud Foundry stages application using framework and and runtime-specific buildpacks. Heroku developed the buildpack approach, and made it available to the open source community.  Cloud Foundry currently provides buildpacks for the several runtimes and frameworks.  See the links below for run-time specific deployment instructions:

* Ruby --- [Deploy Rack, Rails, or Sinatra Applications](/docs/using/deploying-apps/ruby/index.html)
* Javascript --- [Deploy Node.js Applications](/docs/using/deploying-apps/javascript/index.html)
* Java/JVM --- [Deploy Java, Groovy, or Scala Apps that Use the Spring, Grails, Lift, or Play Frameworks](/docs/using/deploying-apps/jvm/index.html)

Cloud Foundry also supports custom buildpacks as described on [Custom Buildpacks](/docs/using/deploying-apps/buildpacks.html).  Some <a href="https://devcenter.heroku.com/articles/third-party-buildpacks">Heroku third party buildpacks</a>  may work with Cloud Foundry, but your experience may vary.  To use a buildpack that is not built-in to Cloud Foundry, you specify the URL of the buildpack when you push an application, using  the `--buildpack` qualifier.  

If you do not specify a buildpack when you run `cf push`, Cloud Foundry determines which built-in buildpack to use, using the `bin/detect` script of each buildpack.

##<a id='deploy-options'></a>Application Deployment Options ##

The details of how an application is deployed are governed by a set of required and optional deployment attributes. For example, you specify the name of the application, the number of instances to run, and how much memory to allocate to the application.  You can supply deployment options on the command line when you run `cf push`, or in an application manifest file. 

* See the [push](/docs/using/managing-apps/cf/index.html#push) section on "cf Command Line Interface" for information about the `push` command and supplying qualifiers on the command line.
* See the [cf Push and the Manifest](/docs/using/deploying-apps/manifest.html#push-and-manifest) section on "Application Manifests" for information about using an application manifest to supply deployment options.


For general intructions on how to push an application to the Pivotal CF hosted service, see [Getting Started](/docs/dotcom/getting-started.html).

##<a id='start-command'></a>The Application Start Command ##

There are three ways that Cloud Foundry can obtain the command to use to start an application; they are listed below in order of precedence.

1. The value supplied with the `--command` qualifer (or in the application’s `manifest.yml` file). For example, `cf push --command java myapp`.
1. The value of the `web` key in the procfile, for the application, if it exists. A procfile is a text file named `Procfile`, in the root directory of your application, that lists the process types in an application, and associated start commands. For example, `web: YourStartCommand`
1. The start command (if specified) for the “web” process type, in `default_process_types` section of the output from the buildpack's `bin/release` script.


## <a id='services'></a>Using Services ##

An application running on a Cloud Foundry instance can use services that the instance is configured to provision. Such built-in services vary for different Cloud Foundry instances.  

The Pivotal CF hosted instance provides a variety of ready-to-provision services, including several databases, email, and Redis, among others.  For information about services available to applications running on the Pivotal CF hosted instance, see [Services Marketplace](/docs/dotcom/marketplace/services/).  

To use a built-in service, you need to create a service instance and bind it to your application.  [Getting Started with Services](/docs/dotcom/adding-a-service.html) has information about how to perform these tasks on the  Pivotal CF hosted service. Depending on the type of service, it may be necessary to configure the application to connect to a service instance.

For framework specific service information see:

* [Service Bindings for Spring Applications](/docs/using/services/spring-service-bindings.html)
* [Service Bindings for Grails Applications]((/docs/using/services/grails-service-bindings.html)
* [Service Bindings for Lift Applications](/docs/using/services/lift-service-bindings.html)
* [Service Bindings for Rack, Rails, or Sinatra Applications](/docs/using/services/ruby-service-bindings.html)
* [Service Bindings for Node.js Applications](http://0.0.0.0:4567/docs/using/services/node-service-bindings.html)

For information about how external services can work with Cloud Foundry, see [Services Architecture](/docs/running/architecture/services/).



