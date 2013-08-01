---
title: New Relic
---

## <a id='managing'></a>Managing Services ##

[Managing services from the command line](../../../using/services/managing-services.html)

### Creating a Service Instance ##

An instance of this service can be provisioned via the CLI with the following command:

<pre class="terminal">
$ cf create-service newrelic
</pre>

### Binding Your Service Instance ##

Bind the service instance to your app with the following command:

<pre class="terminal">
$ cf bind-service 
</pre>

### Single Sign On

To log into your New Relic Account via SSO you only need to log into the [run.pivotal.io Web Console](http://console.run.pivotal.io). Find your New Relic service instance on the Space page in which you created it. Clicking the Manage button will log you into New Relic via SSO.

## <a id='using'></a>Using New Relic with your Application ##

In order for metrics for your application to be reported to New Relic, the following three requirements must be satisfied:

* A New Relic agent bundled with your application
* A configuration file the agent requires
* An account-specific license key configured in the configuration file

All three of these things can be found by logging into your New Relic account as described above, but we want to make it even easier than that. See our language-specific solutions below.

### <a id='ruby'></a>Ruby / Rails ###

* Add the New Relic agent gem to your Gemfile.

  ~~~xml
  gem 'newrelic_rpm'
  ~~~
  Rebuild the bundle to download the gem.
  <pre class="terminal">
  $ bundle install
  </pre>

* Add a New Relic configuration file to your project. This file needs to be configured with your license key, but we've modified New Relic's config file for Ruby to automatically read your license key from the [VCAP_SERVICES](#vcap-services) environment variable. [Download the modified newrelic.yml here](./newrelic.yml).

* All you have left to do is push your app! If you don't already have a New Relic service instance in your space, choose to create one when prompted. If you already have a New Relic service instance in your space, choose to bind to an existing service when prompted. Now generate some usage on your app, and log into New Relic via SSO as described above; you should see data coming through!

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
For more information, see [VCAP_SERVICES Environment Variable](../../../using/services/environment-variable.html).

## <a id='sample-app'></a>Sample Applications ##

<pre class="terminal">
$ git clone -b newrelic-1 git@github.com:cloudfoundry-samples/rails_sample_app.git
$ cd rails_sample_app
$ cf push
</pre>

This rails app already has the newrelic agent included in the Gemfile, as well as the modified configuration file in config/newrelic.yml. We've even configured manifest.yml to create and bind to a New Relic service instance. All you need to do is clone and push!


## <a id='support'></a>Support ##

[Contacting Service Providers for Support](contacting-service-providers-for-support.html)
