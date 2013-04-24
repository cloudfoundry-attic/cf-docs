---
title: Grails - Service Bindings
---

## <a id='intro'></a>Introduction ##

Cloud Foundry provides extensive support for connecting a Grails application to services such as MySQL, vFabric Postgres, MongoDB, Redis, and RabbitMQ. In many cases, a Grails application running on Cloud Foundry can automatically detect and configure connections to services. For more advanced cases, you can control service connection parameters yourself. 

## <a id='plugin'></a>Cloud Foundry Grails Plugin ##

Cloud Foundry provides a [plugin for Cloud Foundry integration](http://grails.org/plugin/cloud-foundry). The Cloud Foundry Grails plugin provides Grails command-line alternatives to the `cf` command line tool, and supports auto-reconfiguration of services in a Grails application. 

### <a id="plugin-install"></a>Installing the Grails Plugin ###

To use the Cloud Foundry Grails plugin in your project, add it as a `compile` dependency in your `BuildConfig.groovy` file. You will also need the Spring Framework Milestone repository in the `repositories` section of `BuildConfig.groovy` to resolve some dependencies:

~~~groovy
  repositories {
    grailsHome()
    mavenCentral()
    grailsCentral()
    mavenRepo "http://maven.springframework.org/milestone/"
  }

  plugins {
    compile ':cloud-foundry:1.2.3'
  }
~~~

The plugin will need information about the Cloud Foundry environment to target and your user account. This information can be added to your application's `Config.groovy` file or `~/.grails/settings.groovy`: 

~~~groovy
grails.plugin.cloudfoundry.target = 'api.cloudfoundry.com'
grails.plugin.cloudfoundry.username = 'your.email@server.com'
grails.plugin.cloudfoundry.password = 'password'
~~~

See the [plugin documentation](http://grails-plugins.github.io/grails-cloud-foundry/docs/manual/guide/3%20Configuration.html) for a full list of configuration options. 

### <a id="plugin-using"></a>Using the Grails Plugin ###

The Cloud Foundry Grails plugin provides an alternative to using the `cf` command line tool for managing applications, services, and other aspects of your Cloud Foundry account. See the [plugin documentation](http://grails-plugins.github.io/grails-cloud-foundry/docs/manual/guide/4%20Deploying%20applications.html) for more details on the provided commands. 

## <a id="auto"></a>Auto-Reconfiguration ##

Grails provides plugins for accessing SQL (using [Hibernate](http://grails.org/plugin/hibernate)), [MongoDB](http://www.grails.org/plugin/mongodb), and [Redis](http://grails.org/plugin/redis) services. If you install any of these plugins and configure them in your `Config.groovy` or `DataSource.groovy` file, the Cloud Foundry Grails plugin will re-configure the plugins when the app starts to provide the connection information to the plugins. 

If you were using all three types of services, your configuration might look like this: 

~~~groovy
environments {
  production {
    dataSource {
      url = 'jdbc:mysql://localhost/db?useUnicode=true&characterEncoding=utf8'
      dialect = org.hibernate.dialect.MySQLInnoDBDialect
      driverClassName = 'com.mysql.jdbc.Driver'
      username = 'user'
      password = "password"
    }
    mongo {
      host = 'localhost'
      port = 27107
      databaseName = "foo"
      username = 'user'
      password = 'password'
    }
    redis {
      host = 'localhost'
      port = 6379
      password = 'password'
      timeout = 2000
    }
  }
}
~~~

The `url`, `host`, `port`, `databaseName`, `username`, and `password` fields in this configuration will be overriden by the Cloud Foundry Grails plugin if it detects that the application is running in a Cloud Foundry environment. If you want to test the application locally against your own services, you can put real values in these fields. If the application will only be run against Cloud Foundry services, you can put placeholder values as shown here, but the fields must exist in the configuration. 

## <a id="manual"></a>Manual Configuration ##

If you do not want to use the Cloud Foundry Grails plugin, you can choose to configure the Cloud Foundry service connections manually. 

The best way to do the manual configuration is to use the `cloudfoundry-runtime` library to get the details of the Cloud Foundry environment the application is running in. To use this library, add it to the `dependencies` section in your `BuildConfig.groovy` file. You will also need the Spring Framework Milestone repository in the `repositories` section:

~~~groovy
  repositories {
    grailsHome()
    mavenCentral()
    grailsCentral()
    mavenRepo "http://maven.springframework.org/milestone/"
  }

  dependencies {
    compile "org.cloudfoundry:cloudfoundry-runtime:0.8.2"
  }
~~~

Then you can use the `cloudfoundry-runtime` API in your `DataSources.groovy` file to set the connection parameters. If you were using all three types of database services as in the auto-reconfiguration example, and the services were named "myapp-mysql", "myapp-mongodb", and "myapp-redis", your `DataSources.groovy` file might look like the one below. 

~~~groovy
import org.cloudfoundry.runtime.env.CloudEnvironment
import org.cloudfoundry.runtime.env.RdbmsServiceInfo
import org.cloudfoundry.runtime.env.RedisServiceInfo
import org.cloudfoundry.runtime.env.MongoServiceInfo

def cloudEnv = new CloudEnvironment()

environments {
  production {
    dataSource {
      pooled = true
      dbCreate = 'update'
      driverClassName = 'com.mysql.jdbc.Driver'

      if (cloudEnv.isCloudFoundry()) {
        def dbInfo = cloudEnv.getServiceInfo('myapp-mysql', RdbmsServiceInfo.class)
        url = dbInfo.url
        username = dbInfo.userName
        password = dbInfo.password
      } else {
        url = 'jdbc:postgresql://localhost:5432/petclinic'
        username = 'sa'
        password = ''
      }
    }
    mongo {
      if (cloudEnv.isCloudFoundry()) {
        def mongoInfo = cloudEnv.getServiceInfo('myapp-mongodb', MongoServiceInfo.class)
        host = mongoInfo.host
        port = mongoInfo.port
        databaseName = mongoInfo.database
        username = mongoInfo.userName
        password = mongoInfo.password
      } else {
        host = 'localhost'
        port = 27107
        databaseName = 'foo'
        username = 'user'
        password = 'password'
      }
    }
    redis {
      if (cloudEnv.isCloudFoundry()) {
        def redisInfo = cloudEnv.getServiceInfo('myapp-redis', RedisServiceInfo.class)
        host = redisInfo.host
        port = redisInfo.port
        password = redisInfo.password
      } else {
        host = 'localhost'
        port = 6379
        password = 'password'
      }
    }
  }
}
~~~

