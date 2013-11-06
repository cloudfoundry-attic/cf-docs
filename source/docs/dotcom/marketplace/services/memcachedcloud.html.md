---
title: Memcached Cloud
category: marketplace
---

[Memcached Cloud](http://garantiadata.com/memcached) is a fully-managed service for running your Memcached in a reliable and fail-safe manner. Your dataset is constantly replicated, so if a node fails, an auto-switchover mechanism guarantees data is served without interruption. Memcached Cloud provides various data persistence options as well as remote backups for disaster recovery purposes. You can quickly and easily get your apps up and running with Memcached Cloud through its add-on for Cloud Foundry, just tell us how much memory you need and get started instantly with your first Memcached bucket.
 
A Memcached bucket is created in seconds and from that moment on, all operations are fully-automated. The service completely frees developers from dealing with nodes, clusters, server lists, scaling and failure recovery, while guaranteeing absolutely no data loss.

## Creating A Memcached Cloud Service

Create a Memcached Cloud service with the following command:

        cf create-service memcachedcloud <plan name>

where `<plan name>` is the desired plan's name.

## Binding Your Memcached Cloud Service

Bind your Memcached Cloud service to your app, using the following command:

	cf bind-service <memcachedcloud_service_name> <app name>

Once your Memcached Cloud service is bound to your app, the service credentials will be stored in the `VCAP_SERVICES` env. variable in the following format:
	
	{
	  memcachedcloud-n/a: [
	    {
	      name: "memcachedcloud-1234a",
	      label: "memcachedcloud-n/a",
	      plan: "20mb",
	      credentials: {
	        servers: "pub-memcache-5678.us-east-1-1.1.ec2.garantiadata.com:5678",
	        username: "memcachedcloud-1234a",
	        password: "your_memcahced_password"
	      }
	    }
	  ]
	}

* [Ruby](#ruby)
* [Rails](#rails)
* [Sinatra](#sinatra)
* [Unicron](#unicorn)
* [Java](#java)
* [Python](#python)
* [Django](#django)
* [PHP](#php)

## <a id="ruby"></a>Using Memcached with Ruby
[Dalli](https://github.com/mperham/dalli) is a high performance pure Ruby client for accessing memcached servers, which uses the binary protocol.

For usage with Rails 3.x, update the Gemfile:
	
	gem 'dalli'  
	
And then install the gem via Bundler:

	bundle install

Parse your credentials as follows:
	
	memcachedcloud_service = JSON.parse(ENV['VCAP_SERVICES'])["memcachedcloud-n/a"]
	credentials = memcachedcloud_service.first["credentials"]

Lastly, in your `config/environments/production.rb`:
		
    	config.cache_store = :dalli_store, credentials.servers, { :username => credentials.username, :password => credentials.password }

### <a id="sinatra"></a>Configuring Memcached on Sinatra

Add this code snippet to your configure block:

	configure do
        . . .
		require 'dalli'
		memcachedcloud_service = JSON.parse(ENV['VCAP_SERVICES'])["memcachedcloud-n/a"]
		credentials = memcachedcloud_service.first["credentials"]
    	$cache = Dalli::Client.new(credentials.servers.split(','), :username => credentials.username, :password => credentials.password)
        . . .
	end

### <a id="unicorn"></a>Using Memcached on Unicorn

No special setup is required when using Memcached Cloud with a Unicorn server.
Users running Rails apps on Unicorn should follow the instructions in the [Configuring Memcached from Rails](#rails) section and users running Sinatra apps on Unicorn should follow the instructions in the [Configuring Memcached on Sinatra](#sinatra) section.

### Testing from Ruby
	
	$cache.set("foo", "bar")
	# => true
	$cache.get("foo")
	# => "bar"
	
## <a id="java"></a>Using Memcached with Java

[spymemcached](https://code.google.com/p/spymemcached/) is a simple, asynchronous, single-threaded memcached client written in java. You can download the latest build from: https://code.google.com/p/spymemcached/downloads/list.
For using the maven repository, start by specifying the repository:
	
	<repositories>
	    <repository>
	      <id>spy</id>
	      <name>Spy Repository</name>
	      <layout>default</layout>
	      <url>http://files.couchbase.com/maven2/</url>
	      <snapshots>
	        <enabled>false</enabled>
	      </snapshots>
	    </repository>
	</repositories>

And specify the actual artifact as follows: 

	<dependency>
	  <groupId>spy</groupId>
	  <artifactId>spymemcached</artifactId>
	  <version>2.8.9</version>
	  <scope>provided</scope>
	</dependency>

Configure connection to your Memcached Cloud service using the `VCAP_SERVICES` environment variable and the following code snippet:

	try {
		String vcap_services = System.getenv("VCAP_SERVICES");
		if (vcap_services != null && vcap_services.length() > 0) {
			// parsing memcachedcloud credentials
			JsonRootNode root = new JdomParser().parse(vcap_services);
			JsonNode "memcachedcloudNode = root.getNode("memcachedcloud-n/a");
			JsonNode credentials = "memcachedcloudNode.getNode(0).getNode("credentials");
			
			// building the memcached client
			AuthDescriptor ad = new AuthDescriptor(new String[] { "PLAIN" },
			        new PlainCallbackHandler(credentials.getStringValue("username"), credentials.getStringValue("password")));
				
			MemcachedClient mc = new MemcachedClient(
			          new ConnectionFactoryBuilder()
			              .setProtocol(ConnectionFactoryBuilder.Protocol.BINARY)
			              .setAuthDescriptor(ad).build(),
			          AddrUtil.getAddresses(credentials.getStringValue("servers")));
			
		}			
	} catch (InvalidSyntaxException ex) {
		// vcap_services could not be parsed.
	} catch (IOException ex) {
		// the memcached client could not be initialized. 
	} 
	
### Testing from Java

	mc.set("foo", 0, "bar");
	Object value = mc.get("foo");

## <a id="python"></a>Using Memcached with Python

[bmemcached](https://github.com/jaysonsantos/python-binary-memcached) is a pure, thread safe, python module to access memcached via it's binary protocol.
 
Use pip to install it:
 
	pip install python-binary-memcached

Configure connection to your Memcached Cloud service using `VCAP_SERVICES` environment variable and the following code snippet:
	
	import os
	import urlparse
	import bmemcached
	import json
	
	memcachedcloud_service = json.loads(os.environ['VCAP_SERVICES'])['"memcachedcloud-n/a'][0]
	credentials = memcached_service['credentials']
	mc = bmemcached.Client(credentials['servers'].split(','), credentials['username'], credentials['password'])
	
### Testing from Python
	
	mc.set('foo', 'bar')
	print client.get('foo')

### <a id="django"></a>Using Memcached with Django

Memcached can be used as a django cache backend, with [django-bmemcached](https://github.com/jaysonsantos/django-bmemcached). 

To do so, install django-bmemcached:
 
	pip install django-bmemcached

Next, configure your `CACHES` in the `settings.py` file:

	import os
	import urlparse
	import json
	
	memcachedcloud_service = json.loads(os.environ['VCAP_SERVICES'])['memcachedcloud-n/a'][0]
	credentials = memcachedcloud_service['credentials']
	CACHES = {
		'default': {
		'BACKEND': 'django_bmemcached.memcached.BMemcached',
		'LOCATION': credentials['servers'].split(','),
		'OPTIONS': {
            		'username' credentials['username'],
            		'password': credentials['password']
			
        }
	  }
	}

### Testing from Django

	from django.core.cache import cache
	cache.set("foo", "bar")
	print cache.get("foo")
	
## <a id="php"></a>Using Memcached with PHP

[PHPMemcacheSASL](https://github.com/ronnywang/PHPMemcacheSASL) is a simple PHP class with SASL support.

Include the class in your project, and configure a connection to your Memcached Cloud service using `VCAP_SERVICES` environment variable with the following code snippet:
	
	<?php
	include('MemcacheSASL.php');
	
	$vcap_services = getenv("VCAP_SERVICES");
	$"memcachedcloud_service = json_decode($vcap_services, true)[""memcachedcloud-n/a"][0]
	$credentials = $"memcachedcloud_service["credentials"]
	
	$mc = new MemcacheSASL;
	list($host, $port) = explode(':', $credentials['servers']);
	$mc->addServer($host, $port);
	$mc->setSaslAuthData($credentials['username], $credentials['password']);
	
### Testing from PHP

	$mc->add("foo", "bar");
	echo $mc->get("foo");

## Dashboard

Our dashboard presents all performance and usage metrics of your Memcached Cloud service on a single screen, as shown below:

![Dashboard](https://s3.amazonaws.com/memcached-cloud-docs/CFdashboard.png)

To access your Memcached Cloud dashboard, simply click the 'Manage' button next to the Memcached Cloud service on your app space console.

You can then find your dashboard under the `MY DATABASES` menu.

## Managing Services

You can continue [managing your services from the command line](http://docs.cloudfoundry.com/docs/using/services/managing-services.html).

## Support

Any Memcached Cloud support issues or product feedbacks are welcome via email at support@garantiadata.com.
Please make sure you are familiar with the CloudFoundry method of [contacting service providers for support](http://docs.cloudfoundry.com/docs/dotcom/services-marketplace/contacting-service-providers-for-support.html).

## Additional resources

* [Developers Resources](http://garantiadata.com/memcached/developers)
* [Memcached Wiki](https://code.google.com/p/memcached/wiki/NewStart)
