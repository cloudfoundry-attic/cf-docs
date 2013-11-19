---
title: Iron Worker
---

IronWorker is a multi-language worker platform that runs tasks in the background, in parallel, and at massive scale.

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