---
title: Ruby
---

Cloud Foundry supports Ruby frameworks such as Rails, Sinatra, and Rack.

## <a id='package'></a>Package ##

We recommend that you use bundler to manage your gem dependencies.

You need to run `bundle install` locally before you deploy your app to make sure that your Gemfile.lock is consistent with your Gemfile.

## <a id='deploy'></a> Deploy ##

How you deploy your `.war` depends on the Cloud Foundry you are targeting. For run.pivotal.io, you can follow the Getting Started document [here](../../getting-started.html).

Cloud Foundry supports multiple Ruby-based frameworks.

### Rails

* [Getting Started](rails-getting-started.html)
* [Running Worker Tasks](rails-running-worker-tasks.html)
* [Using the console](rails-using-the-console.html)

### Rack

* [Getting Started](rack-getting-started.html)

### Sinatra

* [Getting Started](sinatra-getting-started.html)

### Standalone

* [Getting Started](standalone-app-getting-started.html)

## <a id='binding-services'></a>Binding Services ##

* [Service Bindings](./ruby-service-bindings.html) - A general guide to binding services to Ruby applications.

* [CF Runtime](./ruby-cf-runtime.html) - A guide to the "cf-runtime" Ruby Gem.

## <a id='buildpacks'></a>Migrating to Buildpacks ##

[Buildpacks](./migrating-to-buildpacks.html) - Tips for moving an existing deployment to buildpacks.

