---
title: Migrate a Database on Cloud Foundry
---

In this version of CLoud Foundry, you cannot access a database running on Cloud Foundry remotely from a command shell. For this reason, database migration usually involves customizing the start command that Cloud Foundry runs when you push an application. The instructions below include directions for editing an application's manifest to migrate the database prior to starting the application. For more information about `manifest.yml`, see [cf Push and the Manifest](/docs/using/deploying-apps/manifest.html#push-and-manifest) on the [Application Manifests](/docs/using/deploying-apps/manifest.html) page.


## <a id='migrate-ruby-db'></a>Migrate a Database for a Ruby App ##

You can use a Rake task --- `rake db:migrate` --- to migrate a Ruby application's database.

Assuming that you will run multiple instances of the application, you want to run the migration just once, not for each application instance. The sections below describe two approaches for ensuring that a database migration is performed only for one of multiple application instances.  

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

If you wish, you can create a Rake task that limits the migration to the first instance started. The metadata for an application instance running on Cloud Foundry includes `instance_index`; the first instance that starts up has `instance_index` of "0".

1. Write a Rake task that limits an action to the first application instance. For example:

  ~~~
  namespace :cf do
     desc "Only run on the primary Cloud Foundry instance"
     task :on_primary_instance do
        instance_index = JSON.parse(ENV["VCAP_APPLICATION"])["instance_index"] rescue nil
       exit(0) unless instance_index == 0
     end
  end
~~~

2. In `manifest.yml`, define `command` using the new task to limit the `db:migrate` action to the first application instance. For example:

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

Depending on the tool you use for Node.js database migrations, you may be able to adapt the procedure described above in [Start an Instance and then Scale](#start-scale), modifying the application start command to invoke the migration utility. 


## <a id='migrate-node-db'></a>Migrate a Database for a Java App ##

For Java applications, the database upgrade process varies considerably, depending on the database type and your database administration practices, and typically involves application code changes. The notion of a migration as a files that updates a database schema relates primarily to Ruby environments.  
