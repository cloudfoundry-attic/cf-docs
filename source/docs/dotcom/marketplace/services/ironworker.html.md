---
title: IronWorker
---

IronWorker is a multi-language worker platform that runs tasks in the background, in parallel, and at massive scale.

## <a id='managing'></a>Managing Services ##

[Managing services from the command line](../../../using/services/managing-services.html)

### Creating a Service Instance ##

An instance of this service can be provisioned via the CLI with the following command:

<pre class="terminal">
$ cf create-service ironworker
</pre>
    
### Binding Your Service Instance ##

Bind the service instance to your app with the following command:
    
<pre class="terminal">
$ cf bind-service 
</pre>

## <a id='using'></a>Using Service Instances with your Application ##

* Include this section only if your service is bindable. What is the format of the credentials stored in the VCAP_SERVICES environment variable? *

See [Using Service Instances with your Application](../../adding-a-service.html#using) and [VCAP_SERVICES Environment Variable](../../../using/deploying-apps/environment-variable.html).

Format of credentials in `VCAP_SERVICES` environment variable.

~~~xml
{
  service-foo-n/a: [
    {
      name: "service-foo-75efc",
      label: "service-foo-n/a",
      plan: "example-plan",
      credentials: {
        uri: dbtype://username:password@hostname:port/name
        hostname: "foo.example.com"
        port: "1234"
        name: "asdfjasdf"
        username: "QvsXMbJ2rK",
        password: "HCDVOYluTv"
      }
    }
  ]
}
~~~

How to Get your Project ID and Token from Cloud Foundry

Add those values to a file called `iron.json` in your app root directory and add iron.json to your .gitignore file.

    {
      "project_id": "123456789",
      "token": "aslkdjflaksuilaks"
    }

## Ruby

We’re going to need to install the Ruby gem, for development purposes:

<pre class="terminal">
$ gem install worker_ng
</pre>

If you’re building for a Rails application or anything that uses Bundler, add the following to your Gemfile:

~~~
gem 'iron_worker_ng'
~~~

## Create a worker

First things first, let’s create a worker. Save the following code into a file called `hello_worker.rb`:

    puts "Starting HelloWorker at #{Time.now}"
    puts "Payload: #{params}"
    puts "Simulating hard work for 5 seconds..."
    5.times do |i|
      puts "Sleep #{i}..."
      sleep 1
    end
    puts "HelloWorker completed at #{Time.now}"

Now create a file called `hello.worker` that defines your worker’s dependencies:


    # define the runtime language, this can be ruby, java, node, php, go, etc.
    runtime "ruby"
    # exec is the file that will be executed:
    exec "hello_worker.rb"

Now upload it:

    #iron_worker upload hello

Now you’re work is ready to be used. You can quickly test it by running:


    iron_worker queue hello -p "{\"hello\": \"world\"}"

Now you can view the log for the worker with:


    iron_worker log -t 4fcfc8d11bab475a360abd92

Or look at the log in HUD.

Now it’s time to put your worker to work!

## Queue up tasks for your worker from your application

Now that we know the worker runs and uploads from your machine. Simply add the following to your `config/environments/development.rb`:


    ENV['IRON_WORKER_TOKEN'] = 'YOUR TOKEN'
    ENV['IRON_WORKER_PROJECT_ID'] = 'YOUR PROJECT ID'

If you’re using bundler, add the following to your `Gemfile`:

Assuming you’re using Rails, let’s add some code to one of your controllers. For instance, let’s say you have a controller called `WelcomeController`:


    class WelcomeController &lt; ApplicationController
      def index
        iron_worker = IronWorkerNG::Client.new
        iron_worker.tasks.create("hello", "foo"=&gt;"bar")
      end
    end


## <a id='sample-app'></a>Sample Applications ##

Sample Apps in binary, dotnet, go, java, node, php, python, and ruby!

[IronWorker Examples on GitHub](https://github.com/iron-io/iron_worker_examples)

### Next steps

This is just the tip of the iceberg. IronWorker has a robust API that allows for a lot more interaction with your workers. You may want to try:

You can also check out some example workers:

  * We have a [full repository][6] of IronWorker examples for Rails on Github.

### Troubleshooting

When trying to troubleshoot a worker, the best first step is to try and run the worker locally. If the worker runs locally, it should run on the cloud. You can also access your worker logs through the Iron.io HUD. These logs will show you any errors thrown or debug messages you log while the worker is running.

The most common source of worker errors is a mismatch between your local environment and the cloud’s environment. Double-check your `Gemfile` and your Ruby version – workers run under Ruby &gt;1.9. Also, make sure your `Gemfile.lock` has been updated. Run `bundle install` to make sure.

## <a id='dashboard'></a>Dashboard ##

You can view and analyze all your workers from the HUD...

![ironworkers on the hud][1]
  
## Share your projects with other people

Each of your projects can be shared with coworkers and friends. It's easy and just takes a few seconds. They'll get an invite to signup for Iron.io for free and have automatic access to the project once completed.
![Sharing your Iron Worker Project][2]

## <a id='support'></a>Support ##

Provider Support Instructions

- [Dev Center](http:www.dev.iron.io)
- [Live Public Support](http://get.iron.io/chat)
- [Iron.io on GitHub](https://github.com/iron-io)
- [Frequently Asked Questions](http://dev.iron.io/faq)
- [Report an Issue](https://github.com/iron-io/issues/issues)

  [1]: http://www.iron.io/assets/screenshots/home-scrnshot-worker-1.png
  [2]: https://d2oawfjgoy88bd.cloudfront.net/523a211b2cdcf276fb5dae02/523a211c2cdcf276fb5dae04/528be904888b9d471f460281.png?Expires=1384987278&Signature=Bt8WG1evom8MFsh1rLSWqF2KFBK1c6l4tGWjuaTRMbw~jvDYBQY6QvdyCKB29Q2TkjvIb0n5rX9XvWWTEti5MFCJYKHwpKdjcdePk9vv0OhBU0vRCdfwotpPNemnkfQ5DvBBJXb7FxH3cWbN~3TiZnlmB0gMXlbnDtciLoakbgjkALTZsy1nBrAapUQ6VQWqjA9B6~Kb6gBTBP~2Ep8BN63970GtgR5ecBtx1OnsCFFrnFAodzfbUzcPj8AMONSsNjIowLbYPNP8OEePl89Z2U~lXQa7lcvWMAnlV8rzz6Ftvno5C8Ly~YS2C52N~3Zj9Lm-vD9QY4gX7M9-lzjoKg__&Key-Pair-Id=APKAJHEJJBIZWFB73RSA