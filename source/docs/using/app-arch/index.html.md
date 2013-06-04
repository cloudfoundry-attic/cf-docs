---
title: Application Architecture Considerations
---

Applications written using the runtimes and frameworks supported by Cloud Foundry will often run unmodified on Cloud Foundry, provided the design and architecture of an application follows a few simple guidelines. Following these guidelines will make an application cloud-friendly, and ease the deployment of an application to Cloud Foundry and other cloud platforms. 

## <a id="filesystem"></a>Avoid Writing to Local File System ##

Applications running on Cloud Foundry should avoid writing files to the local file system. There are a few reasons for this. 

First, local file system storage is ephemeral - it is not guaranteed to persist for the entire life of the application. When an application instance crashes or is stopped, the resources assigned to that instance are reclaimed by the platform. When the instance is re-started, the application could be running on a different virtual machine or physical machine. This means that, although your application is able to write local files while it is running, the files will disappear after the application restarts. 

Second, instances of the same application do not share a local file system. The application instances could be running in different DEA nodes, in different virtual machines, and on different physical machines. Because of this, a file written by one instance of an application is not visible to other instances of the same application. 

If the files your application is writing are temporary, then this should not be a problem. However, if your application needs the data in the files to persist across application restarts, or the data needs to be shared across all running instances of the application, then the local file system should not be used. 

There are a few alternatives to using the local file system. One option is to use a Cloud Foundry services such as the MongoDB document database or a supported relational database (MySQL or vFabric Postgres). Another option is to use cloud storage providers such as [Amazon S3](http://aws.amazon.com/s3/), [Google Cloud Storage](https://cloud.google.com/products/cloud-storage), [Dropbox](https://www.dropbox.com/developers), or [Box](http://developers.box.com/). If your application needs to communicate across different instances of itself (for example to share state etc), consider the use of a cache like Redis or make use a messaging-based architecture with RabbitMQ.

## <a id="sessions"></a>HTTP Sessions ##

Cloud Foundry supports session affinity or sticky sessions for incoming HTTP requests to applications. If multiple instances of an application are running on Cloud Foundry, all requests from a given client will be routed to the same application instance. This allows application containers and frameworks to store session data specific to each user session. 

Cloud Foundry does not persist or replicate HTTP session data. If an instance of an application crashes or is stopped, any data stored for HTTP sessions that were sticky to that instance will be lost. When a user session that was sticky to a crashed or stopped instance makes another HTTP request, the request will be routed to another instance of the application. 

Any session data that needs to be available even after an application crashes or is stopped, or needs to be shared by all instances of an application, should be stored in a Cloud Foundry service.

## <a id="ports"></a>Ports ##

Applications running on Cloud Foundry can only receive requests using the URLs configured for the application, and only on ports 80 (the standard HTTP port) and 443 (the standard HTTPS port).

Service instances (MySQL, vFabric Postgres, MongoDB, Redis, RabbitMQ) running on Cloud Foundry can only be accessed by applications running on Cloud Foundry. Service instances cannot be accessed by programs running outside of Cloud Foundry, since only ports 80 and 443 are available. [Service Tunneling](/docs/using/tunnelling-with-services.html) can be used to create a connection from one machine to a service running on Cloud Foundry. 

If an application running outside of Cloud Foundry needs access to data stored in a Cloud Foundry service, you should create a web service application to expose the data and run the web service application on Cloud Foundry.

## <a id="smtp"></a>SMTP ##

In order to prevent spam and other abuse, the standard SMTP port (port 25) is blocked on Cloud Foundry. Applications can not send or receive SMTP messages on this port. A good option for applications needing to send and receive email is to use a cloud-based email solution such as [SendGrid](http://sendgrid.com/developers.html). 


