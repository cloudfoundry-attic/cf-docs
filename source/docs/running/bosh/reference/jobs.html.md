---
title: Jobs
---

## Jobs ##

Jobs are realization of packages, i.e. running one or more processes from a package. A job contains the configuration files and startup scripts to run the binaries from a package.

There is a *manyto many* mapping between jobs and VMs - one or more jobs can run in any given VM and many VMs can run the same job. E.g. there can be four VMs running the Cloud Controller job, the Cloud Controller job and the DEA job can also run on the same VM. If you need to run two different processes (from two different packages) on the same VM, you need to create a job which starts both processes.

### Prepare script ###

If a job needs to assemble itself from other jobs (like a super-job) a `prepare` script can be used, which is run before the job is packaged up, and can create, copy or modify files.

### Job templates ###

The job templates are generalized configuration files and scripts for a job, which uses [ERB](http://ruby-doc.org/stdlib-1.9.3/libdoc/erb/rdoc/ERB.html) files to generate the final configuration files and scripts used when a Stemcell is turned into a job.

When a configuration file is turned into a template, instance specific information is abstracted into a property which later is provided when the [director][director] starts the job on a VM. E.g. which port the webserver should run on, or which username and password a databse should use.

The files are located in the `templates` directory and the mapping between template file and its final location is provided in the job `spec` file in the templates section. E.g.

    templates:
      foo_ctl.erb: bin/foo_ctl
      foo.yml.erb: config/foo.yml
      foo.txt: config/foo.txt

### Use of properties ###

The properties used for a job comes from the deployment manifest, which passes the instance specific information to the VM via the [agent][agent].

### "the job of a vm" ###

When a VM is first started, is a Stemcell, which can become any kind of job. It is first when the director instructs the VM to run a job as it will gets its *personality*.

### Monitrc ###

BOSH uses [monit](http://mmonit.com/monit/) to manage and monitor the process(es) for a job. The `monit` file describes how the BOSH [agent][agent] will stop and start the job, and it contains at least three sections:

`with pidfile`
: Where the process keeps its pid file

`start program`
: How monit should start the process

`stop program`
: How monit should stop the process

Usually the `monit` file contain a script to invoke to start/stop the process, but it can invoke the binary directly.
