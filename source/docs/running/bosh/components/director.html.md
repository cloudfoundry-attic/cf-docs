---
title: Director
---

The Director is the core orchestrating component in BOSH which controls creation of VMs, deployment, and other life cycle events of software and services. Command and control is handed over to the the Director-Agent interaction after the CPI has created resources.

There are specific sub components to manage each of the tasks mentioned above. All these are instances of the following classes referenced from the ApiController.

![director-components](/images/director-components.png)

### Deployment Manager ###
Responsible for creating, updating and deleting the deployments which are specified in the deployment file.

Endpoints and Http Method type exposed by the director which are used to access the deployment manager are described below.

| URL 	| Http Method Type	| Description
| ----------------------------------------------------------------------	| ---------------------------	| ------------------
| /deployments 	| POST	|
| /deployments/:deployment/jobs/:job 	| PUT	| Change the state of a job in a deployment based on the parameter
| /deployments/:deployment/jobs/:job/:index/logs 	| GET	| Get logs of a particular job in a deployment
| /deployments/:name	| DELETE	| Delete a deployment

### Instance Manager ###
Instance Manager helps in managing VM Instances created using Bosh deployments.

Some of the functions it performs are 
1. Helps in connecting to the VM instance using ssh through an Agent Client
2. Finding an instance
3. Fetching log from a particular instance


Figure below describes the flow when a user tries to SSH into a VM using Bosh CLI

![director-instance_manager_1](/images/director-instance_manager_1.png)

### Problem Manager ###
This component helps scan a deployment for problems and helps apply resolutions.
It uses a model deployment_problem to keep info about the problem and has 1: many relationship with Deployment Model.


### Property Manager ###
Properties are attributes specified for  jobs in the deployment file.
Allows you to find properties associated with a deployment, update a particular property for a deployment. References the deployment Manager.


### Resource Manager ###
Used to get access to the resources stored in the BlobStore. Some of the actions performed through a resource manager are

	1. Get a Resource using an Id
	2. Delete a resource by giving an resource Id
	3. Get the resource path from an Id

### Release Manager ###
Manages the creation and deletion of releases. Each release references a Release Manager and contains a Deployment Plan object as well as an array of templates.

Director routes the request coming at the following endpoints to the release manager for managing the release lifecycle

| URL 	| Http Method Type	| Response Body	| Description
| -------------	| ---------------------------	| ---------------------------------------------------------------------------------------------------------------------------	| ------------------------------------------------------
| /releases	|        GET	| {"name"     => release.name,"versions" => versions, "in_use"   => versions_in_use}	| Get the list of all releases uploaded 
| /releases 	|        POST	| 	| Create a release for the user specified.


#### Lifecycle of a Release ####
Figure below shows the interaction between various components of a Director when a release is created/ updated or deleted.

![release-lifecycle](/images/director-release-manager.png)


### Stemcell Manager ###
Stemcell Manager manages the Stem cells. It is responsible for creating, deleting or finding a stemcell.

![director-stemcell-manager](/images/director-stemcell-manager.png)

Table below shows the endpoints exposed by the director for managing the Stemcells lifecycle

|     URL 	| Http Method Type	| Response Body	| Description
| -----------------	| ---------------------------	| ---------------------------------------------------------------------------------------------------------------------------	| -------------------------
| /stemcells	|        GET	| { "name" => stemcell.name, "version" => stemcell.version, "cid"     => stemcell.cid}	| Json specifying the stemcell  name, version and cid of the stem cell.
| /stemcells 	|        POST	| 	| Stemcell binary file
| /stemcells	|       DELETE	| 	| Delete the specified stemcell


### Task Manager ###
Task Manager is responsible for managing the tasks which are created and are being run the Job Runner

![director-task-manager](/images/director-task-manager.png)

Following Http Endpoints are exposed by the Director to get information about a task

|     URL 	| Http Method Type	| Response Body	| Description
| -----------------	| ---------------------------	| -----------------	| -------------------------
| /tasks	|        GET	| 	| Get all the tasks being executed of type"update_deployment", "delete_deployment", "update_release","delete_release", "update_stemcell", "delete_stemcell"
| /tasks/:id	|        GET	| 	| Send back output for a task with the given id
| /tasks/:id/output 	|        GET	| 	| Sends back output of given task id and params[:type]
| /task/:id	|       DELETE	| 	| Delete the task specified by a particular Id
	

### User Manager ###
Manages the users stored in the Director’s database. Main functions performed by the User Manager are

	1. Create a User
	2. Delete a User
	3. Authenticate a User
	4. Get a User
	5. Update a User


User Management is delegated by the director to the User Manager with the following URLs

|     URL 	| Http Method Type	| Http Request Body	| Description
| -----------------	| ---------------------------	| ------------	| -------------------------
| /users	|        POST	| 	| Create a User	
| /users/:username 	|        PUT	| 	| Update a User
| /users/:username	|       DELETE	| 	| Delete a User


### VM State Manager ###
Helps fetch the VM State by creating a task which runs the Hob : VmState 

The vm state is fetched by creating a GET request on the `/deployments/:name/vms` endpoint in the Director. `name` is the name of the deployment.

![director-vm-state-manager](/images/director-vm-state-manager.png)

