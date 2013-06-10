---
title: Getting Started with Jenkins on CloudBees DEV@cloud
---

* [Introduction](#intro)
* [Authorizing Access](#authorizing)
* [Revoking Access](#revoking)

## <a id='intro'></a>Introduction ##

Before you can use Jenkins to push applications to Cloud Foundry, you need to have accounts on CloudFoundry.com and on CloudBees.com, and Jenkins must be authorized to push applications to your Cloud Foundry account on your behalf. These steps will guide you through the process of creating and linking those accounts.

If you do not have a CloudFoundry.com account, you can sign up for a free account [here](https://www.cloudfoundry.com/signup). 

## <a id='authorizing'></a>Authorizing Access ##

The following steps will walk you through the process of linking a CloudBees and CloudFoundry.com account together so Jenkins on CloudBees DEV@cloud has the ability to push applications to CloudFoundry.com. 

You should only need to follow these steps once to set up Jenkins. 

### CloudBees Cloud Foundry launch page ###

To start, open a browser and go to the CloudBees Cloud Foundry launch page at [http://cloudfoundry.cloudbees.com](http://cloudfoundry.cloudbees.com). You should see a page similar to this one: 

![CloudBees Cloud Foundry launch page](dotcom/integration/cloudbees/cloudbees-page1.png)

Click on the "Sign in with Cloud Foundry" button, which will send you to the CloudFoundry.com authorization page. 

### Cloud Foundry sign in ###

If you have not already logged into CloudFoundry.com in the current browser session, you will be prompted to log in with the e-mail address you provided at registration and the password you set up after your account was created. If you are already signed in to CloudFoundry.com, this page will be skipped: 

![Cloud Foundry login page](dotcom/integration/cloudbees/cloudbees-page2.png)

### Cloud Foundry authorization ###

After sucessfully signing in, you will be asked to authorize CloudBees to access your CloudFoundry.com account:

![Cloud Foundry authorize page](dotcom/integration/cloudbees/cloudbees-page3.png)

Click the "Authorize" button to allow this access. After clicking the "Authorize" button, you will be returned to the CloudBees site to finish setting up your CloudBees account. 

### CloudBees account setup ###

If you do not already have a CloudBees account, you will be asked to sign up. If you already have a CloudBees account set up with the same e-mail address used to sign in to Cloud Foundry, then this page will be skipped:

![CloudBees signup page](dotcom/integration/cloudbees/cloudbees-page4.png)

### CloudBees Jenkins provisioning ###

CloudBees will now provision and configure your Jenkins account to use the Cloud Foundry Jenkins integration. This may take a few minutes, and the page will update with the current status of this process. After the Jenkins configuration is complete, you should see a page like this one: 

![CloudBees configure page](dotcom/integration/cloudbees/cloudbees-page5.png)

At this point, you can click on the "To Jenkins!" button to start [configuring Jenkins jobs](./jenkins-cloudbees-using.html). 

## <a id='revoking'></a>Revoking Access ##

If at some time in the future you decide you do not want Jenkins have the ability to push applications to your CloudFoundry.com account, you can revoke access. To revoke access from CloudBees, go to the CloudBees Cloud Foundry launch page at [http://cloudfoundry.cloudbees.com](http://cloudfoundry.cloudbees.com) and click on the "Sign in to Cloud Foundry" button. After signing into Cloud Foundry, you will see the Jenkins provisioning page like this: 

![CloudBees configure page](dotcom/integration/cloudbees/cloudbees-page5.png)

Click on the "X" in the corner of the box in the middle of the page to disable the CloudBees and Cloud Foundry integration. After the integration is disabled, you should see a screen like this:

![CloudBees configure page](dotcom/integration/cloudbees/cloudbees-revoke.png)

You can easily re-enable the integration by clicking on the "Enable" button. 
