---
title: Cloud Foundry Glindex 
---

## <a id='application-manifest'></a>application manifest  ##
> An application manifest defines application deployment settings, such as the name of an application, the number of instances to deploy, the maximum memory available to an instance, the services it uses, and so on. The default name for a manifest is `manifest.yml`. Use of a manifest automates application deployment`, allowing a user to provide deployment settings in a file rather than at the command line.
<br> <br>
> For more information, see [Application Manifests](../../using/deploying-apps/manifest.html).

##<a id='autoconfig'></a>auto-configuration ##

> In Cloud Foundry, auto-configuration is the process of automatically configuring an application to connect to a service that is bound to it. In selected frameworks, the `cf-autoconfig` gem can detect server and service connection parameters and update an application's `database.yml` file accordingly. Auto-configuration enables an application to connect to a Cloud Foundry service without the developer having to manually configure the connection settings. Because auto-configuration overwrites the database connection information in an application's `database.yml` file, it may not be suitable for an application running in a production environment. 
<br> <br> 
>When auto-configuration is inappropriate or not supported, service connections can be configured by creating a connection object or (for database applications), manually editing the application's `database.yml` file. 

## <a id='autoreconfig'></a>auto-reconfiguration ##

> See [auto-configuration](#auto-config). 

## <a id='blobstore'></a>blobstore ##

> See [BOSH blobstore](#bosh-blobstore). 

## <a id='bosh-blobstore'></a> BOSH Blobstore ##

> The BOSH Blobstore is an object-based cloud storage platform that stores the content of releases (job and package sources, and compiled packages.) The BOSH Director is the component that reads and writes to the blobstore.



## <a id='bosh-agent'></a>BOSH Agent ##
> The BOSH Agent is a process that runs on each VM in Cloud Foundry and listens for instructions from the BOSH Director. When the director assigns a [job](#job) to an agent, the agent downloads the packages associated with the job from the blobstore and installs and configures them. The agent uses `monit` to start and stops jobs. 


## <a id='bosh-cli'></a>BOSH CLI ##
> Command line interface used to interact with the [director](#director). The BOSH CLI provides command for creating and managing a release and the artifacts it comprises.
<br><br>
For more information see [BOSH Command Line Interface](../bosh/reference/bosh-cli.html).


## <a id='bosh-director'></a>BOSH Director ##
> See [Director](#director). 


## <a id='bosh-health-monitor'></a>BOSH Health Monitor ##
> Receives health status and life cycle events from the BOSH Agent and can send alerts through notification plugins (such as email). The Health Monitor has a simple awareness of events in the system. 


## <a id='bosh-manifest'></a> BOSH manifest ##
> A BOSH manifest is a YAML file that defines deployment settings for a Cloud Foundry instance including: <br><br><ul><li>VMs to be created</li><li>persistent disks to be attached to each VM</li><li>networks and IP addresses to be bound to each VM</li><li>templates from the Bosh release to be applied to each VM</li><li>custom properties to be applied to configuration files and scripts for each job template</li></ul>.


## <a id='bosh'></a>BOSH ##
> BOSH is an open source tool chain for release engineering, deployment, and lifecycle management of large scale distributed services. BOSH can be used to deploy Cloud Foundry, or other distributed services, on Infrastructure as a Service (IaaS) providers such as VMware vSphere, vCloud Director, Amazon Web Services EC2, and OpenStack.  


## <a id='buildpack'></a> buildpack  ##
> A buildpack is a set of scripts that Cloud Foundry runs on an application package to create a [droplet](#droplet) that contains everthing the application needs to run. (This process is referred to as [staging](#staging).) A buildpack is specific to a particular framework or runtime environment. Cloud Foundry includes buildpacks for Ruby, Java, and Node.js; when you upload an application, Cloud Foundry examines the application artifacts to determine which buildpack to apply. Cloud Foundry can use remote buildpacks as well; the URL of the desired buildpack can be specified at the command line when the `cf push` command is run.
<br><br>
> For more information, see [Introduction to Custom Buildpacks](../../using/deploying-apps/buildpacks.html).

## <a id='cc'></a>CC  ##
> See [Cloud Controller](#cc). 


## <a id=' '></a>CF-Release ##
>  [CF-Release](https://github.com/cloudfoundry/cf-release) is the BOSH release repository for Cloud Foundry. You use this with a  manifest customized for your environment to deploy Cloud Foundry.

For more information, see [Using the latest CF-Release](../../running/deploying-cf/common/cf-release.html)

## <a id='ccng'></a>CCNG  ##
> Cloud Control Next Generation, or v2. See [Cloud Controller](#cloud-controller). 


## <a id='cf'></a> cf ##
> cf is a command line interface to the Cloud Controller. It uses the features of the Cloud Controller REST API to enable Cloud Foundry users to deploy and manage applications; provision, bind and manage services; and manage users, organizations, and spaces.  


## <a id='cloud-controller'></a> Cloud Controller##
> Cloud Controller (CC) is the Cloud Foundry component that orchestrates the processing performed by backend components, such as application staging and lifecycle management, and service provisioning and binding operations. Cloud Controller functions and features include:

 * Maintainance of a database of information about applications, services, and configurable items such as organizations, spaces, users and roles. 
 * Storeage of application packages and droplets in a blob store. 
 * Interaction via the NATS messaging bus to interact with other Cloud Foundry components including Droplet Execution Agents (DEAs), Service Gateways, and the Health Manager. 
 * A REST API that enables client access to backend functionality. 

## <a id='cpi'></a> Cloud Provider Interface ##
> A Cloud Provider Interface (CPI) is an API that BOSH uses to interact with an Infrastructure as a Service (IaaS) provider to create and manage stemcells and VMs. CPIs exist for vSphere, OpenStack, and Amazon Web Services. A CPI abstracts an underlying virtualized infrastructure from the rest of BOSH, and is fundamental to Cloud Foundry's consistent model for deploying and running applications across multiple clouds.   

## <a id=' '></a>CPI##
>  See [Cloud Provider Interface](#cpi)

## <a id=' '></a>DEA  
See [Droplet Execution Agent](#dea). 


## <a id='director'></a> Director ##
> The BOSH Director orchestrates creation of virtual machines, the compilation of packages, [deployment](#deployment) of a Cloud Foundry instance, and storage of application packages and droplets in the Blobstore. 

## <a id='droplet'></a>  droplet 
> A droplet is the result of the application staging process, it is an uploaded application to which a buildpack as been applied. It is the original application, with a wrapper around it that  accepts one input -- the port where it should listen for HTTP requests, and has two methods, a start and a stop. 

## <a id='dea'></a> Droplet Execution Agent ##
> A Droplet Execution Agent (DEA) is an agent that runs on Cloud Foundry VMs that run applications. A DEA subsribes to the messages that the Cloud Controller publishes each time it has a droplet that needs to be run. A DEA responds to the Cloud Controller if its host meets the runtime and RAM requirements of the droplet, receives the droplet, and starts it.

## <a id=' '></a>flapping ##
> Cloud Foundry reports the status of an application that repeatedly crashes or will not start as flapping.   

## <a id='glob'></a>glob ##
> A pattern that contains wildcard characters, within a filename.  Unix-like operating can expand such filename expressions into a list of matching filenames. 

## <a id='globster'></a>globster ##
> an unidentified organic mass that washes up on the shoreline of an ocean or other body of water.

## <a id='health-manager'></a>Health Manager ##
> The Health Manager is a daemon that periodically scans the Cloud Controller database  for the expected state of applications that have been deployed and the VMs where they run. The Health Manager compares expected state with actual state, and issues a message to the Cloud Controller when it detects a problem.
<br><br>
> For more information see [Health Manager](health-manager.html).

## <a id='health-monitor'></a>Health Monitor##
>  See [BOSH Health Monitor](#bosh-health-monitor) 

## <a id='job-spec'></a>job specification ##
> YAML file that lists templates files, package dependencies, and properties for a job. 

## <a id='job-template'></a>job template ##
>  a set of generalized configuration files and scripts for a job. The job uses Ruby ERB templates to generate the final configuration files and scripts when a Stemcell is turned into a job. A job template can be generated with the BOSH CLI. <br<br>When a configuration file is turned into a template, instance-specific information is abstracted into a property that later is provided when the Director starts the job on a VM. Information includes, for example, which port the webserver should run on, or which username and password a databse should use

## <a id='job'></a>job ##
> In Cloud Foundry, a job is a set of deployment and execution rules and resources for starting and running the processes for a package. Jobs are defined in deployment manifests (both for Bosh and for Cloud Foundry itself.) A job defines, either explicitly or by reference: <br> <br><ul><li>network settings</li><li>job template</li><li>the number of instances to deploy</li><li>resource allocations (ram, disk, cpu)</li></ul> The jobs defined in a Cloud Foundry deployment manifest include NFS servers, syslog aggregators, the Go Router, NATS, the Cloud Controller and UAA components and associated databases, and so on.<br> <br> The jobs defined in a BOSH manifest include NATS; the BOSH Director, database, and  blobstore; the Health Monitor, and so on. <br> <br>Jobs are also referred to as roles. 

## <a id='manifest'></a>manifest ##
>  See [application manifest](#application-manifest) and [BOSH manifest](#              BOSH-manifest).

## <a id='micro-bosh'></a>Micro BOSH ##
> Micro BOSH is a single VM that includes all BOSH components. Micro BOSH is used to install BOSH.  


## <a id='nats'></a>NATS  ##
>  NATS is a  publish and subscribe and distributed messaging system. Cloud Foundry components use NATS to communicate with each other.


## <a id='org'></a>Organization ##
> In Cloud Foundry, an Organization is a group of users that work on the same, or related, applications and services. Users in an Organization can have varying permissions to resources associate with the Organization. Conceptually, an Organization is similar to a GitHub Organization. 


## <a id='package-spec'></a>package spec ##
>  A file that specifies the name of a package, other packages upon which it depends, and the files it contains. Package contents may be specified using globs. 


## <a id='package'></a>package ##
> A package is a collection of source code and a script for compiling and installing the package. Packages are compiled, as necessary, during deployment. The Director checks whether a compiled version of the package already exists for the stemcell version to which the package will be deployed. If not, the Director instantiates a compile VM using the same stemcell version to which the package will be deployed. This action gets the package source from the blobstore, compiles it, packages the resulting binaries, and stores the package in the blobstore. To turn source code into binaries, each package has a packaging script that is responsible for the compilation, and is run on the compile VM. 


## <a id='release'></a> release ##
> A release is a set of software and configuration templates that are installed on the VMs created from a stemcell.


## <a id='resource pool'></a>resource pool 

> tbd



## <a id='router'></a>Router##
>  The Router routes traffic coming into Cloud Foundry to the appropriate component -- usually Cloud Controller or an application running on a DEA node. The router is implemented in Go. It maintains aA Cloud Foundry Router is a daemon that routes requests to applications. Routers listen for the messages that a DEA issues when an application comes online or goes offline, and maintain an in-memory routing table.  Incoming requests are load balanced across a pool of Routers.


## <a id='simple-blobstore-zerver'></a>Simple Blobstore Server ##
> Cloud Foundry's blobstore. See [blobstore](#bosh-blobstore). 


## <a id='space'></a> Space ##
> In Cloud Foundry, a Space is a logical grouping of applications and services within an [Organization](#org). Examples may include personal Spaces which are similar to a user's home directory in an operating system or shared Spaces like "Development", "Staging", and "Production". Users in an Organization need to be granted specific permissions in a Space in order to access it. Conceptually, a Space is analagous to a GitHub Repository,


## <a id='sts'></a> Spring Tools Suite (STS) ##
> STS is an Eclipse-based development environment for building Spring and Java applications. 


## <a id='staging'></a> staging ##
>  Staging refers to the processing performed by a DEA on an uploaded application, in accordance with the buildpack selected for use by Cloud Foundry or specified by the user. The result of staging process is a [droplet](#droplet).  


## <a id='stemcell'></a>stemcell##
> A stemcell is a VM template that contains a standard Ubuntu distribution and a BOSH Agent. BOSH uses a stemcell to clone a pool of VMs to which a Cloud Foundry [release](#release) is deployed.


## <a id='steno'></a>Steno ##
> A lightweight, modular logging library written  to support Cloud Foundry. 


## <a id='spring-tools-suite'></a>STS  ##
> See [Spring Tools Suite](#sts). 


## <a id='uaa'></a> UAA  ##
> See [User Account and Authentication Service](#uaa) 


## <a id='uaa'></a>User Account and Authentication Service (UAA)  ##
> The UAA is the Cloud Foundry component that provides single sign on for web applications and secures Cloud Foundry resources.  The UAA acts as an OAuth 2.0 Authorization Server. It grants access tokens to client applications for use in accessing Resource Servers in the platform, including the Cloud Controller.   


## <a id='vcap'></a>VCAP ##
> VMware Cloud Application Platform 


## <a id='vmc'></a>VMC   ##
> VMC was the command line interface in Cloud Foundry v1.  [cf](#cf) replaced VMC in Cloud Foundry v2 


## <a id='warden'></a>Warden  ##
> Warden is a framework within Cloud Foundry for creating and managing isolated environments on Unix. Warden provides an API and a command line interface. Containers created by Warden can be limited in terms of network access as well as CPU, memory, and disk usage. 


## <a id='yaml'></a> YAML ##
> YAML is the format used in application manifests and BOSH manifests in Cloud Foundry. For information about the YAML grammar, see [http:\\www.yaml.org]  


## <a id='yml'></a>yml ##
>  The file extension for a YAML file. See [YAML](#yaml). 


## <a id='vagrant'></a>vagrant##
> Vagrant is VM toolkit for developers creating and and configuring portable development environments. Vagrant sits on a virtualization layer such as Virtualbox, VMware Fusion or VMware Workstation.  

## <a id='vcap-services'></a>VCAP_SERVICES##

> An environment variable that contains connection information for all services bound to an application.
<br><br>
> For more information, see [VCAP_SERVICES Environment Variable](../../using/services/environment-variable.html)

