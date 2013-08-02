---
title: Application Design for the Cloud
---

Applications written using the runtimes and frameworks supported by Cloud Foundry often run unmodified on Cloud Foundry, if the application design follows a few simple guidelines. Following these guidelines makes an application cloud-friendly, and facilitates deployment to Cloud Foundry and other cloud platforms.

## <a id="filesystem"></a>Avoid Writing to the Local File System ##

Applications running on Cloud Foundry should not write files to the local file system. There are a few reasons for this.

* **Local file system storage is short-lived.** When an application instance crashes or stops, the resources assigned to that instance are reclaimed by the platform including any local disk changes made since the app started. When the instance is restarted, the application will start with a new disk image. Although your application can write local files while it is running, the files will disappear after the application restarts.

* **Instances of the same application do not share a local file system.** Each application instance runs in it's own isolated container. Thus a file written by one instance is not visible to other instances of the same application. If the files are temporary, this should not be a problem. However, if your application needs the data in the files to persist across application restarts, or the data needs to be shared across all running instances of the application, the local file system should not be used. Rather we recommend using a shared data service like a database or blob store for this purpose.

For example, rather than using the local file system, you can use a Cloud Foundry service such as the MongoDB document database or a relational database (MySQL or Postgres). Another option is to use cloud storage providers such as [Amazon S3](http://aws.amazon.com/s3/), [Google Cloud Storage](https://cloud.google.com/products/cloud-storage), [Dropbox](https://www.dropbox.com/developers), or [Box](http://developers.box.com/). If your application needs to communicate across different instances of itself (for example to share state etc), consider a cache like Redis or a messaging-based architecture with RabbitMQ.

## <a id="sessions"></a>HTTP Sessions Not Persisted or Replicated  ##

Cloud Foundry supports session affinity or sticky sessions for incoming HTTP requests to applications if a jsessionid cookie is used. If multiple instances of an application are running on Cloud Foundry, all requests from a given client will be routed to the same application instance. This allows application containers and frameworks to store session data specific to each user session.

Cloud Foundry does not persist or replicate HTTP session data. If an instance of an application crashes or is stopped, any data stored for HTTP sessions that were sticky to that instance are lost. When a user session that was sticky to a crashed or stopped instance makes another HTTP request, the request is routed to another instance of the application.

Session data that must be available after an application crashes or stops, or that needs to be shared by all instances of an application, should be stored in a Cloud Foundry service. There are several open source projects that share sessions in a data service.

## <a id="ports"></a>HTTP and HTTPS Port Limitations ##

Applications running on Cloud Foundry receive requests using only the URLs configured for the application, and only on ports 80 (the standard HTTP port) and 443 (the standard HTTPS port).

Unlike the Cloud Foundry v1 hosted service, the Cloud Foundry v2 hosted service data services (MySQL, Postgres, MongoDB, Redis, RabbitMQ) used with Cloud Foundry can now be directly accessed by clients not running on Cloud Foundry since these services are offered by Cloud Foundry partners. You can retrieve the connection metadata and credentials of a bound service by retrieving the env.log from an application or via the Cloud Foundry API response for services.