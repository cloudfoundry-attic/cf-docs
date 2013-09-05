---
title: New Relic
---

## <a id='managing'></a>Managing Services ##

[Managing services from the command line](../../../../using/services/managing-services.html)

### <a id='create'></a>Creating a Service Instance ###

An instance of this service can be provisioned via the CLI with the following command:

<pre class="terminal">
$ cf create-service newrelic
</pre>

### <a id='bind'></a>Binding Your Service Instance ###

Bind the service instance to your app with the following command:

<pre class="terminal">
$ cf bind-service 
</pre>

### <a id='sso'></a>Single Sign On ###

To log into your New Relic Account via SSO you only need to log into the [run.pivotal.io Web Console](http://console.run.pivotal.io). Find your New Relic service instance on the Space page in which you created it. Clicking the Manage button will log you into the New Relic account for your instance via SSO.

---

## <a id='sample-app'></a>Sample Applications ##

### <a id='sample-rails'></a>Rails ###

[This sample Rails app](https://github.com/cloudfoundry-samples/rails_sample_app/tree/newrelic) already has the New Relic agent included in `Gemfile`, as well as our modified configuration file in `config/newrelic.yml`. We've even configured `manifest.yml` to create and bind to a New Relic service instance on push. All you need to do is clone and push!

<pre class="terminal">
$ git clone -b newrelic git@github.com:cloudfoundry-samples/rails_sample_app.git
$ cd rails_sample_app
$ cf push
</pre>

### <a id='sample-spring'></a>Spring ###

[This sample Spring app](https://github.com/cloudfoundry-samples/spring-music/tree/newrelic) already has the New Relic agent configured as a dependency in `build.gradle` and the New Relic configuration file in `src/main/resources`. We've also configured `manifest.yml` to set the necessary environment variable when you push the app, but you'll need to edit that file with an actual value for `-Dnewrelic.config.license_key` in `CATALINA_OPTS`. Because we've already got a manifest.yml, we're going to create the New Relic service instance first, update the manifest, then build and push.   

<pre class="terminal">
$ git clone -b newrelic git@github.com:cloudfoundry-samples/spring-music.git
$ cd spring-music
$ cf create-service newrelic --name newrelic --plan standard
</pre>

Log into your New Relic account via SSO [as described above](#sso). Once there, click on Account Settings in the top right. On the right of that page you'll find your New Relic license key. Add the license key to `-Dnewrelic.config.license_key` for `CATALINA_OPTS` in `manifest.yml`.

<pre class="terminal">
$ ./gradlew assemble
$ cf push
</pre>

---

## <a id='using'></a>Using New Relic with your Application ##

In order for metrics for your application to be reported to New Relic, the following three requirements must be satisfied:

* A New Relic agent bundled with your application
* A configuration file the agent requires
* An account-specific license key configured in the configuration file

All three of these things can be found by logging into your New Relic account as described above, but we want to make it even easier than that. See our language-specific solutions below.

### <a id='ruby'></a>Ruby / Rails ###

1. Add the New Relic agent gem to your Gemfile.

  ~~~xml
  gem 'newrelic_rpm'
  ~~~
  Rebuild the bundle if you want to test locally, but this isn't required because Cloud Foundry will bundle the gem when you push your app.
  <pre class="terminal">
  $ bundle install
  </pre>

1. Add a New Relic configuration file to your project. This file needs to be configured with your license key and application name, but we've modified New Relic's config file for Ruby to automatically read your application name and license key from environment variables which are set when the app is pushed. [Download our modified newrelic.yml here](./newrelic-ruby.yml) and save it to `config/newrelic.yml`.

	<pre class="terminal">
	$ wget -O config/newrelic.yml http://docs.cloudfoundry.com/docs/dotcom/marketplace/services/newrelic/newrelic-ruby.yml 
	</pre>

1. All you have left to do is push your app! If you don't already have a New Relic service instance in your space, choose to create one when prompted. If you already have a New Relic service instance in your space, choose to bind to an existing service when prompted.
	
	<pre class="terminal">
	$ cf push
	</pre> 

1. Now generate some usage on your app and log into New Relic via SSO [as described above](#sso); you should see data coming through!

### <a id='java'></a>Java / Spring ###

1. Add the New Relic agent to your project

  For Maven, add the following to `pom.xml`

  ~~~xml
  <dependency>
      <groupId>com.newrelic.agent.java</groupId>
      <artifactId>newrelic-agent</artifactId>
      <version>2.21.3</version>
  </dependency>
  ~~~

  For Gradle, put the following in `build.gradle`

  ~~~xml
  dependencies {
      compile 'com.newrelic.agent.java:newrelic-agent:2.21.3'
  }
  ~~~

1. Add a New Relic configuration file to your project. [Download newrelic.yml](./newrelic.yml) and save it with your other app config files (e.g. in `src/main/resources/newrelic.yml`). No need to populate application name and license key; we'll set an environment variable to pass them as system parameters to the jvm. This will overwrite the same parameters in the config file.

	<pre class="terminal">
	$ wget -O src/main/resources/newrelic.yml http://docs.cloudfoundry.com/docs/dotcom/marketplace/services/newrelic/newrelic.yml
	</pre>

1. Build your app!

1. Push your app to Cloud Foundry. If you don't already have a New Relic service instance in your space, choose to create one when prompted. If you already have a New Relic service instance in your space, choose to bind to an existing service when prompted.

	<pre class="terminal">
	$ cf push
	</pre> 

1. Next, we need to get the license key. Log into your New Relic account via SSO [as described above](#sso). Once there, click on Account Settings in the top right. On the right of that page you'll find your New Relic license key. You're going to need it for the next step.

1. Now we're going to set an environment variable to pass system parameters to the jvm. Replace `your_app_name` and `your_license_key` with actual values.

	<pre class="terminal">
	$ cf set-env <your app name> CATALINA_OPTS "-javaagent:/app/webapps/ROOT/WEB-INF/lib/newrelic-agent-2.21.3.jar 
		-Dnewrelic.home='/app/webapps/ROOT/WEB-INF/classes' 
		-Dnewrelic.config.license_key='your_license_key' 
		-Dnewrelic.config.app_name='your_app_name'
		-Dnewrelic.config.log_file_path='/home/vcap/logs'"
	</pre>

1. Finally, restart your app. This will trigger the jvm to pick up the system parameters required for the New Relic agent to be started with the correct configuration.

	<pre class="terminal">
        $ cf restart <your app name>
        </pre>

1. Now generate some usage on your app and log into New Relic via SSO described above](#sso); you should see data coming through!

####Cloud Foundry is working on improving the developer experience for New Relic and Java. Stay tuned!

### <a id='vcap-services'></a>VCAP_SERVICES ###

When you bind your New Relic service instance with your application, Cloud Foundry makes a request to New Relic for the license key for your account. When you restart your application, we write this key to the `VCAP_SERVICES` environment variable.

Format of `VCAP_SERVICES` environment variable:

~~~xml
{
  "newrelic-n/a":[
    {
      "name":"newrelic-14e9d",
      "label":"newrelic-n/a",
      "plan":"standard",
      "credentials":
        {
          "licenseKey":"2865f6f3nsig8f813af7989fccb24a699cb22a4beb"
        }
    }
  ]
}
~~~
For more information, see [VCAP_SERVICES Environment Variable](../../../using/deploying-apps/environment-variable.html).

---

## <a id='support'></a>Support ##

[Contacting Service Providers for Support](../../contacting-service-providers-for-support.html)

* https://support.newrelic.com/
* support@newrelic.com

Documentation: https://newrelic.com/docs
