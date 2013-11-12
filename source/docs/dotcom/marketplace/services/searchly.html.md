---
title: Searchly
---

Search made simple.

## <a id='managing'></a>Managing Services ##

[Managing services from the command line](../../../using/services/managing-services.html)

### Creating a Service Instance ##

An instance of this service can be provisioned via the CLI with the following command:

<pre class="terminal">
$ cf create-service searchly
</pre>
    
### Binding Your Service Instance ##

Bind the service instance to your app with the following command:
    
<pre class="terminal">
$ cf bind-service 
</pre>

## <a id='using'></a>Using Service Instances with your Application ##

See [Using Service Instances with your Application](../../adding-a-service.html#using) and [VCAP_SERVICES Environment Variable](../../../using/deploying-apps/environment-variable.html).

Format of credentials in `VCAP_SERVICES` environment variable.

~~~xml
{
  searchly-n/a: [
    {
      name: "searchly-1",
      label: "searchly-n/a",
      tags: [ ],
      plan: "starter",
      credentials: {
        uri: "http://cloudfoundry:f0d15584ef7b5dcd1c5c1794ef3506ec@api.searchbox.io",
        sslUri: "https://cloudfoundry:f0d15584ef7b5dcd1c5c1794ef3506ec@api.searchbox.io"
      }
    }
  ]
}
~~~

### Spring

[Jest](https://github.com/searchbox-io/Jest) is a Java HTTP Rest client for ElasticSearch.It is actively developed and tested by Searchly.

### Configuration

Ensure you have added Sonatype repository to your pom.xml

     <repositories>
     .
     .
       <repository>
         <id>sonatype</id>
         <name>Sonatype Groups</name>
         <url>https://oss.sonatype.org/content/groups/public/</url>
       </repository>
     .
     .
     </repositories>


With Maven add Jest dependency to your pom.xml

     <dependency>
       <groupId>io.searchbox</groupId>
       <artifactId>jest</artifactId>
       <version>0.0.5</version>
     </dependency>

Install Jest via Maven

```term
$ mvn clean install
```
### Configuration

Create a Jest Client Bean:
    
```java
@Configuration
public class SpringConfiguration {

	@Bean
	public JestClient jestClient() throws Exception {
	
		// Using jackson to parse VCAP_SERVICES
		Map result = new ObjectMapper().readValue(System.getenv("VCAP_SERVICES"), HashMap.class);
		
		String connectionUrl = (String) ((Map) ((Map) ((List)
		            result.get("searchly-n/a")).get(0)).get("credentials")).get("uri");
		// Configuration
		ClientConfig clientConfig = new ClientConfig.Builder(connectionUrl).multiThreaded(true).build();
		
		// Construct a new Jest client according to configuration via factory
		JestClientFactory factory = new JestClientFactory();
		factory.setClientConfig(clientConfig);
		return factory.getObject();
	}
}
```

### Indexing

Create an index via Jest with ease;

```java
client.execute(new CreateIndex.Builder("articles").build());
```
Create new document.

```java
Article source = new Article();
source.setAuthor("John Ronald Reuel Tolkien");
source.setContent("The Lord of the Rings is an epic high fantasy novel");
```

Index article to "articles" index with "article" type.

```java
Index index = new Index.Builder(source).index("articles").type("article").build();
client.execute(index);
```

### Searching

Search queries can be either JSON String or ElasticSearch SearchSourceBuilder object 
(You need to add ElasticSearch dependency for SearchSourceBuilder).

```java
String query = "{\n" +
    "    \"query\": {\n" +
    "        \"filtered\" : {\n" +
    "            \"query\" : {\n" +
    "                \"query_string\" : {\n" +
    "                    \"query\" : \"Lord\"\n" +
    "                }\n" +
    "            }\n"+
    "        }\n" +
    "    }\n" +
    "}";

Search search = (Search) new Search.Builder(query)
// multiple index or types can be added.
.addIndexName("articles")
.addIndexType("article")
.build();

List<Article> result = client.getSourceAsObjectList(Article.class);
```

Jest has very detailed documentation at it's github [page](https://raw.github.com/searchbox-io/Jest).

### Rails

#### Configuration

Ruby on Rails applications will need to add the following entry into their `Gemfile`.

```ruby
gem 'tire'
```
Update application dependencies with bundler.
```shell
$ bundle install
```
Configure Tire in `configure/application.rb` or `configure/environment/production.rb`



```ruby
# top of Application.configure   
require 'json'
..
..
..

Tire.configure do
    url JSON.parse(ENV['VCAP_SERVICES']['searchly-n/a'][0]['credentials']['uri'])
end
```

#### Search

Make your model searchable:

```ruby
class Document < ActiveRecord::Base
  include Tire::Model::Search
  include Tire::Model::Callbacks
end
```

When you now save a record:

```ruby
Document.create :name => "Cost",
               :text => "Cost is claimed to be reduced and in a public cloud delivery model capital expenditure is converted."
````

The included callbacks automatically add the document to a `documents` index, making the record searchable:

```ruby
@documents = Document.search 'Cost'
```

Tire has very detailed documentation at it's [github page](https://github.com/karmi/tire).

### Node.js

[elasticsearchclient](https://github.com/phillro/node-elasticsearch-client) is a lightweight ElasticSearch client for Node.js. It is actively developed and covers core modules of ElasticSearch.

#### Configuration

Add elasticsearchclient dependency to your `package.json` file and use `npm` to install your dependencies

```javascript
"dependencies": {
   "elasticsearchclient":">=0.5.1"
}
```
#### Search

Create a search client:

```javascript
var ElasticSearchClient = require('elasticsearchclient'),
url = require('url');

var connectionString = url.parse(JSON.parse(process.env.VCAP_SERVICES)['searchly-n/a'][0]['credentials']['uri']);

var serverOptions = {
	host: connectionString.hostname,
	port: connectionString.port,
	secure: false,
	auth: {
		username: connectionString.auth.split(":")[0],
		password: connectionString.auth.split(":")[1]
	}
};

var elasticSearchClient = new ElasticSearchClient(serverOptions);
```
Index a document

```javascript
elasticSearchClient.index('sample', 'document', {'name':'Reliability', 'text':'Reliability is improved', id:"1"})
	.on('data', function(data) {
		console.log(data)
	}).exec()
```
Create a query and search it

```javascript
var qryObj = {
	"query":{
	    "query_string":{
	        "query":"Reliability"
	    }
	}
};

elasticSearchClient.search('sample', 'document', qryObj)
	.on('data', function (data) {
    		console.log(data)
	}).on('error', function (error) {
    		console.log(error)
	}).exec()
``` 

## <a id='sample-app'></a>Sample Applications ##

* [Java Spring Sample](https://github.com/searchbox-io/java-jest-sample)
* [Rails Sample](https://github.com/searchbox-io/rails-sample)
* [Node.js Sample](https://github.com/searchbox-io/node.js-sample)

## <a id='dashboard'></a>Dashboard ##

Via our dashboard, you can get your connection information and api-key, create access keys for scoping indices or public only accesses, check your limitation, create crawlers and get graphical information of your search analytics.

![Dashboard](https://s3.amazonaws.com/searchly-wordpress/assets/dashboard.png)


## <a id='support'></a>Support ##

[Contacting Service Providers for Support](../contacting-service-providers-for-support.html)

* http://support.searchly.com
* support@searchly.com

## <a id='external-links'></a>External Links ##

* http://www.searchly.com/
* http://www.searchly.com/documentation/

