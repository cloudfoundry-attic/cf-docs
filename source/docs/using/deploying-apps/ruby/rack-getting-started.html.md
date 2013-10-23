---
title: Rack, Getting Started
---

## <a id='intro'></a>Introduction ##

Cloud Foundry supports any Rack based application framework. Work through this guide to create a sample application and deploy it to Cloud Foundry.

## <a id='prerequisites'></a>Prerequisites ##

To complete this quickstart guide, you need to fulfill the following prerequisites;

* A Cloud Foundry account, you can sign up [here](https://my.cloudfoundry.com/signup)
* [Ruby](http://www.ruby-lang.org/en/)
* [Bundler](http://gembundler.com/)
* The [CF](../../managing-apps/index.html) command line tool

## <a id='sample-project'></a>Creating a Sample Project ##

Create a folder for your Rack application and create a basic application structure.

<pre class="terminal">
$ mkdir my_rack_app
$ cd my_rack_app
$ touch hello_world.rb config.ru
</pre>

Initialise both files as follows;

hello_world.rb

~~~ruby
class HelloWorld
  def call(env)
    [200, {"Content-Type" => "text/plain"}, ["Hello world!"]]
  end
end
~~~

config.ru

~~~ruby
require './hello_world'
run HelloWorld.new
~~~

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

Name> rack-test

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

1: rack-test.cloudfoundry.com
2: none
URL> rack-test.cloudfoundry.com

Updating rack-test... OK

Create services for application?> n

Bind other services to application?> n

Save configuration?> n

Uploading rack-test... OK
Starting rack-test... OK
Checking rack-test... OK
</pre>

Once this is deployed, you should be able to view the application on Cloud Foundry at the URL you chose during the push.

## <a id='next-steps'></a>Next steps - Binding a service ##

Binding and using a service with Ruby is covered [here](./ruby-service-bindings.html)
