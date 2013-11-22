---
title: IronMQ
---

IronMQ is a reliable message queue service that lets you connect systems and build distributed apps that scale effortlessly and eliminate any single points of failure.

## <a id='managing'></a>Managing Services ##

[Managing services from the command line](../../../using/services/managing-services.html)

### Creating a Service Instance ##

An instance of this service can be provisioned via the CLI with the following command:

<pre class="terminal">
  $ cf create-service ironmq
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

## Language Support

IronMQ has clients for [a lot of languages][3], and you can always use [the REST API][4] (or write your own!).

## Ruby

We’re going to need to install the Ruby gem, for development purposes:

<pre class="terminal">
$ gem install iron_mq
</pre>

If you’re building for a Rails application or anything that uses Bundler, add the following to your Gemfile:

~~~
gem 'iron_mq'
~~~

Now you have a simple helper that allows you to interact with your queues:

~~~ruby
# Create an IronMQ::Client object
@ironmq = IronMQ::Client.new()

# Get a queue (if it doesn't exist, it will be created when you first post a message)
@queue = @ironmq.queue("my_queue")

# Post a message
@queue.post("hello world!")

# Get a message
msg = @queue.get()
p msg

# Delete a message (you must delete a message when you're done with it or it will go back on the queue after a timeout)
msg.delete # or @queue.delete(msg.id)
~~~

## Java

We’re going to need to install [the jar file][5] for the official IronMQ Java library. If you’re using Maven, you can also add the `http://iron-io.github.com/maven/repository` repository as a dependency.

Once you have the jar file added as a dependency, you have a simple wrapper that allows you to interact with your queues:

~~~java

// Get your Iron.io credentials from the environment
Map env = System.getenv();

// Create a Client object
Client client = new Client(env.get("IRON_MQ_PROJECT_ID"), env.get("IRON_MQ_TOKEN"), Cloud.IronAWSUSEast);

// Get a queue (if it doesn't exist, it will be created when you first post a message)
Queue queue = client.queue("my_queue");

// Post a message
queue.Push("hello world!");

// Get a message
Message msg = queue.get();
System.out.println(msg.getBody());

// Delete a message (you must delete a message when you're done with it or it will go back on the queue after a timeout)
queue.deleteMessage(msg);
~~~

## Python

We’re going to have to install the [Python client library][6] for IronMQ. You can do this using `pip install iron_mq` or `easy_install iron_mq`.

Once the package is installed, you have a simple wrapper that allows you to interact with your queues:

~~~python
# Create an IronMQ client object
mq = IronMQ()

# Get a queue (if it doesn't exist, it will be created when you first post a message)
queue = mq.queue("my_queue")

# Post a message
queue.post("hello world!")

# Get a message
msg = queue.get()
print msg

# Delete a message (you must delete a message when you're done with it or it will go back on the queue after a timeout)
queue.delete(msg["messages"][0]["id"])
~~~

## Clojure

We’re going to need to add the [IronMQ Clojure client][7] to your project.clj:


[iron_mq_clojure "1.0.3"]

Use these to create a client that allows you to interact with your queues:

