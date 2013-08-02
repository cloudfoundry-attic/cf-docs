---
title: IntelliJ IDEA
---

> **The IntelliJ plugin for Cloud Foundry will be updated in the coming weeks to support Cloud Foundry v2, including support for organizations, spaces, and custom buildpacks.**

JetBrains, the creators of IntelliJ IDEA, provides an extension to support running JVM applications on Cloud Foundry. In this procedure it is assumed that you have installed IntelliJ IDEA and have enabled Cloud Foundry support.

## <a id='adding-a-configuration'></a>Add a configuration ##

To deploy an application to Cloud Foundry, you need to add a Run/Debug configuration for the instance. Select **Edit Configurations** from the **Run** menu. Click the **plus sign** to add a new configuration, and select **Cloud Foundry** from the menu.

<img src="/images/intellij/add-configuration.png" />

Select the correct cloud instance and add the credentials for the intended account, then click **OK**.

<img src="/images/intellij/credentials.png" />

On the **Deployment** tab, click the **plus button** to add an artifact to deploy. The example shown is a Grails application so the artifact is the generated WAR file.

<img src="/images/intellij/add-artifact.png" />

Once the artifact has been added, configure the type, resource, and services.

<img src="/images/intellij/config-artifact.png" />

## <a id='deploying'></a>Deploy the application ##

Select the relevant entry from the top of the **Run** menu. If the configuration was named "Production-CF", the menu item is captioned "Production-CF". The output pane of the **Run** tab should show output similar to that illustrated below.

<img src="/images/intellij/deploy-output.png" />

The deployment itself uses the name of the uploaded artifact as the URL, so consider this when you deploy. In the example, the artifact is named grails\_hello-0.1.war so the URL for the application is http://grails\_hello\_0\_1\_war.cloudfoundry.com.
