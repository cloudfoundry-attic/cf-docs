---
title: cf Command Line Interface
---

cf is Cloud Foundry's command line interface. You can use cf to deploy and manage applications running on most Cloud Foundry based environments, including CloudFoundry.com.


##<a id='api'></a> api ##

Set or view target API URL.

**Usage**

`go-cf api URL`

<div class="command-doc">
  <pre class="terminal">

</pre>
</div>

##<a id='app'></a> app ##
Display the health and status of an application.

**Usage**

`go-cf app APP`

**Example**

<div class="command-doc">
  <pre class="terminal">

go-cf app hello-frank
Showing health and status for app hello-frank...
OK

state: started
instances: 3/3
usage: 64M x 3 instances
urls: sinatrahelloworld.cfapps.io, marie.test.com

     status    since                    cpu    memory         disk          
#0   running   2013-10-01 02:03:58 PM   0.0%   18M of 64M     63.7M of 1G   
#1   running   2013-10-05 06:18:15 PM   0.0%   16.7M of 64M   63.7M of 1G   
#2   running   2013-10-05 08:08:14 AM   0.0%   18M of 64M     63.7M of 1G   
</pre>
</div>

**Results**

The following data is returned:

* state --- Status of the application, WHAT ARE THE POSSIBLE VALUES?
* instances --- The number of instances running over (/) the number of instances pushed
memory allocated to the application, and the number of instances
* usage --- The amount of memory allocated to each instance, and the number of instances.  
* urls --- URLs mapped to the application
* For each instance of the application:
    * instance index --- 
    * status --- WHAT ARE THE POSSIBLE VALUES?
    * since --- The time that a running instance was last started.
    * cpu --- The percentage of CPU the instance is using.
    * memory --- The amount of memory the instance is using of the memory allocated.
    * disk --- The amount of disk space the instance is using of the space allocated.


## <a id='apps'></a> apps, a ##
List the applications in the current space.


**Usage**

`go-cf apps`
or
`go-cf a`

**Example**

<div class="command-doc">
  <pre class="terminal">
go-cf apps
Getting apps in development...
OK
name               state     instances   memory   disk   urls                                                  
hello-frank        started   3/3         64M      1G     sinatrahelloworld.cfapps.io, marie.test.com           
plain-java         started   1/1         512M     1G                                                           
spring-hello-env   started   1/1         512M     1G     spring-hellothere-env.cfapps.io, diff-url.cfapps.io   

</pre>
</div>

**Results**

The following data is returned for each application:

* name --- name
* state --- stae of the app,  WHAT ARE THE POSSIBLE VALUES?
* instances --- The number of instances running over (/) the number of instances pushed
* memory --- Amount of memory allocated to each instance.
* disk --- Amount of disk space allocated to each instance.
* urls --- URLs mapped to the application


## <a id='bind-service'></a> bind-service ##

Bind a service to an application. Some service types are bindable, some are not. If a service supports binding, binding it to an application adds credentials for the service instance to the `VCAP_SERVICES` environment variable. You may need to restart the application for the binding to take effect.

