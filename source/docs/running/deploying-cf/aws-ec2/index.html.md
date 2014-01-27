Installing Micro BOSH, BOSH and Cloud Foundry for Production on AWS

# Goals of this document

The main goal of this document is to guide someone with minimal experience through an end to end deployment of Cloud Foundry (CF) running on AWS EC2.

This includes guided installation of CLI tools locally, installation of Micro BOSH, deployment of BOSH from Micro BOSH on AWS and deployment of CF from BOSH on AWS.

This document does not intend to take shortcuts via bootstraps or Inception servers. While verbose and more time consuming more options will be explored and understanding found.  CF may be deployed straight from Micro BOSH but this is typically not considered a reliable production safe method and so it is not discussed here.

There are many versions and generations of gems, images, documentation and functionality.  We will identify where to get the most recent version of these when possible as well as the versions that worked at the time of writing this document.

# Concepts

## Inceptions

There will be 3 "inceptions" that will occur starting with your local computer.

### Micro Inception

Local computer creates a Micro BOSH server.

### BOSH Inception

Local computer creates a full BOSH Release set of servers.

### Cloud Foundry (CF) Inception

Local computer is used to create a set of Cloud Foundry servers from a CF release.

## Elements

Every inception utilizes four elements: Stemcell, Release and Deployment Manifest, BOSH CLI and Security Groups.

### Stemcell

A stemcell is a specific operating system image containing a preinstalled agent and associated package bits to support the running of a server.  There are two types of stemcells that we will be using, one for the MicroBOSH and one for the BOSH and CF servers. Stemcells are not interchangeable and are hypervisor specific.

### Deployment Manifest

The deployment manifest is a YAML (.yml) file which prescribes the parameters by which the next server in the inception will be configured.  During the first step we create a deployment manifest file on the computer which prescribes the configuration of one of the following: Micro BOSH, BOSH or CF servers.

### Release

This file contains references to all the packages available to the stemcell.  Like the Deployment Manifest this is a YAML (yml) file and is deployed from the local server to the BOSH server.

### BOSH CLI

The BOSH CLI is a tool which allows you to consume the stemcell and control an inception of bosh.

### Security Groups

At each inception additional ports need to be opened on AWS for pieces of the architecture to talk to each other.

## Local System

The local system used as an example within this document is a OSX laptop. This does not need to be the case, any Linux/Unix/Windows system should do. The details of using these other systems are outside of the scope of this document.

# Steps for Deployment

In order to setup and deploy a full BOSH release there are 9 major steps:

      0.   Create an AWS Account

1. Installation of bits locally preparing for Micro BOSH deployment (Micro Inception)

2. Configuring AWS for Micro BOSH (Micro Inception)

3. Deployment of Micro BOSH on AWS (Micro Inception)

4. Configuring AWS for BOSH (BOSH Inception)

5. Deployment of BOSH on AWS (BOSH Inception)

6. Configuring AWS for CF (CF Inception)

7. Deployment of CF on AWS (CF Inception)

8. Example apps deployed on CF (CF Inception)

## Step 0 - Create an AWS Account

