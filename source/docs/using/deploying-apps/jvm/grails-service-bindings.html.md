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

The plugin will need information about the Cloud Foundry environment to target and your user account. This information can be added to your `Config.groovy` file or `~/.grails.settings.groovy`: 

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
~~~

The `url`, `host`, `port`, `databaseName`, `username`, and `password` fields in this configuration will be overriden by the plugin if it detects that the application is running in a Cloud Foundry environment. If you want to test the application locally against your own services, you can put real values in these fields. If the application will only be run against Cloud Foundry services, you can put placeholder values as shown here, but the fields must exist in the configuration. 

## <a id="manual"></a>Manual Configuration ##

Cloud Foundry exposes information about bound service to an application in a `VCAP_SERVICES` environment variable. If you are not using the Cloud Foundry Grails plugin, or if you want to configure the services yourself, you can parse the information stored in this environment variable in `Config.groovy` or `DataSource.groovy`. 

