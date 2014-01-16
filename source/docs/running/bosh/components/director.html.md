---
title: Director
---

The Director is the core orchestrating component in BOSH. 
It controls creation of VMs, deployment, and other life cycle events of 
software and services. 
Command and control is handed over to the the Director-Agent interaction after 
the CPI has created resources.

Specific subcomponents manage the tasks mentioned above. 
These components are instances of the following classes referenced from the 
ApiController.

![director-components](/images/director-components.png)

### <a id="deployment-manager"></a>Deployment Manager ###
Responsible for creating, updating, and deleting the deployments that are 
specified in the deployment file. 
Endpoints and Http Method type exposed by the director that are used to access 
the Deployment Manager are described below.

| URL 	| Http Method Type	| Description
| ----------------------------------------------------------------------	| ---------------------------	| ------------------
| /deployments 	| POST	|
| /deployments/:deployment/jobs/:job 	| PUT	| Change the state of a job in a deployment based on the parameter
| /deployments/:deployment/jobs/:job/:index/logs 	| GET	| Get logs of a particular job in a deployment
| /deployments/:name	| DELETE	| Delete a deployment

### <a id="instance-manager"></a>Instance Manager ###
Instance Manager helps manage VM instances that are created using Bosh 
deployments.

It helps connect to the VM instance through an Agent Client using ssh, finds an 
instance, and fetches the log from a particular instance.
 
The figure below describes the flow when a user tries to SSH into a VM using Bosh CLI.

![director-instance_manager_1](/images/director-instance_manager_1.png)

### <a id="problem-manager"></a>Problem Manager ###
This component helps scan a deployment for problems and helps apply 
resolutions.
It uses a model deployment\_problem to keep info about the problem and has a 
one-to-many relationship with Deployment Model.

### <a id="property-manager"></a>Property Manager ###
Properties are attributes specified for jobs in the deployment file.
The Property Manager allows you to find properties associated with a deployment 
and update a particular property for a deployment. 
It references the Deployment Manager.

### <a id="resource-manager"></a>Resource Manager ###
The Resource Manager provides access to the resources stored in the BlobStore. Some of the actions performed through a resource manager are:

	1. Get a Resource using an ID
	2. Delete a resource by giving an resource ID
	3. Get the resource path from an ID

### <a id="release-manager"></a>Release Manager ###
The Release Manager manages the creation and deletion of releases. 
Each release references a Release Manager and contains a Deployment Plan object 
as well as an array of templates.

The Director routes the request coming at the following endpoints to the 
release manager for managing the release lifecycle.

| URL 	| Http Method Type	| Response Body	| Description
| -------------	| ---------------------------	| ---------------------------------------------------------------------------------------------------------------------------	| ------------------------------------------------------
| /releases	|        GET	| {"name"     => release.name,"versions" => versions, "in\_use"   => versions\_in\_use}	| Get the list of all releases uploaded 
| /releases 	|        POST	| 	| Create a release for the user specified.

#### Lifecycle of a Release ####
The figure below shows the interaction between various components of a Director 
when a release is created/ updated or deleted.

![release-lifecycle](/images/director-release-manager.png)

### <a id="stemcell-manager"></a>Stemcell Manager ###
The Stemcell Manager manages the Stem cells. 
It is responsible for creating, deleting, or finding a stemcell.

![director-stemcell-manager](/images/director-stemcell-manager.png)

The table below shows the endpoints exposed by the director for managing the 
stemcell's lifecycle.

|     URL 	| Http Method Type	| Response Body	| Description
| -----------------	| ---------------------------	| ---------------------------------------------------------------------------------------------------------------------------	| -------------------------
| /stemcells	|        GET	| { "name" => stemcell.name, "version" => stemcell.version, "cid"     => stemcell.cid}	| Json specifying the stemcell  name, version and cid of the stem cell.
| /stemcells 	|        POST	| 	| Stemcell binary file
| /stemcells	|       DELETE	| 	| Delete the specified stemcell


### <a id="task-manager"></a>Task Manager ###
The Task Manager is responsible for managing the tasks which are created and 
are being run by the Job Runner.

![director-task-manager](/images/director-task-manager.png)

The following http endpoints are exposed by the Director to get information 
about a task.

|     URL 	| Http Method Type	| Response Body	| Description
| -----------------	| ---------------------------	| -----------------	| -------------------------
| /tasks	|        GET	| 	| Get all the tasks being executed of type"update\_deployment", "delete\_deployment", "update\_release","delete\_release", "update\_stemcell", "delete\_stemcell"
| /tasks/:id	|        GET	| 	| Send back output for a task with the given id
| /tasks/:id/output 	|        GET	| 	| Sends back output of given task id and params[:type]
| /task/:id	|       DELETE	| 	| Delete the task specified by a particular Id
	
### <a id="user-manager"></a>User Manager ###
Manages the users stored in the Director’s database. 
Main functions performed by the User Manager are:

	1. Create a User
	2. Delete a User
	3. Authenticate a User
	4. Get a User
	5. Update a User

User Management is delegated by the director to the User Manager with the 
following URLs:

|     URL 	| Http Method Type	| Http Request Body	| Description
| -----------------	| ---------------------------	| ------------	| -------------------------
| /users	|        POST	| 	| Create a User	
| /users/:username 	|        PUT	| 	| Update a User
| /users/:username	|       DELETE	| 	| Delete a User

### <a id="vm-state-manager"></a>VM State Manager ###
Helps fetch the VM State by creating a task which runs the Hob : VmState 

The vm state is fetched by creating a GET request on the 
`/deployments/:name/vms` endpoint in the Director. 
`name` is the name of the deployment.

![director-vm-state-manager](/images/director-vm-state-manager.png)