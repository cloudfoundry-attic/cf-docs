---
title: Migrate a Database on Cloud Foundry
---

Because you cannot access a database running on Cloud Foundry remotely from the shell, database migration usually involves customizing the start command that Cloud Foundry runs when you push an application to migrate the database prior to starting the application. For more information, see [Configure a Custom Start Command](#custom-start) below. 



## <a id='custom-start'></a> Configure a Custom Start Command ##

An application's start command is configured in the application's manifest file, `manifest.yml`, with the `command` attribute. 

If you have previously deployed the application, the application manifest should already exist. There are two ways to create a manifest:

* You can manually create the file and save it in the application's root directory before you deploy the application for the first time. 
* If you do not manually create the manifest file, cf will prompt you to supply deployment settings when you first push the application, and will create and save the manifest file for you, with the settings  you specified interactively. 

For more information about application manifests, and supported attributes, see [Application Manifests](/docs/using/deploying-apps/manifest.html).

Assuming that you will run multiple instances of the application, you want to run the migration just once, not for each application instance. For examples of how to do this, see [Migrate a Database for a Ruby Application](migrate-ruby-db) below.


## <a id='migrate-ruby-db'></a>Migrate a Database for a Ruby App ##

You can use a Rake task --- `rake db:migrate` --- to migrate a Ruby application's database.

This sections below describe two approaches for ensuring that a database migration is performed only for one of the Ruby application instances you will run.  

### <a id='start-scale'></a>Start an Instance and then Scale ###

 Start a single instance when running the migration, and then start additional instances.  

  1. In `manifest.yml`, set the instances attribute to "1", and using the `command` attribute, specify the Rake task --- `rake db:migrate` --- command before the command that starts the application.   

     ~~~
     ---
     applications:
     - name: my-rails-app
       instances: 1
       command: rake db:migrate && rails s
       ... the rest of your settings  ...
    ~~~

  2. Ensure that the instance started (if the migration fails, the application will not be started), and then run [cf scale](/docs/using/managing-apps/cf/index.html#scale) to start additional application instances. 

### <a id='task'></a>Use Rake Task to Limit Migration ###

1. Create a Rake task that limits the migration to the first instance started. The metadata for an application instance running on Cloud Foundry includes `instance_id`; the first instance that starts up has `instance_id` of "0".

  ~~~
  namespace :cf do
     desc "Only run on the primary Cloud Foundry instance"
     task :on_primary_instance do
        instance_index = JSON.parse(ENV["VCAP_APPLICATION"])["instance_index"] rescue nil
       exit(0) unless instance_index == 0
     end
  end
~~~

2. In `manifest.yml`, edit the `command` attribute to include the Rake task. For example:

     ~~~
     ---
     applications:
     - name: my-rails-app
       instances: 5
       command: bundle exec rake cf:on_primary_instance db:migrate && rails s
       ... the rest of your settings  ...
     ~~~

 Verify that the application instances started up, because, as with the prior method, if the migration fails, the application instances will not be started.


## <a id='migrate-node-db'></a>Migrate a Database for a Node App ##

To migrate a database for a Node.js application, adapt the procedure described above in [Start an Instance and then Scale](#start-scale), adding a Node.js migration command to the application start command.

