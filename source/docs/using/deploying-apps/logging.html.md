---
title: Streaming Logs
---

_This page assumes that you are using the [beta of the go cf CLI](http://blog.cloudfoundry.com/2013/11/09/announcing-cloud-foundry-cf-v6/), also known as gcf._

### Features

The logging capability in Cloud Foundry allows you to:

1. Tail application logs.
1. Dump a recent set of application logs.
1. Continually drain application logs to 3rd party log archive and analysis services using syslog.

### Usage

<pre class="terminal">
gcf logs APP_NAME [--recent]
</pre>

You can see a real time stream of your application STDOUT and STDERR with `gcf logs APPNAME`. For example:

<pre class="terminal">
$ gcf logs myapp
2013-12-03T20:52:36.64-0800 [App/0]   ERR 108.216.154.88, 10.10.66.252 - - [04/Dec/2013 04:52:36] "GET / HTTP/1.1" 200 1358 0.0020
2013-12-03T20:52:36.66-0800 [App/0]   ERR 108.216.154.88, 10.10.66.252 - - [04/Dec/2013 04:52:36] "GET / HTTP/1.1" 200 1358 0.0288
2013-12-03T20:52:36.66-0800 [RTR]     OUT env-test.cfapps.io - [04/12/2013:04:52:36 +0000] "GET / HTTP/1.1" 200 1358 "-" "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/31.0.1650.57 Safari/537.36" 10.10.66.252:48779 response_time:0.067069415 app_id:c66ecb53-5aff-4f7d-b7a4-b0143c4b6ade
...
</pre>

To exit, press Ctrl-C (^C).

If your application crashes it can be handy to get recent logs.
To do that, add the --recent flag. For example:

<pre class="terminal">
gcf logs myapp --recent
</pre>

### Notes
The logging capability reports only on STDOUT and STDERR of your application and other relevant system messages. You may need to configure your application to write logs to STDOUT or STDERR instead of a custom log file. Sending application logs that are not part of STDOUT and STDERR is not supported.

Cloud Foundry gathers and stores logs in a best-effort manner and if the buffer of log lines is too large because clients are unable to keep up, the system will drop some log messages. Application logs should typically be available if clients such as a CLI tail or a syslog drain are able to keep up with the application log volume.