This step is necessary if you don’t already have an AWS account.  I good tutorial for this can be found here: [http://bitnami.com/tutorials/create_aws_account](http://bitnami.com/tutorials/create_aws_account)

## Step 1 - Installation of bits locally preparing for Micro BOSH deployment

This step will prepare your local computer for deploying Micro BOSH and is the same regardless of the infrastructure you will deploy to.  You may have some of the steps below already installed if you are a Ruby developer ( and if you are, you know which steps you can skip):

1. Install Ruby

2. Install the Git command line tool

3. Install RubyGems

4. Install Gems for BOSH CLI

### Install Ruby

Ruby 1.9.3 or 2.0.0 must be installed locally on your computer, this can be skipped if you already have Ruby 1.9.3 or 2.0.0 installed.  We recommend doing this with [RVM](https://rvm.io/rvm/install), from a terminal window:

##### **  $ ****\curl -L https://get.rvm.io | bash -s stable**

##### **  $ exec $SHELL -l # re-execute your login shell so that the rvm command will be found.**

##### **  $ rvm install 2.0.0**

##### **  $ rvm use 2.0.0**

There are alternate methodologies mentioned here ([Install Ruby and RubyGems](http://docs.cloudfoundry.com/docs/common/install_ruby.html)) if the above doesn’t work or you want to install Ruby with tools other than RVM.

### Install the Git command line tool

Git will be leveraged for several downloads so the git cli needs to be installed.  Visit [http://git-scm.com/](http://git-scm.com/) for instructions to download and install git on your local system. Then validate that git was installed successfully and is available in your terminal:

##### **  $ git --version**

##### **git version 1.8.4.2**

### Update RubyGems

This installs Ruby’s package management framework, additional details are located [here](http://rubygems.org/pages/download).

##### **$ gem update --system**

### Create a new gemset and update package management

#### **$ ****rvm use 2.0.0@bosh --create**

For Ubuntu

#### **$ ****sudo apt-get update**

For Fedora

  **$ ****sudo yum update**

### Install Gems for BOSH CLI

Run the following command to Install the gems required to run bosh from the command line:

##### **$ ****g****em install bosh_cli_plugin_micro --pre**

Note: if the step above errors out referencing sqlite, execute "apt-get install sqlite-devel" then try the previous step again.

## Step 2 - Configuring AWS for Micro BOSH

We will assume that you already have an AWS account and the approval of someone to spend money.  There is some additional prep work that will need to be performed:

1. Obtain AWS credentials

2. Create Elastic IPs

3. Create a key pair

4. Create a security group

5. Add ports to the security group

Much of this was borrowed from [here](http://blog.cloudfoundry.com/2012/09/06/deploying-to-aws-using-cloud-foundry-bosh/), screen shots were updated to reflect EC2’s new screen layout.

Additional important note: all of the examples below are assuming you will be using US-EAST-1 as your AWS Region.  If you will be leveraging a different AWS region make sure you created Elastic IP’s in the same region as your EC2 instances, IP addresses for one region can’t be given to an instance in another region

### Obtain AWS credentials

If you already know your AWS credentials (access_key_id and secret_access_key, which are not the same as your AWS login and password) you can skip this step.

Start by logging into AWS: [https://console.aws.amazon.com](https://console.aws.amazon.com)

Click on "Instances" in the left pane, make sure to select N. Virginia as your region![image alt text](image_0.png)

Select the dropdown next to your login name and select "Security Credentials"

![image alt text](image_1.png)

Then select "Create New Access Key".  If there are already keys created you may want to stop and consult someone in your organization to obtain the access_key_id and secret_access_key as there is a limit of 2 sets of Access Keys which can exist.

![image alt text](image_2.png)

You will be prompted to download the security file as a csv.  DO THIS!  You cannot retrieve the aws secret key once the screen is closed.![image alt text](image_3.png)

Document the access_key_id and secret_access_key somewhere privately and securely within your organization and keep these safe, these are the only two pieces of information needed to consume AWS resources by fraudsters.

### Create Elastic IPs

The Micro Bosh server will need a public IP address, AWS calls these Elastic IPs.

Making sure that "N. Virginia" is selected as the AWS Region, click “Elastic IPs” then “Allocate New Address”

![image alt text](image_4.png)

Then confirm by clicking "Yes, Allocate", leave “EC2” in the dropdown.

![image alt text](image_5.png)

Take note of the newly created IP address, you’ll be using it later.  Your address will be different than what is listed here.

![image alt text](image_6.png)

### Create a key pair

If you already have a Key Pair created you can skip creating a new key pair. You will still need to place a copy of the pem file as shown following.

Making sure that "N. Virginia" is selected as the AWS Region, click “Key Pairs” then “Create Key Pair”

![image alt text](image_7.png)

Name your key pair name "bosh" and click “Yes”

![image alt text](image_8.png)

After you click "Yes" a file will be downloaded to your computer and likely named “bosh.pem.txt”

Rename this file to "bosh" and save it into your ~/.ssh folder on your computer. For example, on OSX you can do this from the terminal:

#### **local$ mv ~/Downloads/bosh.pem.txt ~/.ssh/bosh**

If you receive an error that ~/.ssh doesn’t exist, you can create this folder by executing:

**mkdir -p ~/.ssh**

### Create a security group

We will be creating a security group for the Micro BOSH server, this is needed to expose ports that the BOSH Agent will use.

Making sure that "N. Virginia" is selected as the AWS Region, click “Security Groups” then “Create Security Group”

![image alt text](image_9.png)

On the popup screen assign "bosh" to the Name, “BOSH Security Group” to the Description, and leave “No VPC” in the dropdown.  Click “Yes, Create”

![image alt text](image_10.png)

### Add ports to the security group

Micro BOSH needs ports 25555 (BOSH Director), 6868 (BOSH Agent) and 22 (ssh to debug) opened for inbound for the security group "bosh" that we just created.  A note here: some or all of these ports may be blocked on your corporate firewall, any easy way around this is to attempt this from your personal home network.

Starting with the BOSH Director which needs port 25555, select the newly created Security Group, click "Inbound".  In the Port range box enter “25555” and click “Add Rule”

![image alt text](image_11.png)

Now add the second port, 6868, by entering this port number into the Port range box and clicking "Add Rule"

![image alt text](image_12.png)

Now add the last port, 22, by entering this port number into the Port range box and clicking "Add Rule".  Since this is the last port you are adding, click “Apply Rule Changes” to save the changes to this Security Group.

![image alt text](image_13.png)

## Step 3 - Deployment of Micro BOSH on AWS

This step will leverage the Elastic IP, Security Group and Key Pair file that we created in Step 2 to deploy a Micro BOSH server on AWS in four steps:

1. Create Directory Structure

2. Create Micro BOSH Deployment Manifest

3. Find the correct Micro BOSH Stemcell

4. Deploy Manifest

Much of this is borrowed from [here](http://blog.cloudfoundry.com/2012/09/06/deploying-to-aws-using-cloud-foundry-bosh/)

### Create Directory Structure

Create a standard place to store the Deployment Manifest on your local computer:

#### **local$ mkdir -p ~/bosh-workspace/deployments/microboshes/deployments/microbosh**

#### **local$ cd ~/bosh-workspace/deployments/microboshes/deployments/microbosh**

#### **local$ touch microbosh.yml**

**Create Micro BOSH Deployment Manifest**

Now let’s review what the contents of the microbosh.yml deployment manifest file should include.  Be sure to replace "x.x.x.x" with the ip address you created on Step 2 in the script below.

<table>
  <tr>
    <td>---
name: microbosh

logging:
  level: DEBUG

network:
  type: dynamic
  vip: x.x.x.x    #Change this to the allocated IP address from Step 2

resources:
  persistent_disk: 20000
  cloud_properties:
    instance_type: m1.small
    availability_zone: us-east-1a

cloud:
  plugin: aws
  properties:
    aws:
      access_key_id: AKIAIYJWVDUP4KRESQ
      secret_access_key: EVGFswlmOvA33ZrU1ViFEtXC5Sugc19yPzoWRf
      default_key_name: bosh
      default_security_groups: ["bosh"]
      ec2_private_key: ~/.ssh/bosh
      ec2_endpoint: ec2.us-east-1.amazonaws.com
      region: us-east-1

apply_spec:
  agent:
    blobstore:
      address: x.x.x.x    #Change this to the allocated IP address from Step 2
    nats:
      address: x.x.x.x    #Change this to the allocated IP address from Step 2
  properties:
    aws_registry:
      address: x.x.x.x    #Change this to the allocated IP address from Step 2
</td>
  </tr>
</table>


Note, Since this is a yml (YAML) file, spacing is extremely important, you’ll receive a syntax error when you get to the "Deploy Manifest" in two more sections.

If you are using the sample manifest provided, here are the things to check:

1. Make sure to update all of the instances of x.x.x.x IP with the appropriate elastic IP created.

2. Add the AWS credentials under the aws section.

3. Verify the aws region added in the manifest.

Save your changes to the file.

**Find the correct Micro BOSH Stemcell**

It is important to deploy the correct AWS image that is compatible with the version of Micro BOSH you will be installing and these will be updated over time.

To obtain the current ami, navigate to [http://bosh_artifacts.cfapps.io](http://bosh_artifacts.cfapps.io) and download the "light-bosh (aws xen ubuntu)" tarball file (.tar.gz).

![image alt text](image_14.png)

This will download the tar file to you local computer.  Extract this file and open the file within named "stemcell.MF" in your text editor.

![image alt text](image_15.png)

This file contains the image name (AMI ID) for this version of the bosh-cli. You will need this AMI ID for the next section.

![image alt text](image_16.png)

### Deploy Manifest

Everything is now in place to use the deployment manifest you have created and deploy Micro BOSH to AWS (the first inception). Let’s now do this.

Enter the deployments folder you created earlier:

#### **local$ cd ~/bosh-workspace/deployments/microboshes/deployments**

Select the deployment you called "aws" in the first section of Step 3

#### **local$ bosh micro deployment microbosh/microbosh.yml**

Ignore the error that isn’t an error, it is just letting you know that the director was mapped to port 25555

  ``WARNING! Your target has been changed to `[http://aws:25555](http://aws:25555)``!

Deploy the Micro BOSH AMI

#### **local$ bosh micro deploy ****ami-979dc6fe**

If the deployment failed clean it up before trying again

#### **local$ bosh micro delete**

Log into the new Micro BOSH server

#### **local$ bosh target 54.204.16.249**

**local$ bosh login**

The default username and password are "admin" and “admin”.

If the deployment ran successfully you will have a Micro BOSH VM deployed onto AWS.

![image alt text](image_17.png)

A few things to note in the screenshot above:

1. **microbosh** - the name of the instance will match the deployment name

2. **us-east-1a** - this is the availability zone that was in the deployment manifest

3. **bosh** - this was the name of the Key Pair

4. **bosh** - this was the name of the Security Group

5. **54.204.16.249 **- this was the Elastic IP address that we created and is the external IP address for the Micro BOSH server

## Step 4 - Configuring AWS for BOSH

The AWS configuration needs to be altered so that the BOSH server(s) can be deployed to AWS EC2:

* Additional ports need to be added to the "bosh" Security Group

* An additional Elastic IP is needed (2 more if you do the multiple BOSH servers deployment)

### Additional Ports

BOSH needs TCP ports ( 53, 4222, 25250 and 25777) and UDP port (53) opened for inbound to the security group "bosh" created previously.  We will also open ports 1 through 65535 so that all servers within that security group can talk to eachother.

Starting with the BOSH Director which needs port 4222, select the newly created Security Group, click "Inbound".  In the Port range box enter “4222” and click “Add Rule”.

![image alt text](image_18.png)

Now add the second port, 53, by entering this port number into the Port range box and clicking "Add Rule".

![image alt text](image_19.png)

Repeat this for the remaining ports 25250.

Now open TCP ports 1-65535 to all servers within the Security Group by entering this port number 1-65535 into the Port range box, entering the Group ID associated to this "bosh" Security Group (yes, this at first sounds circular, it will eventually make sense) and clicking “Add Rule”.  ![image alt text](image_20.png)

Now open UDP port 53 (you’ve already opened it for TCP).  In the Create a new rule: dropdown select Custom UPD rule, enter 53 into the Port range and click "Add Rule." Since this is the last port you are adding, click “Apply Rule Changes” to save the changes to this Security Group.

![image alt text](image_21.png)

### Additional Elastic IPs

Making sure that "N. Virginia" is selected as the AWS Region, click “Elastic IPs” then “Allocate New Address”.

![image alt text](image_22.png)

Leave "EC2" in the dropdown and confirm by clicking “Yes, Allocate”.

![image alt text](image_23.png)

Take note of the newly created IP address, you’ll be using it later.  Your address will be different than what is listed here.  Also notice that the first IP address we created is currently allocated to the Micro Bosh instance. ![image alt text](image_24.png)

## Step 5 - Deployment of BOSH on AWS

This step will leverage the new Elastic IP created in Step 4, Security Group and Key Pair file that we created in Step 2 to deploy a BOSH server on AWS in four steps:

1. Create Directory Structure

2. Create Micro BOSH Deployment Manifest

3. Locate the correct Micro BOSH Stemcell

4. Deploy Manifest

The original source of this information was from the [cloud foundry blog post](http://blog.cloudfoundry.com/2012/09/06/deploying-to-aws-using-cloud-foundry-bosh/).

### Obtain and Upload Release

Simply upload the most recent generic release

<table>
  <tr>
    <td>$ bosh upload release https://s3.amazonaws.com/bosh-jenkins-artifacts/release/bosh-1274.tgz</td>
  </tr>
</table>


### Create Directory Structure

Create a standard place to store the Deployment Manifest on your local computer, you should still be targeting the Micro BOSH server:

<table>
  <tr>
    <td>$ mkdir -p ~/bosh-workspace/deployments/bosh
$ cd ~/bosh-workspace/deployments/bosh
$ touch bosh.yml</td>
  </tr>
</table>


**Locate the correct BOSH Stemcell**

It is important to deploy the correct AWS image that is compatible with the version of BOSH you will be installing, these are updated over time.

To find and obtain the current BOSH stemcell, navigate to [http://bosh_artifacts.cfapps.io](http://bosh_artifacts.cfapps.io) and right click on "Download" and Copy Link for “bosh (aws xen ubuntu)” tarball file (.tar.gz).  An example of the link URL is:

[https://s3.amazonaws.com/bosh-jenkins-artifacts/bosh-stemcell/aws/bosh-stemcell-1274-aws-xen-ubuntu.tgz](https://s3.amazonaws.com/bosh-jenkins-artifacts/bosh-stemcell/aws/bosh-stemcell-1274-aws-xen-ubuntu.tgz)

![image alt text](image_25.png)

Upload the latest stemcell of BOSH onto the Micro BOSH server.

<table>
  <tr>
    <td>$ bosh upload stemcell https://s3.amazonaws.com/bosh-jenkins-artifacts/bosh-stemcell/aws/bosh-stemcell-1274-aws-xen-ubuntu.tgz</td>
  </tr>
</table>


After the upload is complete you can see the list of stemcells by calling:

<table>
  <tr>
    <td>$ bosh stemcells</td>
  </tr>
</table>




**Create BOSH Deployment Manifest**

Now let’s review what the contents of the bosh.yml deployment manifest file should include.

<table>
  <tr>
    <td>---
name: bosh

# The director_uuid is obtained by executing the "bosh status" command.
director_uuid: adf6af65-8b61-4b5f-b43a-44f3f662ec51

release:
  name: bosh
  version: latest

compilation:
  workers: 3
  network: default
  reuse_compilation_vms: true
  cloud_properties:
    instance_type: m1.small

update:
  canaries: 1
  canary_watch_time: 3000-120000
  update_watch_time: 3000-120000
  max_in_flight: 4
  max_errors: 1

networks:
  - name: elastic
    type: vip
    cloud_properties: {}
  - name: default
    type: dynamic
    cloud_properties:
      security_groups:
        - bosh # This needs to be changed if you didn’t call the security group “bosh”

resource_pools:
  - name: medium
    network: default
    size: 1
    stemcell:
      name: bosh-aws-xen-ubuntu
      version: latest
    cloud_properties:
      instance_type: m1.medium

jobs:
  - name: bosh
    template:
    - powerdns
    - nats
    - postgres
    - redis
    - director
    - blobstore
    - registry
    - health_monitor
    instances: 1
    resource_pool: medium
    persistent_disk: 20480
    networks:
      - name: default
        default: [dns, gateway]
      - name: elastic
        static_ips:
          - 23.21.249.15 # CHANGE: Elastic IP #2

properties:
  env:

  postgres: &bosh_db
    user: postgres
    password: postges
    host: 0.bosh.default.bosh.microbosh
    listen_address: 0.bosh.default.bosh.microbosh
    database: bosh

  dns:
    address: 23.21.249.15 # CHANGE: Elastic IP #2
    db: *bosh_db
    user: powerdns
    password: powerdns
    database:
      name: powerdns
    webserver:
      password: powerdns
    replication:
      basic_auth: replication:zxKDUBeCfKYX
      user: replication
      password: powerdns
    recursor: 54.204.16.249 # CHANGE: microBOSH IP address, Elastic IP #1

  redis:
    address: 0.bosh.default.bosh.microbosh
    password: redis

  nats:
    address: 0.bosh.default.bosh.microbosh
    user: nats
    password: nats

  director:
    name: bosh
    address: 0.bosh.default.bosh.microbosh
    db: *bosh_db

  blobstore:
    address: 0.bosh.default.bosh.microbosh
    agent:
      user: agent
      password: agent
    director:
      user: director
      password: director

  registry:
    address: 0.bosh.default.bosh.microbosh
    db: *bosh_db
    http:
      user: registry
      password: registry

  hm:
    http:
      user: hm
      password: hm
    director_account:
      user: admin
      password: admin
    event_nats_enabled: false
    email_notifications: false
    tsdb_enabled: false
    pagerduty_enabled: false
    varz_enabled: true

  aws:
    access_key_id: {{access key goes here}}
    secret_access_key: {{secret access key goes here}}
    default_key_name: bosh
    region: us-east-1
    default_security_groups: ["bosh"]</td>
  </tr>
</table>


Note that since this is a yml (YAML) file, spacing is extremely important, you’ll receive a syntax error when you get to the "Deploy Manifest" in two more sections.

Save your changes to the file.

### Deploy Manifest

Everything is now in place to use the deployment manifest you have created and deploy Micro BOSH to AWS (the first inception). Let’s now do this.

Enter the deployments folder you created earlier:

<table>
  <tr>
    <td>$ cd ~/bosh-workspace/deployments</td>
  </tr>
</table>


Select the deployment you called "bosh" in the first section of Step 5

<table>
  <tr>
    <td>$ bosh deployment bosh/bosh.yml</td>
  </tr>
</table>


Deploy the BOSH

<table>
  <tr>
    <td>$ bosh deploy </td>
  </tr>
</table>


If the deployment failed clean it up before trying again

<table>
  <tr>
    <td>$ bosh delete deployment bosh</td>
  </tr>
</table>


Log into the new BOSH server, replace the IP address with the IP address you created in Step 4 with the one used below.

<table>
  <tr>
    <td>$ bosh target 23.21.249.15</td>
  </tr>
</table>


The default username and password are "admin" and “admin”.

If the deployment ran successfully you will have a BOSH instance deployed onto AWS

Note a few things in the preceding screenshot:

![image alt text](image_26.png)

1. **bosh** - the name of the instance will match the deployment name

2. **us-east-1a** - this is the availability zone that was in the deployment manifest

3. **bosh** - this was the name of the Key Pair

4. **bosh** - this was the name of the Security Group

5. **23.21.249.15 **- this was the Elastic IP address that we created and is the external IP address for the BOSH server

## Step 6 - Configuring AWS for CF

### Additional Elastic IPs

Making sure that "N. Virginia" is selected as the AWS Region, click “Elastic IPs” then “Allocate New Address”.

![image alt text](image_27.png)

Leave "EC2" in the dropdown and confirm by clicking “Yes, Allocate”.

![image alt text](image_28.png)

Take note of the newly created IP address, you’ll be using it later in the CF Deployment Manifest.  Your address will be different than what is listed here.  Also notice that the two IP addresses we created are currently allocated to the Micro Bosh and BOSH instances.

![image alt text](image_29.png)

### Create a new Security Group

Making sure that "N. Virginia" is selected as the AWS Region, click “Security Groups” then “Create Security Group”

![image alt text](image_30.png)

On the popup screen assign "cf" to the Name, “cf Security Group” to the Description, and leave “No VPC” in the dropdown.  Click “Yes, Create”

![image alt text](image_31.png)

### Open Ports for the new Security Group

The original documentation was borrowed from [here](https://github.com/cloudfoundry-community/bosh-cloudfoundry/blob/master/tutorials/build-your-own-heroku-with-cloudfoundry.md), the summary of which is covered below.

Visit the [AWS Console for Security Groups](https://www.google.com/url?q=https%3A%2F%2Fconsole.aws.amazon.com%2Fec2%2Fhome%3Fregion%3Dus-east-1%23s%3DSecurityGroups&sa=D&sntz=1&usg=AFQjCNGEowcsPVCqMAhuqS27xnaVuvKiIg) and click "Create Security Group".

Click Create Security Group and create the group with the name "cf"

Add TCP ports:

* 22 (ssh)

* 80 (http)

* 443 (https)

* 4222

* 1-65535 (for security group VMs only)

Add UDP ports:

* 1-65535 (for security group VMs only)

Click on "Inbound" tab, enter “22” into the “Port range:” box and click “Add Rule”.  Repeat this for ports 80 and 443.  To add TCP 1 - 65535, enter “1-66535” into the “Port range:” box and enter the name of the cf Security Group into the “Source:” box and click “Add Rule”.  To add UDP 1 - 65535, select “Custom UDP rule” from the “Create a new rule:” dropdown box, enter “1-66535” into the “Port range:” box and enter the name of the cf Security Group into the “Source:” box and click “Add Rule”.  When you are done, click the “Apply Rule Changes” button and the screen should look similar to the image below:

![image alt text](image_32.png)

## Step 7 - Deployment of CF on AWS

These steps will leverage the additional security group and ports opened in the previous step to deploy Cloud Foundry from the BOSH server:

* Obtain and Upload Release

* Upload a Stemcell

* Modify a Deployment Manifest

* Deploy

### Obtain and Upload Release

Original documentation borrowed heavily from [here](http://www.google.com/url?q=http%3A%2F%2Fdocs.cloudfoundry.com%2Fdocs%2Frunning%2Fdeploying-cf%2Fcommon%2Fcf-release.html&sa=D&sntz=1&usg=AFQjCNEnuPr0Fy05RET8NliV2OUS-sjwhw), however you can follow the instructions below.

Create a folder on the local computer to store the CF Release:

**$ mkdir -p ~/bosh-workspace/releases/**

**$ cd ~/bosh-workspace/releases/**

**$ git clone -b release-candidate git://github.com/cloudfoundry/cf-release.git**

**$ cd ~/bosh-workspace/releases/cf-release**

Navigate into the releases folder and pick a recent release then upload:

  **$ bosh upload release ~/bosh-workspace/releases/cf-release/releases/cf-146.yml**

Note: if you get a blobstore error "No space left of device…" the local computer ran out of space on the /tmp folder.  To fix this, find a larger local partition and execute the following commands to point /tmp to a larger device.

**$ sudo su -**

**$ mkdir /tmp2**

**$ mount --bind /tmp2 /tmp**

**$ sudo chown root.root /tmp**

**$ sudo chmod 1777 /tmp**

To check that the release was successful:

  **$bosh releases**

### Obtain and Upload Stemcell

These are the exact same instructions that we used to upload the latest stemcell of BOSH onto the Micro BOSH server.

<table>
  <tr>
    <td>$ bosh upload stemcell https://s3.amazonaws.com/bosh-jenkins-artifacts/bosh-stemcell/aws/bosh-stemcell-1274-aws-xen-ubuntu.tgz</td>
  </tr>
</table>


After the upload is complete you can see the list of stemcells by calling:

<table>
  <tr>
    <td>$ bosh stemcells</td>
  </tr>
</table>


### Modify Deployment Manifest

Create a location to save the file

**$ mkdir -p ~/bosh-workspace/deployments/cf**

**$ cd ~/bosh-workspace/deployments/cf**

**$ vi cf.yml**

Below is a sample deployment manifest known to work with cf-146.  Substitute the new IP address you created in the last step for the address 107.20.148.206 seen below.  Obtain your director_uuid by executing "bosh status" and updating the manifest below no other changes are required unless you are using a different version other than cf-146.

This sample deployment was originally created via the bosh-cloudfoundry gem which is located [here](https://github.com/cloudfoundry-community/bosh-cloudfoundry/blob/master/templates/v146/aws/medium/deployment_file.yml.erb).

<table>
  <tr>
    <td>---
name: tutorial
director_uuid: cb876e64-c08f-427f-b84f-3d05a5fde145

releases:
 - name: cf
   version: 146

networks:
- name: floating
  type: vip
  cloud_properties: {}
- name: default
  type: dynamic
  cloud_properties:
    security_groups:
    - cf

update:
  canaries: 1
  canary_watch_time: 30000-60000
  update_watch_time: 30000-60000
  max_in_flight: 4

compilation:
  workers: 1
  network: default
  reuse_compilation_vms: true
  cloud_properties:
    instance_type: m1.medium

resource_pools:
  - name: small
    network: default
    size: 4
    stemcell:
      name: bosh-aws-xen-ubuntu
      version: latest
    cloud_properties:
      instance_type: m1.small

  - name: medium
    network: default
    size: 0
    stemcell:
      name: bosh-aws-xen-ubuntu
      version: latest
    cloud_properties:
      instance_type: m1.medium

jobs:
  - name: data
    release: cf
    template:
      - postgres
      - debian_nfs_server
    instances: 1
    resource_pool: small
    persistent_disk: 4096
    networks:
    - name: default
      default:
      - dns
      - gateway
    properties:
      db: databases

  - name: core
    release: cf
    template:
      - nats
      - health_manager_next
      - uaa
    instances: 1
    resource_pool: small
    networks:
    - name: default
      default:
      - dns
      - gateway

  - name: api
    release: cf
    template:
      - cloud_controller_ng
      - gorouter
    instances: 1
    resource_pool: small
    networks:
    - name: default
      default:
      - dns
      - gateway
    - name: floating
      static_ips:
      - 107.20.148.206
    properties:
      db: databases

  - name: dea
    release: cf
    template:
      - dea_next
    instances: 1
    resource_pool: small
    networks:
      - name: default
        default: [dns, gateway]

properties:
  cf:
    name: tutorial
    dns: 107.20.148.206.xip.io
    ip_addresses: ["107.20.148.206"]
    deployment_size: medium
    security_group: cf
    persistent_disk: 4096
    common_password: eaa139af583c
    dea_server_ram: 1500
    dea_container_depot_disk: 10240

  domain: 107.20.148.206.xip.io
  system_domain: 107.20.148.206.xip.io.com
  system_domain_organization: system_domain
  app_domains:
    - 107.20.148.206.xip.io

  networks:
    apps: default
    management: default

  nats:
    address: 0.core.default.tutorial.bosh
    port: 4222
    user: nats
    password: eaa139af583c
    authorization_timeout: 5

  router:
    port: 8081
    status:
      port: 8080
      user: gorouter
      password: eaa139af583c

  dea: &dea
    memory_mb: 1500
    disk_mb: 10240
    directory_server_protocol: http

  dea_next: *dea

  syslog_aggregator:
    address: 0.syslog-aggregator.default.tutorial.bosh
    port: 54321

  nfs_server:
    address: 0.data.default.tutorial.bosh
    network: "*.tutorial.bosh"
    idmapd_domain: 107.20.148.206.xip.io

  debian_nfs_server:
    no_root_squash: true

  databases: &databases
    db_scheme: postgres
    address: 0.data.default.tutorial.bosh
    port: 5524
    roles:
      - tag: admin
        name: ccadmin
        password: eaa139af583c
      - tag: admin
        name: uaaadmin
        password: eaa139af583c
    databases:
      - tag: cc
        name: ccdb
        citext: true
      - tag: uaa
        name: uaadb
        citext: true

  ccdb: &ccdb
    db_scheme: postgres
    address: 0.data.default.tutorial.bosh
    port: 5524
    roles:
      - tag: admin
        name: ccadmin
        password: eaa139af583c
    databases:
      - tag: cc
        name: ccdb
        citext: true

  ccdb_ng: *ccdb

  uaadb:
    db_scheme: postgresql
    address: 0.data.default.tutorial.bosh
    port: 5524
    roles:
      - tag: admin
        name: uaaadmin
        password: eaa139af583c
    databases:
      - tag: uaa
        name: uaadb
        citext: true

  cc_api_version: v2

  cc: &cc
    logging_level: debug
    external_host: api
    srv_api_uri: http://api.107.20.148.206.xip.io
    cc_partition: default
    db_encryption_key: eaa139af583c
    bootstrap_admin_email: admin@107.20.148.206.xip.io
    bulk_api_password: eaa139af583c
    uaa_resource_id: cloud_controller
    staging_upload_user: uploaduser
    staging_upload_password: eaa139af583c
    resource_pool:
      resource_directory_key: cc-resources
      # Local provider when using NFS
      fog_connection:
        provider: Local
    packages:
      app_package_directory_key: cc-packages
    droplets:
      droplet_directory_key: cc-droplets
    default_quota_definition: runaway

  ccng: *cc

  login:
    enabled: false

  uaa:
    url: http://uaa.107.20.148.206.xip.io
    spring_profiles: postgresql
    no_ssl: true
    catalina_opts: -Xmx768m -XX:MaxPermSize=256m
    resource_id: account_manager
    jwt:
      signing_key: |
        -----BEGIN RSA PRIVATE KEY-----
        MIICXAIBAAKBgQDHFr+KICms+tuT1OXJwhCUmR2dKVy7psa8xzElSyzqx7oJyfJ1
        JZyOzToj9T5SfTIq396agbHJWVfYphNahvZ/7uMXqHxf+ZH9BL1gk9Y6kCnbM5R6
        0gfwjyW1/dQPjOzn9N394zd2FJoFHwdq9Qs0wBugspULZVNRxq7veq/fzwIDAQAB
        AoGBAJ8dRTQFhIllbHx4GLbpTQsWXJ6w4hZvskJKCLM/o8R4n+0W45pQ1xEiYKdA
        Z/DRcnjltylRImBD8XuLL8iYOQSZXNMb1h3g5/UGbUXLmCgQLOUUlnYt34QOQm+0
        KvUqfMSFBbKMsYBAoQmNdTHBaz3dZa8ON9hh/f5TT8u0OWNRAkEA5opzsIXv+52J
        duc1VGyX3SwlxiE2dStW8wZqGiuLH142n6MKnkLU4ctNLiclw6BZePXFZYIK+AkE
        xQ+k16je5QJBAN0TIKMPWIbbHVr5rkdUqOyezlFFWYOwnMmw/BKa1d3zp54VP/P8
        +5aQ2d4sMoKEOfdWH7UqMe3FszfYFvSu5KMCQFMYeFaaEEP7Jn8rGzfQ5HQd44ek
        lQJqmq6CE2BXbY/i34FuvPcKU70HEEygY6Y9d8J3o6zQ0K9SYNu+pcXt4lkCQA3h
        jJQQe5uEGJTExqed7jllQ0khFJzLMx0K6tj0NeeIzAaGCQz13oo2sCdeGRHO4aDh
        HH6Qlq/6UOV5wP8+GAcCQFgRCcB+hrje8hfEEefHcFpyKH+5g1Eu1k0mLrxK2zd+
        4SlotYRHgPCEubokb2S1zfZDWIXW3HmggnGgM949TlY=
        -----END RSA PRIVATE KEY-----
      verification_key: |
        -----BEGIN PUBLIC KEY-----
        MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDHFr+KICms+tuT1OXJwhCUmR2d
        KVy7psa8xzElSyzqx7oJyfJ1JZyOzToj9T5SfTIq396agbHJWVfYphNahvZ/7uMX
        qHxf+ZH9BL1gk9Y6kCnbM5R60gfwjyW1/dQPjOzn9N394zd2FJoFHwdq9Qs0wBug
        spULZVNRxq7veq/fzwIDAQAB
        -----END PUBLIC KEY-----
    cc:
      client_secret: eaa139af583c
    admin:
      client_secret: eaa139af583c
    batch:
      username: batchuser
      password: eaa139af583c
    client:
      autoapprove:
        - cf
    clients:
      cf:
        override: true
        authorized-grant-types: password,implicit,refresh_token
        authorities: uaa.none
        scope: cloud_controller.read,cloud_controller.write,openid,password.write,cloud_controller.admin,scim.read,scim.write
        access-token-validity: 7200
        refresh-token-validity: 1209600
    scim:
      users:
      - admin|eaa139af583c|scim.write,scim.read,openid,cloud_controller.admin
      - services|eaa139af583c|scim.write,scim.read,openid,cloud_controller.admin</td>
  </tr>
</table>


Remember to save your changes to the file

### Deploy CF on AWS

Everything is now in place to use the deployment manifest you have created and deploy CF from the BOSH server to AWS. Let’s now do this.

Select the deployment file

<table>
  <tr>
    <td>$ bosh deployment ~/bosh-workspace/deployments/cf/cf.yml</td>
  </tr>
</table>


Deploy the BOSH

<table>
  <tr>
    <td>$ bosh deploy </td>
  </tr>
</table>


If you receive the following error, try to run "bosh deploy" again

<table>
  <tr>
    <td>Error 400007: `api/0' is not running after update</td>
  </tr>
</table>


## Step 8 - Example apps deployed on CF

This portion is taken from Dr. Nic’s [Build your own Heroku With Cloud Foundry](https://github.com/cloudfoundry-community/bosh-cloudfoundry/blob/master/tutorials/build-your-own-heroku-with-cloudfoundry.md) example, substitute the 1.2.3.4 with the ip address you obtained in the previous step, the one we had in the examples in this document is **107.20.148.206**

### Initialize Cloud Foundry

$ gem install cf
$ cf target http://api.1.2.3.4.xip.io
$ cf login admin
Password> eaa139af583c

$ cf create-org me
$ cf create-space production
$ cf switch-space production

### Deploy first application

$ mkdir apps
$ cd apps
$ git clone https://github.com/cloudfoundry-community/cf-env.git
$ cd cf-env
$ bundle

$ cf push
Instances> 1

1: 128M
2: 256M
3: 512M
4: 1G
Memory Limit> 1

Creating env... OK

1: env
2: none
Subdomain> env

1: 1.2.3.4.xip.io
2: none
Domain> 1.2.3.4.xip.io

Creating route env.1.2.3.4.xip.io... OK
Binding env.1.2.3.4.xip.io to env... OK

Create services for application?> n

Save configuration?> n
...

Open in a browser: [http://env.1.2.3.4.xip.io](http://env.1.2.3.4.xip.io/)

Success!!

## In Progress:

## Instructions for destroying the Deployments

If you have deployed Cloud Foundry, BOSH and MicroBOSH on AWS you are incurring cost for every hour you are using the servers.  To destroy the servers:

Delete the CF deployment

#### **local$ bosh delete deployment tutorial**

Repoint the target to the MicroBOSH server and destroy the BOSH server, replace the ip address below with the one you created for the BOSH server

#### **local$ bosh target 54.204.16.249**

#### **local$ bosh delete deployment bosh**

Repoint the target to the MicroBOSH server and destroy the BOSH server, replace the ip address below with the one you created for the BOSH server

#### **local$ bosh micro delete**

Now you can deallocate the Elastic IPs that were created for CF, BOSH and MicroBOSH

((insert images of deleting IPs))

