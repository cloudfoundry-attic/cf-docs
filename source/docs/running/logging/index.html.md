---
title: Cloud Foundry Logging
---

This section contains information useful for debugging Cloud Foundry system components.

Component Logging
-----------------

The Cloud Foundry components share a common interface for configuring their logs. For more information, see the
READMEs for the [DEA](http://github.com/cloudfoundry/dea_ng#logs), the [Cloud
Controller](http://github.com/cloudfoundry/cloud_controller_ng#logs), or for
[Steno](http://github.com/cloudfoundry/steno), the logging library that these components use.

In `cf-release`, the components are all configured in a similar way:

* All of the job's log files are located in the directory `/var/vcap/sys/log`, on the machine where the job is running.
* The job's main logs are written to a file named `<job-name>.log`.
* Any output written directly to the job's stdout and stderr is written to `<job-name>.stdout.log` and `<job-name>.stderr.log`, respectively.

### Database Migrations

For the Cloud Controller, database migration logs are written to `db_migrate.stdout.log` and `db_migrate.stderr.log`
in the same directory.

Log Aggregation
---------------

There is a service called the `syslog_aggregator`, which allows you to view
logs for all instances of a given job in one place. For example, if your deployment has 60 DEAs,
rather than looking at their logs individually, you can ssh to the
`syslog_aggregator` and view the collected logs of all DEAs. The `syslog_aggregator` works as
follows:

* For most components, if the `syslog_aggregator` is present in the deployment,
logs will additionally be sent to a local syslog server which then forwards
the logs to the `syslog_aggregator`.
* The aggregated logs can be found on the `syslog_aggregator` under `/var/vcap/store/log` in directories named after the job
* They are sorted by year, month and day
* In the top folder `/var/vcap/store/log`, there's a symlink named after each job for that job's current log file
