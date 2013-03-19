---
title: Using the CFoundry Ruby Gem to manage applications
---

## <a id='intro'></a>Introduction ##

This is a guide to using the CFoundry Ruby Gem to manage an account on a Cloud Foundry instance.

## <a id='connecting'></a>Connecting to Cloud Foundry ##

First of all make sure you have included the cfoundry gem as part of your application, add it the Gemfile if your are using bundler;

~~~ruby

source 'https://rubygems.org'
gem 'cfoundry'

~~~

The first step to using cfoundry is creating a Client instance and logging in;

~~~ruby
require 'cfoundry'

endpoint = 'http://api.cloudfoundry.com'
username = 'my_cf_user'
password = 'my_cf_password'

client = CFoundry::Client.new endpoint
client.login username, password
~~~

Test the connection by listing the available services;

~~~ruby

client.services.collect { |x| x.description }

~~~

## <a id='persist-authentication'></a>Persisting Authentication (Using cf tokens) ##

A far safer way of creating a cfoundry client object without potentially exposing your credentials in source code is to login using cf and then use the generated auth token to login in. The auth tokens are stored by cf in ~/.cf/tokens.yml. The following snippet of ruby code shows how to open this file, select the right auth token and then use it to log in to Cloud Foundry.

~~~ruby

require 'cfoundry'
require 'yaml'

home = ENV['HOME']
endpoint = 'https://api.cloudfoundry.com'

config = YAML.load File.read("#{home}/.cf/tokens.yml")
token = CFoundry::AuthToken.from_hash config[endpoint]

client = CFoundry::Client.new endpoint, token

~~~

Once the client object is created, it can be used in the same fashion as before.

## <a id='organisations'></a>Organisations ##

An account will always belong to at least one organization. Inspect the organizations using the client class;

~~~ruby

