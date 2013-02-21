---
title: VMC (VMware Cloud) console interface
---

### Quick links ###
* [Introduction](#intro)
* [Installing](#installing)
* [Commands](#commands)
* [Plug-ins](#plug-ins)

## <a id='intro'></a>Introduction ##

VMC is Cloud Foundry's console-based interface. Using this tool you can deploy and manage applications running on most Cloud Foundry based environments including CloudFoundry.com. 

## <a id='installing'></a>Installing VMC ##

To use VMC you will need to install Ruby and Rubygems, if you are unsure how to do this then see [http://www.ruby-lang.org/en/downloads/](http://www.ruby-lang.org/en/downloads/) for instructions on how to install Ruby on your operating system.

For details on how to install the latest version of Rubygems, take a look at the download and install instructions at [http://www.rubygems.org](http://www.rubygems.org)

## <a id='commands'></a>Commands ##

Commands in VMC are broken up in to managing various concerns on Cloud Foundry; applications, services, organisations, spaces, domains etc. Issue a command by running 'VMC' in the console immediately followed by a command name, for example;

<pre class="terminal">
$ vmc push my-new-app
</pre>

### Applications ###

#### Management commands

These are the primary application-centric commands for VMC;

<div class="command-doc">
  <pre class="terminal">$ vmc push [application name]</pre>
  <div>Deploy a new application, or, if the application already exists, upload any changes made since the last push.</div>
  <div class="break"></div>
</div>

<div class="command-doc">
  <pre class="terminal">$ delete [list of application names]</pre>
  <div>Delete a single or a list of applications. VMC will ask for confirmation to delete the specified applications and whether or not any services orphaned by removing the application should be removed as well.</div>
  <div class="break"></div>
</div>

<div class="command-doc">
  <pre class="terminal">$ vmc rename [application name] [new application name]</pre>
  <div>Rename an application, changing the existing name to the specified new value.</div>
  <div class="break"></div>
</div>

<div class="command-doc">
  <pre class="terminal">$ vmc restart [list of application names]</pre>
  <div>Stop one or more applications and start them again.</div>
  <div class="break"></div>
</div>

<div class="command-doc">
  <pre class="terminal">$ start [list of application names]</pre>
  <div>Start a stopped application.</div>
  <div class="break"></div>
</div>

<div class="command-doc">
  <pre class="terminal">$ stop [list of application names]</pre>
  <div>Stop an application of which the status is not already "Stopped".</div>
  <div class="break"></div>
</div>

#### Information commands

##### Environment variables

Environment variables are a good way to store sensitive values, outside of an applications source code. A good example of this would be API keys for a service such as Amazon S3.

<div class="command-doc">
  <pre class="terminal">$ env [application name]</pre>
  <div>Show all environment variables set for an application.</div>
  <div class="break"></div>
</div>

<div class="command-doc">
  <pre class="terminal">$ set-env [application name] [variable name] [value]</pre>
  <div>Set an environment variable.</div>
  <div class="break"></div>
</div>

<div class="command-doc">
  <pre class="terminal">$ unset-env [application name] [variable name]</pre>
  <div>Remove an environment variable.</div>
  <div class="break"></div>
</div>

##### Production file system

When trying to resolve issues with a production application, access to the file system can be valuable. The following commands make these tasks possible;

<div class="command-doc">
  <pre class="terminal">$ file [application name] [path]</pre>
  <div>Display the contents for a file at a given path, belonging to the specified application.</div>
  <div class="break"></div>
</div>

<div class="command-doc">
  <pre class="terminal">$ files [application name] [path]</pre>
  <div>Display the contents of a given path for the specified application.</div>
  <div class="break"></div>
</div>

<div class="command-doc">
  <pre class="terminal">$ crashes [list of application names]</pre>
  <div>Display all the application instances that have become unresponsive, for the specified list of applications.</div>
  <div class="break"></div>
</div>

<div class="command-doc">
  <pre class="terminal">$ tail [application name] [path]</pre>
  <div>Much like the *nix command 'tail', watch a file for changes given a path and application name and display them in as the file is updated.</div>
  <div class="break"></div>
</div>

<div class="command-doc">
  <pre class="terminal">$ health [list of application names]</pre>
  <div>Display the health status for a given list of application names</div>
  <div class="break"></div>
</div>

<div class="command-doc">
  <pre class="terminal">$ instances [list of application names]</pre>
  <div>List all the instances for the given list of applications. This also displays a timestamp that shows when each instance was started.</div>
  <div class="break"></div>
</div>

<div class="command-doc">
  <pre class="terminal">$ logs [application name]</pre>
  <div>Display the staging, stdout and stderr log for an application. Application specific logs can be viewed using the 'vmc file' command.</div>
  <div class="break"></div>
</div>

<div class="command-doc">
  <pre class="terminal">$ crashlogs [application name]</pre>
  <div>Display the staging, stdout and stderr log only for an applications unresponsive / crashed instances.</div>
  <div class="break"></div>
</div>

##### URL mapping

<div class="command-doc">
  <pre class="terminal">$ map [application name] [url]</pre>
  <div>Associate a URL, external or otherwise, to an application.</div>
  <div class="break"></div>
</div>

<div class="command-doc">
  <pre class="terminal">$ unmap [application name] [url]</pre>
  <div>Disasociate a URL from an application.</div>
  <div class="break"></div>
</div>

##### Scaling

<pre class="terminal">$ scale [application name]</pre>

<div>
  Set the number of instances for a application and the amount of memory assigned to each instance.
  To change the number of instances use the --instances flag, this can be used with either and absolute value or a +/- modifier. For example, if an application, called my_app, has one instance and we wish to increase this to three, this could be achieved with either of the following commands;

  'vmc scale my_app --instances +2' or 'vmc my_app scale --instances 3'

  To set the assigned memory use the --mem switch, to scale to 512Mb per instance we would use the command;

  'vmc scale my_app --mem 512M'
</div>
<br />
<pre class="terminal">$ stats [application name]</pre>

<div>Display statistics concerning each instance of an application, including CPU, memory and disk usage.</div>

### Services ###

<div class="command-doc">
  <pre class="terminal">$ vmc service [instance name]</pre>
  <div>Show service instance information.</div>
  <div class="break"></div>
</div>

<div class="command-doc">
  <pre class="terminal">$ vmc services</pre>
  <div>Lists all provisioned services, showing service type and version.</div>
  <div class="break"></div>
</div>

#### Management

<div class="command-doc">
  <pre class="terminal">$ create-service [service type] [instance name]</pre>
  <div>Create a new service instance. All parameters are optional, you can just choose to follow VMCs interactive prompts to select the type of the service and the instance name.</div>
  <div class="break"></div>
</div>

<div class="command-doc">
  <pre class="terminal">$ bind-service [instance name] [application name]</pre>
  <div>Bind a service instance to an application.</div>
  <div class="break"></div>
</div>

<div class="command-doc">
  <pre class="terminal">$ unbind-service [instance name] [application name]</pre>
  <div>Remove service binding from an application.</div>
  <div class="break"></div>
</div>

<div class="command-doc">
  <pre class="terminal">$ delete-service [instance name]</pre>
  <div>Delete a service.</div>
  <div class="break"></div>
</div>

<div class="command-doc">
  <pre class="terminal">$ rename-service [instance name] [new instance name]</pre>
  <div>Rename a service.</div>
  <div class="break"></div>
</div>

<div class="command-doc">
  <pre class="terminal">$ tunnel [instance name] [application name]</pre>
  <div>Tunnel to a service instance. You can choose to keep the tunnel open or automatically open a client and connect to the service. For more information on tunneling to a service see the [Service Tunneling](./service-tunneling.html) page.</div>
  <div class="break"></div>
</div>

### Organisations ###

<div class="command-doc">
  <pre class="terminal">$ vmc create-org [organisation name]</pre>
  <div>Create an organization</div>
  <div class="break"></div>
</div>

<div class="command-doc">
  <pre class="terminal">$ vmc create-org [organisation name]</pre>
  <div>Create an organization</div>
  <div class="break"></div>
</div>

<div class="command-doc">
  <pre class="terminal">$ vmc delete-org [organisation name]</pre>
  <div>Delete an organization</div>
  <div class="break"></div>
</div>

<div class="command-doc">
  <pre class="terminal">$ vmc org [organisation name]</pre>
  <div>Show organization information</div>
  <div class="break"></div>
</div>

<div class="command-doc">
  <pre class="terminal">$ vmc orgs</pre>
  <div>List available organizations</div>
  <div class="break"></div>
</div>

<div class="command-doc">
  <pre class="terminal">$ rename-org [organization name] [new organization name]</pre>
  <div>Rename an organization</div>
  <div class="break"></div>
</div>

### Spaces ###

<div class="command-doc">
  <pre class="terminal">$ create-space [space name] [organization name]</pre>
  <div>Create a space in an organization.</div>
  <div class="break"></div>
</div>

<div class="command-doc">
  <pre class="terminal">$ delete-space [list of space names]</pre>
  <div>Delete a space and its contents.</div>
  <div class="break"></div>
</div>

<div class="command-doc">
  <pre class="terminal">$ rename-space [space name] [new space name]</pre>
  <div>Rename a space.</div>
  <div class="break"></div>
</div>

<div class="command-doc">
  <pre class="terminal">$ space [space name]</pre>
  <div>Show space information.</div>
  <div class="break"></div>
</div>

<div class="command-doc">
  <pre class="terminal">$ spaces [organization name]</pre>
  <div>List spaces in an organization.</div>
  <div class="break"></div>
</div>

<div class="command-doc">
  <pre class="terminal">$ take-space [space name]</pre>
  <div>Switch to a space, creating it if it doesn't exist.</div>
  <div class="break"></div>
</div>

### Domains ###

In order to have a domain resolve to a Cloud Foundry hosted application, a domain name should registered against a space. There are five commands for managing domains;

<div class="command-doc">
  <pre class="terminal">$ add-domain [domain]</pre>
  <div>Add a domain and assign it to the current space. Domains should be in top-level format, e.g 'mydomain.com'</div>
  <div class="break"></div>
</div>

<div class="command-doc">
  <pre class="terminal">$ create-domain [domain]</pre>
  <div>Create a domain.</div>
  <div class="break"></div>
</div>

<div class="command-doc">
  <pre class="terminal">$ delete-domain [domain]</pre>
  <div>Delete a domain.</div>
  <div class="break"></div>
</div>

<div class="command-doc">
  <pre class="terminal">$ domains [space]</pre>
  <div>List domains, optionally specify a space.</div>
  <div class="break"></div>
</div>

<div class="command-doc">
  <pre class="terminal">$ remove-domain [domain]</pre>
  <div>Remove a domain from a space. This is not the same as deleting a domain, it simply removes the association to a space.</div>
  <div class="break"></div>
</div>


### Routes ###

Routes are the actual mappings between a domain and an application. An example would be to create the domain 'mydomain.com' and then create a route for 'www.mydomain.com'.

<div class="command-doc">
  <pre class="terminal">$ create-route [url]</pre>
  <div>Create a route.</div>
  <div class="break"></div>
</div>

<div class="command-doc">
  <pre class="terminal">$ delete-route [route]</pre>
  <div>Delete a route.</div>
  <div class="break"></div>
</div>

<div class="command-doc">
  <pre class="terminal">$ vmc routes</pre>
  <div>List routes in a space.</div>
  <div class="break"></div>
</div>

## <a id='plug-ins'></a>Plug-ins ##

VMC allows the use of plug-ins to extend it's own functionality. The four main plug-ins maintained from the [Cloud Foundry vmc-plugins repository](http://github.com/cloudfoundry/vmc-plugins) are admin, console, mcf and tunnel.

### Admin ###
 
This plugin allows the management of users on a Cloud Foundry instance, this requires an admin account.

The following commands are made available by the plug-in;

<div class="command-doc">
  <pre class="terminal">$ vmc create-user [email]</pre>
  <div>Create a new user account.</div>
  <div class="break"></div>
</div>

<div class="command-doc">
  <pre class="terminal">$ vmc delete-user [email]</pre>
  <div>Delete a user account.</div>
  <div class="break"></div>
</div>

<div class="command-doc">
  <pre class="terminal">$ vmc passwd [email]</pre>
  <div>Set a user's password.</div>
  <div class="break"></div>
</div>


### Console ###

The console plug-in allows Rails developers to connect to a Rails console running on their production application. For more details, see [Rails 3, Using the Console](/docs/using/deploying-apps/ruby/rails-using-the-console.html) as part of the "Deploying Rails Apps" section.

### MCF ###

This plugin can be used to switch a Micro Cloud Foundry VM between online and offline mode. Install it with Ruby Gems, the gem name is mcf-vmc-plugin.

The following commands are made available by the plug-in;

<div class="command-doc">
  <pre class="terminal">$ micro-status [vmx path] [password]</pre>
  <div>Display Micro Cloud Foundry VM status for a particular VMX path.</div>
  <div class="break"></div>
</div>

<div class="command-doc">
  <pre class="terminal">$ micro-offline [vmx path] [password]</pre>
  <div>Switch a Micro Cloud Foundry instance to offline mode.</div>
  <div class="break"></div>
</div>

<div class="command-doc">
  <pre class="terminal">$ micro-online [vmx path] [password]</pre>
  <div>Switch a Micro Cloud Foundry instance to online mode.</div>
  <div class="break"></div>
</div>

For a more detailed explanation of this plugin see the [micro cloud foundry vmc plugin](/docs/running/micro-cloud-foundry/vmc_plugin.html) page of the Micro Cloud Foundry section.

### Tunnel ###

The tunnel plugin, working in a similar way to console, allows access to a live data service running in the production environment. For more information on how to use this plug-in, please see [Tunneling to a Service](./service-tunneling.html)