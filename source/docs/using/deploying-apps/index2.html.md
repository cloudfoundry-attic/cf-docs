---
title: Deploying Applications to Cloud Foundry
---

## <a id='intro'></a>Introduction ##

Cloud Foundry allows you, as an application developer, to deploy your application without worrying about configuration headaches.
There are five steps to getting your application hosted at the publicly available Cloud Foundry hosted at run.pivotal.io:

1. Sign up for an account
1. Install the command line tool
1. Prepare your application on your local machine
1. Push your application code to the cloud
1. (Optional) Connect your application to one or more services

Other Cloud Foundry instances may have some slight differences.

## <a id='signup'></a>Sign Up for An Account ##

Before you can deploy your application, you will need a Cloud Foundry account. Your can [sign up here](https://console.run.pivotal.io)

## <a id='install-cf'></a>Install the cf Command Line Tool ##

You will also need the `cf` command line tool.
Because `cf` is a Ruby gem, you will need to have Ruby (minimum version 1.8.7) and RubyGems.

To install `cf`, simply type the following at your command line:

<pre class="terminal">
$ gem install cf
</pre>

## <a id='prepare-app'></a>Prepare Your Application for Deployment ##

The steps to prepare your application depend on the technology you are using.
Choose your technology to see what you need to do.

### JVM-Based Languages

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

### Ruby

Cloud Foundry supports most popular Ruby frameworks such as Rails, Sinatra, and Rack.

We recommend that you use bundler to manage your gem dependencies.

You need to run `bundle install` locally before you deploy your app to make sure that your Gemfile.lock is consistent with your Gemfile.

### Node

Before you deploy your Node application you need to include cf-autoconfig in your package.json and require it in your app.

* Add cf-autoconfig to your dependencies in package.json:

~~~json
  "dependencies": {
    ...other dependencies...
    "cf-autoconfig": "*"
  }
~~~

* Add the require statement to the top of your app file:

~~~javascript
  require("cf-autoconfig");
~~~

* Run npm install to install your dependencies locally

## <a id='services'></a>Set Up Your Service(s) ##

## <a id='push-app'></a>Push Your Application to the Cloud ##

Before you deploy, you need to decide on the answers to some questions.

| Name | Use any series of alpha-numeric characters without spaces |
| Instances | The number of instances you want running |
| Memory Limit | The maximum amount of memory each instance is allowed to consume. If an instance goes over the maximum limit, it will be restarted. If it has to be restarted too often, it will be terminated. So make sure you are generous in your memory limit. |
| Start Command | This is the command that Cloud Foundry will use to start each instance of your application. The start command is specific to your framework. Some examples appear below. |
| URL and Domain | `cf` will prompt you for both a URL and a domain. The URL is the subdomain for your application and it will be hosted at the primary domain you choose. The combination of the URL and domain must be globally unique. |
| Services | If your application requires a service such as MySQL or Redis you will need to configure it. `cf` will ask you if you want to do this, however you should set up your services . |


### Examples of Start Commands

### Using a Custom Domain

Name> grails-hello-world

Instances> 1

1: 64M
2: 128M
3: 256M
4: 512M
5: 1G
6: 2G
Memory Limit> 512M

Creating grails-hello-world... OK

1: grails-hello-world.cloudfoundry.com
2: none
URL> grails-hello-world.cloudfoundry.com

Updating grails-hello-world... OK

Create services for application?> n

Save configuration?> n

Uploading grails-hello-world... OK
Starting grails-hello-world... OK
Checking grails-hello-world... OK

Open a command shell and `cd` into the directory where your application files are located.
The `cf push` command will attempt to upload all the files in your current directory.
Make sure you aren't in your desktop!

Start deploying your app by typing:

<pre class="terminal">
$ cf push
</pre>

`cf` will ask you a series of questions.



## <a id='troublshooting'></a>Troubleshooting ##

If your application does not start on Cloud Foundry, try the following:

1. Make sure your application can run locally
1. Increase the amount of memory specified for your application


## <a id='service-connect'></a>Connect Your Application to One or More Services ##]


Toggle: [run.pivotal.io]
Create a folder for your Rack application and create a basic application structure.

<pre class="terminal">
$ mkdir sinatra_hello_world
$ cd sinatra_hello_world
$ touch hello_world.rb config.ru Gemfile
</pre>

Initialise both files as follows;

hello_world.rb

~~~ruby
require 'sinatra/base'

class HelloWorld < Sinatra::Base
  get "/" do
    "Hello, World!"
  end
end
~~~

config.ru

~~~ruby
require './hello_world'
run HelloWorld.new
~~~

Gemfile

~~~ruby
source 'https://rubygems.org'
gem 'sinatra'
~~~

Install the required Sinatra gem using Bundler;

<pre class="terminal">
$ bundle install
</pre>

You should be able to run the application locally by using Rackup;

<pre class="terminal">
$ rackup
>> Thin web server (v1.4.1 codename Chromeo)
>> Maximum connections set to 1024
>> Listening on 0.0.0.0:9292, CTRL+C to stop
</pre>

View your application at [http://localhost:9292](http://localhost:9292)

## <a id='deploying'></a>Deploying Your Application ##

Push the application with CF;

<pre class="terminal">
$ cf push

Name> sinatra-hello-world

Instances> 1

1: 64M
2: 128M
3: 256M
4: 512M
5: 1G
6: 2G
7: 4G
8: 8G
9: 16G
Memory Limit> 128M

Creating rack-test... OK

1: sinatra-hello-world.cloudfoundry.com
2: none
URL> sinatra-hello-world.cloudfoundry.com

Updating rack-test... OK

Create services for application?> n

Bind other services to application?> n

Save configuration?> n

Uploading sinatra-hello-world... OK
Starting sinatra-hello-world... OK
Checking sinatra-hello-world... OK
</pre>

Once this is deployed, you should be able to view the application on Cloud Foundry at the URL you chose during the push.

## <a id='next-steps'></a>Next steps - Binding a service ##

Binding and using a service with Ruby is covered [here](./ruby-service-bindings.html)
