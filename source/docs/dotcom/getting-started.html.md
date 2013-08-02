---
title: Getting Started
---

Cloud Foundry allows you to deploy applications without worrying about configuration headaches, making it faster and easier to build, test, deploy and scale your app.

This guide walks you through getting started at run.pivotal.io, powered by Cloud Foundry.

## <a id='intro'></a>Steps to Get Started ##

In order to run your application on run.pivotal.io, you need to:

1. [Sign up for an account](#signup)
1. [Install and configure the `cf` command line tool](#install-cf)
1. [Prepare your application on your local machine](#prepare-app)
1. [Push your application code to the cloud](#push-app)

## <a id='signup'></a>Sign Up for An Account ##

Before you can deploy your application, you will need an account on run.pivotal.io. If you already had an account on cloudfoundry.com, your account credentials have already been transferred over to run.pivotal.io for you. You can simply [log in to your account](https://login.run.pivotal.io/login).

If you do not have an account yet, you can [sign up here](https://console.run.pivotal.io).

## <a id='install-cf'></a>Install cf Command Line Tool ##

You'll use the `cf` [command line tool](/docs/using/managing-apps/cf) to deploy your application. You can also use it to check on the health of your application, change settings, and stop and restart your app.

Because `cf` is a Ruby gem, you will need to have Ruby and RubyGems installed. See the [Installing Ruby](/docs/common/install_ruby.html) page for help installing Ruby and RubyGems.

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

Cloud Foundry supports many frameworks and runtimes. Learn about the preparations for each below:

| Runtime        | Framework                                                                             |
| :------------- | :-------------                                                                        |
| Javascript     | [Node.js](/docs/using/deploying-apps/javascript/index.html)                           |
| Java / JVM     | [Java Spring, Grails, Scala Lift, and Play](/docs/using/deploying-apps/jvm/index.html)|
| Ruby           | [Rack, Rails, or Sinatra](/docs/using/deploying-apps/ruby/index.html)                 |

Cloud Foundry supports these frameworks and runtimes using a buildpack model. Some of the <a href="https://devcenter.heroku.com/articles/third-party-buildpacks">Heroku third party buildpacks</a> will work, but your experience may vary. To push an application using one of these buildpacks use `cf push [appname] --buildpack=[git url]`

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
