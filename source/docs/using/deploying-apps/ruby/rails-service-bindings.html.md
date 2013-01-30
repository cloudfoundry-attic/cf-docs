---
title: Rails 3, Service Bindings
---

### Quick links ###
* [Introduction](#intro)
* [Prerequisites](#prerequisites)
* [Configuring your Gemfile](#gemfile)
* [Modifying the sample application](#modifying)
* [Creating and binding the service](#creating-and-binding)

## <a id='intro'></a>Introduction ##

This guide is for developers who wish to bind an ORM type data source to a Rails 3 application deployed and running on Cloud Foundry. For information on binding other data sources to Rails and other Ruby-based applications see the Ruby [Service Bindings](./ruby-service-bindings.html) page.

## <a id='prerequisites'></a>Prerequisites ##

To complete this quickstart guide, you need to fulfill the following prerequisites;

* A Cloud Foundry account, you can sign up [here](https://my.cloudfoundry.com/signup)
* [Ruby](http://www.ruby-lang.org/en/)
* [Rails](http://rubyonrails.org/)
* [Bundler](http://gembundler.com/)
* The [VMC](../../managing-apps/) command line tool 
* A sample application such as the one created in [this](./rails-getting-started.html) tutorial

## <a id='gemfile'></a>Configuring your Gemfile ##

Depending on which service you plan to bind to your application, you need to make sure the correct gem is included in the project and the bundle has been updated. Edit the file 'Gemfile' and make sure the following gem is made available to the production environment;

<pre>
Service Type      Gem

MySQL             mysql2
PostgreSQL        pg
MongoDB           mongo_mapper

</pre>

Add the gems for the bound services and update the bundle

<pre class="terminal">
$ bundle update
</pre>

## <a id='modifying'></a>Modifying the sample application ##

If you are using ActiveRecord both MySQL and Postgres should work fine as long as the adapter is set correctly in config/database.yml for the production environment and the correct service bound to the application.

For MySQL;

~~~yaml
production:
  adapter: mysql2
  encoding: utf8
~~~

For Postgres;

~~~yaml
production:
  adapter: postgresql
  encoding: unicode
~~~

For MongoDB there are a few different gems you can use, however if you are looking for an ActiveRecord-like ORM, best use [Mongo Mapper](http://mongomapper.com/). This requires a few changes to the application itself, all the changes are explained in detail on the "[Rails 3 - Getting Started]" page of the Mongo DB website.

Both 

## <a id='creating-and-binding'></a>Creating and binding the service ##

To create a service issue the following command with vmc and answer the interactive prompts;

<pre class="terminal">
$ vmc create-service
</pre>

To bind the service to the application, use the following vmc command;

<pre class="terminal">
$ vmc bind-service --app [application name] --service [service name]
</pre>

