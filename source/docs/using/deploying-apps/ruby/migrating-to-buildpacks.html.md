---
title: Migrating an existing application to use buildpacks
---

## <a id="intro"></a> Introduction ##

Cloud Foundry V2 uses a buildpack type architecture to provision applications. This means that, for Ruby applications, there should be no need to actually have to specify a framework or a runtime.

It should be possible to simply re-push an application and have it automatically use the correct buildpack for the intended runtime and framework. 

### Remove calls to establish_connection ###
There was a time in the past where it was necessary to have explicit calls
to ActiveRecord::Base.establish_connection in apps using the staging env,
since cloudfoundry would only put credentials for bound database services
in the 'production' section of database.yml. That time is past, and code
like below will break everything and should be removed:

~~~ruby
# CloudFoundry only puts credentials in database.yml's production section
if ENV.has_key?("CF_APP_VERSION")
  ActiveRecord::Base.establish_connection("production")
end
~~~
