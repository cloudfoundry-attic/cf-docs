---
title: SendGrid
category: marketplace
---

### Environment Variables

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

## Sample Application

This app can be used to test your SendGrid service binding. Credentials can be configured in src/main/resources/application.properties.

<pre class="terminal">
$ git clone git@github.com:scottfrederick/spring-sendgrid.git
$ cd spring-sendgrid
$ cf push
</pre>


