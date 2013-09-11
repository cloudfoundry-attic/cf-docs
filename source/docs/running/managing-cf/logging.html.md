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

In cf-release, there is a service called the `syslog_aggregator`, which allows you to view
the logs of all instances of a given job together. For example, if your deployment has 60 DEAs,
rather than looking at their logs individually, you can ssh to the `syslog_aggregator` node and
view the collected logs of all DEAs. The `syslog_aggregator` works as follows:

* Most CF components have the `syslog_aggregator` package as one of the dependencies in their
job spec. Example: [Cloud Controller job spec](http://github.com/cloudfoundry/cf-release/blob/5bfcdf9498051f410e5f60a8d3af77040e8ee6d7/jobs/cloud_controller_ng/spec#L24)
* The start script for the component includes the execution of a script in the `syslog_aggregator` package that
starts a local syslog server. Example: [Cloud Controller start script](http://github.com/cloudfoundry/cf-release/blob/5bfcdf9498051f410e5f60a8d3af77040e8ee6d7/jobs/cloud_controller_ng/templates/cloud_controller_ng_ctl.erb#L104)
* The component's config file is written such that the component send its logs to this local syslog server in addition to its local log file.
Example: [Cloud Controller config file](http://github.com/cloudfoundry/cf-release/blob/5bfcdf9498051f410e5f60a8d3af77040e8ee6d7/jobs/cloud_controller_ng/templates/cloud_controller_ng.yml.erb#L55).
To see how this configuration is used, see the readme for [Steno](http://github.com/cloudfoundry/steno).
* The local syslog server forwards the logs to the `syslog_aggregator` node: a [job](http://github.com/cloudfoundry/cf-release/tree/5bfcdf9498051f410e5f60a8d3af77040e8ee6d7/jobs/syslog_aggregator) in cf-release.
* The aggregated logs can be found on the `syslog_aggregator` VM in the `/var/vcap/store/log` directory.
* That directory contains subdirectories for each job, year, month and day. Example: `/var/vcap/store/log/cloud_controller_ng/2013/4/19`.
* In the top folder `/var/vcap/store/log`, there's a symlink named after each job for that job's current log file.

### Bosh deployment configuration

To run the `syslog_aggregator` job, you will want to:

1. Add a job that includes the `syslog_aggregator` job template
1. Include a persistent disk in this job large enough to store the aggregated logs
1. Ensure that the `syslog_aggregator` job template is run _after_ the `nats` job template; as it will use NATS.
1. Add global properties to enable all other jobs to emit rsyslog events to your `syslog_aggregator` job.

For example, you might add the following to your deployment file:

~~~yaml
name: mydeployment

jobs:
- name: nats
  ...

- name: syslog
  release: cf
  template:
    - syslog_aggregator
  instances: 1
  resource_pool: small
  persistent_disk: 8192
  networks:
  - name: default
    default:
    - dns
    - gateway

...
properties:
  syslog_aggregator:
    address: 0.syslog.default.mydeployment.microbosh
    port: 54321
~~~

