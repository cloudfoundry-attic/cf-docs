---
title: Spring - Service Bindings
---

### Quick links ###
* [Introduction](#intro)
* [Auto-Reconfiguration](#auto)
    * [Opting out of Auto-Reconfiguration](#optout)
* [Manual Configuration](#manual)
    * [Cloud Namespace](#namespace)
    * [Profiles](#profiles)
* [Service-specific Details](#services)
    * [MySQL and vFabric Postgres](#rdbms)
    * [MongoDB](#mongodb)
    * [Redis](#redis)
    * [RabbitMQ](#rabbitmq)

## <a id='intro'></a>Introduction ##

## <a id='auto'></a>Auto-Reconfiguration ##

If your Spring application requires services (such as a database or RabbitMQ), you might be able to deploy your application to Cloud Foundry without changing any code. In this case, Cloud Foundry automatically re-configures the relevant bean definitions to bind them to cloud services. 

Cloud Foundry auto-reconfigures applications only if the following items are true for your application:

* You bind only one service instance of a given service type to your application. In this context, MySQL and vFabric Postgres are considered the same service type (relational database), so if you have bound both a MySQL and a vFabric Postgres service to your application, auto-reconfiguration will not occur.
* You include only one bean of a matching type in your Spring application context file. For example, you can have only one bean of type `javax.sql.DataSource`.

With auto-reconfiguration, Cloud Foundry creates the database or connection factory itself, using its own values for properties such as host, port, username and so on. For example, if you have a single `javax.sql.DataSource` bean in your application context that Cloud Foundry reconfigures and binds to its own database service, Cloud Foundry doesn’t use the username and password and driver URL you originally specified. Rather, it uses its own internal values. This is transparent to the
application, which really only cares about having a relational database to which it can write data but doesn’t really care what the specific properties are that created the database. Also note that if you have customized the configuration of a service (such as the pool size or connection properties), Cloud Foundry auto-reconfiguration ignores the customizations.

For more information on auto-reconfiguration of specific services types, see the [Service-specific Details](#services) section.

### <a id='optout'></a>Opting out of Auto-Reconfiguration ###

Sometimes you may not want Cloud Foundry to auto-reconfigure your Spring application. There are two ways to opt out of auto-reconfiguration:

* When you deploy your application using vmc or STS, specify that the framework is `JavaWeb` instead of `Spring`. Note that in this case your application will not be able to take advantage of the [Spring Profiles](#profiles) feature.
* Use the [`<cloud:>` namespace](#namespace) elements in your Spring application context file to explicitly create a bean that represents a service. This makes auto-reconfiguration unnecessary. 

## <a id='manual'></a>Manual Configuration ##

If your Spring application cannot take advantage of Cloud Foundry’s auto-reconfiguration feature, or you want more control over the configuration, the additional steps you must take are very simple. 

### <a id='namespace'></a>Cloud Namespace ###

The `<cloud:>` namespace can be used in Spring XML application context configuration files to manually configure services. This allows multiple services of the same type to be used in a Spring application. The `<cloud:>` namespace elements provide defaults for most common configurations.

The basic steps to update your Spring application to use any of the Cloud Foundry services are as follows:

* Update your application build process to include a dependency on the `org.cloudfoundry.cloudfoundry-runtime` artifact. For example, if you use Maven to build your application, the following `pom.xml` snippet shows how to add this dependency:

~~~xml
<dependencies>
    <dependency>
        <groupId>org.cloudfoundry</groupId>
        <artifactId>cloudfoundry-runtime</artifactId>
        <version>0.8.1</version>
    </dependency>

    <!-- additional dependency declarations -->
</dependencies>
~~~ 

* Update your application build process to include the Spring Framework Milestone repository. The following `pom.xml` snippet shows how to do this for Maven:

~~~xml
<repositories>
    <repository>
          <id>org.springframework.maven.milestone</id>
           <name>Spring Maven Milestone Repository</name>
           <url>http://maven.springframework.org/milestone</url>
           <snapshots>
                   <enabled>false</enabled>
           </snapshots>
    </repository>

    <!-- additional repository declarations -->
</repositories>
~~~

* In your Spring application, update all application context files that will include the Cloud Foundry service declarations, such as a data source, by adding the `<cloud:>` namespace declaration and the location of the Cloud Foundry services schema, as shown in the following snippet:

~~~xml
<beans xmlns="http://www.springframework.org/schema/beans"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:context="http://www.springframework.org/schema/context"
    xmlns:cloud="http://schema.cloudfoundry.org/spring"
    xsi:schemaLocation="http://www.springframework.org/schema/beans
        http://www.springframework.org/schema/beans/spring-beans-3.2.xsd
        http://www.springframework.org/schema/context
        http://www.springframework.org/schema/context/spring-context-3.2.xsd
        http://schema.cloudfoundry.org/spring
        http://schema.cloudfoundry.org/spring/cloudfoundry-spring.xsd"
        >

    <!-- bean declarations -->

</beans>
~~~

You can now specify the Cloud Foundry services in the Spring application context file by using the `<cloud:>` namespace along with the name of specific elements. Cloud Foundry provides elements for each of the supported services: database (MySQL and vFabric Postgres), Redis, MongoDB, and RabbitMQ. See the [Service-specific Details](#services) section for details on the namespace elements for each of these services.

### <a id='profiles'></a>Profiles ###

## <a id='services'></a>Service-specific Details ##

The following sections describe Spring auto-reconfiguration and manual configuration for the services supported by Cloud Foundry. 

### <a id='rdbms'></a>MySQL and vFabric Postgres ###

#### Auto-Reconfiguration

Auto-reconfiguration occurs if Cloud Foundry detects a `javax.sql.DataSource` bean in the Spring application context. The following snippet of a Spring application context file shows an example of defining this type of bean which Cloud Foundry will detect and potentially auto-reconfigure:

~~~xml
<bean class="org.apache.commons.dbcp.BasicDataSource" destroy-method="close" id="dataSource">
    <property name="driverClassName" value="org.h2.Driver" />
    <property name="url" value="jdbc:h2:mem:" />
    <property name="username" value="sa" />
    <property name="password" value="" />
</bean>
~~~ 

The relational database that Cloud Foundry actually uses depends on the service instance you explicitly bind to your application when you deploy it: MySQL or vFabric Postgres. Cloud Foundry creates either a commons DBCP or Tomcat datasource.

Cloud Foundry will internally generate values for the following properties: `driverClassName`, `url`, `username`, `password`, `validationQuery`.

#### Manual Configuration ####

The `<cloud:data-source>` element provides an easy way for you to configure a JDBC data source in your Spring application. Later, when you actually deploy the application, you bind a particular MySQL or vFabric Postgres service instance to it.

##### Basic Manual Configuration 

The following example shows a simple way to configure a JDBC data source that will be injected into a `org.springframework.jdbc.core.JdbcTemplate` bean:

~~~xml
<cloud:data-source id="dataSource" />

<bean id="jdbcTemplate" class="org.springframework.jdbc.core.JdbcTemplate">
  <property name="dataSource" ref="dataSource" />
</bean>
~~~

In the preceding example, note that no specific information about the datasource is supplied, such as the JDBC driver classname, the specific URL to access the database, or the database user. Instead, Cloud Foundry will provide these values at runtime, using appropriate information from the specific type of database service instance you bind to your application.

The following table lists the attributes of the `<cloud:data-source>` element:

| Attribute | Description | Type |
|-----------|-------------|------|
| id | The ID of this data source. The JdbcTemplate bean uses this ID when it references the data source. Default value is the name of the bound service instance. | String |
| service-name | The name of the data source service. You specify this attribute only if you are binding multiple database services to your application and you want to specify which particular service instance binds to a particular Spring bean. The default value is the name of the bound service instance. | String |

##### Advanced Manual Configuration 

The example above shows the configuration of a simple JDBC data source; Cloud Foundry uses the most common configuration options when it actually creates the data source at runtime. You can, however, specify some of these configuration options using two child elements of `<cloud:data-source>`: `<cloud:connection>` and `<cloud:pool>`.

The `<cloud:connection>` child element takes a single String attribute (properties) that you use to specify connection properties you want to send to the JDBC driver when establishing new database connections. The format of the string must be semi-colon separated name/value pairs (`[propertyName=property;]`).

The `<cloud:pool>` child element takes the following two attributes:

| Attribute | Description | Type | Default |
|-----------|-------------|------|---------|
| pool-size | Specifies the size of the connection pool. Set the value to either the maximum number of connections in the pool, or a range of the minimum and maximum number of connections separated by a dash. | int | Default minimum is `0`. Default maximum is `8`. These are the same defaults as the Apache Commons Pool. |
| max-wait-time | In the event that there are no available connections, this attribute specifies the maximum number of milliseconds that the connection pool waits for a connection to be returned before throwing an exception. Specify `-1` to indicate that the connection pool should wait forever. | int | Default value is `-1` (forever). |

The following example shows how to use these advanced data source configuration options:

~~~xml
<cloud:data-source id="mydatasource">
  <cloud:connection properties="charset=utf-8" />
  <cloud:pool pool-size="5-10" max-wait-time="2000" />
</cloud:data-source>
~~~

In the preceding example, the JDBC driver is passed the property that specifies that it should use the UTF-8 character set. The minimum and maximum number of connections in the pool at any given time is 5 and 10, respectively. The maximum amount of time that the connection pool waits for a returned connection if there are none available is 2000 milliseconds (2 seconds), after which the JDBC connection pool throws an exception.

### <a id='mongodb'></a>MongoDB ###

#### Auto-Reconfiguration

You must use [Spring Data MongoDB](http://www.springsource.org/spring-data/mongodb) 1.0 M4 or later for auto-reconfiguration to work.

Auto-reconfiguration occurs if Cloud Foundry detects a `org.springframework.data.document.mongodb.MongoDbFactory` bean in the Spring application context. The following snippet of a Spring application context file shows an example of defining this type of bean which Cloud Foundry will detect and potentially auto-reconfigure:

~~~xml
<mongo:db-factory
    id="mongoDbFactory"
    dbname="pwdtest"
    host="127.0.0.1"
    port="1234"
    username="test_user"
    password="test_pass"  />
~~~ 

Cloud Foundry will create a `SimpleMongoDbFactory` with its own values for the following properties: `host`, `port`, `username`, `password`, `dbname`.

#### Manual Configuration ####

The `<cloud:mongo-db-factory>` namespace provides a simple way for you to manually configure a MongoDB connection factory for your Spring application.

##### Basic Manual Configuration #####

The following example shows a `MongoDbFactory` configuration that will be injected into a `org.springframework.data.mongodb.core.MongoTemplate` bean:

~~~xml
<cloud:mongo-db-factory id="mongoDbFactory" />

<bean id="mongoTemplate" class="org.springframework.data.mongodb.core.MongoTemplate">
    <constructor-arg ref="mongoDbFactory"/>
</bean>
~~~

The following table lists the attributes of the `<cloud:mongo-db-factory>` element.

<table>
<tbody>
  <tr>
    <th>Attribute</th>
    <th>Description</th>
    <th>Type</th>
  </tr>
  <tr>
    <td>id</td>
    <td>The ID of this MongoDB connection factory.  The MongoTemplate bean uses this ID when it references the connection factory. <br>Default value is the name of the bound service instance.</td>
    <td>String</td>
  </tr>
  <tr>
  <td>service-name</td>
    <td>The name of the MongoDB service. <br>You specify this attribute only if you are binding multiple MongoDB services to your application and you want to specify which particular service instance binds to a particular Spring bean.  The default value is the name of the bound service instance.</td>
    <td>String</td>
  </tr>
  <tr>
    <td>write-concern</td>
    <td>Controls the behavior of writes to the data store.  The values of this attribute correspond to the values of the `com.mongodb.WriteConcern` class.
       <p>If you do not specify this attribute, then no `WriteConcern` is set for the database connections and all writes default to NORMAL.  </p>
       <p>The possible values for this attribute are as follows:</p>
       <ul>
         <li><b>NONE</b>: No exceptions are raised, even for network issues.</li>
         <li><b>NORMAL</b>: Exceptions are raised for network issues, but not server errors.</li>
         <li><b>SAFE</b>: MongoDB service waits on a server before performing a write operation.  Exceptions are raised for both network and server errors.</li>
         <li><b>FSYNC_SAVE</b>: MongoDB service waits for the server to flush the data to disk before performing a write operation.  Exceptions are raised for both network and server errors.</li>
       </ul>
     </td>
     <td>String</td>
   </tr>
</tbody>
</table>

##### Advanced Manual Configuration #####

The preceding section shows how to configure a simple MongoDB connection factory using default values for the options. This is adequate for many environments. However, you can further configure the connection factory by specifying the optional `<cloud:mongo-options>` child element of `<cloud:mongo-db-factory>`.

The following example shows how to use the advanced MongoDB options:

~~~xml
<cloud:mongo-db-factory id="mongoDbFactory" write-concern="FSYNC_SAFE">
  <cloud:mongo-options connections-per-host="12" max-wait-time="2000" />
</cloud:mongo-db-factory>
~~~

In the preceding example, the maximum number of connections is set to 12 and the maximum amount of time that a thread waits for a connection is 1 second. The WriteConcern is also specified to be the safest possible (FSYNC_SAFE).

The `<cloud:mongo-options>` child element takes the following attributes:

| Attribute | Description | Type | Default |
|-----------|-------------|------|---------|
| connections-per-host | Specifies the maximum number of connections allowed per host for the MongoDB instance. Those connections will be kept in a pool when idle. Once the pool is exhausted, any operation requiring a connection will block while waiting for an available connection. | int | 10 | 
| max-wait-time | Specifies the maximum wait time (in milliseconds) that a thread waits for a connection to become available. | int | 120,000 (2 minutes) |

### <a id='redis'></a>Redis ###

#### Auto-Reconfiguration

You must be using [Spring Data Redis](http://www.springsource.org/spring-data/redis) 1.0 M4 or later for auto-reconfiguration to work.

Auto-reconfiguration occurs if Cloud Foundry detects a `org.springframework.data.redis.connection.RedisConnectionFactory` bean in the Spring application context. The following snippet of a Spring application context file shows an example of defining this type of bean which Cloud Foundry will detect and potentially auto-reconfigure:

~~~xml
<bean id="redis"
      class="org.springframework.data.redis.connection.jedis.JedisConnectionFactory"
      p:hostName="localhost" p:port="6379"  />
~~~

Cloud Foundry will create a `JedisConnectionFactory` with its own values for the following properties: `host`, `port`, `password`. This means that you must package the Jedis JAR in your application. Cloud Foundry does not currently support the JRedis and RJC implementations.

#### `<cloud:data-source>` Namespace ####

### <a id='rabbitmq'></a>RabbitMQ ###

#### Auto-Reconfiguration

You must be using [Spring AMQP](http://www.springsource.org/spring-amqp) 1.0 or later for auto-reconfiguration to work. Spring AMQP provides publishing, multi-threaded consumer generation, and message conversion. It also facilitates management of AMQP resources while promoting dependency injection and declarative configuration.

Auto-reconfiguration occurs if Cloud Foundry detects a `org.springframework.amqp.rabbit.connection.ConnectionFactory` bean in the Spring application context. The following snippet of a Spring application context file shows an example of defining this type of bean which Cloud Foundry will detect and potentially auto-reconfigure:

~~~xml
<rabbit:connection-factory
    id="rabbitConnectionFactory"
    host="localhost"
    password="testpwd"
    port="1238"
    username="testuser"
    virtual-host="virthost" />
~~~

Cloud Foundry will create a `org.springframework.amqp.rabbit.connection.CachingConnectionFactory` with its own values for the following properties: `host`, `virtual-host`, `port`, `username`, `password`.

#### `<cloud:data-source>` Namespace ####

