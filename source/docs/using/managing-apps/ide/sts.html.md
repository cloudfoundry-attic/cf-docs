---
title: Spring Tool Suite
---

The Spring Tool Suite™ plugin for Cloud Foundry is upgraded for Cloud Foundry v2, and provides support for organizations, spaces, and custom buildpacks. 

Spring Tool Suite™ (STS) provides the best Eclipse-powered development environment for building Spring-powered enterprise applications. STS supplies tools for the latest enterprise Java and Spring releases, and incorporates the latest Eclipse releases.

This short tutorial shows you how to install the Cloud Foundry Eclipse extension, register a server endpoint, and deploy a Spring application.

## <a id='installing-the-extension'></a>Install the Extension ##

Cloud Foundry support is provided by an Eclipse extension. Select the **Dashboard** pane and then the **Extensions** tab. Seach for *Cloud Foundry*; select and install the correct extension.

<img src="/images/sts/install_extension.png" />

## <a id='register-a-server'></a>Register a Server ##

You can now register Cloud Foundry servers. Right-click the **Servers** pane and select **New > Server**. In the **New Server** dialog, make sure **Cloud Foundry** is selected in the server type list, under the VMWare folder. Click **Next**.

<img src="/images/sts/new_server.png" />

Enter the credentials for the endpoint, select the endpoint type (most likely **VMWare Cloud Foundry**) and click **Finish**. A new entry for the server should appear in the **Servers** pane, labeled VMWare Cloud Foundry.

<img src="/images/sts/enter_credentials.png" />

However, if you are connecting to a New Generation Cloud Foundry instance, you may see a window like this, asking you to select an organization and space:

<img src="/images/sts/select_org_and_space.png" />

## <a id='deploying-an-application'></a>Deploy an Application ##

To deploy an application to a running server, either drag the application on to the relevant entry in the **Servers** pane or start it using the Run on Server menu item (the green start arrow). If the selected server is a Cloud Foundry instance, the following pane is displayed:

<img src="/images/sts/deploy-1.png" />

Click **Next**. Usually the extension picks the correct options automatically for the application, but in some cases you may need to adjust the default URL and memory allocation for the application.

<img src="/images/sts/deploy-2.png" />

Select data services to bind to the application and click **Finish**.

<img src="/images/sts/deploy-3.png" />

The application should appear in the **Servers** pane, listed under the associated Cloud Foundry instance. After deployment it should also respond to the specified URL.
