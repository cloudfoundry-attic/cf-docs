---
title: Cloud Foundry Eclipse Plugin
---

**5 September 2013 - This page is a work in progress, and contains information that is subject to review, correction, and enhancement.**

The Cloud Foundry Eclipse Plugin is an extension that enables Cloud Foundry users to deploy and manage Java and Spring applications on a Cloud Foundry instance from Eclipse or Spring Tools Suite (STS).

The plugin supports Eclipse v3.8 and v4.3 (a JEE version is recommended), and STS 3.0.0 and later.

This page has instructions for installing and using v1.5.1 of the plugin, which is compatible with Cloud Foundry v2.

You can use the plugin to:

* Deploy applications from an Eclipse or STS workspace to a running Cloud Foundry instance. The plugin supports Spring, Java, Java standalone, Web, Grails, and Lift applications.
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

Follow these instructions to install the Cloud Foundry Eclipse Plugin to Eclipse from the Eclipse Marketplace. If you are installing the plugin to STS, see the following section [Install to STS from Extensions Tab](#install-to-sts).

1. Start Eclipse
1. Select **Eclipse Marketplace** from the Eclipse **Help** menu.
1. On the marketplace window, enter "Cloud Foundry" in the **Find** field, and click **Go**.
1. In the search results, click the **Install** control next to the listing for Cloud Foundry Integration.

  <img src="/images/sts/eclipse-marketplace.png"/>  

1. The **Confirm Selected Features** window lists the plugin --- "Cloud Foundry Integration for Eclipse" --- and the optional "SpringSource UAA Integration" component, which reports tool usage data, anonymously. If you prefer that your plugin usage statistics not be reported, de-select the UAA component before clicking **Confirm**.

     <img src="/images/sts/confirm-selected-features.png" />

1. The **Review Licenses** window appears. Click “I accept the terms of the license agremment” and click **Finish**.
1. The **Sofware Updates** window appears. Click **Yes** to restart Eclipse.

     <img src="/images/sts/software-updates.png" />

### <a id='install-to-sts'></a>Install to STS from Extensions Tab ###

Follow these instructions to install the Cloud Foundry Eclipse Plugin to STS from the **Extensions** tab.

1. Start STS.
1. Select the **Extensions** tab from the STS Dashboard.
1. Enter "Cloud Foundry" in the **Find** field.
1. Select **Cloud Foundry Integration for Eclipse** and click **Install**.

  <img src="/images/sts/extensions.png" />

1. The **Install** window lists the plugin --- "Cloud Foundry Integration for Eclipse" --- and the optional "Spring UAA Integration" component, which reports tool usage data, anonymously. If you prefer that your plugin usage statistics not be reported, de-select the UAA component beform clicking  **Next**.

  <img src="/images/sts/install.png"/>

1. On the **Install Details** window, click **Next**.

  <img src="/images/sts/install-details.png"/>

1. The **Review Licenses** window appears. Click “I accept the terms of the license agremment” and click **Finish** to perform the installation. 

1. The **Sofware Updates** window appears. Click **Yes** to restart STS.

     <img src="/images/sts/restart-sts.png" />

1. After STS restarts, you can see new panes in the Editor portion of the screen. See [About the Plugin User Interface](#plugin-ui) below for a description of the plugin tabs and the information in each.
1. Proceed to [Create a Cloud Foundry Server](#cloud-foundry-server).

## <a id='cloud-foundry-server'></a>Create a Cloud Foundry Server ##

This section has instructions for configuring a server resource that will represent a target Cloud Foundry space. You will create a server for each space in your Cloud Foundry instance to which you will deploy applications.

1. Right-click the **Servers** pane and select **New > Server**. 
1. In the **Define a New Server** window, expand the **Pivotal** folder, select **Cloud Foundry**, and click **Next**.  

     <img src="/images/sts/define-new-server.png" />

1. On the **Cloud Foundry Account** window, if you already have a Cloud Foundry account enter the email account and password you use to log on to Cloud Foundry Click **Validate Account**. 

  If you do not have a Cloud Foundry account you can click **Pivotal CF Signup** to get one, and complete this procedure after your account is established.

     <img src="/images/sts/cloud-foundry-account.png" />

1. The **Cloud Foundry Account** window is refreshed and displays a message indicating whether or not your credentials were valid --- if they were, click **Finish**. 

      <img src="/images/sts/new-server.png" />

1. On the **Orgnizations and Spaces** window, select the space you want to target, and click **Finish**.  

      <img src="/images/sts/orgs-and-spaces.png" />

1. Once you have successfully configured the Pivotal Cloud Foundry server, it will appear in the **Servers** pane of the Eclipse or STS user interface. To familiarize yourself with the plugin user interface, see [About the Plugin User Interface](#plugin-ui). When you are ready, proceed to [Deploy an Application](#deploy-an-application).     

## <a id='plugin-ui'></a>About the Plugin User Interface ##

The paragraphs below describe the Cloud Foundry Eclipse plugin user interface. If you do not see the tabs described below, select the Pivotal Cloud Founder server in the **Servers** pane.

### <a id='overview-tab'></a>Overview Tab ###

The follow panes are present when the **Overview** tab is selected:

* A --- The **Package Explorer** pane lists the projects in the current workspace. 
* B -- The **Servers** tab lists server instances configured in the current workspace. A server of type "Pivotal Cloud Foundry" represents a targeted space in a Cloud Foundry instance. 
* C -- The **General Information** pane lists...
* D -- The **Account Information** pane lists your credentials for the target Cloud Foundry instance and the specific organization and space that are targeted. The pane includes these controls:
    * **Clone Server** --- Click to create additional Pivotal Cloud Foundry server instances. You must configure a server instance for each Cloud Foundry space you wish to target. For more information, see [Create Additional Server Instances](#clone).
    * **Change Password** --- Click to change your Cloud Foundry password.
    * **Validate Account** --- Click to verify your currently configured Cloud Foundry credentials
    * **Pivotal CF Signup** --- If you do not have a Cloud Foundry account, click to sign up for one.
* E -- The **Server Status** pane shows whether or not you are connected to Cloud Foundry space that the currently selected server instance targets. When you have multiple Pivotal Cloud Foundry server instances configured, you will use the **Disconnect** and **Connect** controls to switch among them.
* F -- The **Console** pane displays status messages when you perform an action such as deploying an application.
* G -- You can use the **Remote Systems View** pane to view the contents of a file that is part of a deployed application. For more information, see [View an Application File](#view-file).

<img src="/images/sts/ui-overview-tab.png" style="width: 1150px;"/>

### <a id='apps-services-tab'></a>Applications and Services Tab ###

The follow panes are present when the *Applications and Services* tab is selected: 

* H --- The **Applications** pane lists the applications deployed to the targeted space.
* I --  The **Services** pane lists the services provisioned in the targeted space
* J --  The **General** pane displays information for the application currently selected in the **Applications** pane.
* K --  The **Services** pane lists services that are bound to the application currently selected in the **Applications** pane. Note the icon in the upper right corner of the pane --- it allows you to create a service, as described in [Create a Service](#create-service), below. 

<img src="/images/sts/ui-apps-services-tab.png" style="width: 1150px;" />

## <a id='deploy-an-application'></a>Deploy an Application ##
To deploy an application to Cloud Foundry using the plugin: 

1. To initiate deployment either:
  * Drag the application from the **Package Explorer** pane onto the Pivotal Cloud Foundry server in the **Servers** pane, or
  * Right-click the Pivotal Cloud Foundry server in the **Servers** pane, select **Add and Remove* from the server context menu, and then 
1. On the **Application Details** window, you can enter the URL of an external buildpack if desired. Click **Next** to continue.

      <img src="/images/sts/application-details.png" />

1. On the **Launch Deployment** window:

  **Host** --- By default, contains the name of the application.

  **Domain** --- By default, contains
  
  **Deployed URL** --- 
  **Memory Reservation** --- Select the amount of memory to allocate to the application from the pull-down list.
  
  **Start application...** --- If you do not want the application to be started upon deployment, uncheck the box.

      <img src="/images/sts/launch-deployment.png" />

1. The **Services Selection** window lists services provisioned in the target space. Checkmark the services, if any, that you want to bind to the application, and click **Finish**. Note that you can bind services to the application after deployment.  

      <img src="/images/sts/services-selection.png" />

   As the deployment proceeds, progress messages appear in the **Console** pane. When deployment is complete, the application is listed in the ** Applications** pane.   

## <a id='create-service'></a>Create a Service ##

Before you can bind a service to an application you must create it. To do so:

1. Select the **Applications and Services** tab.
1. Click the icon in the upper right corner of the "Services" pane.
1. In the **Service Configuration** window:

  * Name --- Enter a name for the service.
  * Type --- Select the service type from the pull-down list.

      <img src="/images/sts/service-configuration.png" />

1. The new service appears in the **Services** pane.

## <a id='bind-service'></a>Bind a Service ##


## <a id='view-file'></a>View an Application File ##

You can view the contents of a file in a deployed application by selecting it the **Remote Systems View**. (See the pane labelled "G" in the screenshot in the [Overview Tab](#overview-tab) above.) 

1. If the **Remote Systems View** pane is not visible:
  * Select the *Applications and Services* tab.
  * In the **Instances* pane, click the **Remote Systems View** link.

2. On the **Remote Systems View** pane, browse to the application and application file of interest, and double-click the file. A new tab appears in the editor area with the contents of the selected file. 

      <img src="/images/sts/remote-systems.png" />

## <a id='undeploy'></a>Undeploy an Application##


## <a id='scale-application'></a>Scale an Application ##

You can change the memory allocation for an application and the number of instances deployed in the **General** pane when the **Applications and Services** tab is selected.  Use the **Memory Limit** and **Instances** selector lists. 

## <a id='scale-application'></a>Manage Application URLs##

You add, edit, and remove URLs mapped to the currently selected application in the **General** pane when the **Applications and Services** tab is selected.  Click the pencil icon to display the **Mapped URIs Configuration** pane. 

      <img src="/images/sts/manage-uris-configuration.png" />

## <a id='clone'></a>Create Additional Server Instances ##


## <a id='add-URL'></a>Add a Cloud Foundry Instance URL ##

1. step 1 here
     
      <img src="/images/sts/manage-cloud-urls.png" />

2. step 2 here

      <img src="/images/sts/add-cloud-url.png" />

