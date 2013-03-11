---
title: SpringSource Tool Suite
---

## <a id='intro'></a>Introduction ##

The Spring Tool Suite™ (STS) provides the best Eclipse-powered development environment for building Spring-powered enterprise applications. STS supplies tools for all of the latest enterprise Java and Spring, and comes on top of the latest Eclipse releases.

This short tutorial will show you how to install the Cloud Foundry extension, register a server endpoint and then deploy a Spring application.

## <a id='installing-the-extension'></a>Installing the Extension ##

Cloud Foundry support is provided by an Eclipse extension. To install the extension, select the "Dashboard" pane and then the "Extensions" tab. Seach for "Cloud Foundry", select and install the correct extension.

<img src="/images/sts/install_extension.png" />

## <a id='register-a-server'></a>Register a Server ##

It should now be possible to register Cloud Foundry servers in the servers pain. Right click the servers pane and select "New > Server", the "New Server" dialog show be visible. Making sure "Cloud Foundry" in the "VMWare" folder is selected from the server type list, hit the next button.

<img src="/images/sts/new_server.png" />

Enter the credentials for the endpoint, select the endpoint type (most likely "VMWare Cloud Foundry") and click the "Finish" button. A new entry for the server should appear in the "Servers" pane, labelled "VMWare Cloud Foundry".

<img src="/images/sts/enter_credentials.png" />

However, if you are connecting to a "New Generation" Cloud Foundry instance you may see a window like this, asking you to select an organization and space;

<img src="/images/sts/select_org_and_space.png" />

## <a id='deploying-an-application'></a>Deploying an Application ##

To deploy an application to a running server either drag the application on to the relevant entry in the "Servers" pane or start it using the "Run on Server" menu item (the green start arrow). If the selected server is a Cloud Foundry instance, the following pane is displayed;

<img src="/images/sts/deploy-1.png" />

Most of the time the extension should pick these options automatically for the application, but in some cases adjustment may be necessary. Click "Next" and if necessary, adjust the default URL and memory allocation for the application.

<img src="/images/sts/deploy-2.png" />

Select any data services that should be bound to the application and click "Finish"

<img src="/images/sts/deploy-3.png" />

The application should appear in the "Servers" pane, listed under the associated Cloud Foundry instance and after deployment should also respond to the specified URL.
