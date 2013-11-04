---
title: Getting Started with cf v6
---

cf is Cloud Foundry's command line interface. You can use cf to deploy and manage applications running on most Cloud Foundry based environments, including CloudFoundry.com.

Download cf v6: link
Install cf v6: link

##<a id='beta'></a>Beta Notice##

cf v6 is currently in beta. During the beta period, the executable will be named gcf instead of cf. If you would prefer to completely switch to gcf now, you can use an alias to cf.

After an estimated four to six week beta period for community feedback, and once the application manifest work in cf v6 is complete, we will deprecate the Ruby cf v5 cli. At that point, cf v6 commands will be changed to use cf.

##<a id='new'></a>New and Improved Features##

##<a id='login'></a>login##

The `login` command in cf v6 has expanded functionality, allowing you to specify target information in addition to your username password. When you log in, you can optionally specify (any or all of) the target API endpoint, organization, and space.  cf will prompt for values you do not specify on the command line.

**Usage:**

<pre class="terminal">
gcf login [-a API_URL] [-u USERNAME] [-p PASSWORD] [-o ORG] [-s SPACE]
</pre>

If you have only one organization and one space, they will be automatically targeted when you log in; you need not specify them.

Upon successful login, cf v6 saves your API endpoint, organization, space values, and access token in a `config.json` file  in your `~/.cf` directory. If you change your target API endpoint, organization, or space, the `config.json` file will be updated accordingly.

cf v6 will always use any flags passed in the cf login command first. If you’re scripting login and targeting, please use the non-interactive gcf api, gcf auth, and gcf target commands.

##<a id='push'></a>push##

`push` command options are changed: most are introduced with a shorter, one-character length flag, and two new options are added

**Usage:**

`gcf push APP [-b URL] [-c COMMAND] [-d DOMAIN] [-i NUM_INSTANCES] [-m MEMORY] [-n HOST] [-p PATH] [-s STACK] [--no-hostname] [--no-route] [--no-start]`

As before, pushing updates to an app requires nothing other than cf push APP. Optional arguments include:

-b  Custom buildpack URL (for example: https://github.com/heroku/heroku-buildpack-play.git)
-c  Startup command
-d  Domain (for example: example.com)
-i  Number of instances
-m  Memory limit (for example: 256, 1G, 1024M)
-n  Hostname (for example: my-subdomain)
-p  Path of app directory or zip file
-s  Stack to use
--no-hostname Map the root domain to this app (NEW)
--no-route  Do not map a route to this app (NEW)
--no-start  Do not start an app after pushing

* Will user be prompted for any required options not supplied as command line options?
* Want to specify default values?
* what units are assumed if I enter "-m 256"
* if I do not specify -d DOMAIN, is default domain mapped to app?
* what does "route domain" mean?
* what are allowable values for stack?  Default value?
* shall we document that these options are removed:
	* –[no-]bind-services
	* –[no-]create-services
	* –[no-]restart
	* –name NAME
	* –plan PLAN
	* –reset


##<a id='user-provided'></a>User-Provided Services##

cf v6 has new commands to interact with user-provided services:

* cf create-user-provided service (or gcf cups)
* gcf update-user-provided-service (or gcf uups)

Once created, user-provided services can be bound to an application with with `gcf bind-service`, unbound with `gcf unbind-service`, renamed with `gcf rename-service`, and deleted with `gcf delete-service`, just like any other service.

Credentials for user-provided services can be entered in two ways:

* Interactively for most use cases
  `gcf create-user-provided-service SERVICE_INSTANCE -p "comma, separated, parameter, names"` (cf v6 will prompt for the values)

* Non-interactively in scripts: gcf create-user-provided-service SERVICE_INSTANCE -p '{"name":"value","name":"value"}'

Additionally, both create and update commands now support an optional -l SYSLOG_DRAIN_URL parameter to send data formatted according to RFC5424 to any third-party log management software as described in RFC6587.

Note that the update command will replace any current name value pairs with whatever is entered as arguments in gcf update-user-provided-service.

Domains and routes

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

Org and space roles management

cf v6 brings the ability to manage users and their roles to the cli for the first time:

gcf org-users  Show org users by role
gcf set-org-role  Assign an org role to a user (roles include OrgManager, BillingManager, and OrgAuditor)
gcf unset-org-role  Remove an org role from a user

gcf space-users  Show space users by role
gcf set-space-role  Assign a space role to a user (roles include SpaceManager, SpaceDeveloper, and SpaceAuditor)
gcf unset-space-role  Remove a space role from a user

New aliases

cf v6 introduces single-letter aliases for commonly used commands, such as gcf p for push and gcf t for target. Help documents which commands have aliases.

Help

As with the Ruby cf v5, cf v6 is self-documenting. Run gcf help to view a list of all commands and their intended use. On any command, add -h to see its full help output, such as gcf login -h. Help is also shown when the command arguments do not map to correct usage.

Both required and optional user input is always capitalized, as in gcf push APP and gcf bind-service APP SERVICE_INSTANCE. Optional user input is designated with a flag and brackets, as in gcf create-route SPACE DOMAIN [-n HOSTNAME].

Notable exceptions

The cf v6 beta release represents a complete rewrite of the Ruby cf cli feature-set with three exceptions:

App manifests are not yet supported.
The display of gcf push staging and buildpack logs is still being optimized to work with Loggregator. Some lines may be missing until the final fixes are in; please use gcf logs --recent to see log entries from the staging process that may be missing.
For some commands, only the first 50 results are shown.

All will be fixed in the final release of cf v6.