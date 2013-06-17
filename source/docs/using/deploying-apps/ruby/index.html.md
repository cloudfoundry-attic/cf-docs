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

If the data service (such as a database) you are using with your application is available directly and supports connectivity when not running on Cloud Foundry, then you can run rake tasks locally (not on Cloud Foundry) and perform database migrations and other tasks outside of Cloud Foundry. See further below on how to access the contents of the `VCAP_SERVICES` environment variable that contains bound service connection information.

Alternatively, to run a rake task on Cloud Foundry, you can use the start command in your manifest.yml.

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

`ENV['VCAP_APPLICATION']`

You can also retrieve environment variables logged in the `env.log` with the `cf log APPNAME` command:

~~~
Reading logs/env.log... OK
TMPDIR=/home/vcap/tmp
VCAP_APP_PORT=61169
VCAP_CONSOLE_IP=0.0.0.0
USER=vcap
VCAP_APPLICATION={"application_users":[],"instance_id":"d05ee6e8198d8b8deb51b3a5dcd0f228","instance_index":0,"application_version":"0699019d-51f4-409e-b588-ef6669596c6f","application_name":"railsnew","application_uris":["railsnew.cfapps.io"],"started_at":"2013-06-14 01:46:34 +0000","started_at_timestamp":1371174394,"host":"0.0.0.0","port":61169,"limits":{"mem":256,"disk":1024,"fds":16384},"version":"0699019d-51f4-409e-b588-ef6669596c6f","name":"railsnew","uris":["railsnew.cfapps.io"],"users":[],"start":"2013-06-14 01:46:34 +0000","state_timestamp":1371174394}
RACK_ENV=production
PATH=/home/vcap/app/bin:/home/vcap/app/vendor/bundle/ruby/1.9.1/bin:/bin:/usr/bin:/bin:/usr/bin
PWD=/home/vcap
LANG=en_US.UTF-8
VCAP_SERVICES={}
HOME=/home/vcap/app
SHLVL=2
RAILS_ENV=production
GEM_PATH=/home/vcap/app/vendor/bundle/ruby/1.9.1:
PORT=61169
VCAP_APP_HOST=0.0.0.0
MEMORY_LIMIT=256m
DATABASE_URL=
VCAP_CONSOLE_PORT=61170
_=/usr/bin/env

~~~