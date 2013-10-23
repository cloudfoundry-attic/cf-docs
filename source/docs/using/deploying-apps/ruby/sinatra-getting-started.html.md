---
title: Sinatra, Getting Started
---

## <a id='intro'></a>Introduction ##

Cloud Foundry provides support for Sinatra applications. Work through this guide to create a sample application and deploy it to Cloud Foundry.

## <a id='prerequisites'></a>Prerequisites ##

To complete this quickstart guide, you need to fulfill the following prerequisites;

* A Cloud Foundry account, you can sign up [here](https://my.cloudfoundry.com/signup)
* [Ruby](http://www.ruby-lang.org/en/)
* [Bundler](http://gembundler.com/)
* The [CF](../../managing-apps/index.html) command line tool

## <a id='sample-project'></a>Creating a Sample Project ##

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
