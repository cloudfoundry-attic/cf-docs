---
title: Streaming Logs
---

_This page assumes that you are using the [beta of the go cf CLI](http://blog.cloudfoundry.com/2013/11/09/announcing-cloud-foundry-cf-v6/), also known as gcf._

### Features

The logging capability in Cloud Foundry allows you to:

1. Tail application logs.
1. Dump a recent set of application logs.
1. Continually drain application logs to 3rd party log archive and analysis
services using syslog.

#### Tailing Application Logs

<pre class="terminal">
gcf logs APP_NAME [--recent]
</pre>

You can see a real time stream of your application STDOUT and STDERR with `gcf
logs APPNAME`.
For example:

<pre class="terminal">
$ gcf logs myapp
2013-12-03T20:52:36.64-0800 [App/0]   ERR 108.216.154.88, 10.10.66.252 - - [04/Dec/2013 04:52:36] "GET / HTTP/1.1" 200 1358 0.0020
2013-12-03T20:52:36.66-0800 [App/0]   ERR 108.216.154.88, 10.10.66.252 - - [04/Dec/2013 04:52:36] "GET / HTTP/1.1" 200 1358 0.0288
2013-12-03T20:52:36.66-0800 [RTR]     OUT env-test.cfapps.io - [04/12/2013:04:52:36 +0000] "GET / HTTP/1.1" 200 1358 "-" "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/31.0.1650.57 Safari/537.36" 10.10.66.252:48779 response_time:0.067069415 app_id:c66ecb53-5aff-4f7d-b7a4-b0143c4b6ade
...
</pre>

To exit, press Ctrl-C (^C).

#### Dumping Recent Application Logs

If your application crashes, recent logs can be useful to examine.
To dump recent log files, use `gcf logs` with the `--recent` flag:

<pre class="terminal">
gcf logs APP_NAME --recent
</pre>

#### Draining Application Logs

The CF logging system support the syslog format as described in [RFC 5424](http://tools.ietf.org/html/rfc5424) with octet encoding as described in
[RFC 6587](http://tools.ietf.org/html/rfc6587).
Optionally, you can use syslog TLS support as described in [RFC 5425](http://tools.ietf.org/html/rfc5425)

To drain your application's logs to a 3rd party syslog drain service, you will
need to bind a syslog drain url to your application.

You can do this by adding a 3rd party log service to your application or by
adding a user-provided service with a custom syslog drain url to your application
via the command line.

To create a user-provided syslog service:

<pre class="terminal">
gcf create-user-provided-service SERVICE_NAME -l SYSLOG-DRAIN-URL
</pre>

The SYSLOG-DRAIN-URL should be in the format of 'scheme://host:port' where
allowed schemes are 'syslog' or 'syslog-tls' For example:

    syslog scheme:     'syslog://my.unencrypted.syslogservice.example.com:1234'
    syslog tls scheme: 'syslog-tls://my.encrypted.syslogservice.example.com:5467'

After you create your custom service you need to bind the applications to it.
For example:

<pre class="terminal">
gcf bind-service APP_NAME SERVICE_NAME
</pre>

You can repeat this for all applications you wish to drain to your syslog
service.
You will need to restart your application(s) to pick up the new service.

##### Notes
Cloud Foundry gathers and stores logs in a best-effort manner.
If the buffer of log lines is too large because clients are unable to keep up,
the system will drop some log messages.
Application logs should typically be available if clients such as a CLI tail or
a syslog drain are able to keep up with the application log volume.

The logging capability reports only on STDOUT and STDERR of your application and
other relevant system messages.
You may need to configure your application to write logs to STDOUT or STDERR
instead of a custom log file.
Sending application logs that are not part of STDOUT and STDERR is not
supported.

Logging output delivered with an internal timestamp.
This timestamp is assigned when the logging service receives the log line.
If the log line includes a timestamp, this timestamp is not processed by the
logging system.
Instead, it is passed as part of the opaque 'message data'.

To prevent issues you should ensure your application is NOT buffering output to
STDOUT or STDERR.

For Sinatra, make sure to have this in your configure block:

    $stderr.sync = true
    $stdout.sync = true

If you use Log4J ConsoleAppender, by default there is no buffering, and the
[immediateFlush](http://logging.apache.org/log4j/1.2/apidocs/org/apache/log4j/WriterAppender.html#immediateFlush) option defaults to true.
If the immediateFlush option is set to false, there might be some buffering.

Logback's [ConsoleAppender](http://logback.qos.ch/manual/appenders.html#ConsoleAppender)
buffers by default (by using a OutputStreamWriter under the hood).