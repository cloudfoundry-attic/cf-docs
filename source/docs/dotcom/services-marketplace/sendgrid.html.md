---
title: SendGrid
category: marketplace
---

## <a id='managing-services'></a>Managing Services ##

[Manage Services from the Command Line](managing-services.html)

## <a id='environment-variable'></a>Environment Variables ##

Format of credentials in VCAP_SERVICES environment variable.

~~~xml
{
  sendgrid-dev-n/a: [
    {
      name: "sendgrid-dev-75efc",
      label: "sendgrid-dev-n/a",
      plan: "free",
      credentials: {
        username: "QvsXMbJ2rK",
        password: "HCDVOYluTv"
      }
    }
  ]
}
~~~

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


