---
title: Using the CFoundry Ruby Gem to manage applications (Classic / Legacy Cloud Foundry)
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

## <a id='services'></a>Services ##

The Client class contains four service methods; services, service_instances, service_instance_by_name and service_instance.

The first method, 'services', returns a hash of all the available services on the targeted Cloud Foundry instance;

~~~ruby
pp client.services
[#<CFoundry::V1::Service:0x007fb844068ca0
  @description="MySQL database",
  @label="mysql",
  @provider="core",
  @state=:current,
  @type="database",
  @version="5.1">,
 #<CFoundry::V1::Service:0x007fb844068ac0
  @description="PostgreSQL database (vFabric)",
  @label="postgresql",
  @provider="core",
  @state=:current,
  @type="database",
  @version="9.0">,
 ...
 #<CFoundry::V1::Service:0x007fb8440678f0
  @description="MongoDB NoSQL database",
  @label="mongodb",
  @provider="core",
  @state=:current,
  @type="document",
  @version="2.0">]
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
service = client.service_instance 'my_new_service'
service.vendor = 'redis' # <- this is the label property of the service
service.version = '2.6' # <- if there are multiple versions of the same service, specify the one required
service.tier = 'free'
service.create!

# if the create was succesful, it should return true.
~~~
## <a id='runtimes-and-frameworks'></a>Runtimes and Frameworks ##

Both runtimes and frameworks have a collection that can be used to reference them both;

~~~ruby

client.frameworks.collect { |x| x.name }
=> ["rails3", "rack", "java_web", "play", "spring", "node", "standalone", "lift", "sinatra", "grails"]

client.runtimes.collect { |x| x.name }
=> ["java", "java7", "node", "node06", "node08", "ruby18", "ruby19"]

~~~

## <a id='applications'></a>Applications ##

The Client class contains three application methods; apps, app and app_by_name

The 'apps' method returns a list of all the deployed applications;

~~~ruby

pp client.apps
[#<CFoundry::V1::App 'sidekiq'>,
 #<CFoundry::V1::App 'sidekiq-worker'>,
 #<CFoundry::V1::App 'caldecott'>,
 #<CFoundry::V1::App 'db-sample'>,
 #<CFoundry::V1::App 'go-test'>]

~~~

The 'app\_by\_name' method finds an application by it's name;

~~~ruby
client.app_by_name 'sidekiq'
=> #<CFoundry::V1::App 'sidekiq'>
~~~

To create an application user the app method;

~~~ ruby

app = client.app 'my_new_app'
app.instances = 1 # <- set the number of instances you want
app.memory = 256 # <- set the allocated amount of memory
app.services = [service] # <- set the services bound to the appliation as an array of references to service_instance objects (optional)
app.framework_name = 'standalone' # <- the name of the framework
app.command = 'bundle exec ./app.rb' # <- an optional command to start the application (if standalone)
app.runtime_name = 'ruby19' # <- the name of the runtime
app.create!

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
