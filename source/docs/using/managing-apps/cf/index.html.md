---
title: cf Command Line Interface
---

cf is Cloud Foundry's command line interface. You can use cf to deploy and manage applications running on most Cloud Foundry based environments including CloudFoundry.com.

## <a id='commands'></a>Commands by Functional Category ##

This table below lists all cf commands, including those enabled by cf plug-ins. Click a command in the table for information about command options and functionality. For options that apply to all cf commands, see [Command Usage and Qualifiers](#usage).

|   |  | |
| :-------- | :---------- |:---------- |
| **Basics** <br>[info](#info) <br>[login EMAIL](#login) <br>[logout](#logout) <br>[targets](#targets) <br>[target URL](#target)  <br> <br> **Manage Users** <br>  [create-user EMAIL](#create-user)  <br>   [passwd](#passwd) <br> [register EMAIL](#register) <br> [users](#users)<br><br> **Manage Apps** <br>[app APP](#app) <br> [apps](#apps) <br>[bind-service SVC APP](#bind-service)<br> [console APP](#console) <br>[delete APP](#delete) <br>[map APP HOST DOMAIN](#map) <br>[push NAME](#push) <br>[rename APP APP](#rename) <br>[restart APP](#restart) <br> [scale APP](#scale) <br> [set-env APP NAME VALUE](#set-env)<br>[start APPS](#start) <br>[stop APPS](#stop) <br>[unbind-service SVC APP](#unbind-service)   <br> [unmap URL APP](#unmap) <br> [unset-env APP NAME](#unset-env)    <br> <br> | **Get Information About Apps**  <br>[crashes APPS](#crashes) <br>[crashlogs APP](#crashlogs)  <br> [env APP](#env)  <br> [file APP PATH](#file)  <br> [files APP PATH](#file) <br> [guid TYPE NAME](#guid) <br>[health APP](#health) <br>[instances APP](#instances) <br>[logs APP](#logs) <br>[stats APP](#stats) <br>[tail APP PATH](#tail)        <br> <br>  **Manage Services** <br>[bind-service SVC APP](#bind-service) <br>[create-service-auth-token LABEL PROVIDER](#create-service-auth-token)<br>[create-service OFFERING NAME](#create-service) <br>[delete-service-auth-token TOKEN](#delete-service-auth-token)<br>[delete-service SVC](#delete-service) <br>[rename-service SVC SVC](#rename-service) <br>[tunnel INSTANCE CLIENT](#tunnel)  <br>[unbind-service SVC APP](#unbind-service)  <br>[update-service-auth-token TOKEN](#update-service-auth-token)   <br> <br>**Get Information about Services** <br>[info --service](#info) <br> [service-auth-tokens](#service-auth-tokens) <br>[service SERVICE](#service) <br>[services](#services)   |**Manage Organizations and Spaces** <br>[create-org ORG](#create-org) <br>[create-space NAME ORG](#create-space)  <br>  [delete-org ORG](#delete-org) <br>[delete-space SPACE](#delete-space)   <br>[rename-org ORG ORG](#rename-org)   <br>[rename-space SPACE SPACE](#rename-space) <br> [set-quota QUOTA ORG](#set-quota) <br>[switch-space SPACE](#switch-space) <br> <br> **Get Information About Organizations and Spaces** <br> [guid TYPE NAME](#guid) <br>[org ORG](#org)  <br>[orgs](#orgs)  <br>[space SPACE](#space)  <br> [spaces ORG](#spaces)  <br> <br>**Manage Domains and Routes** <br>[domains SPACE](#domains) <br> [guid TYPE NAME](#guid)<br>[routes](#routes) <br>[unmap-domain DOMAIN](#unmap-domain )  <br>
|  | |

## <a id='installing'></a>Installing cf ##

cf requires Ruby and RubyGems. For information about installing Ruby and RubyGems, see [Installing Ruby](/docs/common/install_ruby.html).

After installing Ruby and RubyGems, use this command to install the latest released version of cf:

<pre class="terminal">
$ gem install cf
</pre>

To install a pre-release version of cf:

<pre class="terminal">
$ gem install cf --pre
</pre>

## <a id='usage'></a>Command Usage and Qualifiers ##

cf commands allow you to view, and in some cases create and modify, information related to Cloud Foundry applications, services, organisations, spaces, domains, and so on. Preface each command with `cf`, for example:

<pre class="terminal">
$ cf push my-new-app
</pre>


Most commands have qualifiers that you can use to tailor command behavior or supply required argument values. If you do not supply a required argument value at the command line, cf presents a dialog that prompts for required data. If you use cf commands in a non-interactive script, you must specify required arguments as part of the command. Command qualifiers can be specifed in any order.

This page documents the optional and required qualfiers for each cf command. You can display similar information in the console by entering `cf help [command]`, or by appending `-h` or `--help` to the end of a command.

**Global Command Qualifiers**

The following qualifiers apply to all cf commands.

| Qualifier | Description |
| :------------------------ | :---------- |
|  --color, --no-color                  | |
|  --debug | If the command fails, write the stack trace to the console instead of logging it to ~/.cf/crash. |
|  --force | Skip prompts and confirmation responses. If you use `--force`, be sure to supply any required qualifiers <br>on the command line; if the command cannot be executed without user input, it may fail.
|  --help | Display a description of the command and a list of the qualifiers it accepts. |
| --http-proxy HTTP_PROXY |Connect though an http proxy server. |
| --https-proxy HTTP_PROXY |Connect though an https proxy server |
| --manifest FILE, -m
|  --quiet, --no-quiet |  Return a minimal response. For example, `cf apps --quiet` will return the `name` attribute for each app, <br>but not `status`, `usage`, and `url`, which would otherwise be listed for each app. The `--quiet` <br>qualifier is useful in cf scripts. |
| --script |  Run the command with both the `--force` and  `--quiet` qualifiers. Note that cf will automatically apply <br>the `--script` qualifier if you redirect command output or pipe it to another command. To disable this, <br>use the `--no-script` qualifier. |
|  --trace, -t | Dump all traffic between the CLI and the target. This is useful for debugging. Note however that the <br>`--trace` qualifier may return sensitive data, for instance, your token. |
|  --verbose, -V | Return a verbose response, if available. Not every command has a verbose version of its results. |
|  --version, -v | Display the version of cf. |





## <a id='details'></a>Detailed Command Documentation ##

#### <a id='app'></a> app ####
List information about an application.

<div class="command-doc">
  <pre class="terminal">$ cf app [application name]</pre>
</div>

The following data is returned:

* status -- status of the app, for example, "running"
* usage -- memory allocated to the application, and the number of instances
* urls -- URLs mapped to the application
* services --- service instances bound to the application

#### <a id='apps'></a> apps ####
List the applications in the current space.

<div class="command-doc">
  <pre class="terminal">$ cf apps</pre>
</div>

The following data is returned for each application:

* name -- name
* status -- status of the app, for example, "running"
* usage -- memory allocated to the application, and the number of instances.
* url -- URL of the application

The table below lists supported command qualifiers.  

| Qualifier | Required | Description |
| :-------- | :------- | :---------- |
| --full     |   n       | Verbose output format.            |
| --name NAME     |  n        |  List applications whose names match the specified regular expression.           |
| --space SPACE    |   n       |List application in the specified space.             |
| --url URL     |   n       | List applications whose URLs match the specified regular expression.           |

#### <a id='bind-service'></a> bind-service ####

Bind a service to an application. Some service types are bindable, some are not. If a service supports binding, binding it to an application adds credentials for the service instance to the `VCAP_SERVICES` environment variable. You may need to restart the application for the binding to take effect.

Note that you can bind a service to an application at the time you create the service, as described in [create-service](#create-service). For more information about creating and binding service instances, see [Getting Started - Adding a Service](/docs/dotcom/adding-a-service.html).




<div class="command-doc">
  <pre class="terminal">$ cf bind-service [instance name] [application name]</pre>
  <div class="break"></div>
</div>

| Qualifier | Required | Description |
| :-------- | :------- | :---------- |
| --app     |   y       | The name of the application to which the service should be bound.            |
| --service     |  y        |  The service to bind to the application.           |


#### <a id='console'></a> console ####

Open a Rails console and connect to an application. For information about using the Rails console see [Rails 3, Using the Console](/docs/using/deploying-apps/ruby/rails-using-the-console.html)  in "Deploying Rails Apps".  **This command is provided by the `console` plugin.**

<div class="command-doc">
  <pre class="terminal">$ cf console  [application name] [port}</pre>
  <div class="break"></div>
</div>
| Qualifier | Required | Description |
| :-------- | :------- | :---------- |
| --app     |   y       | The name of the application.            |
| --port     |  y        | The port where the application is running.           |

#### <a id='crashes'></a> crashes ####

For the for the specified list of applications, list instances that are unresponsive.

<div class="command-doc">
  <pre class="terminal">$ cf crashes [list of application names]</pre>
  <div class="break"></div>
</div>


#### <a id='crashlogs'></a> crashlogs ####

Display the staging, stdout and stderr logs for an application's unresponsive instances.

<div class="command-doc">
  <pre class="terminal">$ cf crashlogs [application name]</pre>
  <div class="break"></div>
</div>

#### <a id='create-org'></a> create-org ####

Create an organization.

<div class="command-doc">
  <pre class="terminal">$ cf create-org [organisation name]</pre>
  <div class="break"></div>
</div>

| Qualifier | Required | Description |
| :-------- | :------- | :---------- |
| --[no-]add-self     |     n    | Use this option to specify that you do (or do not) want to add yourself to the organization.            |
| --name     |   y       | The name to assign to the organization.           |
|  -t, --[no-]target    | n         | Use this option to specify that you do (or do not) want to switch to the organization after creation. |

#### <a id='create-service'></a> create-service ####

Create a new service instance, and optionally, bind it to an application. If you do not bind a service to an application when you create, you can do it later with the [bind-service](#bind-service) command. For more information about creating and binding service instances, see [Getting Started - Adding a Service](/docs/dotcom/adding-a-service.html).

To list service instances that already exist, use the [services](#services) command.


<div class="command-doc">
  <pre class="terminal">$ cf create-service [service type] [instance name]</pre>
  <div class="break"></div>
</div>



The table below lists supported command qualifiers. cf prompts for required qualifiers not provided on the command line. 

| Qualifier | Required | Description |
| :-------- | :------- | :---------- |
| --app, --bind APP   |  n       | Use this option to specify an application to which to bind the service.         |
| --name     |   y       | The name you assign to the service. When you run `create-service` interactively, cf will supply a default instance name at the prompt, which you can override with another value. The name can can contain alpha-numeric characters ([a-z], [A-Z], [0-9]), hyphens (-), and underscores (_).            |
|--offering | y| The type of the service to create, for example, "rediscloud", "mongolab", and so on. If you run `create-service` interactively, cf will present a list of available service types, along with the service version and provider. |
|--plan | y |The service plan. A service plan defines a set of service features and resource levels. If you run `create-service` interactively, cf will present a list of the plans that the service provider offers. |
|--provider | n|The service provider. |
|--version |n |The service version. |

#### <a id='create-service-auth-token'></a> create-service-auth-token ####

Create a service authorization token. **This command is provided by the `admin` plugin.**

<div class="command-doc">
  <pre class="terminal">$ cf create-service-auth-token [label] [provider]</pre>
  <div class="break"></div>
</div>

| Qualifier | Required | Description |
| :-------- | :------- | :---------- |
|--label | |Token lable.|
|--provider | |Token provider. |
|--token TOKEN | |Token value. |


#### <a id='create-space'></a> create-space ###

Create a space in an organization.

<div class="command-doc">
  <pre class="terminal">$ cf create-space [space name] [organization name]</pre>
  <div class="break"></div>
</div>

| Qualifier | Required | Description |
| :-------- | :------- | :---------- |
|--[no-]developer | |Use this option to add (or not add) yourself to the space as a developer. |
| --[no-]manager| |Use this option to add (or not add) yourself to the space as a manager. |
|--auditor  | |Use this option to add (or not add) yourself to the space as an auditor. |
|--name NAME | |Name for the new space. |
|-o, --organization, --org ORGANIZATION | |Organization in which to add the space. |
|-t, --target | |Use this option to switch to the new space after creation. |


#### <a id='create-user'></a> create-user ####

Create a user account. If you do not supply required options on the command line, cf will prompt for them. 

**This command is provided by the `admin` plugin.**

<div class="command-doc">
  <pre class="terminal">$ cf create-user [email]</pre>
  <div></div>
  <div class="break"></div>
</div>


| Qualifier | Required | Description |
| :-------- | :------- | :---------- |
|--email EMAIL | y|Email of the new user. |
|--password PASSWORD |y |Password for the new user. |
|--verify VERIFY |y |Supply the password again. |
|-o, --organization, --org ORGANIZATION| |Organization to which to assign the new user. |

#### <a id='delete'></a> delete ####

Delete an application. cf will ask you to confirm that you wish to delete the application and whether you want to also delete the services bound to the application.

<div class="command-doc">
  <pre class="terminal">$ cf delete [list of application names]</pre>
</div>


| Qualifier | Required | Description |
| :-------- | :------- | :---------- |
|--all |n |Delete all applications in the current space. |
|--apps, --app APPS |y | The name of the application to delete. |
|--routes | n |Delete the routes associated with the application to be deleted |
|-o, --delete-orphaned DELETE_ORPHANED |n | |

#### <a id='delete-org'></a> delete-org ####

Delete an organization.

<div class="command-doc">
  <pre class="terminal">$ cf delete-org [organisation name]</pre>
  <div class="break"></div>
</div>


| Qualifier | Required | Description |
| :-------- | :------- | :---------- |
| --[no-]warn| | |
| -o, --organization, --org ORGANIZATION| | |
| -r, --recursive| | |


#### <a id='delete-route'></a> delete-route ####

Delete a route.

<div class="command-doc">
  <pre class="terminal">$ cf delete-route [route]</pre>
  <div class="break"></div>
</div>



#### <a id='delete-service-auth-token'></a> delete-service-auth-token ####

Delete a service authorization token. **This command is provided by the `admin` plugin.**

<div class="command-doc">
  <pre class="terminal">$ cf delete-service-auth-token [service auth token]</pre>
  <div class="break"></div>
</div>

#### <a id='delete-service'></a> delete-service ####

Delete a service.

<div class="command-doc">
  <pre class="terminal">$ cf delete-service [instance name]</pre>
  <div class="break"></div>
</div>


| Qualifier | Required | Description |
| :-------- | :------- | :---------- |
|--[no-]unbind    | |Unbind from applications before deleting? |
| --all| |Delete all services. |
| --service SERVICE| |Service to delete. |

#### <a id='delete-space'></a> delete-space ####

Delete a space and its contents.

<div class="command-doc">
  <pre class="terminal">$ cf delete-space [list of space names]</pre>
  <div class="break"></div>
</div>

| Qualifier | Required | Description |
| :-------- | :------- | :---------- |
|--[no-]warn | |Use this option to indicate that you do (or do not) want to be warned if the specified space is the last space in the organization. |
|--space SPACE | |Space to delete. |
|-o, --organization, --org ORGANIZATION | |The organization that contains the space to delete. |
|-r, --recursive  | |

#### <a id='delete-user'></a> delete-user ####

Delete a user account. **This command is provided by the `admin` plugin.**

<div class="command-doc">
  <pre class="terminal">$ cf delete-user [email]</pre>
  <div class="break"></div>
</div>



#### <a id='domain'></a> domains ####

List domains.

<div class="command-doc">
  <pre class="terminal">$ cf domains [space]</pre>
  <div class="break"></div>
</div>

The following data is returned for each domain:

* name -- The name of the domain.
* owner -- The owner of the domain.

#### <a id='env'></a> env ####

Show all environment variables set for an application. Environment variables are a good way to store sensitive data, such as API keys for Amazon S3, outside of an application's source code.

<div class="command-doc">
  <pre class="terminal">$ cf env [application name]</pre>
</div>

#### <a id='file'></a> file ####

Display the contents for a file at a given path, belonging to the specified application.

<div class="command-doc">
  <pre class="terminal">$ cf file [application name] [path]</pre>
</div>

#### <a id='files'></a> files ###

List an application's files.

#### <a id='guid'></a> guid ####

Get the GUID for the object with the type (for instance, app, organization, space, domain, and so on) and name specified.  **This command is provided by the `admin` plugin.**

<div class="command-doc">
  <pre class="terminal">$ cf guid type [name]</pre>
  <div></div>
  <div class="break"></div>
</div>

| Qualifier | Required | Description |
| :-------- | :------- | :---------- |
|--name NAME  | n|The name of the object. |
|--type TYPE |y |The type of the object: "app", "org", "space", "domain".  |


#### <a id='health'></a> health ####

Display the health of the specified applications.

<div class="command-doc">
  <pre class="terminal">$ cf health [list of application names]</pre>
  <div class="break"></div>
</div>

The current status of the application, for example "running", "flapping", "stopped", is returned. If only a subset of application instances are running, the percentage of instances that are running is shown.

#### <a id='info'></a> info ####

Display information on the target cloud

| Qualifier | Required | Description |
| :-------- | :------- | :---------- |
|-a, --all | n| |
|-s, --services |n |  |

The following information is returned:

* target -- The target Cloud Foundry instance.
* version -- The Cloud Foundry version.
* If you use the `--all` or `--services` options, the following information is returned for each available service type:
    * service -- Type of service.
    * version -- Version of service
    * provider -- The company that provides the service.
    * plans -- Plans under which the service is available.
    * description -- Description of the service.

#### <a id='instances'></a> instances ####
List the instances of the specified application.

<div class="command-doc">
  <pre class="terminal">$ cf instances [list of application names]</pre>
  <div class="break"></div>
</div>

For an instance that is running, the following data is returned:

* started -- The time that the instance was started.
* console -- The port and IP address where the instance is running.

#### <a id='login'></a> login ####

Authenticate with the target. If you do not supply required options on the command line, cf will prompt for them. 

<div class="command-doc">
  <pre class="terminal">$ cf login [email]</pre>
  <div class="break"></div>
</div>

| Qualifier | Required | Description |
| :-------- | :------- | :---------- |
|--password PASSWORD |y |Password to use to authenticate. |
|--username, --email EMAIL  |y |Username or email that identifies the user account.|
|-o, --organization, --org ORGANIZATION |n |Use this option to specify the space to switch to upon login. |
|-s, --space SPACE  |n |Use this option so specify the space to switch to upon login. |

#### <a id='logout'></a> logout ####

Log out from the target.

<div class="command-doc">
  <pre class="terminal">$ cf logout</pre>
  <div class="break"></div>
</div>

#### <a id='logs'></a> logs ####

Display log files, such as staging, stdout, and stderr, for an application. The log files available for an application vary by type.

To view application-specific logs, use 'cf file'.

<div class="command-doc">
  <pre class="terminal">$ cf logs [application name]</pre>
  <div class="break"></div>
</div>
| Qualifier | Required | Description |
| :-------- | :------- | :---------- |
|--all |n |Use this option if you want to list log files for all instances of the application. |
|--app APP |y |The name of the application. |
|--instance INSTANCE |n |Use to specify the application instance, for instance "2", whose logs you want to list. <br>If not specified logs for the first instance started ("0") are listed.|


#### <a id='map'></a> map ####

Associate a URL, external or otherwise, to an application.

<div class="command-doc">
  <pre class="terminal">$ cf map [application name] [url]</pre>
  <div class="break"></div>
</div>

| Qualifier | Required | Description |
| :-------- | :------- | :---------- |
|--app APP| |Application to which you want to map the URL.|
|--domain DOMAIN | |Top-level domain. |
|--host HOST | | |


#### <a id='map-domain'></a> map-domain ####

Add a domain and assign it to a space.
<div class="command-doc">
  <pre class="terminal">$ cf map-domain [domain]</pre>
  <div class="break"></div>
</div>

| Qualifier | Required | Description |
| :-------- | :------- | :---------- |
| --name NAME | |Domain name. Specify a domain in top-level format, for example, `mydomain.com`. |
| --shared | |Make the domain shared.|
|--space SPACE | |The space to which to map the domain. If not specified, the domain is mapped to the current space. |
|-o, --organization, --org ORGANIZATION   | |The organization to which to map the domain. If not specified, the domain is mapped to the current organization. |
#### <a id='micro-offline'></a> micro-offline ####

Switch a Micro Cloud Foundry instance to offline mode. **This command is provided by the `mcf` plug-in.**

<div class="command-doc">
  <pre class="terminal">$ cf micro-offline [vmx path] [password]</pre>
  <div class="break"></div>
</div>

#### <a id='micro-online'></a> micro-online ####

Switch a Micro Cloud Foundry instance to online mode. **This command is provided by the `mcf` plug-in.**

<div class="command-doc">
  <pre class="terminal">$ cf micro-online [vmx path] [password]</pre>
  <div class="break"></div>
</div>

#### <a id='micro-status'></a> micro-status ####

Display Micro Cloud Foundry VM status for a particular VMX path. **This command is provided by the `mcf` plug-in.**

<div class="command-doc">
  <pre class="terminal">$ cf micro-status [vmx path] [password]</pre>
  <div class="break"></div>
</div>

#### <a id='org'></a> org ####

Show organization information.

<div class="command-doc">
  <pre class="terminal">$ cf org [organisation name]</pre>
  <div class="break"></div>
</div>


| Qualifier | Required | Description |
| :-------- | :------- | :---------- |
|--full | |Return information about spaces in the organization. |
|--org ORGANIZATION | |The organization for which to display data. If not specified, results for the current organization are returned.  |

The following data is returned:

* domains -- Domains mapped to the organization.
* spaces -- The spaces in the organization
* If the `--full` option is used, the following data is returned for each space in the organization:
     * apps -- Applications that have been deployed to the space.
     * services -- Services in the space.

#### <a id='orgs'></a> orgs ####

List available organizations.

<div class="command-doc">
  <pre class="terminal">$ cf orgs</pre>
  <div class="break"></div>
</div>

The following data is returned:

* domains -- Domains mapped to the organization.
* spaces -- The spaces in the organization
* If the `--full` option is used, the following data is returned for each space in the organization:
     * apps -- Applications that have been deployed to the space.
     * services -- Services in the space.


| Qualifier | Required | Description |
| :-------- | :------- | :---------- |
|--full |n |Return information about spaces in each organization. |
#### <a id='passwd'></a> passwd ####

Set a user's password. **This command is provided by the `admin` plugin.**

<div class="command-doc">
  <pre class="terminal">$ cf passwd [email]</pre>
  <div class="break"></div>
</div>

#### <a id='push'></a> push ####

Deploy a new application, or, if the application already exists, upload any changes made since the last push.

cf will interactively prompt you for any required qualifiers that you do not supply on the command line.

After you supply the qualifiers required to push an application, cf will offer you the option to save the configuration. If you accept, the settings you chose will be saved in a Cloud Foundry manifest file, `manfiest.yml`. If you subsequently do a `cf push` without supplying qualifiers on the command line, cf will use the configuration settings from the saved `manfiest.yml`.


<div class="command-doc">
  <pre class="terminal">$ cf push [APP]</pre>
</div>

| Qualifier           | Required | Description |
| :------------------ | :------- | :---------- |
| --[no-]bind-services                |  | Use this qualifier to indicate that you do (or do not) want to specify services to bind to the application. <br>If you indicate that you want bind services, you will be prompted to select the service type to bind. |
| --[no-]create-services         |   |Use this qualifier to indicate that you do (or do not) want to create one or more <br>services.  |
| --[no-]restart              |  | Restart app after updating? |
| --[no-]start      |          |Use this qualifier to to indicate that you do (or do not) want the application to be started upon <br>deployment. |
| --buildpack BUILDPACK         |          | Specify the URL of a buildpack to be used to stage the application. |
| --command COMMAND        |         |The command to use to start the application.  |
| --domain DOMAIN              |          | The top level internet domain for the application. |
| --host HOST    |        |The subdomain, leave blank if specifying custom domain.            |
| --instances INSTANCES       |          | The  number of instances of the application to start.|
| --memory MEMORY             |          | The maximum memory to allocate to each application instance.           |
| --name NAME             | | The name of the application to push. |
| --plan PLAN              | | Specify the desired plan for the service. (A _plan_ specifies a pricing terms and resource <BR>limits for the service.)     |
|--path | |Path to the application to be pushed. |
| --reset             | |Use this option if you are specifying a new value for one or more `push` options to indicate <BR>that the newly supplied value should override previously provided option values. |
| --stack STACK           | | |

#### <a id='register'></a> register ####

Create a user and login.

<div class="command-doc">
  <pre class="terminal">$ cf register [email]</pre>
</div>


| Qualifier | Required | Description |
| :-------- | :------- | :---------- |
|--[no-]login  | | |
|--email EMAIL  | | |
|--password PASSWORD  | | |
|--verify VERIFY
 | | |
#### <a id='rename'></a> rename ####

Rename an application.  If you do not provide the required input on the command line, cf will prompt for it.

Note that after you change an application's name, cf will not recognize the application's previous name if you use it in commands that act upon an application.  

<div class="command-doc">
  <pre class="terminal">$ cf rename [current application name] [new application name]</pre>
</div>

#### <a id='rename-org'></a> rename-org ####

Rename an organization
<div class="command-doc">
  <pre class="terminal">$ cf rename-org [organization name] [new organization name]</pre>
  <div class="break"></div>
</div>

#### <a id='rename-service'></a> rename-service ####

Rename a service.
<div class="command-doc">
  <pre class="terminal">$ cf rename-service [instance name] [new instance name]</pre>
  <div class="break"></div>
</div>

#### <a id='rename-space'></a> rename-space ####

Rename a space.

<div class="command-doc">
  <pre class="terminal">$ cf rename-space [space name] [new space name]</pre>
  <div class="break"></div>
</div>

#### <a id='restart'></a> restart ####

Stop an application and then start it.

<div class="command-doc">
  <pre class="terminal">$ cf restart [APP]</pre>
</div>


| Qualifier | Required | Description |
| :-------- | :------- | :---------- |
|--all | |Delete all applications in the current space. |
|--app APP | |The name of the application to delete. |
|-d, --debug-mode DEBUG_MODE  | |Use this option to specify a debug mode to use when restarting the application. |

#### <a id='routes'></a> routes ####

List routes in a space.

<div class="command-doc">
  <pre class="terminal">$ cf routes</pre>
  <div></div>
  <div class="break"></div>
</div>

#### <a id='scale'></a> scale ####

Set the number of instances for a application and the amount of memory assigned to each instance.

<div class="command-doc">
  <pre class="terminal">$ cf scale [application name]</pre>
  <div class="break"></div>
</div>


| Qualifier | Required | Description |
| :-------- | :------- | :---------- |
|--[no-]restart | |Use this option to indicate that you do (or do not) want to restart the application after updating it. |
|--app APP | |Application to update. |
|--disk DISK | |Amound of disk space to allocate to the application. |
|--instances INSTANCES | |Number of instances to run. |
|--memory MEMORY | |Amount of memory to allocate to the application. |
|--plan PLAN | |Application plan. |


#### <a id='service-auth-token'></a> service-auth-token ####

List service authorization tokens. **This command is provided by the `admin` plugin.**

<div class="command-doc">
  <pre class="terminal">$ cf service-auth-token</pre>
  <div class="break"></div>
</div>

The following data is returned for each token:

* guid -- The GUID for the service type.
* provider -- The vendor or supplier of the service.

#### <a id='service'></a> service ####

Display service instance information.

<div class="command-doc">
  <pre class="terminal">$ cf service [instance name]</pre>
  <div class="break"></div>
</div>

#### <a id='services'></a> services ####

Display information about service instances in the current space.

<div class="command-doc">
  <pre class="terminal">$ cf services</pre>
  <div class="break"></div>
</div>

The table below defines command qualifiers.

| Qualifier | Required | Description |
| :-------- | :------- | :---------- |
| --app APP | n | List only services instances that are bound to the specified application.  |
| --full | n | Provide verbose output.  |
| --name NAME | n |List only service instances whose names match the specified string.  |
| --plan PLAN | n | List only service instances provisioned under a plan that matches the specified string. |
|--provider PROVIDER   | n |List only service instances provisioned by a service from the the provider that matches the specified string.   |
|--service SERVICE   |n  |List only service instances provisioned by a service that matches the specified string.   |
| --space SPACE |  |List only service instances in the specified space.  |
| --version VERSION |  |List only services instances whose version matches the specified string.  |

      
The following data is returned for each service instance:

* name -- The name assigned to the service instance when it was created.
* service -- The type of service, for example, "cleardb" or "rediscloud".
* provider -- The service vendor or supplier.
* version -- The version of the service.
* plan -- The provider plan under which the service was obtained.
* description -- This attribute, a description of the plan, is returned if you run the command with the `--full` option.
* bound apps -- The applications to which the service is bound.

#### <a id='set-env'></a> set-env ####

Set an environment variable. For information about removing an environment variable see [set-env](#set-env).

<div class="command-doc">
  <pre class="terminal">$ cf set-env [App] [Variable] [Value]</pre>
</div>

| Qualifier | Required | Description |
| :-------- | :------- | :---------- |
|--[no-]restart |n |Use this option to indicate that you do (or do not) want to restart the application after updating it. |
|--app APP | y |The application for which you are defining the variable. |
|--name NAME    | y |The name of the environment variable. |
|--value VALUE   | y |The value of the environment variable. |

#### <a id='set-quota'></a> set-quota ####

Define the quota for an organization. **This command is provided by the `admin` plugin.**

<div class="command-doc">
  <pre class="terminal">$ cf set-quota [QUOTA_DEFINITION] [ORGANIZATION]</pre>
</div>

| Qualifier | Required | Description |
| :-------- | :------- | :---------- |
|--quota-definition QUOTA-DEFINITION| y| Allowable values are: "free", "paid", "runaway", and "trial"|
|--organization ORG |y |The organization for which to set the quota. |


#### <a id='space'></a> space ####

Show space information.

<div class="command-doc">
  <pre class="terminal">$ cf space [space name]</pre>
  <div class="break"></div>
</div>

| Qualifier | Required | Description |
| :-------- | :------- | :---------- |
|--full | |Include information about applications in the space. |
|--space SPACE | |The space for which you want to see information.  If not specified, information about the current <br>space is returned. |
|--org ORGANIZATION | |The organization for which to display data. If not specified, results for the current organization <br>are returned.  |

The following data is returned:

* organization -- Organization that contains the space.
* apps -- Applications that have been deployed to the space.
* services -- Services in the space.
* domains -- çomains in the space.
* If the `full` option is used, the following information is returned for applications in the space:
     * status -- the current status of the application, for example "stopped", running", "flapping", and so on.

#### <a id='spaces'></a> spaces ####

List spaces in an organization.

<div class="command-doc">
  <pre class="terminal">$ cf spaces [organization name]</pre>
  <div class="break"></div>
</div>

| Qualifier | Required | Description |
| :-------- | :------- | :---------- |
|--full | |Include information about applications and services in each space. |
|--name NAME | |Filter by name.  If not specified, information about all spaces in the current or selected organization is returned. |
|--org ORGANIZATION | |The organization for which to list spaces. If not specified, spaces in the current organization are returned.  |
#### <a id='start'></a> start ####

Start a stopped application.

<div class="command-doc">
  <pre class="terminal">$ cf start [APP]</pre>
</div>

| Qualifier | Required | Description |
| :-------- | :------- | :---------- |
|--all | |Start all application in the space. |
|--apps, --app APPS | |Use this qualifier to specify selected applications to start. |
|-d, --debug-mode DEBUG_MODE  | |Debug mode in which to start the application. |

#### <a id='stats'></a> stats ####

Display resource statistics for each instance of an application, including CPU, memory, and disk usage.

<div class="command-doc">
  <pre class="terminal">$ cf stats [application name]</pre>
  <div class="break"></div>
</div>

The following data is returned for each instance of the application:

* instance -- Instance number
* cpu -- CPU utilization
* memory -- Memory utilization
* disk -- Disk utilization

#### <a id='stop'></a> stop ####

Stop an application whose status is not already "Stopped".

<div class="command-doc">
  <pre class="terminal">$ cf stop [list of application names]</pre>
</div>

| Qualifier | Required | Description |
| :-------- | :------- | :---------- |
|--all | |Stop all application in the space. |
|--apps, --app APPS | |Use this qualifier to specify selected applications to stop. |

#### <a id='switch-space'></a> switch-space ####

Switch to a different space.

<div class="command-doc">
  <pre class="terminal">$ cf switch-space [space name]</pre>
</div>
#### <a id='tail'></a> tail ####

Watch the file for the specified application and the specified path, and display changes as they occur. (Similar to the \*nix  'tail' command.)

<div class="command-doc">
  <pre class="terminal">$ cf tail [application name] [path]</pre>
  <div class="break"></div>
</div>

| Qualifier | Required | Description |
| :-------- | :------- | :---------- |
|--app APP| | |
|--path PATH | | |

#### <a id='target'></a> target ####

Set or display the target cloud, organization, and space. When you run a cf command that reads or writes information about applications or service instances, by default the command will  access objects in the currently selected target cloud, organization, and space. 

<div class="command-doc">
  <pre class="terminal">$ cf target [URL]</pre>
  <div class="break"></div>
</div>


| Qualifier | Required | Description |
| :-------- | :------- | :---------- |
| --url URL |n| Use this option to select a different Cloud Foundry instance.|
|--org ORGANIZATION |n |Use this option to select a different Cloud Foundry organization. |
|--space SPACE |n |Use this option to select a different Cloud Foundry space. |

If no qualifiers are specified on the command line, the following data is returned:

* target -- The target Cloud Foundry instance.
* organization -- The currently selected organization.
* space -- The currently selected space.

#### <a id='targets'></a> targets ####

List known targets.

<div class="command-doc">
  <pre class="terminal">$ cf targets</pre>
  <div class="break"></div>
</div>

The URL for each known Cloud Foundry instance will be returned.


#### <a id='tunnel'></a> tunnel ####

Tunnel to a service instance. You can keep the tunnel open or automatically open a client and connect to the service. For more information on tunneling to a service see [Service Tunneling](./service-tunneling.html). **This command is provided by the `tunnel` plug-in.**

<div class="command-doc">
  <pre class="terminal">$ cf tunnel [instance name] [application name]</pre>
  <div class="break"></div>
</div>


| Qualifier | Required | Description |
| :-------- | :------- | :---------- |
| --client CLIENT | |Client to automatically launch. |
|--instance INSTANCE | |Service instance to tunnel to. |
|--port PORT             | |Port to bind the tunnel to. |

#### <a id='unbind-service'></a> unbind-service ####

Remove a service binding from an application. cf will prompt for required qualifiers not supplied on the command line.

<div class="command-doc">
  <pre class="terminal">$ cf unbind-service [instance name] [application name]</pre>
  <div class="break"></div>
</div>

#### <a id='unmap-domain'></a> unmap-domain ####

Unmap a domain from the current space, and optionally delete it.

<div class="command-doc">
  <pre class="terminal">$ cf unmap-domain [domain] [--delete]</pre>
  <div class="break"></div>
</div>


| Qualifier | Required | Description |
| :-------- | :------- | :---------- |
|--delete | | | Use this qualifier to delete as well as unmap the domain.
|--domain DOMAIN | |Domain to unmap |
| --space SPACE| | Space from which to unmap the domain. |
| --org ORGANIZATION| |Oranization from which to unmap the domain. |

#### <a id='unmap'></a> unmap ####

Disassociate a URL from an application.

<div class="command-doc">
  <pre class="terminal">$ cf unmap [application name] [url]</pre>
  <div class="break"></div>
</div>


| Qualifier | Required | Description |
| :-------- | :------- | :---------- |
|--all | |Act on all routes |
| --app APP| |Application from which to remove the URL.|
|--url URL | |URL to unmap. |
| | | |
#### <a id='unset-env'></a> unset-env ####

Remove an environment variable. For information about defining an environment variable see [set-env](#set-env).

<div class="command-doc">
  <pre class="terminal">$ cf unset-env [application name] [variable name]</pre>
</div>


| Qualifier | Required | Description |
| :-------- | :------- | :---------- |
|--[no-]restart |n |Use this option to indicate that you do (or do not) want to restart the application after updating it. |
|--app APP | y |The application from which you are defining the variable. |
|--name NAME    | y |The name of the environment variable to remove. |

#### <a id='update-service-auth-token'></a> update-service-auth-token ####

Update a service authorization token.

<div class="command-doc">
  <pre class="terminal">$ cf update-service-auth-token [SERVICE_AUTH_TOKEN]</pre>
</div>

#### <a id='users'></a> users ##

List all users.

<div class="command-doc">
  <pre class="terminal">$ cf users</pre>
</div>

## <a id='plugins'></a>About cf Plug-ins ##

cf Plugins extend the cf command line interface with additional commands; they are available from the [Cloud Foundry cf-plugins repository](http://github.com/cloudfoundry/cf-plugins). Available cf Plugins include:

* admin -- Provides commands useful to cloud operators. Made available by the `admin-cf-plugin` gem.

* console -- This plugin allows you to open a Rails console and connect to a Rails application.

* mcf -- This plugin can be used to switch a Micro Cloud Foundry VM between online and offline mode. Install it with Ruby Gems, the gem name is `mcf-cf-plugin`. For more information, see [Micro Cloud Foundry](/docs/running/micro_cloud_foundry).

* tunnel -- This plugin allows access to a live data service running in the production environment. For more information on how to use this plug-in, please see [Tunneling to a Service](/docs/using/services/tunnelling-with-services.html).



