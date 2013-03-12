---
title: IntelliJ IDEA
---

## <a id='intro'></a>Introduction ##

JetBrains, the creators of IntelliJ IDEA, provide an extension to support running JVM applications on Cloud Foundry. This guide assumes you have installed IntelliJ IDEA and have enable Cloud Foundry support already.

## <a id='adding-a-configuration'></a>Adding a configuration ##

To be able to deploy to Cloud Foundry, a Run/Debug configuration should be added for the instance. To start, select "Edit Configurations" from the "Run" menu and then click the "Add new configuration" button (the plus sign), selecting "Cloud Foundry" from the menu.

<img src="/images/intellij/add-configuration.png" />

Select the correct cloud instance and add the credentials for the intended account, then click "OK"

<img src="/images/intellij/credentials.png" />

Switch over to the Deployment tab and click the "+" button to add an artefact to deploy. The example shown is a Grails application so the artifact is the generated WAR file.

<img src="/images/intellij/add-artifact.png" />

Once the artifact has been added, configure the type, resource and services.

<img src="/images/intellij/config-artifact.png" />

## <a id='adding-a-configuration'></a>Deploying ##

To deploy the application, select the relevant entry from the top of the "Run" menu. If the configuration was named "Production-CF" then the menu item will be captioned "Production-CF". The output pane of the "Run" tab should show output similar to that illustrated below;

<img src="/images/intellij/deploy-output.png" />

The deployment itself uses the name of the uploaded artifact as the URL so it may be worth considering this when you deploy. In the example, the artifact is named 'grails\_hello-0.1.war' so the URL for the application is 'http://grails\_hello\_0\_1\_war.cloudfoundry.com'