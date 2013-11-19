---
title: SendGrid
---

[SendGrid's](http://sendgrid.com)  cloud-based email infrastructure relieves businesses of the cost and complexity of maintaining custom email systems. SendGrid provides reliable delivery, scalability and real-time analytics along with flexible APIs that make custom integration a breeze.

Pivotal CF hosted customers can start receiving 25,000 free emails using SendGrid each month. This will give you access to advanced reporting and analytics and all APIs (Web, SMTP, Event, Parse, Sub-User). If you have a run.pivotal.io account, simply [login](http://console.run.pivotal.io/) and go to the SendGrid plan page in the Marketplace to get started with your 25,000 free monthly emails for use with your app. Sign up [here](http://console.run.pivotal.io/register) if you do not have an account.

## <a id='managing'></a>Managing Services ##

To create and bind a new SendGrid service, see [Managing Services from the Command Line](../../../using/services/managing-services.html).

### Creating A SendGrid Service ##

SendGrid can be provisioned with the following command:

<pre class="terminal">
$ cf create-service sendgrid [service-name] [plan-level]
</pre>

The service name can be anything you want and the plan level is one of these options: free, bronze, silver, gold, platinum.

### Binding Your SendGrid Service ##

Bind your SendGrid service to your app, using the following command:
    
<pre class="terminal">
$ cf bind-service [service-name] [app-name]
</pre>

The service name should match the one you provisioned above and the app name should be an existing Cloud Foundry app.

Once SendGrid has been added a username and password will be available. These are the credentials you use to access the newly provisioned SendGrid service instance.

## <a id='using'></a>Using SendGrid within your Application ##

Once a SendGrid service instance has been bound to your application, the [VCAP_SERVICES Environment Variable](../../../using/deploying-apps/environment-variable.html) will be automatically updated to include your credentials. The section of `VCAP_SERVICES` that pertains to SendGrid will look like this:


    {
      sendgrid-n/a: [
        {
          name: "mysendgrid",
          label: "sendgrid-n/a",
          plan: "free",
          credentials: {
            hostname: "smtp.sendgrid.net",
            username: "QvsXMbJ3rK",
            password: "HCHMOYluTv"
          }
        }
      ]
    }

The getting started guide has more background on [using service instances with your application](../../adding-a-service.html#using).


## <a id='sample-app'></a>Sample Applications ##

With the SendGrid service provisioned and credentials added to the `VCAP_SERVICES` environment variable, you can now use SendGrid within your applications. You can either use SMTP with your SendGrid credentials or one of the many [SendGrid libraries](http://sendgrid.com/docs/Integrate/libraries.html).

### Java ###

The recommended way to use SendGrid with Java is to use the [sendgrid-java](https://github.com/sendgrid/sendgrid-java) library. The following example uses [sendgrid-java](https://github.com/sendgrid/sendgrid-java). Simply, replace your username and password with the username and password in your `VCAP_SERVICES` environment variable.

```java
import com.github.sendgrid.SendGrid;
SendGrid sendgrid = new SendGrid("sendgrid_username", "sendgrid_password");

sendgrid.addTo("example@example.com");
sendgrid.setFrom("other@example.com");
sendgrid.setSubject("Hello World");
sendgrid.setText("My first email through SendGrid");

sendgrid.send();
```

Optionally, combine with [vcapenv](https://github.com/scottmotte/vcapenv) to avoid entering in the username and password directly. Vcapenv will do the work to automatically pull your credentials from SendGrid.

```java
import com.github.scottmotte.Vcapenv;
import com.github.sendgrid.SendGrid;

Vcapenv vcapenv = new Vcapenv();
String sendgrid_username = vcapenv.SENDGRID_USERNAME();
String sendgrid_password = vcapenv.SENDGRID_PASSWORD();

SendGrid sendgrid = new SendGrid(sendgrid_username, sendgrid_password);

sendgrid.addTo("example@example.com");
sendgrid.setFrom("other@example.com");
sendgrid.setSubject("Hello World");
sendgrid.setText("My first email through SendGrid");

sendgrid.send();
```

See the example app [Spring-Attack](https://github.com/scottmotte/spring-attack) for a complete working example.

#### Alternative approach with JavaMail

If you prefer to use Java's built in libraries to send emails you can do the following using [JavaMail](https://java.net/projects/javamail/pages/Home).

```java
    import javax.mail.*;
    import javax.mail.internet.*;
    import javax.mail.Authenticator;
    import javax.mail.PasswordAuthentication;
    import java.util.Properties;
     
    public class SimpleMail {
     
        private static final String SMTP_HOST_NAME = “smtp.sendgrid.net”;
        private static final String SMTP_AUTH_USER = “<sendgrid_username>”;
        private static final String SMTP_AUTH_PWD  = “<sendgrid_password>”;
     
        public static void main(String[] args) throws Exception{
           new SimpleMail().test();
        }
     
        public void test() throws Exception{
            Properties props = new Properties();
            props.put(“mail.transport.protocol”, “smtp”);
            props.put(“mail.smtp.host”, SMTP_HOST_NAME);
            props.put(“mail.smtp.port”, 587);
            props.put(“mail.smtp.auth”, “true”);
     
            Authenticator auth = new SMTPAuthenticator();
            Session mailSession = Session.getDefaultInstance(props, auth);
            // uncomment for debugging infos to stdout
            // mailSession.setDebug(true);
            Transport transport = mailSession.getTransport();
     
            MimeMessage message = new MimeMessage(mailSession);
     
            Multipart multipart = new MimeMultipart(“alternative”);
     
            BodyPart part1 = new MimeBodyPart();
            part1.setText(“This is multipart mail and u read part1……”);
     
            BodyPart part2 = new MimeBodyPart();
            part2.setContent(”<b>This is multipart mail and u read part2……</b>”, “text/html”);
     
            multipart.addBodyPart(part1);
            multipart.addBodyPart(part2);
     
            message.setContent(multipart);
            message.setFrom(new InternetAddress(“me@myhost.com”));
            message.setSubject(“This is the subject”);
            message.addRecipient(Message.RecipientType.TO,
                 new InternetAddress(“someone@somewhere.com”));
     
            transport.connect();
            transport.sendMessage(message,
                message.getRecipients(Message.RecipientType.TO));
            transport.close();
        }
     
        private class SMTPAuthenticator extends javax.mail.Authenticator {
            public PasswordAuthentication getPasswordAuthentication() {
               String username = SMTP_AUTH_USER;
               String password = SMTP_AUTH_PWD;
               return new PasswordAuthentication(username, password);
            }
        }
    }
```
A sample application for using Spring Framework and SendGrid on Cloud Foundry can be found [here](https://github.com/cloudfoundry-samples/spring-sendgrid).

### Ruby on Rails ###

You can quickly get started with SendGrid using Ruby on Rails ActionMailer.

First, get SendGrid credentials from `VCAP_SERVICES` environment variable

```ruby
    credentials = host = username = password = ''
    if !ENV['VCAP_SERVICES'].blank?
      JSON.parse(ENV['VCAP_SERVICES']).each do |k,v|
        if !k.scan("sendgrid").blank?
          credentials = v.first.select {|k1,v1| k1 == "credentials"}["credentials"]
          host = credentials["hostname"]
          username = credentials["username"]
          password = credentials["password"]
        end
      end
    end
```    

You will also need to edit the ActionMailer settings in `config/environment.rb`:

```ruby
    ActionMailer::Base.smtp_settings = {
      :address => '<smtp_host>',
      :port => '587',
      :authentication => :plain,
      :user_name => '<sendgrid_username>',
      :password => '<sendgrid_password>',
      :domain => 'yourdomain.com',
      :enable_starttls_auto => true
    }
```
A sample application for using Ruby on Rails and SendGrid on Cloud Foundry can be found [here](https://github.com/cloudfoundry-samples/sendgrid-cloudfoundry-rails).

## <a id='dashboard'></a>Dashboard ##

SendGrid offers statistics for a number of different metrics to report on what is happening with your messages.

![Dashboard](http://static.sendgrid.com.s3.amazonaws.com/images/delivery_metrics.png)

To access your SendGrid dashboard, simply click the 'Manage' button next to the SendGrid service on your app space console.

## <a id='support'></a>Support ##

One of SendGrid's best features is its responsive customer service. You can contact SendGrid 24/7 by phone, web, and live chat:

* [http://support.sendgrid.com/](http://support.sendgrid.com/)
* Toll Free: +1 (877) 969-8647
* support@sendgrid.com

To properly reference your SendGrid account within CloudFoundry, see the information about [contacting service providers for support](../contacting-service-providers-for-support.html).

If you have product feedback, or issues unrelated to your account, you can add it to [http://support.sendgrid.com/home](http://support.sendgrid.com/home).

## <a id='additional-resources'></a>Additional Resources ##

Additional resources are available at:

- [Integrate With SendGrid](http://sendgrid.com/docs/Integrate/index.html)
- [Code Examples](http://sendgrid.com/docs/Code_Examples/index.html)
