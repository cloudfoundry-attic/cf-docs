---
title: Jobs
---

Jobs are a realization of packages, i.e. running one or more processes from a package. A job contains the configuration files and startup scripts to run the binaries from a package.

There is a *many-to-many* mapping between jobs and VMs. One or more jobs can run in any given VM, and many VMs can run the same job. For example, four VMs are running the Cloud Controller job, and the Cloud Controller job and the DEA job can also run on the same VM. If you need to run two different processes (from two different packages) on the same VM, you need to create a job that starts both processes.

## <a id="prepare-script"></a> Prepare Script ##

If a job needs to assemble itself from other jobs (like a super-job), you can use a `prepare` script. The script is run before the job is packaged up, and can create, copy, or modify files.

## <a id="job-templates"></a> Job Templates ##

Job templates are generalized configuration files and scripts for a job. The job uses [ERB](http://ruby-doc.org/stdlib-1.9.3/libdoc/erb/rdoc/ERB.html) files to generate the final configuration files and scripts when a Stemcell is turned into a job.

When a configuration file is turned into a template, instance-specific information is abstracted into a property that later is provided when the [Director](/docs/running/bosh/components/director.html) starts the job on a VM. Information includes, for example, which port the webserver should run on, or which username and password a databse should use.

The files are located in the `templates` directory, and the mapping between a template file and its final location is provided in the job `spec` file in the templates section. For example:

    templates:
      foo_ctl.erb: bin/foo_ctl
      foo.yml.erb: config/foo.yml
      foo.txt: config/foo.txt

## <a id="use-of-properties"></a> Use of Properties ##

The properties used for a job comes from the deployment manifest, which passes the instance-specific information to the VM through the [agent](/docs/running/bosh/components/agent.html).

## <a id="the-job-of-a-vm"></a> The Job of a VM ##

When a VM is first started, it is a Stemcell, which can become any kind of job. It is first when the director instructs the VM to run a job as it will gets its *personality*.

## <a id="monit-rc"></a> Monitrc ##

BOSH uses [monit](http://mmonit.com/monit/) to manage and monitor the process(es) for a job. The `monit` file describes how the BOSH [agent](/docs/running/bosh/components/agent.html) will stop and start the job, and it contains at least three sections:

`with pidfile`
: Where the process keeps its pid file

`start program`
: How monit should start the process

`stop program`
: How monit should stop the process

Usually the `monit` file contains a script to invoke to start and stop the process, but it can invoke the binary directly.

Early in the development of a BOSH release, it may be useful to leave the `monit` file empty --- this does not cause a problem. ou still must include a `monit` file, but it can simply be an empty file.