Note that you can bind a service to an application at the time you create the service, as described in [create-service](#create-service). For more information about creating and binding service instances, see [Getting Started - Adding a Service](/docs/dotcom/adding-a-service.html).

**Usage**

`go-cf bind-service APP SERVICE_INSTANCE` or `go-cf bs APP SERVICE_INSTANCE`

**Example**
<div class="command-doc">
  <pre class="terminal">
go-cf bind-service spring-hello-env user-provided-2ee08
Binding service user-provided-2ee08 to spring-hello-env...
OK
TIP: Use 'cf push' to ensure your env variable changes take effect</pre>
  <div class="break"></div>
</div>



## <a id='crashlogs'></a> crashlogs TBS##

Display the staging, stdout and stderr logs for an application's unresponsive instances.

**Usage**

**Example**

<div class="command-doc">
  <pre class="terminal"></pre>
  <div class="break"></div>
</div>

## <a id='create-org'></a> create-org ##

Create an organization.


**Usage**

`create-org ORG` or `cs ORG`

<div class="command-doc">
  <pre class="terminal">
go-cf create-org Partner22
Creating org Partner22...
OK

TIP: Use 'cf target -o Partner22' to target new org
</pre>
  <div class="break"></div>
</div>


## <a id='create-service'></a> create-service ##

Create a new service instance, and optionally, bind it to an application. If you do not bind a service to an application when you create, you can do it later with the [bind-service](#bind-service) command. For more information about creating and binding service instances, see [Getting Started - Adding a Service](/docs/dotcom/adding-a-service.html).

**Usage**

`go-cf create-service SERVICE PLAN SERVICE_INSTANCE` or `cs SERVICE PLAN SERVICE_INSTANCE`

**Example**

<div class="command-doc">
  <pre class="terminal">
go-cf create-service cleardb spark clear-db-mine
Creating service clear-db-mine...
OK
</pre>
  <div class="break"></div>
</div>

To list service instances that already exist, use the [services](#services) command.


## <a id='create-service-auth-token'></a> create-service-auth-token ##

Create a service authorization token. 

**Usage**

`go-cf create-service-auth-token LABEL PROVIDER TOKEN`

**Example**

<div class="command-doc">
  <pre class="terminal"> </pre>
  <div class="break"></div>
</div>

## <a id='create-service-broker'></a> create-service-broker ##

Create a service broker. 

**Usage**

`go-cf create-service-broker SERVICE_BROKER USERNAME PASSWORD URL`

**Example**

<div class="command-doc">
  <pre class="terminal"> </pre>
  <div class="break"></div>
</div>

## <a id='create-space'></a> create-space ##

Create a space in an organization.

**Usage**

`go-cf create-space SPACE`

**Example**


<div class="command-doc">
  <pre class="terminal">go-cf create-space Stress
Creating space Stress...
OK

TIP: Use 'cf target -s Stress' to target new space</pre>
  <div class="break"></div>
</div>

## <a id='create-user'></a>create-user-provided-service, cups ##

Make a user-provided service available to Cloud Foundry applications.
**Usage**

**Example**

<div class="command-doc">
  <pre class="terminal"></pre>
  <div></div>
  <div class="break"></div>
</div>


## <a id='create-user'></a>create-user ##

Create a user account. If you do not supply required options on the command line, cf will prompt for them. 

**Usage**

**Example**

<div class="command-doc">
  <pre class="terminal"></pre>
  <div></div>
  <div class="break"></div>
</div>

## <a id='delete-domain'></a> delete-domain ##

Delete a domain.

**Usage**
`go-cf delete-domain DOMAIN` 

Use the `-f` option to delete the domain without being prompted to confirm that you want to delete it. For example:

`go-cf delete-domain -f DOMAIN`

## <a id='delete'></a> delete, d ##

Delete an application. cf will ask you to confirm that you wish to delete the application and whether you want to also delete the services bound to the application.

**Usage**
`go-cf delete APP` or `cf d APP`

Use the `-f` option to delete the application without being prompted to confirm that you want to delete it. For example:

`go-cf delete -f APP`

**Example**

<div class="command-doc">
  <pre class="terminal">
go-cf d -f plain-java
Deleting app plain-java...
OK</pre>
</div>


## <a id='delete-org'></a> delete-org ##

Delete an organization.

**Usage**

`go-cf delete-org ORG`

Use the `-f` option to delete the organization without being prompted to confirm that you want to delete it. For example:

`go-cf delete-org -f ORG`

**Example**

<div class="command-doc">
  <pre class="terminal">$ cf delete-org [organisation name]</pre>
  <div class="break"></div>
</div>

## <a id='delete-route'></a> delete-route TBS##

Delete a route.

**Usage**

**Example**

<div class="command-doc">
  <pre class="terminal"></pre>
  <div class="break"></div>
</div>


## <a id='delete-service-auth-token'></a> delete-service-auth-token ##

Delete a service authorization token. 

**Usage**

**Example**

<div class="command-doc">
  <pre class="terminal"></pre>
  <div class="break"></div>
</div>

## <a id='delete-service-auth-token'></a> delete-service-broker ##

Delete a service broker. 

**Usage**
`go-cf delete-service-broker SERVICE_BROKER

**Example**

<div class="command-doc">
  <pre class="terminal"></pre>
  <div class="break"></div>
</div>

## <a id='delete-service'></a>delete-service, ds ##

Delete a service.

**Usage**

go-cf delete-service SERVICE

**Example**

<div class="command-doc">
  <pre class="terminal">go-cf delete-service clear-db-mine
Deleting service clear-db-mine...
OK
</pre>
  <div class="break"></div>
</div>

## <a id='delete-space'></a> delete-space ##

Delete a space and its contents.

**Usage**

`go-cf delete-space SPACE`

Use the `-f` option to delete the space without being prompted to confirm that you want to delete it. For example:

`go-cf delete-space -f SPACE`

**Example**

<div class="command-doc">
  <pre class="terminal">
go-cf delete-space Stress -f
Deleting space Stress...
OK
</pre>
  <div class="break"></div>
</div>


## <a id='delete-user'></a> delete-user ##

Delete a user account. 

**Usage**

**Example**

<div class="command-doc">
  <pre class="terminal"> </pre>
  <div class="break"></div>
</div>

## <a id='domain'></a> domains ##

List domains in the target organization..

**Usage**

`go-cf domains`

**Example**

<div class="command-doc">
  <pre class="terminal">go-cf domains
Getting domains in org mmcgarry...
OK
name                 status     spaces                                                                                   
cfapps.io            shared     development, staging, production, pearl, development, staging, production, development   
test.com             owned      development                                                                                                                                                          
test2.com            owned      development                                                                              
myfav.com            owned      staging, production, pearl                                                               
allspacedomain.com   reserved                                                                                            
mynewdomain.com      reserved                                                                                            
www.myexample.com    owned      development, staging, production, pearl                                                  
foo.bar.mel.com      owned      development, staging, production, pearl                                                  
www.test.do.more     owned      development, staging, production, pearl   
</pre>
  <div class="break"></div>
</div>

**Results**

The following data is returned:

* name -- The name of the domain.
* status --- The status of the domain: "shared", "owned", or "reserved"
* spaces --- ???


## <a id='env'></a> env, e ##

Show all environment variables set for an application. Environment variables are a good way to store sensitive data, such as API keys for Amazon S3, outside of an application's source code.

You can set environment variables for an application:

* in the application manifest when deploying the application, as described in [Set Environment Variable in a Manifest](/docs/using/deploying-apps/manifest.html#var) on the "Application Manifests" page, or 
* after pushing the application, with the [set-env](#set-env) command. 

**Usage**

`go-cf env APP`

**Example**

<div class="command-doc">
  <pre class="terminal">go-cf env hello-frankie
Getting env variables for hello-frankie...
OK
lang: english</pre>
</div>

## <a id='events'></a> events ##

Show recent events for an application. 

**Usage**

`go-cf events APP`

**Example**
<div class="command-doc">
  <pre class="terminal">go-cf events hello-frankie
Getting events for hello-frankie...
OK
time                          instance   description     exit status   
2013-05-30T10:51:12.00-0700   2          out of memory   137           
2013-05-30T10:51:12.00-0700   1          out of memory   137           
2013-05-30T10:51:12.00-0700   0          out of memory   137 
</pre>
</div>

**Results** 
The following data is returned for each event:

* time ---
* instance --- The instance index.
* description --- Description of the error.
* exit status --- Exit status 

## <a id='files'></a> files, f##

Print out a list of files in a directory or the contents of a specific file, belonging to the specified application.

**Usage**

`cf files APP [PATH]` or `cf f APP [PATH]`

**Example**

In this example, the files in the application named "hello-frankie" are listed.
<div class="command-doc">
  <pre class="terminal">
go-cf files hello-frankie
Getting files...
OK
.bash_logout                              220B
.bashrc                                   3.0K
.profile                                  675B
app/                                         -
logs/                                        -
run.pid                                     3B
startup                                   490B
tmp/                                         -                         -
</pre>
</div>

In this example, the contents of the file named "run.pid" are listed.

<div class="command-doc">
  <pre class="terminal">
go-cf files hello-frankie run.pid
Getting files...
OK
32
</pre>
</div>


## <a id='guid'></a> guid TBS##

Get the GUID for the object with the type (for instance, app, organization, space, domain, and so on) and name specified. 

<div class="command-doc">
  <pre class="terminal">$ cf guid type [name]</pre>
  <div></div>
  <div class="break"></div>
</div>

| Qualifier | Required | Description |
| :-------- | :------- | :---------- |
|--name NAME  | n|The name of the object. |
|--type TYPE |y |The type of the object: "app", "org", "space", "domain".  |


## <a id='login'></a> login, l ##

Authenticate with the target. 

**Usage**

`cf login [USERNAME] [PASSWORD]`

**Interactive Login Example**

Although you can supply your username and password on the command line, it is not recommended, as your shell history will contain your password in plain text. For best security, enter `login` on the command line without your username and password, and then respond to the interactive prompts.

<div class="command-doc">
  <pre class="terminal">
cf login

target: https://api.run.pivotal.io

Email> jdoe@startup.io

Password> *********

Authenticating... OK
  </pre>
  <div class="break"></div>
</div>

**Non-interactive Examples**


`cf login jdoe@startup.io pa55woRD` (specify username and password to login non-interactively)

`cf login jdoe@startup.io "my password"` (use quotes for passwords with a space)
   
`cf login jdoe@startup.io "\"password\""` (escape quotes if used in password)

## <a id='logout'></a> logout, lo ##

Log out from the target.

**Usage**

`cf logout`

## <a id='logs'></a> logs ##

Tail, or by using the `--recent` qualifier, display the recently added content of log files, such as staging, stdout, and stderr, for an application. The log files available for an application vary by type.

To view the contents of a specific file in the application directory structure, use `cf files`.

**Usage**

`cf logs APP [--recent]`


**Example**

<div class="command-doc">
  <pre class="terminal">cf logs rabbitmq-node

Using manifest file manifest.yml

Getting logs for rabbitmq-node #0... OK

Reading logs/env.log... OK
TMPDIR=/home/vcap/tmp
VCAP_CONSOLE_IP=0.0.0.0
VCAP_APP_PORT=61749
USER=vcap
VCAP_APPLICATION={"instance_id":"633be93bac16a403721cef6adb8f48f0","instance_index":0,"host":"0.0.0.0","port":61749,"started_at":"2013-08-20 22:32:39 +0000","started_at_timestamp":1377037959,"start":"2013-08-20 22:32:39 +0000","state_timestamp":1377037959,"limits":{"mem":256,"disk":1024,"fds":16384},"application_version":"230091c5-b14b-41d2-94c0-c0149a8ba4b7","application_name":"rabbitmq-node","application_uris":[],"version":"230091c5-b14b-41d2-94c0-c0149a8ba4b7","name":"rabbitmq-node","uris":[],"users":null}
PATH=/home/vcap/app/bin:/home/vcap/app/node_modules/.bin:/bin:/usr/bin
PWD=/home/vcap
VCAP_SERVICES={"cloudamqp-n/a":[{"name":"rabbit-sample","label":"cloudamqp-n/a","tags":[],"plan":"lemur","credentials":{"uri":"amqp://urhyfncz:CvvtPhOUHdk_CFQiUruW6sQDTFBd61Sv@lemur.cloudamqp.com/urhyfncz"}}]}
SHLVL=1
HOME=/home/vcap/app
PORT=61749
VCAP_APP_HOST=0.0.0.0
DATABASE_URL=
MEMORY_LIMIT=256m
VCAP_CONSOLE_PORT=61750
_=/usr/bin/env



Reading logs/staging_task.log... OK
-----> Downloaded app package (4.0K)
-----> Resolving engine versions

       WARNING: No version of Node.js specified in package.json, see:
       https://devcenter.heroku.com/articles/nodejs-versions

       Using Node.js version: 0.10.15
       Using npm version: 1.2.30
-----> Fetching Node.js binaries
-----> Vendoring node into slug
-----> Installing dependencies with npm
       npm WARN package.json rabbitmq-node@0.0.2 No repository field.
       npm http GET https://registry.npmjs.org/amqp
       npm http GET https://registry.npmjs.org/sanitizer
       npm http 200 https://registry.npmjs.org/sanitizer
       npm http GET https://registry.npmjs.org/sanitizer/-/sanitizer-0.0.15.tgz
       npm http 200 https://registry.npmjs.org/amqp
       npm http GET https://registry.npmjs.org/amqp/-/amqp-0.1.7.tgz
       npm http 200 https://registry.npmjs.org/sanitizer/-/sanitizer-0.0.15.tgz
       npm http 200 https://registry.npmjs.org/amqp/-/amqp-0.1.7.tgz
       sanitizer@0.0.15 node_modules/sanitizer
       
       amqp@0.1.7 node_modules/amqp
       npm WARN package.json rabbitmq-node@0.0.2 No repository field.
       amqp@0.1.7 /tmp/staged/app/node_modules/amqp
       sanitizer@0.0.15 /tmp/staged/app/node_modules/sanitizer
       Dependencies installed
-----> Building runtime environment



Reading logs/stderr.log... OK


Reading logs/stdout.log... OK
Starting ... AMQP URL: amqp://urhyfncz:CvvtPhOUHdk_CFQiUruW6sQDTFBd61Sv@lemur.cloudamqp.com/urhyfncz

  <div class="break"></div>
</div>

## <a id='map'></a> map ##

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


## <a id='map-domain'></a> map-domain ##

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


## <a id='org'></a> org ##

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

## <a id='orgs'></a> orgs ##

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

## <a id='passwd'></a> passwd ##

Set a user's password. 
<div class="command-doc">
  <pre class="terminal">$ cf passwd [email]</pre>
  <div class="break"></div>
</div>

## <a id='push'></a> push ##

Deploy a new application, or, if the application already exists, upload any changes made since the last push.

You can define deployment options on the command line, interactively, or in a manifest file. The first time you run `cf push` for an application, unless you provide deployment options on the command line, cf will look for `manifest.yml` in the current working directory. If the manifest file does not exist, cf will prompt you to supply the deployment settings interactively. After you supply the qualifiers required to push an application, cf will offer you the option to save the configuration. If you accept, the settings you chose will be saved in the current working directory in `manifest.yml`. 

Note that when you redeploy an application, cf does _not_ refer to `manifest.yml` for deployment settings. Instead, cf will deploy the application with the currently active deployment settings. You must use the `--reset` option to cause the settings in the manifest to be applied on subsequent pushes. For more information see [cf push and the Manifest](../../deploying-apps/manifest.html#push-and-manifest) on the [Application Manifests](../../deploying-apps/manifest.html) page.


cf will upload all application files with the exception of version control files with file extensions `.svn`, `.git`, and `.darcs`. If there are other files you wish to exclude from upload, you can specify them in a `.cfignore` file in the directory where you run the push command. `.cfignore` behaves similarly to `.gitignore`. For more information see [Exclude Unnecessary Files with cfignore](/docs/using/deploying-apps/index.html#exclude) on [Key Facts About Application Deployment](/docs/using/deploying-apps/index.html).


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
| --command COMMAND        |         |The command to use to start the application. <br><br>If you use this option to specify a script that contains the start command, be sure to include the relative path to the script. For example, if your start script, `start.sh`, is in the `\bin` directory of your application's root directory, specify `--command './bin.start.sh'`.<br><br>For information about how Cloud Foundry starts an application if you do not specify a start command when you push the application, see [The Application Start Command](/docs/using/deploying-apps/index.html#start-command), on [Key Facts About Application Deployment](/docs/using/deploying-apps/index.html). |
| --domain DOMAIN              |          | The top level internet domain for the application. |
| --host HOST    |        |The subdomain, leave blank if specifying custom domain.            |
| --instances INSTANCES       |          | The  number of instances of the application to start.|
| --memory MEMORY             |          | The maximum memory to allocate to each application instance.           |
| --name NAME             | | The name of the application to push. |
| --plan PLAN              | | Specify the desired plan for the service. (A _plan_ specifies a pricing terms and resource <BR>limits for the service.)     |
|--path | |Path to the application to be pushed. |
| --reset             | |Use this option if you are specifying a new value for one or more `push` options to indicate <BR>that the newly supplied value should override previously provided option values. |
| --stack STACK           | | |

## <a id='register'></a> register ##

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
## <a id='rename'></a> rename ##

Rename an application.  If you do not provide the required input on the command line, cf will prompt for it.

Note that after you change an application's name, cf will not recognize the application's previous name if you use it in commands that act upon an application.  

<div class="command-doc">
  <pre class="terminal">$ cf rename [current application name] [new application name]</pre>
</div>

## <a id='rename-org'></a> rename-org ##

Rename an organization
<div class="command-doc">
  <pre class="terminal">$ cf rename-org [organization name] [new organization name]</pre>
  <div class="break"></div>
</div>

## <a id='rename-service'></a> rename-service ##

Rename a service.
<div class="command-doc">
  <pre class="terminal">$ cf rename-service [instance name] [new instance name]</pre>
  <div class="break"></div>
</div>

## <a id='rename-space'></a> rename-space ##

Rename a space.

<div class="command-doc">
  <pre class="terminal">$ cf rename-space [space name] [new space name]</pre>
  <div class="break"></div>
</div>

## <a id='restart'></a> restart ##

Stop an application and then start it.

<div class="command-doc">
  <pre class="terminal">$ cf restart [APP]</pre>
</div>


| Qualifier | Required | Description |
| :-------- | :------- | :---------- |
|--all | |Delete all applications in the current space. |
|--app APP | |The name of the application to delete. |
|-d, --debug-mode DEBUG_MODE  | |Use this option to specify a debug mode to use when restarting the application. |

## <a id='routes'></a> routes ##

List routes in a space.

<div class="command-doc">
  <pre class="terminal">$ cf routes</pre>
  <div></div>
  <div class="break"></div>
</div>

## <a id='scale'></a> scale ##

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


## <a id='service-auth-token'></a> service-auth-token ##

List service authorization tokens. 

<div class="command-doc">
  <pre class="terminal">$ cf service-auth-token</pre>
  <div class="break"></div>
</div>

The following data is returned for each token:

* guid -- The GUID for the service type.
* provider -- The vendor or supplier of the service.

## <a id='service'></a> service ##

Display service instance information.

<div class="command-doc">
  <pre class="terminal">$ cf service [instance name]</pre>
  <div class="break"></div>
</div>

## <a id='services'></a> services ##

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
| -m --marketplace | n | List service types available from the Services Marketplace. |
| --plan PLAN | n | List only service instances provisioned under a plan that matches the specified string. |
|--provider PROVIDER   | n |List only service instances provisioned by a service from the the provider that matches the specified string.   |
|--service SERVICE   |n  |List only service instances provisioned by a service that matches the specified string.   |
| --space SPACE |  |List only service instances in the specified space.  |
| --version VERSION |  |List only services instances whose version matches the specified string.  |

If the `--marketplace` qualifier is supplied, the following data is returned for each service available from the Services Marketplace:

* service -- The type of service, for example, "cleardb" or "rediscloud".
* version -- The version of the service.
* provider -- The service vendor or supplier.
* plan -- The provider plans under which the service is available.
* description -- A description of the service.   

When qualifiers other than `--marketplace` are supplied, the following data is returned for each service instance:

* name -- The name assigned to the service instance when it was created.
* service -- The type of service, for example, "cleardb" or "rediscloud".
* provider -- The service vendor or supplier.
* version -- The version of the service.
* plan -- The provider plan under which the service was obtained.
* description -- This attribute, a description of the plan, is returned if you run the command with the `--full` option.
* bound apps -- The applications to which the service is bound.

## <a id='set-env'></a> set-env ##

Set an environment variable. For information about removing an environment variable see [unset-env](#unset-env).

<div class="command-doc">
  <pre class="terminal">$ cf set-env [App] [Variable] [Value]</pre>
</div>

| Qualifier | Required | Description |
| :-------- | :------- | :---------- |
|--[no-]restart |n |Use this option to indicate that you do (or do not) want to restart the application after updating it. |
|--app APP | y |The application for which you are defining the variable. |
|--name NAME    | y |The name of the environment variable. |
|--value VALUE   | y |The value of the environment variable. |

## <a id='set-quota'></a> set-quota ##

Define the quota for an organization. 

<div class="command-doc">
  <pre class="terminal">$ cf set-quota [QUOTA_DEFINITION] [ORGANIZATION]</pre>
</div>

| Qualifier | Required | Description |
| :-------- | :------- | :---------- |
|--quota-definition QUOTA-DEFINITION| y| Allowable values are: "free", "paid", "runaway", and "trial"|
|--organization ORG |y |The organization for which to set the quota. |


## <a id='space'></a> space ##

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

## <a id='spaces'></a> spaces ##

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

## <a id='start'></a> start ##

Start a stopped application.

<div class="command-doc">
  <pre class="terminal">$ cf start [APP]</pre>
</div>

| Qualifier | Required | Description |
| :-------- | :------- | :---------- |
|--all | |Start all application in the space. |
|--apps, --app APPS | |Use this qualifier to specify selected applications to start. |
|-d, --debug-mode DEBUG_MODE  | |Debug mode in which to start the application. |

## <a id='stats'></a> stats ##

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

## <a id='stop'></a> stop ##

Stop an application whose status is not already "Stopped".

<div class="command-doc">
  <pre class="terminal">$ cf stop [list of application names]</pre>
</div>

| Qualifier | Required | Description |
| :-------- | :------- | :---------- |
|--all | |Stop all application in the space. |
|--apps, --app APPS | |Use this qualifier to specify selected applications to stop. |


## <a id='tail'></a> tail ##

Watch the file for the specified application and the specified path, and display changes as they occur. (Similar to the \*nix  'tail' command.)

<div class="command-doc">
  <pre class="terminal">$ cf tail [application name] [path]</pre>
  <div class="break"></div>
</div>

| Qualifier | Required | Description |
| :-------- | :------- | :---------- |
|--app APP| | |
|--path PATH | | |

## <a id='target'></a> target ##

Set a target organization or user, or view the currently targeted API endpoint, logged-in user, and targeted organization and space. 

**Usage**

`go-cf target [-o ORG] [-s SPACE0`

**Example**

To target an organization and space:
<div class="command-doc">
  <pre class="terminal">
go-cf target -o jdoe -s development
API endpoint: https://api.run.pivotal.io (API version: 2)
User:         jdoe@gopivotal.com
Org:          jdoe
Space:        development
</pre>
  <div class="break"></div>
</div>

To target a different space:
<div class="command-doc">
  <pre class="terminal">
go-cf target  -s production
API endpoint: https://api.run.pivotal.io (API version: 2)
User:         jdoe@gopivotal.com
Org:          jdoe
Space:        production
</pre>
  <div class="break"></div>
</div>

To view current target settings:

<div class="command-doc">
  <pre class="terminal">
go-cf target 
API endpoint: https://api.run.pivotal.io (API version: 2)
User:         jdoe@gopivotal.com
Org:          jdoe
Space:        production
</pre>
  <div class="break"></div>
</div>

## <a id='unbind-service'></a> unbind-service ##

Remove a service binding from an application. cf will prompt for required qualifiers not supplied on the command line.

<div class="command-doc">
  <pre class="terminal">$ cf unbind-service [instance name] [application name]</pre>
  <div class="break"></div>
</div>


## <a id='unmap-domain'></a> unmap-domain##

Unmap a domain from a space.

**Usage**
<div class="command-doc">
  <pre class="terminal">$ cf unmap-domain SPACE DOMAIN</pre>
  <div class="break"></div>
</div>

**Example**

## <a id='unmap-route'></a> unmap-route##

Remove a URL route from an application.

**Usage**
<div class="command-doc">
  <pre class="terminal">$ cf unmap-route APP DOMAIN [-n HOSTNAME]</pre>
  <div class="break"></div>
</div>

**Example**

## <a id='unset-env'></a> unset-env ##

Remove an environment variable. For information about defining an environment variable see [set-env](#set-env).

**Usage**
<div class="command-doc">
  <pre class="terminal">$ cf unset-env APP NAME</pre>
</div>


## <a id='update-service-auth-token'></a> update-service-auth-token ##

Update a service authorization token.

**Usage**

<div class="command-doc">
  <pre class="terminal">$ cf update-service-auth-token [SERVICE_AUTH_TOKEN]</pre>
</div>

## <a id='update-service-broker'></a> update-service-broker ##
**Usage**

<div class="command-doc">
  <pre class="terminal">$ cf update-service-broker SERVICE_BROKER USERNAME PASSWORD URL</pre>
</div>

## <a id='update-user-provided-service'></a>update-user-provided-service, uups ##

**Usage**

<div class="command-doc">
  <pre class="terminal">$ cf update-service-broker SERVICE_BROKER USERNAME PASSWORD URL</pre>
</div>



