---
title: Deploying Apps
---

Cloud Foundry supports many frameworks and runtimes, including these: 

| Runtime        | Framework                                                                             |
| :------------- | :-------------                                                                        |
| Javascript     | [Node.js](/docs/using/deploying-apps/javascript/index.html)                           |
| Java / JVM     | [Java Spring, Grails, Scala Lift, and Play](/docs/using/deploying-apps/jvm/index.html)|
| Ruby           | [Rack, Rails, or Sinatra](/docs/using/deploying-apps/ruby/index.html)                 |

Cloud Foundry supports these frameworks and runtimes using a buildpack model. Some of the <a href="https://devcenter.heroku.com/articles/third-party-buildpacks">Heroku third party buildpacks</a> will work, but your experience may vary. To push an application using one of these buildpacks use `cf push [appname] --buildpack=[git url]`

You can also build your own [Custom Buildpack](buildpacks.html).

How you deploy your application depends on the Cloud Foundry you are targeting. 

For **run.pivotal.io**, you can follow the [Getting Started document here](../../dotcom/getting-started.html).
