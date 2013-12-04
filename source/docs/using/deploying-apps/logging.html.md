---
title: Streaming Logs
---

_This page assumes you are using cf v6._

### Features

The logging capability in Cloud Foundry allows you to:

1. Tail application logs.
1. Dump a recent (< 1 hour old) set of application logs.
1. Continually drain application logs to 3rd party log archive and analysis services.

### Usage

<pre class="terminal">
cf logs [APP_NAME] [--recent]
</pre>

If you have a `manifest.yml` file in your current working directory, `APP_NAME` defaults to the
name of the application in the manifest.

You can see a real time stream of your application STDOUT with `cf logs`. For example:

<pre class="terminal">
$ cf logs myapp
Started GET "/" for 127.0.0.1 at 2013-04-05 13:14:58 -0700
Started GET "/assets/rails.png" for 127.0.0.1 at 2013-04-05 13:14:58 -0700
...
</pre>

To exit, press Ctrl-C (^C).

If your application crashes it can be handy to get recent logs.
To do that, add the --recent flag. For example:

<pre class="terminal">
cf logs myapp --recent
</pre>

### Notes

Because the logging capability reports only on STDOUT, you may need to configure your application
to write logs to STDOUT instead of a custom log file.

Cloud Foundry gathers and stores logs in a best-effort manner.
Although your logs should usually be available, your application logs may sometimes be truncated.