~~~clojure
(require '[iron-mq-clojure.client :as mq])

(def client (mq/create-client (System/getenv "IRON_MQ_TOKEN") (System/getenv "IRON_MQ_PROJECT_ID")))

; Post a message
(mq/post-message client "my_queue" "Hello world!")

; Get a message
(let [msg (mq/get-message client "my_queue")]
(println (get msg "body"))

; Delete a message (you must delete a message when you're done with it or it will go back on the queue after a timeout)
(mq/delete-message client "my_queue" msg))
~~~

## Node.js

We’re going to need to the [IronMQ Node.js client][8] to interact with our queues. You can get it using `npm install iron_mq` or by downloading the source from Github (though you’ll need [iron_core_node][9], too).

Once that’s done, you can require it to get a simple wrapper for the API:

~~~ruby
var iron_mq = require("iron_mq");

var client = new iron_mq.Client({"queue_name": "my_queue"});

// Post a message
client.post("test message", function(error, body) {
console.log(body);
console.log(error);
});

// Get a message
client.get({}, function(error, body) {
console.log(error);
console.log(body);
if(error == null) {
// Delete a message
client.del(body["id"], function(error, body) {
console.log(error);
console.log(body);
});
}
});
~~~

## Next Steps

To get into more advanced uses of IronMQ, you may want to check out the [API docs][4]

## Support

You’re also welcome to stop by the [Iron.io support chat room][12] and chat with Iron.io staff about issues. You can also find more resources at the [Iron.io Dev Center][13].

## <a id='sample-app'></a>Integrations ##

<ul>
  <li><a href="/mq/integrations/delayed_job" >Delayed Job for Rails</a></li>
  <li><a href="http://www.sumoheavy.com/message-queues-in-magento/" target="_blank" >Zend Framework</a></li>
  <li><a href="/mq/integrations/celery/" >Celery for Python</a></li>
  <li><a href="http://www.yiiframework.com/extension/yiiron/" target="_blank" >Yii Framework</a></li>
  <li><a href="http://bundles.laravel.com/bundle/ironmq" target="_blank" >Laravel Framework</a></li>
  <li><a href="http://drupal.org/project/ironio" target="_blank" >Drupal</a>
    <li><a href="http://tech.pro/tutorial/1196/blacksmith-ironmq-client-library-fun-with-queues" target="_blank" >.NET Framework</a></li>
  </ul>

  ## <a id='dashboard'></a>Dashboard (HUD) ##

  You can view and analyze all your queues from the HUD...

  ![ironworkers on the hud][1]

  ## View analytics and gain insight about your queues

  ![ironmq analytics][2]
  
  ## Share your projects with other people

  Each of your projects can be shared with coworkers and friends. It's easy and just takes a few seconds. They'll get an invite to signup for Iron.io for free and have automatic access to the project once completed.
  ![Sharing your Iron Worker Project][3]

  ## <a id='support'></a>Support ##

  - [Dev Center](http:www.dev.iron.io)
  - [Live Public Support](http://get.iron.io/chat)
  - [Iron.io on GitHub](https://github.com/iron-io)
  - [Frequently Asked Questions](http://dev.iron.io/faq)
  - [Report an Issue](https://github.com/iron-io/issues/issues)


  [1]: http://www.iron.io/assets/screenshots/home-scrnshot-mq-1.png
  [2]: http://www.iron.io/assets/screenshots/home-scrnshot-mq-2.png
  [3]: https://d2oawfjgoy88bd.cloudfront.net/523a211b2cdcf276fb5dae02/523a211c2cdcf276fb5dae04/528be904888b9d471f460281.png?Expires=1384987278&Signature=Bt8WG1evom8MFsh1rLSWqF2KFBK1c6l4tGWjuaTRMbw~jvDYBQY6QvdyCKB29Q2TkjvIb0n5rX9XvWWTEti5MFCJYKHwpKdjcdePk9vv0OhBU0vRCdfwotpPNemnkfQ5DvBBJXb7FxH3cWbN~3TiZnlmB0gMXlbnDtciLoakbgjkALTZsy1nBrAapUQ6VQWqjA9B6~Kb6gBTBP~2Ep8BN63970GtgR5ecBtx1OnsCFFrnFAodzfbUzcPj8AMONSsNjIowLbYPNP8OEePl89Z2U~lXQa7lcvWMAnlV8rzz6Ftvno5C8Ly~YS2C52N~3Zj9Lm-vD9QY4gX7M9-lzjoKg__&Key-Pair-Id=APKAJHEJJBIZWFB73RSA
  [3]: http://dev.iron.io/mq/libraries/
  [4]: http://dev.iron.io/mq/reference/api/
  [5]: https://github.com/iron-io/iron_mq_java/downloads
  [6]: https://github.com/iron-io/iron_mq_python
  [7]: https://github.com/iron-io/iron_mq_clojure
  [8]: https://github.com/iron-io/iron_mq_node
  [9]: https://github.com/iron-io/iron_core_node
  [12]: http://get.iron.io/chat
  [13]: http://dev.iron.io