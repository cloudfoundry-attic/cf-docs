---
title: Rails 3, Getting Started
---

### Quick links ###
* [Introduction](#intro)
* [Prerequisites](#prerequisites)
* [Creating a Sample Project](#sample-project)
* [Assets, Precompile or Not?](#assets)
* [Deploying Your Application](#deploying)
* [Next Steps - Binding a service](#next-steps)


## <a id='intro'></a>Introduction ##

Cloud Foundry has comprehensive support for Rails 3, including legacy versions. Work through this guide to create a sample application and deploy it to Cloud Foundry.

## <a id='prerequisites'></a>Prerequisites ##

To complete this quickstart guide, you need to fulfill the following prerequisites;

* A Cloud Foundry account, you can sign up [here](https://my.cloudfoundry.com/signup)
* [Ruby](http://www.ruby-lang.org/en/)
* [Rails](http://rubyonrails.org/)
* [Bundler](http://gembundler.com/)
* The [VMC](../../managing-apps/) command line tool 
* A basic understanding of how to create and run Rails applications

## <a id='sample-project'></a>Creating a Sample Project ##

Create a sample rails application and move in to the created folder.

<pre class="terminal">
$ rails new sample_rails
$ cd sample_rails
</pre>

Create a scaffold for an example model, let's use the one from the Rails scaffold [tutorial](http://guides.rubyonrails.org/getting_started.html#getting-up-and-running-quickly-with-scaffolding) and run the migration.

<pre class="terminal">
$ rails generate scaffold Post name:string title:string content:text
$ rake db:migrate
</pre>

Remove index.html from the public folder.

<pre class="terminal">
$ rm public/index.html
$ vi config/routes.rb
</pre>

Also, change the default root for the application to point to the new controller, so it looks like 

~~~ruby
SampleRails::Application.routes.draw do
  resources :posts
  root :to => 'posts#index'
end
~~~

Run the example and make sure you can add and remove posts.

<pre class="terminal">
$ rails s
</pre>

## <a id='assets'></a>Assets, Precompile or Not? ##

Cloud Foundry provides support for the Rails asset pipeline. This means that if you don't choose to precompile assets before deployment to Cloud Foundry, precompilation will occur when the application is staged.
To precompile asssets before deployment use the following command;

<pre class="terminal">
rake assets:precompile
</pre>

Doing this before deployment ensures that staging the application will take less time as the precomplilation task will not need to take place on Cloud Foundry. 

One potential problem can occur during application initialization. The precompile rake task will run a complete re-initialization of the Rails application. This might trigger some of the initialization procedures and require service connections and environment checks that are unavailable during staging. You can turn this off by adding a configuration option in application.rb:

~~~ruby
config.assets.initialize_on_precompile = false
~~~

If the assets:precompile task fails, Cloud Foundry makes use of live compilation mode, this is the alternative to asset precompilation. In this mode, assets are compiled when they are loaded for the first time. This can be enabled by adding a setting to application.rb that forces the live compilation process.

~~~ruby
Rails.application.config.assets.compile = true
~~~

## <a id='deploying'></a>Deploying Your Application ##

With VMC installed, target your desired Cloud Foundry instance and login

<pre class="terminal">
$ vmc target api.cloudfoundry.com
Setting target to https://api.cloudfoundry.com... OK

$ vmc login
</pre>

Deploy the application by using the "push" command and follow the prompts;

<pre class="terminal">
$ vmc push rails-3-test
Instances> 1

1: rails3
2: other
Framework> rails3

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
Memory Limit> 256M

Creating rails-3-test... OK

1: rails-3-test.cloudfoundry.com
2: none
URL> rails-3-test.cloudfoundry.com

Updating rails-3-test... OK

Create services for application?> n

Bind other services to application?> n

Save configuration?> n

Uploading rails-3-test... OK
Starting rails-3-test... OK
Checking rails-3-test... OK
</pre>

At this point, the application should be available to view at the URL specified when performing the push. 

## <a id='next-steps'></a>Next steps - Binding a service ##

Binding and using a service with Rails 3 is covered [here](./rails-service-bindings.html)