---
title: Getting Started
---

Cloud Foundry allows you to deploy applications without worrying about configuration headaches, making it faster and easier to build, test, deploy and scale your app.

This guide walks you through getting started at run.pivotal.io, powered by Cloud Foundry.

## <a id='intro'></a>Steps to Get Started ##

In order to run your application on run.pivotal.io, you need to:

1. [Sign up for an account](#signup)
1. [Install and configure the `cf` command line tool](#install)
1. [Prepare your application on your local machine](#prepare-app)
1. [Push your application code to the cloud](#push-app)

## <a id='signup'></a>Sign Up for An Account ##

Before you can deploy your application, you will need an account on run.pivotal.io. If you already had an account on cloudfoundry.com, your account credentials have already been transferred over to run.pivotal.io for you. You can simply [log in to your account](https://login.run.pivotal.io/login).

If you do not have an account yet, you can [sign up here](https://console.run.pivotal.io).

## <a id='install-cf'></a>Install and Configure the cf Command Line Tool ##

You'll use the `cf` command line tool to deploy your application. You can also use it to check on the health of your application, change settings, and stop and restart your app.

Because `cf` is a Ruby gem, you will need to have Ruby (minimum version 1.8.7) and RubyGems. If you do not already have Ruby installed, see [ruby-lang.org](http://www.ruby-lang.org).

To install `cf`, simply type the following at your command line:

<pre class="terminal">
$ gem install cf
</pre>

When the gem has completed installing you should see a message that says, "Successfully installed." You can now target `cf` at the Cloud Controller for run.pivotal.io:

<pre class="terminal">
$ cf target api.run.pivotal.io
Setting target to https://api.run.pivotal.io... OK
</pre>

Then log in:

<pre class="terminal">
$ cf login
email>
password>
</pre>

When you log in, `cf` will prompt you to choose a space. In v2 Cloud Foundry, a space is a container for an application and all its associated processes. By default, your account has three spaces:

<pre class="terminal">
1: development
2: production
3: staging
Space>
</pre>

You can choose any of these spaces to deploy your application.

## <a id='prepare-app'></a>Prepare Your Application for Deployment ##

The steps to prepare your application depend on the technology you are using.

<input type="button" class="togglebutton" value="JVM"> <input type="button" class="togglebutton" value="Ruby"> <input type="button" class="togglebutton" value="Node">

<div>

<div id="JVM" style="display:none">

<h3>JVM-Based Languages</h3>

Cloud Foundry supports most JVM-based frameworks such as Java Spring, Grails, Scala Lift, and Play.
If your application can be packaged as a `.war` file and deployed to Apache Tomcat,
then it should also run on Cloud Foundry without changes.
However, before you can deploy, you need to compile your application.

If you are using Spring or Lift, you can use maven:

<pre class="terminal">
$ mvn package
</pre>

If you are using play:

<pre class="terminal">
$ play redist
</pre>

If you are using Grails:

<pre class="terminal">
$ grails prod war
</pre>
<hr>
</div>

<div id="Ruby" style="display:none">

<h3>Ruby</h3>

Cloud Foundry supports most popular Ruby frameworks such as Rails, Sinatra, and Rack.

We recommend that you use bundler to manage your gem dependencies.

You need to run `bundle install` locally before you deploy your app to make sure that your Gemfile.lock is consistent with your Gemfile.
<hr>
</div>

<div id="Node" style="display:none">

<h3> Node </h3>

Before you deploy your Node application you need to include cf-autoconfig in your package.json and require it in your app.

Add cf-autoconfig to your dependencies in package.json:

<br><br>
<pre><code>
  "dependencies": {
    ...other dependencies...
    "cf-autoconfig": "*"
  }
</code></pre>
<br>
Add the require statement to the top of your app file:
<br><br>
<pre><code>
  require("cf-autoconfig");
</code></pre>
<br>
Run npm install to install your dependencies locally
<hr>
</div>

</div>

## <a id='push-app'></a>Push Your Application to the Cloud ##

Before you deploy, you need to decide on the answers to some questions:

* **Name**: You can use any series of alpha-numeric characters without spaces as the name of your application.
* **Instances**: The number of instances you want running.
* **Memory Limit**: The maximum amount of memory that each instance of your application is allowed to consume. If an instance goes over the maximum limit, it will be restarted. If it has to be restarted too often, it will be terminated. So make sure you are generous in your memory limit.
* **Start Command**: This is the command that Cloud Foundry will use to start each instance of your application. The start command is specific to your framework.
* **URL and Domain**: `cf` will prompt you for both a URL and a domain. The URL is the subdomain for your application and it will be hosted at the primary domain you choose. The combination of the URL and domain must be globally unique.
* **Services**: `cf` will ask you if you want to create and bind one or more services such as MySQL or Redis to your application. For the purposes of this guide, you can answer no when prompted to add a service. Services are addressed in the next guide, [Adding a Service](adding-a-service.html).

## <a id='example-push-app'></a>An Example Transcript ##

Here is an example transcript from deploying a Ruby on Rails application.
Note that in this example, we already provisioned an ElephantSQL instance and named it "elephantpg":

<pre class="terminal">
  $ cf push
  Name> whiteboard

  Instances> 1

  1: 64M
  2: 128M
  3: 256M
  4: 512M
  5: 1G
  6: 2G
  Memory Limit> 256M

  Creating whiteboard... OK

  1: whiteboard
  2: none
  Subdomain> whiteboard

  1: cfapps.io
  2: none
  Domain> cfapps.io

  Creating route whiteboard.cfapps.io... OK
  Binding whiteboard.cfapps.io to whiteboard... OK

  Create services for application?> n

  Bind other services to application?> y

  1: elephantpg
  Which service?> 1

  Binding elephantpg to whiteboard... OK
  Save configuration?> n

  Uploading whiteboard... OK
  Starting whiteboard... OK
  -----> Downloaded app package (224K)
  Installing ruby.
  -----> Using Ruby version: ruby-1.9.2
  -----> Installing dependencies using Bundler version 1.3.2
         Running: bundle install --without development:test --path vendor/bundle --binstubs vendor/bundle/bin --deployment
         ...
         Your bundle is complete! It was installed into ./vendor/bundle
         Cleaning up the bundler cache.
  -----> Writing config/database.yml to read from DATABASE_URL
  -----> Preparing app for Rails asset pipeline
         Running: rake assets:precompile
         Asset precompilation completed (41.70s)
  -----> Rails plugin injection
         Injecting rails_log_stdout
         Injecting rails3_serve_static_assets
  -----> Uploading staged droplet (41M)
  -----> Uploaded droplet
  Checking whiteboard...
  Staging in progress...
  Staging in progress...
  Staging in progress...
  Staging in progress...
  Staging in progress...
  Staging in progress...
  Staging in progress...
  Staging in progress...
  Staging in progress...
    0/1 instances: 1 starting
    0/1 instances: 1 starting
    0/1 instances: 1 starting
    0/1 instances: 1 starting
    0/1 instances: 1 starting
    0/1 instances: 1 starting
    0/1 instances: 1 starting
    0/1 instances: 1 starting
    0/1 instances: 1 starting
    0/1 instances: 1 starting
    0/1 instances: 1 starting
    0/1 instances: 1 starting
    0/1 instances: 1 starting
    0/1 instances: 1 starting
    1/1 instances: 1 running
  OK
</pre>

## <a id='troublshooting'></a>Troubleshooting ##

If your application does not start on Cloud Foundry, it's a good idea to double-check that your application can run locally.

You can troubleshoot your application in the cloud using `cf`.

To check the health of your application, use

<pre class="terminal">
  cf health appname
</pre>

To check how much memory your application is using:

<pre class="terminal">
  cf stats appname
</pre>

To see the environment variables and recent log entries:

<pre class="terminal">
  cf logs appname
</pre>

To tail your logs:

<pre class="terminal">
  cf tail appname
</pre>

If your application has crashed and you cannot retrieve the logs with `cf logs`, you can retrieve its dying words with:

<pre class="terminal">
  cf crashlogs appname
</pre>

## <a id='binding-a-service'></a>Next Step - Binding a service ##

Binding and using a service is covered in our guide, [Adding a Service](adding-a-service.html).
