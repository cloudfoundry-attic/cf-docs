---
title: Migrating an existing app to buildpacks
---
### Update your project's manifest.yml ###
1. change "framework" from 'rails19' (or whatever) to 'buildpack', and
   remove all the other framework configuration
2. if you have a database that needs to be migrated sometimes, you'll have
   to make your start command run migrations.

Old manifest.yml:

~~~yaml
applications:
  .:
    name: myapp
    runtime: ruby19
    framework:
      name: rails3
      info:
        mem: 256M
        description: Rails Application
        exec:
    url: ${name}.${target-base}
    mem: 256M
    instances: 1
~~~

New manifest.yml:

~~~yaml
applications:
  .:
    name: myapp
    runtime: ruby19
    framework: buildpack
    command: bundle exec rake db:migrate && bundle exec rails server -p $PORT
    url: ${name}.${target-base}
    mem: 256M
    instances: 1
~~~

### Remove calls to establish_connection ###
There was a time in the past where it was necessary to have explicit calls
to ActiveRecord::Base.establish_connection in apps using the staging env,
since cloudfoundry would only put credentials for bound database services
in the 'production' section of database.yml. That time is past, and code
like below will break everything and should be removed:

~~~ruby
# CloudFoundry only puts credentials in database.yml's production section
if ENV.has_key?("VMC_APP_VERSION")
  ActiveRecord::Base.establish_connection("production")
end
~~~

### Clean up other cruft ###
Now is also a good time to remove other old hacks and workarounds for
cloudfoundry bugs of olde. Here's a partial list:

1. Helpers that fool Health Manager for standalone apps by listening on
   a socket.
2. Extra environment variables for setting RAILS_ENV in a roundabout way
   during application startup. You can set RAILS_ENV and RACK_ENV just like
   any other environment variable now.
