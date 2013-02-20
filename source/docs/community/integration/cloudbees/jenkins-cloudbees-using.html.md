---
title: Using Jenkins to Deploy
---

Jenkins can push applications to CloudFoundry.com after a successful build. This guide will show the process for configuring a Jenkins job to push to CloudFoundry.com. 

* [Prerequisites](#prerequisites)
* [Configuring a Job](#config)
* [Troubleshooting](#troubleshooting)

## <a id='prerequisites'></a>Prerequisites ##

This guide will show how to configure an existing CloudBees Jenkins job to push an application to CloudFoundry.com. Before this can be done, the follow steps should be completed: 

* The source code for the application should be in a public git or subversion repository (e.g. [GitHub](http://www.github.com), [BitBucket](https://bitbucket.org/), [Google Code](http://code.google.com/hosting/) or [CloudBees Forge](http://www.cloudbees.com/)).
* A Jenkins job should be created and configured to successfully build the application. See the [CloudBees Jenkins documentation](http://developer.cloudbees.com/bin/view/DEV/Getting+started+with+Jenkins) for help creating the initial Jenkins job. 

## <a id='config'></a>Configuring a Job ##

Follow these steps to configure an existing Jenkins job to push an application to CloudFoundry.com.

Starting from the Jenkins Dashboard, click on the project name to view the project details:

![Jenkins Dashboard](community/integration/cloudbees/jenkins-dashboard.png)

From the project page, click on the "Configure" link: 

![Jenkins Project Page](community/integration/cloudbees/jenkins-project.png)

Scroll to the bottom of the project configuration page. Click on the "Add post-build action" button, and select "Deploy applications" from the presented list.

![Jenkins Configure Page](community/integration/cloudbees/jenkins-project-configure-1.png)

![Jenkins Configure Page](community/integration/cloudbees/jenkins-project-configure-2.png)

Look for the "Cloud Foundry" section added to the page:

![Jenkins Configure Page](community/integration/cloudbees/jenkins-project-configure-3.png)

Fill out the form fields as follows:

* **Target API end-point**: Enter the URL for the Cloud Foundry environment's Cloud Controller. 
* **Credentials**: Choose the CloudBees account that you previously linked to your CloudFoundry.com account.
* **Application Name**: Enter a name for the application. This name must be unique to your Cloud Foundry account.
* **Deployment Hostname**: Enter the URL that will be used to access the application. It must be unique across CloudFoundry.com. 
* **Application Type**: Choose the option appropriate for the application. 
* **Runtime**: Choose the option appropriate for the application
* **Number of Instances**: Enter the number of instances of the application that should be started on Cloud Foundry. 
* **Memory Reservation**: Choose the amount of memory that Cloud Foundry should allocate to the application.
* **Start application on deployment**: Check if Cloud Foundry should start the application after it is pushed. 

If the application requires services (a database, document store, key-value store, or messaging system), click on the "Add service" button. Additional fields will be added to the form: 

![Jenkins Configure Page](community/integration/cloudbees/jenkins-project-configure-4.png)

Fill out the additional form fields as follows: 

* **Service name**: Enter a name for the service. This name must be unique to your Cloud Foundry account.
* **Service type**: Choose the appropriate service type from the list.
* **Service version**: Choose a service version from the list. 

You can add as many services as necessary for your application by clicking the "Add service" button multiple times. 

After you are done adding the Cloud Foundry configuration to the Jenkins job, press the "Save" button. You will be returned to the project details page, where you can click the "Build Now" link to start a build of the project. 

## <a id='troubleshooting'></a>Troubleshooting ##

*TODO*: anything to put here?

