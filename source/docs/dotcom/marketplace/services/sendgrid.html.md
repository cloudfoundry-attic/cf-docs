---
title: SendGrid
category: marketplace
---

[SendGrid's](http://sendgrid.com)  cloud-based email infrastructure relieves businesses of the cost and complexity of maintaining custom email systems. SendGrid provides reliable delivery, scalability and real-time analytics along with flexible APIs that make custom integration a breeze.


## <a id='creating-a-sendgrid-service'></a>Creating A SendGrid Service ##

SendGrid can be provisioning via the CLI with the following command:

<pre class="terminal">
$ cf create-service sendgrid [service-name]
</pre>
    
and the desired plan.    

## <a id='binding-your-sendgrid-service'></a>Binding Your SendGrid Service ##

Bind your SendGrid service to your app, using the following command:
    
    $ cf bind-service [service-name] [app name]


Once SendGrid has been added a username, password will be available and will contain the credentials used to access the newly provisioned SendGrid service instance.


## <a id='environment-variable'></a>Environment Variables ##

Format of credentials in VCAP_SERVICES environment variable.


    {
      sendgrid-n/a: [
        {
          name: "[service-name]",
          label: "sendgrid-n/a",
          plan: "free",
          credentials: {
            username: "QvsXMbJ3rK",
            password: "HCHMOYluTv"
          }
        }
      ]
    }



## <a id='sample-app'></a>Sample Applications ##

### Spring

https://github.com/scottfrederick/spring-sendgrid

This app can be used to test your SendGrid service binding. 

<pre class="terminal">
$ git clone git@github.com:scottfrederick/spring-sendgrid.git
$ cd spring-sendgrid
$ ./gradlew assemble
$ cf push
</pre>

When prompted to create a service for your app, select yes and choose SendGrid. This will provision an account on SendGrid and bind it to your app, which stores credentials for the account in the VCAP_SERVICES environment variable. This application will read those credentials and use them when it sends emails.

You can verify what credentials the app is using by navigating to `http://spring-sendgrid.<cloud-foundry-domain>/creds`.

You can see what environment variables are available to the application by navigating to `http://spring-sendgrid.<cloud-foundry-domain>/env`.

You can override SMTP credentials by configuring them in `src/main/resources/application.properties`.

~~~java
smtp.host=
smtp.user=
smtp.password=
~~~

## <a id='dashboard'></a>Dashboard ##

SendGrid offers statistics a number of different metrics to report on what is happening with your messages.
![Dashboard](https://sendgrid.com/docs/images/delivery_metrics.png)

To access your SendGrid dashboard, simply click the 'Manage' button next to the SendGrid service on your app space console.


## Managing Services

You can continue [managing your services from the command line](http://docs.cloudfoundry.com/docs/using/services/managing-services.html).


## <a id='support'></a>Support ##

All SendGrid support and runtime issues should be submitted via on of the [Contacting Service Providers for Support](http://docs.cloudfoundry.com/docs/dotcom/services-marketplace/contacting-service-providers-for-support.html). Any non-support related issues or product feedback is welcome at [http://support.sendgrid.com/home](http://support.sendgrid.com/home).


## <a id='additional-resources'></a>Additional resources ##

Additional resources are available at:

- [Integrate With SendGrid](http://sendgrid.com/docs/Integrate/index.html)
- [Code Examples](http://sendgrid.com/docs/Code_Examples/index.html)
