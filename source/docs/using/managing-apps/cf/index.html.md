---
title: CF (VMware Cloud) console interface
---

## <a id='intro'></a>Introduction ##

CF is Cloud Foundry's console-based interface. Using this tool you can deploy and manage applications running on most Cloud Foundry based environments including CloudFoundry.com.

## <a id='installing'></a>Installing CF ##

To use CF you will need to install Ruby and Rubygems, if you are unsure how to do this then see [http://www.ruby-lang.org/en/downloads/](http://www.ruby-lang.org/en/downloads/) for instructions on how to install Ruby on your operating system.

For details on how to install the latest version of Rubygems, take a look at the download and install instructions at [http://www.rubygems.org](http://www.rubygems.org)

## <a id='commands'></a>Commands ##

Commands in CF are broken up in to managing various concerns on Cloud Foundry; applications, services, organisations, spaces, domains etc. Issue a command by running 'CF' in the console immediately followed by a command name, for example;

<pre class="terminal">
$ cf push my-new-app
</pre>

Every interaction has an equivalent flag, which is useful for scripting. These flags can be viewed with `cf help [command]`, or by tacking `-h` or `--help` to the end of a command. The order of these flags does not matter.


### Global Flags ###

These flags apply to all commands, and change how they run.

<div class="command-doc">
  <pre class="terminal">$ cf --version</pre>
  <div>Show the version of CF.</div>
  <div class="break"></div>
</div>

<div class="command-doc">
  <pre class="terminal">$ cf [command] --help</pre>
  <div>Show the help text for the command. This will show a brief description and list all of the flags it accepts.</div>
  <div class="break"></div>
</div>

<div class="command-doc">
  <pre class="terminal">$ cf [command] --force</pre>
  <div>Skip all interaction, confirmation dialogues, etc. If the action cannot be completed without user intervention, it may fail.</div>
  <div class="break"></div>
</div>

<div class="command-doc">
  <pre class="terminal">$ cf [command] --quiet</pre>
  <div>Indicate to the command that it should only print what's necessary. For example, `cf apps --quiet` will only list app names, instead of a table of information. This is useful for scripting.</div>
  <div class="break"></div>
</div>

<div class="command-doc">
  <pre class="terminal">$ cf [command] --script</pre>
  <div>Shortcut for --force and --quiet. CF will automatically switch to this mode if the output is not a terminal (i.e. piping to another command, or capturing its output). To disable this, use --no-script.</div>
  <div class="break"></div>
</div>

<div class="command-doc">
  <pre class="terminal">$ cf [command] --trace</pre>
  <div>Dump all traffic between the CLI and the target. This is very useful for debug reports, but may include sensitive information such as your token.</div>
  <div class="break"></div>
</div>

<div class="command-doc">
  <pre class="terminal">$ cf [command] --debug</pre>
  <div>Print the stack trace in the event of failure, instead of logging it to ~/.cf/crash</div>
  <div class="break"></div>
</div>

<div class="command-doc">
  <pre class="terminal">$ cf [command] --verbose</pre>
  <div>Indicate to the command that it should be chatty. This is entirely up to how the command interprets the flag, and may not make any difference.</div>
  <div class="break"></div>
</div>


### Applications ###

#### Management commands

These are the primary application-centric commands for CF;

<div class="command-doc">
  <pre class="terminal">$ cf apps</pre>
  <div>List the applications in the current space.</div>
  <div class="break"></div>
</div>

<div class="command-doc">
  <pre class="terminal">$ cf push [application name]</pre>
  <div>Deploy a new application, or, if the application already exists, upload any changes made since the last push.</div>
  <div class="break"></div>
</div>

<div class="command-doc">
  <pre class="terminal">$ cf delete [list of application names]</pre>
  <div>Delete a single or a list of applications. CF will ask for confirmation to delete the specified applications and whether or not any services orphaned by removing the application should be removed as well.</div>
  <div class="break"></div>
</div>

<div class="command-doc">
  <pre class="terminal">$ cf rename [application name] [new application name]</pre>
  <div>Rename an application, changing the existing name to the specified new value.</div>
  <div class="break"></div>
</div>

<div class="command-doc">
  <pre class="terminal">$ cf restart [list of application names]</pre>
  <div>Stop one or more applications and start them again.</div>
  <div class="break"></div>
</div>

<div class="command-doc">
  <pre class="terminal">$ cf start [list of application names]</pre>
  <div>Start a stopped application.</div>
  <div class="break"></div>
</div>

<div class="command-doc">
  <pre class="terminal">$ cf stop [list of application names]</pre>
  <div>Stop an application of which the status is not already "Stopped".</div>
  <div class="break"></div>
</div>

#### Information commands

##### Environment variables

Environment variables are a good way to store sensitive values, outside of an applications source code. A good example of this would be API keys for a service such as Amazon S3.

<div class="command-doc">
  <pre class="terminal">$ cf env [application name]</pre>
  <div>Show all environment variables set for an application.</div>
  <div class="break"></div>
</div>

<div class="command-doc">
  <pre class="terminal">$ cf set-env [application name] [variable name] [value]</pre>
  <div>Set an environment variable.</div>
  <div class="break"></div>
</div>

<div class="command-doc">
  <pre class="terminal">$ cf unset-env [application name] [variable name]</pre>
  <div>Remove an environment variable.</div>
  <div class="break"></div>
</div>

##### Production file system

When trying to resolve issues with a production application, access to the file system can be valuable. The following commands make these tasks possible;

<div class="command-doc">
  <pre class="terminal">$ cf file [application name] [path]</pre>
  <div>Display the contents for a file at a given path, belonging to the specified application.</div>
  <div class="break"></div>
</div>

<div class="command-doc">
  <pre class="terminal">$ cf files [application name] [path]</pre>
  <div>Display the contents of a given path for the specified application.</div>
  <div class="break"></div>
</div>

<div class="command-doc">
  <pre class="terminal">$ cf crashes [list of application names]</pre>
  <div>Display all the application instances that have become unresponsive, for the specified list of applications.</div>
  <div class="break"></div>
</div>

<div class="command-doc">
  <pre class="terminal">$ cf tail [application name] [path]</pre>
  <div>Much like the \*nix command 'tail', watch a file for changes given a path and application name and display them in as the file is updated.</div>
  <div class="break"></div>
</div>

<div class="command-doc">
  <pre class="terminal">$ cf health [list of application names]</pre>
  <div>Display the health status for a given list of application names</div>
  <div class="break"></div>
</div>

<div class="command-doc">
  <pre class="terminal">$ cf instances [list of application names]</pre>
  <div>List all the instances for the given list of applications. This also displays a timestamp that shows when each instance was started.</div>
  <div class="break"></div>
</div>

<div class="command-doc">
  <pre class="terminal">$ cf logs [application name]</pre>
  <div>Display the staging, stdout and stderr log for an application. Application specific logs can be viewed using the 'cf file' command.</div>
  <div class="break"></div>
</div>

<div class="command-doc">
  <pre class="terminal">$ cf crashlogs [application name]</pre>
  <div>Display the staging, stdout and stderr log only for an applications unresponsive / crashed instances.</div>
  <div class="break"></div>
</div>

##### URL mapping

<div class="command-doc">
  <pre class="terminal">$ cf map [application name] [url]</pre>
  <div>Associate a URL, external or otherwise, to an application.</div>
  <div class="break"></div>
</div>

<div class="command-doc">
  <pre class="terminal">$ cf unmap [application name] [url]</pre>
  <div>Disasociate a URL from an application.</div>
  <div class="break"></div>
</div>

##### Scaling

<div class="command-doc">
  <pre class="terminal">$ cf scale [application name]</pre>
  <div>Set the number of instances for a application and the amount of memory assigned to each instance.</div>
  <div class="break"></div>
</div>

<div class="command-doc">
  <pre class="terminal">$ cf stats [application name]</pre>
  <div>Display statistics concerning each instance of an application, including CPU, memory and disk usage.</div>
  <div class="break"></div>
</div>

### Services ###

<div class="command-doc">
  <pre class="terminal">$ cf services</pre>
  <div>Lists all provisioned services, showing service type and version.</div>
  <div class="break"></div>
</div>

<div class="command-doc">
  <pre class="terminal">$ cf service [instance name]</pre>
  <div>Show service instance information.</div>
  <div class="break"></div>
</div>

#### Management

<div class="command-doc">
  <pre class="terminal">$ cf create-service [service type] [instance name]</pre>
  <div>Create a new service instance. All parameters are optional, you can just choose to follow CFs interactive prompts to select the type of the service and the instance name.</div>
  <div class="break"></div>
</div>

<div class="command-doc">
  <pre class="terminal">$ cf bind-service [instance name] [application name]</pre>
  <div>Bind a service instance to an application.</div>
  <div class="break"></div>
</div>

<div class="command-doc">
  <pre class="terminal">$ cf unbind-service [instance name] [application name]</pre>
  <div>Remove service binding from an application.</div>
  <div class="break"></div>
</div>

<div class="command-doc">
  <pre class="terminal">$ cf delete-service [instance name]</pre>
  <div>Delete a service.</div>
  <div class="break"></div>
</div>

<div class="command-doc">
  <pre class="terminal">$ cf rename-service [instance name] [new instance name]</pre>
  <div>Rename a service.</div>
  <div class="break"></div>
</div>

<div class="command-doc">
  <pre class="terminal">$ cf tunnel [instance name] [application name]</pre>
  <div>Tunnel to a service instance. You can choose to keep the tunnel open or automatically open a client and connect to the service. For more information on tunneling to a service see the [Service Tunneling](./service-tunneling.html) page.</div>
  <div class="break"></div>
</div>

### Organisations ###

<div class="command-doc">
  <pre class="terminal">$ cf orgs</pre>
  <div>List available organizations</div>
  <div class="break"></div>
</div>

<div class="command-doc">
  <pre class="terminal">$ cf create-org [organisation name]</pre>
  <div>Create an organization</div>
  <div class="break"></div>
</div>

<div class="command-doc">
  <pre class="terminal">$ cf delete-org [organisation name]</pre>
  <div>Delete an organization</div>
  <div class="break"></div>
</div>

<div class="command-doc">
  <pre class="terminal">$ cf org [organisation name]</pre>
  <div>Show organization information</div>
  <div class="break"></div>
</div>

<div class="command-doc">
  <pre class="terminal">$ cf rename-org [organization name] [new organization name]</pre>
  <div>Rename an organization</div>
  <div class="break"></div>
</div>

### Spaces ###

<div class="command-doc">
  <pre class="terminal">$ cf spaces [organization name]</pre>
  <div>List spaces in an organization.</div>
  <div class="break"></div>
</div>

<div class="command-doc">
  <pre class="terminal">$ cf create-space [space name] [organization name]</pre>
  <div>Create a space in an organization.</div>
  <div class="break"></div>
</div>

<div class="command-doc">
  <pre class="terminal">$ cf delete-space [list of space names]</pre>
  <div>Delete a space and its contents.</div>
  <div class="break"></div>
</div>

<div class="command-doc">
  <pre class="terminal">$ cf rename-space [space name] [new space name]</pre>
  <div>Rename a space.</div>
  <div class="break"></div>
</div>

<div class="command-doc">
  <pre class="terminal">$ cf space [space name]</pre>
  <div>Show space information.</div>
  <div class="break"></div>
</div>

### Domains ###

In order to have a domain resolve to a Cloud Foundry hosted application, a domain name should registered against a space. There are five commands for managing domains;

<div class="command-doc">
  <pre class="terminal">$ cf domains [space]</pre>
  <div>List domains, optionally specify a space.</div>
  <div class="break"></div>
</div>

<div class="command-doc">
  <pre class="terminal">$ cf map-domain [domain]</pre>
  <div>Add a domain and assign it to the current space. Domains should be in top-level format, e.g 'mydomain.com'</div>
  <div class="break"></div>
</div>

<div class="command-doc">
  <pre class="terminal">$ cf unmap-domain [domain] [--delete]</pre>
  <div>Unmap a domain from the current space, and optionally delete it.</div>
  <div class="break"></div>
</div>


### Routes ###

Routes are the actual mappings between a domain and an application. An example would be to create the domain 'mydomain.com' and then create a route for 'www.mydomain.com'.

<div class="command-doc">
  <pre class="terminal">$ cf routes</pre>
  <div>List routes in a space.</div>
  <div class="break"></div>
</div>

<div class="command-doc">
  <pre class="terminal">$ cf map [app] [host] [domain]</pre>
  <div>Associate a route with an app.</div>
  <div class="break"></div>
</div>

<div class="command-doc">
  <pre class="terminal">$ cf unmap [route] [app] [--delete]</pre>
  <div>Disassociate a route from an application. Note that the route still exists and is mapped to the space unless you pass `--delete`.</div>
  <div class="break"></div>
</div>

## <a id='plug-ins'></a>Plug-ins ##

CF allows the use of plug-ins to extend it's own functionality. The four main plug-ins maintained from the [Cloud Foundry cf-plugins repository](http://github.com/cloudfoundry/cf-plugins) are admin, console, mcf and tunnel.

### Admin ###

This plugin is for lower-level tasks often done by Cloud Operators.

The following commands are made available by the `admin-cf-plugin` gem;

<div class="command-doc">
  <pre class="terminal">$ cf curl [method] [path] [-b body]</pre>
  <div>Send a manually constructed request to the target, as the current user.</div>
  <div class="break"></div>
</div>

<div class="command-doc">
  <pre class="terminal">$ cf guid [object] [name]</pre>
  <div>Get the GUID for a named object (i.e. app, space, organization).</div>
  <div class="break"></div>
</div>

<div class="command-doc">
  <pre class="terminal">$ cf create-user [email]</pre>
  <div>Create a new user account.</div>
  <div class="break"></div>
</div>

<div class="command-doc">
  <pre class="terminal">$ cf delete-user [email]</pre>
  <div>Delete a user account.</div>
  <div class="break"></div>
</div>

<div class="command-doc">
  <pre class="terminal">$ cf passwd [email]</pre>
  <div>Set a user's password.</div>
  <div class="break"></div>
</div>


### Console ###

The console plug-in allows Rails developers to connect to a Rails console running on their production application. For more details, see [Rails 3, Using the Console](/docs/using/deploying-apps/ruby/rails-using-the-console.html) as part of the "Deploying Rails Apps" section.

### MCF ###

This plugin can be used to switch a Micro Cloud Foundry VM between online and offline mode. Install it with Ruby Gems, the gem name is mcf-cf-plugin.

The following commands are made available by the plug-in;

<div class="command-doc">
  <pre class="terminal">$ cf micro-status [vmx path] [password]</pre>
  <div>Display Micro Cloud Foundry VM status for a particular VMX path.</div>
  <div class="break"></div>
</div>

<div class="command-doc">
  <pre class="terminal">$ cf micro-offline [vmx path] [password]</pre>
  <div>Switch a Micro Cloud Foundry instance to offline mode.</div>
  <div class="break"></div>
</div>

<div class="command-doc">
  <pre class="terminal">$ cf micro-online [vmx path] [password]</pre>
  <div>Switch a Micro Cloud Foundry instance to online mode.</div>
  <div class="break"></div>
</div>

For a more detailed explanation of this plugin see the [micro cloud foundry cf plugin](/docs/running/micro-cloud-foundry/cf_plugin.html) page of the Micro Cloud Foundry section.

### Tunnel ###

The tunnel plugin, working in a similar way to console, allowing access to a live data service running in the production environment. For more information on how to use this plug-in, please see [Tunneling to a Service](./service-tunneling.html)
