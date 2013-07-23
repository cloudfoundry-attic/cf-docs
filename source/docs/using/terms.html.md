---
title: Cloud Foundry Glindex (Glossary + Index)
---
This page briefly describes a number of terms that are commonly used in Cloud Foundry documentation. For some terms, cross-references to related topics are provided. 

## <a id='application-manifest'></a>application manifest  ##
> An application manifest defines application deployment settings, such as the name of an application, the number of instances to deploy, the maximum memory available to an instance, the services it uses, and so on. The default name for a manifest is `manifest.yml`. Use of a manifest automates application deployment`, allowing a user to provide deployment settings in a file rather than at the command line.
<br> <br>
> For more information, see [Application Manifests](../../using/deploying-apps/manifest.html).

##<a id='autoconfig'></a>auto-configuration ##

> In Cloud Foundry, auto-configuration is the process of automatically configuring an application to connect to a service that is bound to it. In selected frameworks, Cloud Foundry can detect server and service connection parameters and update the appropriate configuration file accordingly. Auto-configuration enables an application to connect to a Cloud Foundry service without the developer having to manually configure the connection settings. 

## <a id='autoreconfig'></a>auto-reconfiguration ##

> See [auto-configuration](#auto-config). 

## <a id='bosh-agent'></a>BOSH Agent ##

> The BOSH Agent is a process that runs on each VM maganged by BOSH and listens for instructions from the [BOSH Director](bosh-director). When the director assigns a [job](#job) to an agent, the agent downloads the packages associated with the job from the blobstore and installs and configures them. The agent uses `monit` to start and stops jobs. 

## <a id='bosh-blobstore'></a> BOSH Blobstore ##

> The BOSH Blobstore is an object-based cloud storage platform that stores the content of releases (job and package sources, and compiled packages.) The BOSH Director is the component that reads and writes to the blobstore.

## <a id='bosh-cli'></a>BOSH CLI ##

> Command line interface used to interact with the [BOSH Director](#bosh-director). The BOSH CLI provides commands for creating and managing a release and the artifacts it comprises.
<br><br>
>For more information see [BOSH Command Line Interface](../bosh/reference/bosh-cli.html).

## <a id='bosh-director'></a>BOSH Director ##

> The BOSH Director orchestrates creation of virtual machines, the compilation of packages, deployment of a Cloud Foundry instance, and storage of application packages and droplets in the blobstore.  


## <a id='bosh-health-monitor'></a>BOSH Health Monitor ##

> Receives health status and life cycle events from the BOSH Agent and can send alerts through notification plugins, such as email. 

## <a id='bosh'></a>BOSH ##

> BOSH is an open source tool chain for release engineering, deployment, and lifecycle management of large scale distributed services. BOSH can be used to deploy Cloud Foundry, or other distributed services, on Infrastructure as a Service (IaaS) providers such as VMware vSphere, vCloud Director, Amazon Web Services EC2, and OpenStack.  

## <a id='bosh-manifest'></a> BOSH manifest ##

> A BOSH manifest is a YAML file that defines deployment settings for a Cloud Foundry instance including: 
<br> <br>

> - VMs to be created.

> - Persistent disks to be attached to each VM.

> - Networks and IP addresses to be bound to each VM.

> - Templates from the BOSH release to be applied to each VM.

> - custom properties to be applied to configuration files and scripts for each [job template](#job-template).

## <a id='buildpack'></a> buildpack  ##

> A buildpack is a set of scripts that Cloud Foundry runs on an application [package](#package) to create a [droplet](#droplet) that contains everthing the application needs to run. (This process is referred to as [staging](#staging).) A buildpack is specific to a particular framework or runtime environment. Cloud Foundry includes buildpacks for Ruby, Java, and Node.js; when you upload an application, Cloud Foundry examines the application artifacts to determine which buildpack to apply. Cloud Foundry can use remote buildpacks as well; you can specify the URL of the desired buildpack when running the `cf push` command.
<br><br>
> For more information, see [Introduction to Custom Buildpacks](../../using/deploying-apps/buildpacks.html).

## <a id='cc'></a>CC  ##
> See [Cloud Controller](#cloud-controller). 

## <a id='ccng'></a>CCNG  ##
> Cloud Control Next Generation, or v2. See [Cloud Controller](#cloud-controller). 

## <a id='cf'></a> cf ##
> cf is a command line interface to the Cloud Controller. It uses the features of the Cloud Controller REST API to enable Cloud Foundry users to deploy and manage applications; provision, bind and manage services; and manage users, organizations, and spaces.  
<br>
> For more information, see [cf Command Line Interface](../../using/managing-apps/cf/index.html).

## <a id='cf-release'></a>CF-Release ##
>  [CF-Release](https://github.com/cloudfoundry/cf-release) is the BOSH release repository for Cloud Foundry. You use CF-Release with a  manifest customized for your environment to deploy Cloud Foundry.
<br><br>  

> For more information, see [Using the latest CF-Release](../../running/deploying-cf/common/cf-release.html)

## <a id='cloud-controller'></a> Cloud Controller##

> Cloud Controller (CC) is the Cloud Foundry component that orchestrates the processing performed by backend components, such as application staging and lifecycle management, and service provisioning and binding operations. Cloud Controller functions and features include:
<br> <br>

> - Maintainance of a database of information about applications, services, and configurable items such as organizations, spaces, users, and roles. 

> - Storage of application packages and droplets in the blobstore.

> - Interaction, via the NATS messaging bus, with other Cloud Foundry components, including Droplet Execution Agents (DEAs), Service Gateways, and the Health Manager. 

> - A REST API that enables client access to backend functionality. 

## <a id='cpi'></a> Cloud Provider Interface ##

> A Cloud Provider Interface (CPI) is an API that BOSH uses to interact with an Infrastructure as a Service (IaaS) provider to create and manage stemcells and VMs. CPIs exist for vSphere, OpenStack, and Amazon Web Services. A CPI abstracts an underlying virtualized infrastructure from the rest of BOSH, and is fundamental to Cloud Foundry's model for deploying and running applications across multiple clouds.   

## <a id='cloud-provider-interface'></a>CPI ##

>  See [Cloud Provider Interface](#cpi).

## <a id='droplet-execution-agent'></a>DEA  ##

> See [Droplet Execution Agent](#dea). 

## <a id='dea'></a> Droplet Execution Agent ##

> A Droplet Execution Agent (DEA) is a process that runs on Cloud Foundry VMs that host applications. A DEA subscribes to the messages that the Cloud Controller publishes when droplets need to be run. If the DEA host meets the runtime and RAM requirements of a droplet, the DEA responds to the Cloud Controller's request, receives the droplet, and starts it. Similarly, a DEA stops an application as requested by the Cloud Controller. A DEA keepS track of the instances it started and periodically broadcasts messages about their state using [NATS](#nats). 
<br><br>  

> For more information, see [Droplet Execution Agent](../architecture/execution-agent.html).

## <a id='droplet'></a> droplet ##

> A droplet is the result of the application [staging](#staging) process, it is an uploaded application to which a buildpack as been applied. It is the original application, with a wrapper around it that accepts one input -- the port where it should listen for HTTP requests, and has two methods, a start and a stop. 

## <a id=' '></a>flapping ##

> Flapping is the heath status that Cloud Foundry reports for an application that repeatedly crashes or will not start.   

## <a id='health-manager'></a>Health Manager ##

> The Health Manager is a daemon that periodically scans the Cloud Controller database  for the expected state of applications that have been deployed and the VMs where they run. The Health Manager compares expected state with actual state, and issues a message to the Cloud Controller when it detects a problem.
<br> <br> 
> For more information see [Health Manager](health-manager.html).

## <a id='health-monitor'></a>Health Monitor##

>  See [BOSH Health Monitor](#bosh-health-monitor). 

## <a id='job'></a>job ##

> In BOSH, a job is a set of deployment and execution rules and resources for starting and running the processes for a package. Jobs are defined in deployment manifests (both for BOSH and for Cloud Foundry itself.) A job defines, either explicitly or by reference to a [resource pool](#resource-pool): <br> <br>

> - Network settings

> - Job template

> - The number of instances to deploy

> - Resource allocations (ram, disk, CPU )

> Jobs are also referred to as roles. 


## <a id='job-spec'></a>job specification ##

> A job specification is YAML file that lists templates files, package dependencies, and properties for a [job](#job). 

## <a id='job-template'></a>job template ##

>  A set of generalized configuration files and scripts for a [job](#job). The job uses Ruby ERB templates to generate the final configuration files and scripts when a Stemcell is turned into a job. A job template can be generated with the BOSH CLI. 
<br><br>

> When a configuration file is turned into a template, instance-specific information is abstracted into a property that later is provided when the Director starts the job on a VM. Information includes, for example, which port the webserver should run on, or which username and password a databse should use.



## <a id='manifest'></a>manifest ##
>  See [application manifest](#application-manifest) and [BOSH manifest](#bosh-manifest).

## <a id='micro-bosh'></a>Micro BOSH ##
> Micro BOSH is a VM that includes all BOSH components. Micro BOSH is used to install BOSH. 
<br><br>

> For more information see [Deploying BOSH with Micro BOSH](../../running/deploying-cf/vsphere/deploying_bosh_with_micro_bosh.html).


## <a id='nats'></a>NATS  ##
>  NATS is a  publish and subscribe and distributed messaging system. Cloud Foundry components use NATS to communicate with each other.


## <a id='org'></a>Organization ##
> In Cloud Foundry, an organization is a group of users that work on the same, or related, applications and services. Users in an organization can have varying permissions to resources associated with the organization. Organizations contain [Spaces](#space).
<br><br>

> For more information see [Organizations and Spaces](../../using/managing-apps/orgs-and-spaces.html).


## <a id='package'></a>package ##
> In BOSH, a package is a collection of source code and a script for compiling and installing the package. Packages are compiled, as necessary, during deployment. The Director checks whether a compiled version of the package already exists for the stemcell version to which the package will be deployed. If not, the Director instantiates a compile VM using the same stemcell version to which the package will be deployed. This action gets the package source from the blobstore, compiles it, packages the resulting binaries, and stores the package in the blobstore. To turn source code into binaries, each package has a packaging script that is responsible for the compilation, and is run on the compile VM.

## <a id='package-spec'></a>package spec ##

>  A file that specifies the name of a package, other packages upon which it depends, and the files it contains. 


## <a id='release'></a> release ##

> In BOSH, a release is a set of software and configuration templates that are installed on the VMs created from a stemcell.


## <a id='resource pool'></a>resource pool ##

> In a BOSH manifest, a resource pool defines the characteristics of a pool of VMs to be created, to which one or more [jobs](#job) can be assigned. The attributes defined for a resource pool include the number of VMs to create and the stemcell from which to create them; the number of CPUs and the amount of RAM and disk space to configure for each VM, and so on.
<br><br>

> Refer to [Cloud Foundry Example Manifest](../../running/deploying-cf/vsphere/cloud-foundry-example-manifest.html) to see resource pool definitions, and how each job in the manifest is assigned to a resource pool. 
 

## <a id='router'></a>Router ##

>  The Router routes traffic coming into Cloud Foundry to the appropriate component -- usually Cloud Controller or an application running on a DEA node. The router is implemented in Go. Routers listen for the messages that a DEA issues when an application comes online or goes offline, and maintain an in-memory routing table. Incoming requests are load balanced across a pool of Routers.
<br><br>

> For more information, see [Router](router.html).


## <a id='space'></a> Space ##

> In Cloud Foundry, a space is a logical grouping of applications and services within an [organization](#org). Examples may include personal spaces which are similar to a user's home directory in an operating system or shared Spaces like "Development", "Staging", and "Production". Users in an organization must be granted specific permissions in a Space in order to access it. 
<br><br>
> For more information see [Organizations and Spaces](../../using/managing-apps/orgs-and-spaces.html).

## <a id='staging'></a> staging ##

>  Staging refers to the processing performed by a DEA on an uploaded application, in accordance with the buildpack selected for use by Cloud Foundry or specified by the user. The result of thestaging process is a [droplet](#droplet).  


## <a id='stemcell'></a>stemcell##

> A stemcell is a VM template with Linux and a BOSH Agent. BOSH uses a stemcell to clone a pool of VMs to which a Cloud Foundry [release](#release) is deployed.

## <a id='steno'></a>Steno ##

> A lightweight, modular logging library written  to support Cloud Foundry. 


## <a id='uaa'></a> UAA  ##

> See [User Account and Authentication Service](#uaa). 


## <a id='uaa'></a>User Account and Authentication Service (UAA)  ##

> In Cloud Foundry, the User Account and Authentication Service (UAA) provides single sign-on for web applications and secures Cloud Foundry resources. The UAA acts as an OAuth 2.0 Authorization Server. It grants access tokens to client applications for use in accessing Resource Servers in the platform, including the Cloud Controller.   
<br><br>

> For more information, see [User Account and Authentication Service](../architecture/uaa.html).

## <a id='vcap-services'></a>VCAP_SERVICES##

> An environment variable that contains connection information for all services bound to an application.
<br><br>
> For more information, see [VCAP_SERVICES Environment Variable](../../using/services/environment-variable.html).


## <a id='vmc'></a>VMC ##
> VMC was the command line interface in Cloud Foundry v1.  [cf](#cf) replaced VMC in Cloud Foundry v2.


## <a id='warden'></a>Warden ##

> Warden is a framework within Cloud Foundry for creating and managing isolated environments on Unix. Warden provides an API and a command line interface for creating and managing containers within a VM. Containers created by Warden can be limited in terms of network access as well as CPU, memory, and disk usage. 


## <a id='yaml'></a> YAML ##

> YAML is the format used in application manifests and BOSH manifests in Cloud Foundry. For information about the YAML grammar, see [www.yaml.org](www.yaml.org).  


## <a id='yml'></a>yml ##

>  The file extension for a YAML file. See [YAML](#yaml). 




