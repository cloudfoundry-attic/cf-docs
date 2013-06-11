---
title: Deploying Apps
---

Cloud Foundry supports many frameworks and runtimes.

| Runtime         			| Framework     							|
| :-------------  			|:------------- 							|
| Javascript	     		| Node.js 									|
| Java / JVM 				| Java Spring, Grails, Scala Lift, and Play |
| Ruby						| Rack, Rails, Sinatra						|

You can also use [Custom Buildpacks](buildpacks.html) for other runtimes and frameworks not in this list.

## <a id='prepare-app'></a>Prepare for Deployment ##

The steps to prepare your application depend on the technology you are using.

<input type="button" class="togglebutton" value="JVM"> <input type="button" class="togglebutton" value="Ruby"> <input type="button" class="togglebutton" value="Node">

<div>

<div id="JVM" style="display:none">

<h3>JVM-Based Languages</h3>

Cloud Foundry supports most JVM-based frameworks such as Java Spring, Grails, Scala Lift, and Play.
If your application can be packaged as a `.war` file and deployed to Apache Tomcat,
then it should also run on Cloud Foundry without changes.
However, before you can deploy, you need to compile your application.

If you are using Spring or Lift, you can use maven:

<pre class="terminal">
$ mvn package
</pre>

If you are using play:

<pre class="terminal">
$ play redist
</pre>

If you are using Grails:

<pre class="terminal">
$ grails prod war
</pre>
<hr>
</div>

<div id="Ruby" style="display:none">

<h3>Ruby</h3>

Cloud Foundry supports most popular Ruby frameworks such as Rails, Sinatra, and Rack.

We recommend that you use bundler to manage your gem dependencies.

You need to run `bundle install` locally before you deploy your app to make sure that your Gemfile.lock is consistent with your Gemfile.
<hr>
</div>

<div id="Node" style="display:none">

<h3> Node </h3>

Before you deploy your Node application you need to include cf-autoconfig in your package.json and require it in your app.

Add cf-autoconfig to your dependencies in package.json:

<br><br>
<pre><code>
  "dependencies": {
    ...other dependencies...
    "cf-autoconfig": "*"
  }
</code></pre>
<br>
Add the require statement to the top of your app file:
<br><br>
<pre><code>
  require("cf-autoconfig");
</code></pre>
<br>
Run npm install to install your dependencies locally
<hr>
</div>

</div>

## <a id='Binding Services'></a> Binding Services ##

There are three ways of binding services on Cloud Foundry.

| Binding Strategy		| Description    		| 
| :------------------- 	|:--------------------	| 
| Auto-Reconfiguration	|  For databases only. Cloud Foundry creates a service connection for you.				| 
| cfruntime  		| Creates an object with the location and settings of your services. Set your service connections based on the values in that object.    		| 
| Manualy      	| Use Cloud Foundry Environment Variables to set your service connections. |

How you employ these strategies depends on the framework you are using.

| Runtime         			| Framework     							|
| :-------------  			|:------------- 							|
| Javascript	     		| [Node.js](node.html) 									|
| Java / JVM 				| <li>[Lift](../services/lift-service-bindings.html) <li>[Grails](../services/grails-service-bindings.html)<li>[Spring](../services/spring-service-bindings.html) |
| Ruby						| Rack, Rails, Sinatra						|

