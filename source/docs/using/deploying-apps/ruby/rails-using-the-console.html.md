---
title: Rails 3, Using the Console
---

## <a id='intro'></a>Introduction ##

From debugging issues on a production application to managing data, the Rails console is an invaluable tool. CF makes it very simple to get a connection to a Rails console up and running.

## <a id='install'></a>Installing the console plugin for CF ##

First step, make sure you have the 'tunnel-cf-plugin' gem installed;

<pre class="terminal">
$ gem install tunnel-cf-plugin
</pre>

## <a id='invoke'></a>Invoking the console ##

Next, invoke the console with the following command;

<pre class="terminal">
$ cf console [application name]
Opening console on port 10000... OK
irb():001:0>
</pre>

The familiar IRB-style console should open with a live connection to the Rails application.
