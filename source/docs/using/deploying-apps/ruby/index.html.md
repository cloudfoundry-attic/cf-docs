---
title: Deploying Ruby Apps (Rack, Rails, or Sinatra)
---

This page will prepare you for using deploying Rack, Rails, or Sinatra apps via the [getting started guide](../../../dotcom/getting-started.html).

## <a id='bundler'></a> Do I need to use Bundler?##

You need to run <a href="http://gembundler.com/">Bundler</a> to create both a Gemfile and Gemfile.lock. These files must be in your application before you push to Cloud Foundry.

## <a id='config'></a> Do I need a Rack config file?##

For both **Rack** and **Sinatra** you need a config.ru file like the example below:

config.ru

~~~ruby
require './hello_world'
run HelloWorld.new
~~~

## <a id='precompile'></a> Can I use precompilation? ##

Cloud Foundry provides support for the Rails asset pipeline. This means that if you don't choose to precompile assets before deployment to Cloud Foundry, precompilation will occur when the application is staged.
To precompile asssets before deployment use the following command:

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

## <a id='standalone'></a> Can I run a standalone Ruby script? ##

Worker tasks are supported by Cloud Foundry. Follow this [standalone app quick start](rails-running-worker-tasks.html) to understand how it works.

## <a id='workers'></a> Can I run workers tasks? ##

Worker tasks are supported by Cloud Foundry. Follow this [Rails workers quick start](rails-running-worker-tasks.html) to understand how it works.

## <a id='console'></a> Can I use the Rails console? ##

Cloud Foundry supports the Rails Console. Follow the [Using the console quick start](rails-using-the-console.html).

## <a id='services'></a> How do I bind services? ##

Refer to the [instructions for Ruby service bindings](../../services/ruby-service-bindings.html).

## <a id='rake'></a> How do I run Rake tasks? ##

To run a rake task for the first time, you need to use the start command in your manifest.yml.

You will be asked if you want to save your configuration the first time you deploy. This will save a `manifest.yml` in your application with the settings you entered during the initial push. Edit the `manifest.yml` file and create a start command as follows:

~~~yaml
---
applications:
- name: my-rails-app
  command: rake db:migrate && rails s
... the rest of your settings  ...
~~~

**Important** Your first migration can only run against an application with one instance. After running the migration, you can scale the application using the `cf scale` command. You could run subsequent migrations using a script that checks for a unique instance number using the JSON formatted environment variable `VCAP_APPLICATION` - which includes an `instance_id` value. 

`VCAP_APPLICATION` works the same way as `VCAP_SERVICES`, which you can read about [here](../../services/environment-variable.html). 

To look at the contents of `VCAP_APPLICATION`, dump it in a Ruby app running in Cloud Foundry via:

`ENV['VCAP_SERVICES']`