---
title: Cloud Foundry Eclipse Plugin
---

**5 September 2013 - This page is a work in progress, and contains information that is subject to review, correction, and enhancement.**

The Cloud Foundry Eclipse is a plugin for Eclipse and Spring Tools Suite (STS) for deploying and managing Java and Spring applications on Cloud Foundry. 

The plugin supports Eclipse v3.8 and v4.3 (a JEE version is recommended(, and STS 3.0.0 and later.

This page has instructions for installing and using v1.5.1 of the plugin, which is compatible with Cloud Foundry v2.

You can use the plugin to:

* Deploy applications from an Eclipse or STS workspace to a running Cloud Foundry instance. the plugin supports Spring, Java, Java standalone, Web, Grails, and Lift application.
* Create, bind, and unbind services.
* View and manage deployed applications and services.
* Start and stop applications.

v1.5.1 of the plugin provides several new features:

* Custom buildpack support --- When you deploy an application using the plugin, you can supply the URL of a custom buildpack.
* Separately defined host and domain --- In this version of the plugin, you specify the components (host and domain) of an application URL separately, rather than as a complete URL.
* Cloud Foundry server cloning --- v1.5.1 of the plugin makes it easier to work with multiple Cloud Foundry spaces. After configuring a first Cloud Foundry server instance using the plugin, you can use the new **Clone Server** command to create additional server instances that target other Cloud Foundry spaces.   

## <a id='install'></a>Install Cloud Foundry Eclipse Plugin ##
The sections below have instructions for installing the Cloud Foundry Eclipse Plugin.
### <a id='install-to-eclipse'></a>Install to Eclipse from Marketplace ###

Follow these instructions to instally the Cloud Foundry Eclipse Plugin to Eclipse from the Eclipse Marketplace.

1. Start Eclipse
1. Select **Eclipse Marketplace** from the Eclipse **Help** menu.

  <img src="/images/sts/eclipse-marketplace.png"/>  

1. On the marketplace pane, enter "Cloud Foundry" in the **Find** field, and click **Go**.
1. In the search results, click the **Install** control next to the listing for CLoud Foundry Integration.
1. On the **Confirm Selected Features" pane, click **Confirm**.

     <img src="/images/sts/confirm-selected-features.png" />

1. The **Review Licenses** window appears. Click “I accept the terms of the license agremment” and click **Finish**.
1. The **Sofware Updates** window appears. Click **Yes** to restart Eclipse.

     <img src="/images/sts/software-updates.png" />

### <a id='install-to-sts'></a>Install to STS from Extensions Tab ###

Follow these instructions to instally the Cloud Foundry Eclipse Plugin to STS from the Extensions tab.

1. Start STS.
1. Select the **Extensions** tab from the STS Dashboard.
1. Enter "Cloud Foundry in the **Find** field.
1. Select **Cloud Foundry Integration for Eclipse** and click **Install**.

  <img src="/images/sts/extensions.png" />

1. The **Install** window lists the plugin --- "Cloud Foundry Integration for Eclipse" --- and the optional "Spring UAA Integration" component, which reports tool usage data, anonymously. If you prefer that your plugin usage statistics not be reported, deselect the UAA component beform clicking  **Next**.

  <img src="/images/sts/install.png"/>

1. On the **Install Details** window, click **Next**.

  <img src="/images/sts/install-details.png"/>

1. The **Review Licenses** window appears. Click “I accept the terms of the license agremment” and click **Finish** to perform the installation. 

1. The **Sofware Updates** window appears. Click **Yes** to restart STS.

     <img src="/images/sts/restart-sts.png" />

1. After STS restarts, you can see the new panes in the Editor portion of the screen.

     <img src="/images/sts/plugin.png" style="width: 1100px;"/>

1. Installation is complete. Proceed to [Create a Cloud Foundry Server](#cloud-foundry-server).

## <a id='cloud-foundry-server'></a>Create a Cloud Foundry Server ##

This section has instructons for configuring a server resource that will represent a target Cloud Foundry space. You will create a server for each space in your Cloud Foundry instance to which you will deploy applications.

1. Right-click the **Servers** pane and select **New > Server**. 
 
1. In the **Define a New Server** window, expand the **Pivotal** folder, select **Cloud Foundry**, and click **Next**.  

     <img src="/images/sts/define-new-server.png" />

1. On the **Cloud Foundry Account** window:
      * If you already have a Cloud Foundry account enter the email account and password you use to log on to Cloud Foundry Click **Validate Account**. 
      * If you do not have a Cloud Foundry account you can click **Pivotal CF Signup** to get one.

     <img src="/images/sts/cloud-foundry-account.png" />

1. The **Cloud Foundry Account** window is refreshed and displays a message indicating whether or not your credentials were valid --- if they were, click **Finish**. 

      <img src="/images/sts/new-server.png" />

1. On the **Orgnizations and Spaces** window, select the space you want to target, and click **Finish**.  

      <img src="/images/sts/orgs-and-spaces.png" />

## <a id='plugin-ui'></a>About the Plugin User Interface ##


## <a id='deploying-an-application'></a>Deploy an Application ##
To deploy an application to Cloud Foundry, you can either:

* Drag the application frp, onto the Cloud Foundry server in the “Servers” view. 
* select the “Add and Remove …” option from the server’s context-menu

## <a id='view-file'></a>View an Application File ##
1. vvccb vcbv vb c

      <img src="/images/sts/remote-systems.png" />

1. vbcvb

      <img src="/images/sts/file-contents.png" />



## <a id='scale-application'></a>Scale an Application ##

## <a id='add URL'></a>Add a Cloud Foundry Instance URL ##
     <img src="/images/sts/manage-cloud-urls.png" />

     <img src="/images/sts/add-cloud-url.png" />

