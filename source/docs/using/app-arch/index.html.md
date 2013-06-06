---
title: Application Architecture Considerations
---

Applications written using the runtimes and frameworks supported by Cloud Foundry often run unmodified on Cloud Foundry, if the application design follows a few simple guidelines. Following these guidelines makes an application cloud-friendly, and facilitates deployment to Cloud Foundry and other cloud platforms. 

## <a id="filesystem"></a>Avoid Writing to the Local File System ##

Applications running on Cloud Foundry should not write files to the local file system. There are a few reasons for this. 

* **Local file system storage is not guaranteed to persist for the life of the application.** When an application instance crashes or stops, the resources assigned to that instance are reclaimed by the platform. When the instance is restarted, the application could be running on a different virtual machine or physical machine. Although your application can write local files while it is running, the files will disappear after the application restarts. 

* **Instances of the same application do not share a local file system.** The instances could be running in different DEA nodes, in different virtual machines, and on different physical machines. Thus a file written by one instance is not visible to other instances of the same application. If the files are temporary, this should not be a problem. However, if your application needs the data in the files to persist across application restarts, or the data needs to be shared across all running instances of the application, the local file system should not be used. 

Instead of the local file system, you can use a Cloud Foundry service such as the MongoDB document database or a supported relational database (MySQL or vFabric Postgres). Another option is to use cloud storage providers such as [Amazon S3](http://aws.amazon.com/s3/), [Google Cloud Storage](https://cloud.google.com/products/cloud-storage), [Dropbox](https://www.dropbox.com/developers), or [Box](http://developers.box.com/). If your application needs to communicate across different instances of itself (for example to share state etc), consider a cache like Redis or a messaging-based architecture with RabbitMQ.

## <a id="sessions"></a>HTTP Sessions Not Persisted or Replicated  ##

Cloud Foundry supports session affinity or sticky sessions for incoming HTTP requests to applications. If multiple instances of an application are running on Cloud Foundry, all requests from a given client will be routed to the same application instance. This allows application containers and frameworks to store session data specific to each user session. 

Cloud Foundry does not persist or replicate HTTP session data. If an instance of an application crashes or is stopped, any data stored for HTTP sessions that were sticky to that instance are lost. When a user session that was sticky to a crashed or stopped instance makes another HTTP request, the request is routed to another instance of the application. 

Session data that must be available after an application crashes or stops, or that needs to be shared by all instances of an application, should be stored in a Cloud Foundry service.

## <a id="ports"></a>HTTP and HTTPS Port Limitations ##

Applications running on Cloud Foundry receive requests using only the URLs configured for the application, and only on ports 80 (the standard HTTP port) and 443 (the standard HTTPS port).

Service instances (MySQL, vFabric Postgres, MongoDB, Redis, RabbitMQ) running on Cloud Foundry can be accessed only by applications running on Cloud Foundry. Service instances cannot be accessed by programs running outside of Cloud Foundry, because only ports 80 and 443 are available. You can use [Service Tunneling](/docs/using/tunnelling-with-services.html) to create a connection from one machine to a service running on Cloud Foundry. 

If an application running outside of Cloud Foundry needs access to data stored in a Cloud Foundry service, create a web service application to expose the data and run the web service application on Cloud Foundry.

## <a id="smtp"></a>Standard SMTP Port Blocked ##

To prevent spam and other abuse, the standard SMTP port (port 25) is blocked on Cloud Foundry. Applications cannot send or receive SMTP messages on this port. Applications that need to send and receive email can use a cloud-based email solution such as [SendGrid](http://sendgrid.com/developers.html). 


