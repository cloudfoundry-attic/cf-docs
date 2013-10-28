---
title: Troubleshoot Application Deployment and Health
---

## <a id='cf-commands'></a>cf Troubleshooting Commands ##

Cloud Foundry's cf command line interface provides several commands you can use to investigate application deployment and health.


* `cf apps` —-- Lists applications that are deployed to the current space, deployment options, including the number of instances, memory and disk allocations, and the current state of each application. For command usage, see the [apps](/docs/using/managing-apps/cf/index.html#apps) section on the [cf Command Line Interface](/docs/using/managing-apps/cf/index.html) page.

* `cf app` --- Returns the health and status of each instance of an application, including current status, how long it has been running, and how much CPU, memory, and disk it consumes. For command usage, see [app](/docs/using/managing-apps/cf/index.html#app).
                      
* `cf logs` --- You can use this command to view recent output to STDOUT and STDERR for an application, or to tail the streams. If your application uses a log4j facility that is configured to send log messages to STDOUT, such messages will also be returned by the `logs` command. You may need to configure your application to issue messages to STDOUT and STDERR. (If your application environment logs errors of interest to a file, rather than STDOUT or STDERR, use the `cf file` command to view the messages.)  For command usage, see [logs](/docs/using/managing-apps/cf/index.html#logs).

* `cf events` --- This command returns information about application crashes, including error codes. See https://github.com/cloudfoundry/errors for a list of Cloud Foundry errors. For command usage, see [events](/docs/using/managing-apps/cf/index.html#eventss).

* `cf files` and `cf file`--- You can use these command to view a list of files in an application directory, or the contents of a particular file, respectively. For command usage, see [files](/docs/using/managing-apps/cf/index.html#files) and [file](/docs/using/managing-apps/cf/index.html#file).

* `cf guid` --- You can use this command to return the guid of an applicaton. For usage information, see [guid](/docs/using/managing-apps/cf/index.html#guid).

* `cf stats` --- Lists resource statistics for each instance of an application, including CPU, memory, and disk usage. For usage information, see [stats](/docs/using/managing-apps/cf/index.html#stats).

## <a id='java-apps'></a>Java Requirements and Best Practices ##

* Provide JDBC driver --- The Java buildpack does not bundle a JDBC driver with your application. If your application will access a SQL RDBMS, include the appropriate driver in your application.

* Allocate sufficient memory  --- If you do not allocate sufficient memory to an application when you deploy it, it may fail to start, or be killed by Cloud Foundry. Allocate enough memory to allow for Java heap, Perm Gen, thread stacks and JVM overhead. The Java buildpack allocates 10% of the memory limit to PermGen. Memory-related JVM options are configured in `config/openjdk.yml`.  When your application is running, you can use the `cf stats` command to see memory utilization.

## <a id='node-apps'></a>Node Requirements and Best Practices ##

* Specify a Node.js applications's web start command in a Procfile or the application deployment manifest.

## <a id='ruby-apps'></a>Ruby Requirements and Best Practices ##

* Precompile assets --- Recommended to reduce staging time.

* Use `rails_serv_static_assets` on Rails 4 --- By default Rails 4 will return a 404 if an asset is not handled via an external proxy such as Nginx. The `rails_serve_static_assets` gem enables your Rails server to deliver static assets directly, instead of returning a 404. You can use this capability to populate an edge cache CDN or serve files directly from your web application. This gives your app total control, redirect requests, or set headers in your Ruby code. The `rails_serv_static_assets` gem enables this behavior in an app by setting  the `config.serve_static_assets` option to "true", so you do not need to configure it manually. 
