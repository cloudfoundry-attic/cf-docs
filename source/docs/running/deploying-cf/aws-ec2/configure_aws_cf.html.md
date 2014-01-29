---
title: Step 6 - Configuring AWS for CF
---

### Additional Elastic IPs

Making sure that "N. Virginia" is selected as the AWS Region, click “Elastic IPs” then “Allocate New Address”.

![image alt text](/images/aws-ec2/image_27.png)

Leave "EC2" in the dropdown and confirm by clicking “Yes, Allocate”.

![image alt text](/images/aws-ec2/image_28.png)

Take note of the newly created IP address, you’ll be using it later in the CF Deployment Manifest.  Your address will be different than what is listed here.  Also notice that the two IP addresses we created are currently allocated to the Micro Bosh and BOSH instances.

![image alt text](/images/aws-ec2/image_29.png)

### Create a new Security Group

Making sure that "N. Virginia" is selected as the AWS Region, click “Security Groups” then “Create Security Group”

![image alt text](/images/aws-ec2/image_30.png)

On the popup screen assign "cf" to the Name, “cf Security Group” to the Description, and leave “No VPC” in the dropdown.  Click “Yes, Create”

![image alt text](/images/aws-ec2/image_31.png)

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

![image alt text](/images/aws-ec2/image_32.png)