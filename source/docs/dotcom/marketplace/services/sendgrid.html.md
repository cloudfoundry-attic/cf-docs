---
title: SendGrid
category: marketplace
---

[SendGrid's](http://sendgrid.com)  cloud-based email infrastructure relieves businesses of the cost and complexity of maintaining custom email systems. SendGrid provides reliable delivery, scalability and real-time analytics along with flexible APIs that make custom integration a breeze.


## <a id='creating-a-sendgrid-service'></a>Creating A SendGrid Service ##

SendGrid can be provisioned via the CLI with the following command:

<pre class="terminal">
$ cf create-service sendgrid [service-name]
</pre>
    
and the desired plan.    

## <a id='binding-your-sendgrid-service'></a>Binding Your SendGrid Service ##

Bind your SendGrid service to your app, using the following command:
    
<pre class="terminal">
$ cf bind-service [service-name] [app name]
</pre>

Once SendGrid has been added a username, password will be available and will contain the credentials used to access the newly provisioned SendGrid service instance.


## <a id='environment-variable'></a>Environment Variables ##

Format of credentials in `VCAP_SERVICES` environment variable.


    {
      sendgrid-n/a: [
        {
          name: "[service-name]",
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



## <a id='sample-app'></a>Sample Applications ##

### Java ###

This Java program will build a multi-part MIME email and send it through SendGrid. Java already has built in libraries to send and receive emails. This example uses [javamail] (https://java.net/projects/javamail/pages/Home).

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

### Ruby / Rails ###
Get SendGrid credentials from `VCAP_SERVICES` environment variable

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

The following settings are necessary for apps using ActionMailer.
Edit `config/environment.rb`:

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
A sample application for using Ruby on Rails and SendGrid on Cloud Foundry can be found [here](https://github.com/laur-craciun/sendgrid-cloudfoundry-rails).

## <a id='dashboard'></a>Dashboard ##

SendGrid offers statistics a number of different metrics to report on what is happening with your messages.

![Dashboard](http://static.sendgrid.com.s3.amazonaws.com/images/delivery_metrics.png)


To access your SendGrid dashboard, simply click the 'Manage' button next to the SendGrid service on your app space console.


## Managing Services

You can continue [managing your services from the command line](http://docs.cloudfoundry.com/docs/using/services/managing-services.html).


## <a id='support'></a>Support ##

All SendGrid support and runtime issues should be submitted via on of the [Contacting Service Providers for Support](http://docs.cloudfoundry.com/docs/dotcom/marketplace/contacting-service-providers-for-support.html). Any non-support related issues or product feedback is welcome at [http://support.sendgrid.com/home](http://support.sendgrid.com/home).


## <a id='additional-resources'></a>Additional Resources ##

Additional resources are available at:

- [Integrate With SendGrid](http://sendgrid.com/docs/Integrate/index.html)
- [Code Examples](http://sendgrid.com/docs/Code_Examples/index.html)
