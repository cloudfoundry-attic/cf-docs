---
title: Troubleshoot Application Health
---
Cloud Foundry's cf command line interface provides several commands you can use to investigate application health.


* `apps` —-- Lists applications that are deployed to the current space, deployment options, including the number of instances, memory and disk allocations, and current state for each application. For usage information, see the [apps](/docs/using/managing-apps/cf/index.html#apps) section on the [cf Command Line Interface](/docs/using/managing-apps/cf/index.html) page.

* `app` --- Returns the health and status of each instance of an application, including current status, how long it has been running, and how much CPU, memory, and disk it consumes. For usage information, see the [app](/docs/using/managing-apps/cf/index.html#app) section on the [cf Command Line Interface](/docs/using/managing-apps/cf/index.html) page.
                      
* `logs` --- You can use this command to view recent output to STDOUT and STDERR for an application, or to tail the streams. You may need to configure your application to issue messages to STDOUT and STDERR. If your application uses a log4j facility that is configured to send log messages to STDOUT, such messages will be returned by the `logs` command. For usage information, see the [logs](/docs/using/managing-apps/cf/index.html#logs) section on the [cf Command Line Interface](/docs/using/managing-apps/cf/index.html) page.

* `events` --- This command returns information about application crashes, including error codes. See https://github.com/cloudfoundry/errors for a list of Cloud Foundry errors. For `events` usage information, see the [events](/docs/using/managing-apps/cf/index.html#events) section on the [cf Command Line Interface](/docs/using/managing-apps/cf/index.html) page.

* `files` --- You can use this command to view a list of files in an application directory, or the contents of a particular file. For usage information, see the [files](/docs/using/managing-apps/cf/index.html#files) section on the [cf Command Line Interface](/docs/using/managing-apps/cf/index.html) page.

* `guid` --- You can use this command to return the guid of an applicaton. For usage information, see the [guid](/docs/using/managing-apps/cf/index.html#guid) section on the [cf Command Line Interface](/docs/using/managing-apps/cf/index.html) page.


