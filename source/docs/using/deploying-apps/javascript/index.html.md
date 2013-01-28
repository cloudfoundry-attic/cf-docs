---
title: Node.js
---

### Quick links ###
* [Introduction](#intro)
* [Prerequisites](#prerequisites)
* [Create your application](#create-your-app)
* [Dependencies](#dependencies)
* [Deploying your application](#deploy-your-app)
* [Node.js version parity](#checking-node-versions)
* [Next Steps - Binding a service](#next-steps)

## <a id='intro'></a>Introduction ##

This quickstart guide is for developers who wish to build applications with the [Node.js](http://www.nodejs.org) Javascript framework and deploy to Cloud Foundry.

## <a id='prerequisites'></a>Prerequisites ##

* A Cloud Foundry account; you can sign up [here](https://my.cloudfoundry.com/signup)
* The [vmc](../../managing-apps/vmc) command line tool 
* [Node.js](http://www.nodejs.org) installed using the matching version of Node.js on your Cloud Foundry instance
* [NPM](http://npmjs.org/) - Node Package Manager, to manage dependencies on your application

## <a id='create-your-app'></a>Create your application ##

For the purposes of this tutorial we will build a very simple application that makes use of the node.js package, [express](http://expressjs.com).

Open a shell and create a folder for your application in your desired location:

<pre class="terminal">
$ cd ~/Projects
$ mkdir hello-node
$ cd hello-node
</pre>

Create a file called "app.js" with the following contents:

```javascript
var express = require("express");
var app = express();

app.get('/', function(req, res) {
    res.send('Hello from Cloud Foundry');
});

app.listen(3000);
```

Create a file called "package.json" with the following contents:

```json
{
  "name": "hello-node",
  "version": "0.0.1",
  "dependencies": {
    "express": "*"
  },
  "engines": {
    "node": "0.8.x"
  }
}
```

This file tells node which libraries are in use (express, in this case) and what versions to use. The engines configuration can also be used to specify which version of node to use, although this is also selected using VMC when deploying the application. For a more detailed explanation of package.json, take a look at the [Node.js documentation](https://npmjs.org/doc/json.html).

## <a id='dependencies'></a>Dependencies, NPM and package.json ##

Install the modules declared as dependencies in package.json using NPM:

<pre class="terminal">
$ npm install
</pre>

This should create a "node_modules" folder that contains the application's dependencies.

Start the application as a local server and check its output:

<pre class="terminal">
$ node app.js
</pre>

Open a browser and navigate to http://localhost:3000, or, alternatively use `curl` in another shell:

<pre class="terminal">
$ curl http://localhost:3000
</pre>

You should see the output `Hello from Cloud Foundry`.

## <a id='deploy-your-app'></a>Deploying your application ##

With vmc installed, target your desired Cloud Foundry instance and login:

<pre class="terminal">
$ vmc target api.cloudfoundry.com
Setting target to https://api.cloudfoundry.com... OK

$ vmc login
</pre>

Deploy the application by using the `push` command. Notice the URL "hello-node.cloudfoundry.com" was taken, so it was changed to "hello-node2.cloudfoundry.com".
All the other options were left as the default by pushing enter:

<pre class="terminal">
$ vmc push

Name> hello-node
Instances> 1

1: node
2: other
Framework> 1   

1: node
2: node06
3: node08
4: other
Runtime> 3

1: 64M
2: 128M
3: 256M
4: 512M
5: 1G
6: 2G
7: 4G
8: 8G
9: 16G
Memory Limit> 64M

Creating hello-node... OK

1: hello-node.cloudfoundry.com
2: none
URL> hello-node.cloudfoundry.com

Updating hello-node... FAILED
The URI: "hello-node.cloudfoundry.com" has already been taken or reserved

1: hello-node.cloudfoundry.com
2: none
URL> hello-node2.cloudfoundry.com

Updating hello-node... OK

Create services for application?> n

Bind other services to application?> n

Save configuration?> n

Uploading hello-node... OK
Starting hello-node... OK
Checking hello-node... OK
</pre>

Finally check your application has deployed correctly, navigating to the configured URL.

## <a id='checking-node-versions'></a>Node.js version parity ##

It is important to make sure that the version of Node.js used on your computer is the same as the version you use when deploying to Cloud Foundry. Check your local version, like so:

<pre class="terminal">
$ node -v
v0.8.2
</pre>

In this instance you can see the installed version is 0.8.2, so when deploying we would select "node08" for the runtime. To see a list of available runtimes using VMC, use the following command:

<pre class="terminal">
$ vmc info --runtimes

Getting runtimes... OK

runtime   description
java      1.6.0_24   
java7     1.7.0_04   
node      0.4.12     
node06    0.6.8      
node08    0.8.2      
ruby18    1.8.7p357  
ruby19    1.9.2p180  
</pre>

## <a id='next-steps'></a>Next steps - Binding a service ##

Binding and using a service with Node.js is covered [here](./services.html)