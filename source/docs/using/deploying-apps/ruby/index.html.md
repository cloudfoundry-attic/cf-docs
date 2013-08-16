---
title: Deploy Rack, Rails, or Sinatra Applications
---

This page will prepare you to deploy Rack, Rails, or Sinatra apps via the [getting started guide](../../../dotcom/getting-started.html).

## <a id='bundler'></a> Application Bundling ##

You need to run <a href="http://gembundler.com/">Bundler</a> to create both a Gemfile and Gemfile.lock. These files must be in your application before you push to Cloud Foundry.

## <a id='config'></a> Rack Config File ##

For both Rack and Sinatra you need a `config.ru` file like the example below:

~~~ruby
require './hello_world'
run HelloWorld.new
~~~

## <a id='precompile'></a> Asset Precompilation ##

Cloud Foundry supports the Rails asset pipeline. If you do not precompile assets before deploying your application, Cloud Foundry will precompile them when staging the application. 

To precompile asssets before deployment use the following command:

<pre class="terminal">
rake assets:precompile
</pre>

Precompilation before deploying the application reduces the time it  takes to stage the application. 

Note that the precompile rake task completely re-initializes the Rails application. This might pose a problem if initialization require service connections or environment checks that are unavailable during staging. To prevent re-initialiation duirng precompilation, add the folllowing line to `application.rb`:

~~~ruby
config.assets.initialize_on_precompile = false
~~~

If the `assets:precompile` task fails, Cloud Foundry uses live compilation mode, the alternative to asset precompilation. In this mode, assets are compiled when they are loaded for the first time. You can force the live compilation by adding this line to `application.rb`.

~~~ruby
Rails.application.config.assets.compile = true
~~~

## <a id='workers'></a> Worker Tasks ##

Worker tasks are supported by Cloud Foundry. Follow this [Rails workers quick start](rails-running-worker-tasks.html) to understand how it works.

## <a id='console'></a> Rails Console ##

Cloud Foundry v2 does not yet support Rails Console.

## <a id='services'></a> Binding to Services ##

Refer to the [instructions for Ruby service bindings](../../services/ruby-service-bindings.html).

## <a id='rake'></a> Running Rake Tasks ##

If the data service (such as a database) your application uses is available directly and supports connectivity when not running on Cloud Foundry, then you can run rake tasks locally (not on Cloud Foundry) and perform database migrations and other tasks outside of Cloud Foundry. For information about obtaining service connection information from the `VCAP_SERVICES` environment variable, see [VCAP_SERVICES Environment Variable](/docs/using/services/environment-variable.html).

Alternatively, to run a rake task on Cloud Foundry, you can use define the start command in the application's `manifest.yml` file.

You will be asked if you want to save your configuration the first time you deploy.This will save a `manifest.yml` in your application with the settings you entered during the initial push. Edit the `manifest.yml` file and define the start command as follows:

~~~yaml
---
applications:
- name: my-rails-app
  command: rake db:migrate && rails s
... the rest of your settings  ...
~~~

**Important** Your first migration can only run against an application with one instance. After running the migration, you can scale the application using the `cf scale` command. You could run subsequent migrations using a script that checks for a unique instance number using the JSON formatted environment variable `VCAP_APPLICATION` --- which includes an `instance_id` value.


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
