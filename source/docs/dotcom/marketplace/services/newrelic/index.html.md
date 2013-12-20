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

## <a id='notes'></a>Important Notes ##

* To opt-out of marketing emails from New Relic, log into their dashboard via SSO as described above and click the account dropdown in the top-right. In User Preferences, unselect "I want to receive information emails", then click "Save email preferences".
* Also on the User Preferences page of New Relic's site is a field to change the email address for the account. *Do not change this field*. Doing so with break the SSO integration and prevent you from logging into your account. 

## <a id='sample-app'></a>Sample Applications ##

### <a id='sample-rails'></a>Rails ###

[This sample Rails app](https://github.com/cloudfoundry-samples/rails_sample_app/tree/newrelic) already has the New Relic agent included in `Gemfile`, as well as our modified configuration file in `config/newrelic.yml`. We've even configured `manifest.yml` to create and bind to a New Relic service instance on push. All you need to do is clone and push!

<pre class="terminal">
$ git clone -b newrelic git@github.com:cloudfoundry-samples/rails_sample_app.git
$ cd rails_sample_app
$ cf push
</pre>

### <a id='sample-java'></a>Java ###

[This sample Java app](https://github.com/cloudfoundry-samples/spring-music/tree/newrelic) takes advantage of the Java buildpack's zero-touch New Relic support.  The included `manifest.yml` contains configuration to automatically create and bind a new instance of the New Relic service to your application.  All you need to do is clone, build, and push!

<pre class="terminal">
$ git clone -b newrelic https://github.com:cloudfoundry-samples/spring-music.git
$ cd spring-music
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

### <a id='java'></a>Java ###

1. Build your app.
1. Push your app to Cloud Foundry. If you don't already have a New Relic service instance in your space, choose to create one when prompted. If you already have a New Relic service instance in your space, choose to bind to an existing service when prompted.
	<pre class="terminal">
	$ cf push
	</pre>
1. Now generate some usage on your app and log into New Relic via SSO [as described above](#sso); you should see data coming through!

---

## <a id='vcap-services'></a>VCAP_SERVICES ##

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
For more information, see [VCAP_SERVICES Environment Variable](/docs/using/deploying-apps/environment-variable.html).

---

## <a id='support'></a>Support ##

[Contacting Service Providers for Support](../../contacting-service-providers-for-support.html)

* https://support.newrelic.com/
* support@newrelic.com

Documentation: https://newrelic.com/docs
