---
title: Iron Worker
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


## <a id='sample-app'></a>Sample Applications ##

Sample Apps in binary, dotnet, go, java, node, php, python, and ruby!

[IronWorker Examples on GitHub](https://github.com/iron-io/iron_worker_examples)
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