---
title: Configure AWS for Micro Bosh
---

We will assume that you already have an AWS account and the approval of someone to spend money.

 There is some additional prep work that will need to be performed:

1. Obtain AWS credentials

2. Create Elastic IPs

3. Create a key pair

4. Create a security group

5. Add ports to the security group

Note: all of the examples below are assuming you will be using US-EAST-1 as your AWS Region.  If you will be leveraging a different AWS region make sure you created Elastic IP’s in the same region as your EC2 instances, IP addresses for one region can’t be given to an instance in another region

### Obtain AWS credentials

If you already know your AWS credentials (access_key_id and secret_access_key, which are not the same as your AWS login and password) you can skip this step.

Start by logging into AWS: [https://console.aws.amazon.com](https://console.aws.amazon.com)

Click on "Instances" in the left pane, make sure to select N. Virginia as your region![image alt text](/images/aws-ec2/image_0.png)

Select the dropdown next to your login name and select "Security Credentials"

![image alt text](/images/aws-ec2/image_1.png)

Then select "Create New Access Key".  If there are already keys created you may want to stop and consult someone in your organization to obtain the access_key_id and secret_access_key as there is a limit of 2 sets of Access Keys which can exist.

![image alt text](/images/aws-ec2/image_2.png)

You will be prompted to download the security file as a csv.  DO THIS!  You cannot retrieve the aws secret key once the screen is closed. You will have to repeat this step create a new key if you lose this one.

![image alt text](/images/aws-ec2/image_3.png)

Document the access_key_id and secret_access_key somewhere privately and securely within your organization and keep these safe, these are the only two pieces of information needed to consume AWS resources by fraudsters.

### Create Elastic IPs

The Micro Bosh server will need a public IP address, AWS calls these Elastic IPs.

Making sure that "N. Virginia" is selected as the AWS Region, click “Elastic IPs” then “Allocate New Address”

![image alt text](/images/aws-ec2/image_4.png)

Then confirm by clicking "Yes, Allocate", leave “EC2” in the dropdown.

![image alt text](/images/aws-ec2/image_5.png)

Take note of the newly created IP address, you’ll be using it later.  Your address will be different than what is listed here.

![image alt text](/images/aws-ec2/image_6.png)

### Create a key pair

In order to ssh in to your instances you'll need to create a key pair. If you already have a Key Pair created you can skip creating a new key pair. You will still need to place a copy of the pem file as shown following.

Making sure that "N. Virginia" is selected as the AWS Region, click “Key Pairs” then “Create Key Pair”

![image alt text](/images/aws-ec2/image_7.png)

Name your key pair name "bosh" and click “Yes”

![image alt text](/images/aws-ec2/image_8.png)

After you click "Yes" a file will be downloaded to your computer and likely named “bosh.pem.txt”

Rename this file to "bosh" and save it into your ~/.ssh folder on your computer. For example, on OSX you can do this from the terminal:

<pre class="terminal">
  mv ~/Downloads/bosh.pem.txt ~/.ssh/bosh
</pre>

If you receive an error that ~/.ssh doesn’t exist, you can create this folder by executing:

<pre class="terminal">
  mkdir -p ~/.ssh
</pre>

### Create a security group

We will be creating a security group for the Micro BOSH server, this is needed to expose ports that the BOSH Agent will use.

Making sure that "N. Virginia" is selected as the AWS Region, click “Security Groups” then “Create Security Group”

![image alt text](/images/aws-ec2/image_9.png)

On the popup screen assign "bosh" to the Name, “BOSH Security Group” to the Description, and leave “No VPC” in the dropdown.  Click “Yes, Create”

![image alt text](/images/aws-ec2/image_10.png)

### Add ports to the security group

Micro BOSH needs ports 25555 (BOSH Director), 6868 (BOSH Agent) and 22 (ssh to debug) opened for inbound for the security group "bosh" that we just created.  A note here: some or all of these ports may be blocked on your corporate firewall, any easy way around this is to attempt this from your personal home network.

Starting with the BOSH Director which needs port 25555, select the newly created Security Group, click "Inbound".  In the Port range box enter “25555” and click “Add Rule”

![image alt text](/images/aws-ec2/image_11.png)

Now add the second port, 6868, by entering this port number into the Port range box and clicking "Add Rule"

![image alt text](/images/aws-ec2/image_12.png)

Now add the last port, 22, by entering this port number into the Port range box and clicking "Add Rule".  Since this is the last port you are adding, click “Apply Rule Changes” to save the changes to this Security Group.

![image alt text](/images/aws-ec2/image_13.png)

###Go on to [Deployment of Micro BOSH on AWS](/docs/running/deploying-cf/aws-ec2/deploy_aws_micro_bosh.html) or [Return to Index](/docs/running/deploying-cf/aws-ec2/index.html)