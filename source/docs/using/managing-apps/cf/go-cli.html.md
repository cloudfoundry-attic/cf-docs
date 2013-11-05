---
title: Getting Started with cf v6
---

cf is Cloud Foundry's command line interface. You can use cf to deploy and manage applications running on most Cloud Foundry based environments, including CloudFoundry.com.

Download cf v6: link

Install cf v6: link

## <a id='questions'></a>Questions ##

* Please explain:
    * "If you would prefer to completely switch to gcf now, you can use an alias to cf."
	* "cf v6 will always use any flags passed in the cf login command first. If you’re scripting login and targeting, please use the non-interactive gcf api, gcf auth, and gcf target commands. "
* Re: gcf push
	* what are allowable values for stack?  Default value?
	* what units are assumed if I enter "-m 256"
	* shall we document that these push options are removed:
     	* –[no-]bind-services
		* –[no-]create-services
		* –[no-]restart
		* –name NAME
		* –plan PLAN
		* –reset
* What does this mean:
	* "Note that when you create or update a user-provided service, you can use the `-l SYSLOG_DRAIN_URL` option to send data formatted according to RFC 5424 to a third-party log management software as described in RFC 6587."


## <a id='beta'></a>Beta Notice ##

cf v6 is currently in beta. During the beta period, the executable will be named gcf instead of cf. If you would prefer to completely switch to gcf now, you can use an alias to cf.

After an estimated four to six week beta period for community feedback, and once the application manifest work in cf v6 is complete, we will deprecate the Ruby cf v5 cli. At that point, cf v6 commands will be changed to use cf.

## <a id='new'></a>New and Improved Features ##

## <a id='login'></a>login ##

The `login` command in cf v6 has expanded functionality. In addition to supplying your username and password, you can  optionally specify (any or all of) the target API endpoint, organization, and space. cf will prompt for values you do not specify on the command line.

**Usage:**

<pre class="terminal">
gcf login [-a API_URL] [-u USERNAME] [-p PASSWORD] [-o ORG] [-s SPACE]
</pre>

If you have only one organization and one space, they will be automatically targeted when you log in; you need not specify them.

Upon successful login, cf v6 saves your API endpoint, organization, space values, and access token in a `config.json` file  in your `~/.cf` directory. If you change your target API endpoint, organization, or space, the `config.json` file will be updated accordingly.

cf v6 will always use any flags passed in the cf login command first. In a script logs you in and rarget If you are If you’re scripting login and targeting, please use the non-interactive gcf api, gcf auth, and gcf target commands.

## <a id='push'></a>push ##

`push` command options are changed: most are introduced with a shorter, one-character length flag, and two new options are added.

Usage:

<pre class="terminal">
gcf push APP [-b URL] [-c COMMAND] [-d DOMAIN] [-i NUM_INSTANCES] [-m MEMORY] [-n HOST] [-p PATH] [-s STACK] [--no-hostname] [--no-route] [--no-start]`
</pre>

The only argument you must supply is `APP`. Optional arguments include:

* `-b` --- Custom buildpack URL, for example, https://github.com/heroku/heroku-buildpack-play.git
* `-c` --- Start command for the application
* `-d` --- Domain, for example, example.com
* `-i` --- Number of instances of the application to run
* `-m` --- Memory limit, for example, 256, 1G, 1024M, and so on.
* `-n` --- Hostname, for example, `my-subdomain`
* `-p` --- Path to application directory or archive.
* `-s` --- Stack to use
* `--no-hostname` --- Map the root domain to this app (NEW)
* `--no-route` --- Do not map a route to this app (NEW)
* `--no-start` --- Do not start an app after pushing


## <a id='user-provided'></a> User-Provided Services ##

cf v6 has new commands for creating and updating user-provided services, described in the subsections below.

Note that when you create or update a user-provided service, you can use the `-l SYSLOG_DRAIN_URL` option to send data formatted according to RFC 5424 to a third-party log management software as described in RFC 6587.

Once created, user-provided services can be bound to an application with with `gcf bind-service`, unbound with `gcf unbind-service`, renamed with `gcf rename-service`, and deleted with `gcf delete-service`.

### <a id='user-cups'></a>gcf create-user-provided-service, gcf cups ###

Interactive Usage:

<pre class="terminal">
gcf create-user-provided-service SERVICE_INSTANCE -p "HOST, PORT, DATABASE, USERNAME, PASSWORD" -l SYSLOG-DRAIN-URL
</pre>

Non-interactive Usage:

<pre class="terminal">
gcf create-user-provided-service SERVICE_INSTANCE -p '{"username":"USERNAME","password":"PASSWORD"}' -l SYSLOG-DRAIN-URL
</pre>

### <a id='user-uups'></a>gcf update-user-provided-service`, gcf uups ###

