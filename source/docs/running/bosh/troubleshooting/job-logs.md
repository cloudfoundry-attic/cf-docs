---
title: How to locate and watch logs on Job VMs
---

When deploying a bosh release, such as the Cloud Foundry cf-release, you might have a job fail to run.

<pre>
Updating job common4
  core/0 (canary) (00:12:55)
Done                    1/1 00:12:55

Error 400007: `core/0' is not running after update
</pre>

To diagnose the cause of the failure, you will need to look at various log files on the failing instance. Hopefully the answer to your issue will become apparent and you can make corrections.

## Access a job VM ##

In the example above, the job VM is called `core/0`. You can get a terminal session to this job VM via the `bosh ssh` command. Run either of the following commands:

<pre class="terminal">
$ bosh ssh core/0
$ bosh ssh core 0
</pre>

## Log files of interest ##

There are four places to look for log files:

* job template log folders
* bosh agent log file
* bosh monit log file
* default locations that services might output logs

### Job template log folders ###

The first place to look for problems is the log files of the processes running within the job VM.

By convention, `/var/vcap/sys/log/*/*` is where all bosh releases are configured to place log files.

<pre class="terminal">
$ sudo tail -f -n 200 /var/vcap/sys/log/*/*
</pre>

ProTip: when writing a bosh release please configure all services to place their logs in `/var/vcap/sys/log/JOB_NAME`.

### Bosh agent log file ###

If the job(s) within a VM have not yet started, then look in the bosh agent's log file for possible errors or aberrations:

<pre class="terminal">
$ sudo tail -f -n 200 /var/vcap/bosh/log/current
</pre>

### Bosh monit log file ###

Monit is used by the bosh agent to start, restart and stop services included in each job template.

Rarely, but occasionally, will monit know about an error and output useful information to its log file. But it does have one, and gold might be hidden there:

<pre class="terminal">
$ sudo tail -f -n 200 /var/vcap/monit/monit.log
</pre>

ProTip: when writing a bosh release, consider using a [monit wrapper](http://stackoverflow.com/questions/3356476/debugging-monit/4439403#4439403 "shell - Debugging monit - Stack Overflow") around your job's start & stop scripts to aide future debugging.

### Default locations that services might output logs ###

Finally, it is possible that the services being run within a job, such as PostgreSQL, can output logs into its own default locations. You will need to be familiar with these services to know where to look to find any logs that aren't in the conventional location above.

For example, if your bosh release has a `postgres` job, the startup log may be at `/var/vcap/store/postgres/pg_log/startup.log`.

Perhaps the following command might uncover additional logs:

<pre class="terminal">
$ sudo tail -n 200 -f /var/vcap/store/postgres/*/*.log
</pre>