>> client.organizations
=> [#<CFoundry::V2::Organization '1e3ce9fb-50ac-4d2a-9506-f4d671c00f50'>, #<CFoundry::V2::Organization '77ab28ea-2b6e-4a7f-86c8-2c2df2714535'>]

~~~

## <a id='spaces'></a>Spaces ##

Each organisation on Cloud Foundry can be separated in to spaces, we can easily inspect these via the client class;

~~~ruby

>> client.spaces.collect { |x| x.name }
=> ["development", "staging", "production"]

~~~

Creating and deleting a space is also straight forward;

~~~ruby

# create a space
new_space = client.space
new_space.name = 'New Space'
new_space.organization = client.organizations.first
new_space.create!

# then, delete it
new_space.delete!

~~~

There are several methods for retrieving a space;

~~~ruby

# find space by name
client.space_by_name 'development'
=> #<CFoundry::V2::Space '07b7271f-bcfa-47df-aa9b-3911c60a0d65'>

client.methods.grep /space_by/
=> [:spaces_by_name, :spaces_by_organization_guid, :spaces_by_developer_guid, :spaces_by_app_guid]

~~~

## <a id='services'></a>Services, Service Instances and Service Plans ##

On Cloud Foundry each service has many service plans, depending on the instance, they will vary greatly. For the purposes of this document we will always use the first service plan for each service.

The Client class contains four service methods; services, service_instances, service_instance_by_name and service_instance.

The first method, 'services', returns a hash of all the available services on the targeted Cloud Foundry instance;

~~~ruby
client.services.collect { |x| x.description }
=> ["MySQL database", "MongoDB NoSQL database", "Redis key-value store", "RabbitMQ message queue", "PostgreSQL database (vFabric)"]
~~~

The 'service_instances' method returns the actual service instances currently provisioned on that account;

~~~ruby
pp client.service_instances
[#<CFoundry::V1::ServiceInstance 'mysql-7327e'>,
 #<CFoundry::V1::ServiceInstance 'redis-6b10d'>,
 #<CFoundry::V1::ServiceInstance 'mongodb-3894a'>,
 #<CFoundry::V1::ServiceInstance 'postgresql-e7870'>,
 #<CFoundry::V1::ServiceInstance 'mysql-adeb7'>,
 ...
 #<CFoundry::V1::ServiceInstance 'mysql-13e8f'>,
 #<CFoundry::V1::ServiceInstance 'mongodb-220c4'>]
~~~

The 'service\_instance\_by_name' method returns a named service instance;

~~~ruby
client.service_instance_by_name 'mysql-7327e'
=> #<CFoundry::V1::ServiceInstance 'mysql-7327e'>
~~~

To create a service instance use the service_instance method;

~~~ruby

service = client.services.select{ |x| x.label == 'redis' }.first # <- find the service we wish to deploy
service_plan = client.service_plans_by_service_guid(service.guid).first # <- find the services first service plan

service_instance = client.service_instance # <- prepare a new instance
service_instance.name = 'my_new_redis_service' # <- give it a name

service_instance.service_plan = service_plan # <- assign the plan
service_instance.space = client.spaces.first # <- assign the space the service instance will belong to

service_instance.create! # <- send the request to create it

# if the create was succesful, it should return true.

~~~
## <a id='runtimes-and-frameworks'></a>Runtimes and Frameworks ##

Both runtimes and frameworks have a collection that can be used to reference them both;

~~~ruby

client.frameworks.collect { |x| x.name }
=> ["play", "java_web", "buildpack", "lift", "rails3", "spring", "grails", "sinatra", "rack", "node", "standalone"]

client.runtimes.collect { |x| x.name }
=> ["java", "java7", "node", "node06", "node08", "ruby18", "ruby19"]


~~~


## <a id='applications'></a>Applications ##

The Client class contains three application methods; apps, app and app_by_name

The 'apps' method returns a list of all the deployed applications;

~~~ruby

client.apps
=> [#<CFoundry::V2::App '27edfb92-b0f4-47ad-acd6-cb911eb88096'>]

~~~

The 'app\_by\_name' method finds an application by it's name;

~~~ruby
client.apps_by_name "node_app"
=> [#<CFoundry::V2::App '27edfb92-b0f4-47ad-acd6-cb911eb88096'>]
~~~

To create an application user the app method;

~~~ ruby

app = client.app
app.name = 'my_new_app'
app.total_instances = 2 # <- set the number of instances you want
app.memory = 512 # <- set the allocated amount of memory
app.production = true # <- should the application run in production mode
app.framework = client.frameworks.select{ |x| x.name == 'rails3' }.first # <- set the framework
app.runtime = client.runtimes.select{ |x| x.name == 'ruby19' }.first # <- set the runtime
app.space = client.spaces.first # <- assign the application to a space

app.create!

# we may also want to bind a service too
app.bind client.service_instance_by_name('my_new_redis_service')

~~~

In order for the application to be accessible via http it has to be assigned a route on a domain;

~~~ruby
route = client.route
route.domain = client.domains.first # <- pick the first / default route
route.space = space # <- assign the route to a space
route.host = 'my-rails-app' # <- this is the part of the url that is prepended to the domain
route.create!

app.add_route route # <- add the route to the domain

~~~

This only creates an application 'stub', as of yet there is no actual code uploaded to Cloud Foundry nor is the application started. To give the application something to run and depending on the runtime and framework archive the source, byte code or binary in to a zip file. Upload the zipfile to the application but using the upload command;

~~~ruby

require 'zip/zip'

# create an archive of the current folder

Zip::ZipFile.open('app.zip', Zip::ZipFile::CREATE) do |zipfile|
  Dir.glob('**/*').each do |filename|
    zipfile.add(filename, File.join(folder, filename))
  end
end

app.upload 'app.zip'

~~~

Now the application has been uploaded to Cloud Foundry, all that is left is to start the application

~~~ruby
app.start!
~~~~

The call to start is asynchronous, if true and a block is passed to the method then the block gets called with a URL. The url is the location of a real time log that can be requested via HTTP. CFoundry::Client has a method named stream_url which will transfer chunked data from the server;

~~~ruby

app.start!(true) do |url|
  begin
    offset = 0

    while true
      begin
        client.stream_url(url + "&tail&tail_offset=#{offset}") do |out|
          offset += out.size
          print out
        end
      rescue Timeout::Error
      end
    end

  rescue CFoundry::APIError
  end
end

~~~

## <a id='env-vars'></a>Environment Variables ##

Modifying an applications environment variable is trivial;

~~~ruby

app = client.apps.first

app.env['my_env_var'] = 'env_value' # <- set the environment variable
app.update! # <- commit the change to the application
=> true

app.env['my_env_var'] # <- retrieve the variable
=> "env_value"

~~~

## <a id='domains'></a>Domains ##

Domains are the base on which routes are created. The default domain for a Cloud Foundry instance is the domain the Cloud Foundry instance is actually on.

To create a new domain use the 'domain' method on the client class;

~~~ruby

domain = client.domain
domain.name = 'mydomain.com' # <- the name of the domain
domain.wildcard = true
domain.owning_organization = client.organizations.first # <- set the owning organisation
domain.create! # <- commit

~~~

To retrieve already existing domains;

~~~ruby

client.domains # <- all domains
=> [#<CFoundry::V2::Domain '665b1cf3-e736-42cb-b7fe-bae8362fc30d'>]

client.domains_by_owning_organization_guid client.organizations.first # <- domains belonging to an organization
=> [#<CFoundry::V2::Domain '665b1cf3-e736-42cb-b7fe-bae8362fc30d'>]

client.domains_by_space_guid client.spaces.first # <- domains assigned to a space
=> [#<CFoundry::V2::Domain '665b1cf3-e736-42cb-b7fe-bae8362fc30d'>]

~~~