You can use `gcf update-user-provided-service` to update one or more of the attributes for a user-provided service. Attributes that you do  not supply will not be updated.

Interactive Usage:

<pre class="terminal">
gcf update-user-provided-service SERVICE_INSTANCE -p "HOST, PORT, DATABASE, USERNAME, PASSWORD" -l SYSLOG-DRAIN-URL
</pre>

Non-interactive Usage:

<pre class="terminal">
gcf update-user-provided-service SERVICE_INSTANCE -p '{"username":"USERNAME","password":"PASSWORD"}' -l SYSLOG-DRAIN-URL
</pre>


## <a id='user-provided'></a> Domains and Routes ##

In keeping with the principle of “each command does one thing,” cf v6 features more explicit domains and routes commands:

gcf create-domain  Create a domain in an org for later use
gcf share-domain  Share a domain with all orgs
gcf map-domain  Map a domain to a space
gcf unmap-domain  Unmap a domain from a space
gcf delete-domain  Delete a domain

gcf create-route  Create a url route in a space for later use
gcf map-route  Add a url route to an app (mapping a route also creates it)
gcf unmap-route  Remove a url route from an app
gcf delete-route  Delete a route

In order to use a domain in a route, it must first be created in an org with gcf create-domain (or use a domain previously shared across all orgs), then it must be mapped to a space with gcf map-domain, and then it can be mapped to an app in that space with gcf map-route. Keep in mind that the first two steps need only be done once per org and space.

## <a id='domains-routes'></a> Management of Roles for Organizations and Spaces ##


cf v6 brings the ability to manage users and their roles to the cli for the first time:

gcf org-users  Show org users by role
gcf set-org-role  Assign an org role to a user (roles include OrgManager, BillingManager, and OrgAuditor)
gcf unset-org-role  Remove an org role from a user

gcf space-users  Show space users by role
gcf set-space-role  Assign a space role to a user (roles include SpaceManager, SpaceDeveloper, and SpaceAuditor)
gcf unset-space-role  Remove a space role from a user


## <a id='aliases'></a> New Aliases ##

cf v6 introduces single-letter aliases for commonly used commands, such as gcf p for push and gcf t for target. Help documents which commands have aliases.

## <a id='help'></a> Command Line Help ##

Run `gcf help` to view a list all gcf commands and a brief description of each. To view detailed help for a command, add `-h` to the command line.  For example:

<pre class="terminal">
gcf push -h
NAME:
   push - Push a new app or sync changes to an existing app

ALIAS:
   p

USAGE:
   gcf push APP [-b URL] [-c COMMAND] [-d DOMAIN] [-i NUM_INSTANCES]
               [-m MEMORY] [-n HOST] [-p PATH] [-s STACK]
               [--no-hostname] [--no-route] [--no-start]

OPTIONS:
   -b ''		Custom buildpack URL (for example: https://github.com/heroku/heroku-buildpack-play.git)
   -c ''		Startup command
   -d ''		Domain (for example: example.com)
   -i '1'		Number of instances
   -m '128'		Memory limit (for example: 256, 1G, 1024M)
   -n ''		Hostname (for example: my-subdomain)
   -p ''		Path of app directory or zip file
   -s ''		Stack to use
   --no-hostname	Map the root domain to this app
   --no-route		Do not map a route to this app
   --no-start		Do not start an app after pushing
</pre>

Note that:

* User input is capitalized, as in  `gcf push APP`
* Optional user input is designated with a flag and brackets, as in `gcf create-route SPACE DOMAIN [-n HOSTNAME]`.

Notable exceptions

The cf v6 beta release represents a complete rewrite of the Ruby cf cli feature-set with three exceptions:

App manifests are not yet supported.
The display of gcf push staging and buildpack logs is still being optimized to work with Loggregator. Some lines may be missing until the final fixes are in; please use gcf logs --recent to see log entries from the staging process that may be missing.
For some commands, only the first 50 results are shown.

All will be fixed in the final release of cf v6.