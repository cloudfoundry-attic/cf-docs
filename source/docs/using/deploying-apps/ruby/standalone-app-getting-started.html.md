---
title: Standalone, Getting Started
---

## <a id='intro'></a>Introduction ##

Cloud Foundry supports running standalone applications. This guide will show you how to create a standalone application that will execute ruby code at a given interval using the Clockwork gem.

## <a id='prerequisites'></a>Prerequisites ##

To complete this quickstart guide, you need to fulfill the following prerequisites;

* A Cloud Foundry account, you can sign up [here](https://my.cloudfoundry.com/signup)
* [Ruby](http://www.ruby-lang.org/en/)
* [Bundler](http://gembundler.com/)
* The [VMC](../../managing-apps/) command line tool 

## <a id='sample-project'></a>Creating a Sample Project ##

Create a folder for your Standalone application and create a basic application structure.

<pre class="terminal">
$ mkdir ruby_scheduler
$ cd ruby_scheduler
$ touch scheduler.rb Gemfile
</pre>

Initialise both files as follows;

Gemfile

~~~ruby
source :rubygems
gem 'clockwork'
~~~

scheduler.rb

~~~ruby
#!/usr/bin/env ruby
require 'rubygems'
require 'bundler/setup'
require 'clockwork'

class Job
  
  def do_job(frequency)
    puts "Doing job for #{frequency}"
  end

end

include Clockwork

handler do |frequency|

  job = Job.new
  job.do_job(frequency)

end

every(1.hour, :hour)
every(1.day, :day)
every(1.week, :week)

Clockwork::run
~~~

As shown in the code above the, every hour, day and week the a job class is created and the method 'do_job' is called. 

Install the required Clockwork gem using bundler

<pre class="terminal">
$ bundle install
</pre>

You should be able to run the application locally by making scheduler.rb executable and running it;

<pre class="terminal">
$ chmod +x scheduler.rb
$ ./scheduler.rb
I, [2013-01-30T12:32:34.921632 #74958]  INFO -- : Starting clock for 3 events: [ hour day week ]
I, [2013-01-30T12:32:34.921738 #74958]  INFO -- : Triggering '#&lt;Clockwork::Event:0x007fd51a1ec9f8&gt;'
Doing job for hour
I, [2013-01-30T12:32:34.921775 #74958]  INFO -- : Triggering '#&lt;Clockwork::Event:0x007fd51a1ec980&gt;'
Doing job for day
I, [2013-01-30T12:32:34.921802 #74958]  INFO -- : Triggering '#&lt;Clockwork::Event:0x007fd51a1ec908&gt;'
Doing job for week
</pre>

## <a id='deploying'></a>Deploying Your Application ##

Push the application with VMC;

<pre class="terminal">
$ vmc push

Name> scheduler  

Instances> 1

1: grails
2: java_web
3: lift
4: node
5: play
6: rack
7: rails3
8: sinatra
9: spring
10: standalone
Framework> 10

Startup command> bundle exec ./scheduler.rb

1: ruby18
2: ruby19
3: other
Runtime> 2

1: 64M
2: 128M
3: 256M
4: 512M
5: 1G
6: 2G
7: 4G
8: 8G
9: 16G
Memory Limit> 64M

Creating scheduler... OK

1: scheduler.cloudfoundry.com
2: none
URL> 2                         


Create services for application?> n

Bind other services to application?> n

Save configuration?> n

Uploading scheduler... OK
Starting scheduler... OK
Checking scheduler... OK
</pre>

As shown above when asked for the application type, select 'standalone' and then when asked for a startup command enter 'bundle exec ./scheduler.rb'

Once this is deployed, we can check it is running correctly by viewing the stdout log;

<pre class="terminal">
$ vmc file scheduler logs/stdout.log
Getting file contents... OK

No Redis service bound to app.  Skipping auto-reconfiguration.
No Mongo service bound to app.  Skipping auto-reconfiguration.
No MySQL service bound to app.  Skipping auto-reconfiguration.
No PostgreSQL service bound to app.  Skipping auto-reconfiguration.
No RabbitMQ service bound to app.  Skipping auto-reconfiguration.
I, [2013-01-30T12:39:32.230255 #17934]  INFO -- : Starting clock for 3 events: [ hour day week ]
I, [2013-01-30T12:39:32.230366 #17934]  INFO -- : Triggering '#&lt;Clockwork::Event:0x000000012205a0&gt;'
Doing job for hour
I, [2013-01-30T12:39:32.230410 #17934]  INFO -- : Triggering '#&lt;Clockwork::Event:0x00000001220500&gt;'
Doing job for day
I, [2013-01-30T12:39:32.230445 #17934]  INFO -- : Triggering '#&lt;Clockwork::Event:0x00000001220488&gt;'
Doing job for week
</pre>

## <a id='next-steps'></a>Next steps - Binding a service ##

Binding and using a service with Ruby is covered [here](./ruby-service-bindings.html)