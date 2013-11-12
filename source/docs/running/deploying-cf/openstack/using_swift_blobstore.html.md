---
title: Using OpenStack Swift as Cloud Foundry blobstore
---

<br />

## Introduction ##

The Cloud Controller stores user uploaded applications, buildpacks, droplets and application resources in a blobstore. There are different blobstore providers like the local file system (Local), AWS S3 (AWS) and OpenStack Swift (OpenStack). This article describes how to configure the Cloud Controller blobstore to use the Swift storage.

The files uploaded by users are stored in private buckets and secured against unauthorized access. 
If DEAs need to access these files from the Cloud Controller's blobstore, the Cloud Controller generates temporary urls to the required files and provides them to the DEA. The DEA can download the according files from the received url to execute staging tasks and delivers back the results. The generated temporary urls are only valid for a limited amount of time. This ensures that the data is secure.

<strong>!!! Annotation: This feature is not available yet, because it depends on the fog gem > v1.16.0. The cloud controller's fog version needs to be bumped.</strong>

<br/>


## OpenStack prerequisites ##

To use the temporary url feature the OpenStack user needs the role ResellerAdmin.
You have to configure an account meta temp url key for your OpenStack account to enable temporary url generation. This can be done by executing the following commands.


### Retrieve an auth-token ###

```
curl -s -H 'Content-type: application/json' -d '{"auth": {"tenantName": "<tenant>", "passwordCredentials": {"username": "<user>", \
	 "password": "<password>"}}}' https://auth.example.com:5000/v2.0/tokens | python -mjson.tool
```	

### Assign an account meta temp url key to your OpenStack account ###

```
curl -i -X POST -H 'X-Auth-Token:<your auth token>' -H 'X-Account-Meta-Temp-URL-Key:<account meta temp url key>' \
	https://swift.example.com/v1/AUTH_<your tenant id>	
```
	
<br />	
	
	
## Bosh Deployment manifest ##

The Swift credentials have to be provided in your Bosh deployment manifest file.
The following snippet shows the required entries in the properties section of the deployment manifest. This example uses the OpenStack fog provider.

```
...
properties:
  ...
  ccng:
    ...
    packages:
      app_package_directory_key: cc-packages
	  fog_connection: &fog_connection
	    provider: 'OpenStack'
	    openstack_username: '<user>'
	    openstack_api_key: '<password>'
	    openstack_auth_url: 'https://auth.example.com:5000/v2.0/tokens'
	    openstack_temp_url_key: '<account meta temp url key>'
	droplets:
	  droplet_directory_key: cc-droplets
	  fog_connection: *fog_connection
	resource_pool:
 	  resource_directory_key: cc-resources
	  fog_connection: *fog_connection
	buildpacks:
	  buildpack_directory_key: cc-buildpacks
	  fog_connection: *fog_connetion  
```

<br />

## Links ##

* [OpenStack Swift temporary url documentation](http://docs.openstack.org/trunk/config-reference/content/object-storage-tempurl.html)
* [Fog gem](http://fog.io/)
* [OpenStack fog provider @github](https://github.com/fog/fog/tree/master/lib/fog/openstack)
