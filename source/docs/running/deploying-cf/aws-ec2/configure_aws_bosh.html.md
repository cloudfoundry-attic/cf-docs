---
title: Configuring AWS for BOSH
---
The AWS configuration needs to be altered so that the BOSH server(s) can be deployed to AWS EC2:

* Additional ports need to be added to the "bosh" Security Group

* An additional Elastic IP is needed (2 more if you do the multiple BOSH servers deployment)

### Additional Ports

BOSH needs TCP ports ( 53, 4222, 25250 and 25777) and UDP port (53) opened for inbound to the security group "bosh" created previously.  We will also open ports 1 through 65535 so that all servers within that security group can talk to eachother.

Note: during the process below your changes will not be complete until you click "Apply Rule Changes" if you click on another security group during this process you will lose your changes if you haven't applied them.

Starting with the BOSH Director which needs port 4222, select the newly created Security Group, click "Inbound".  In the Port range box enter “4222” and click “Add Rule”.

![image alt text](/images/aws-ec2/image_18.png)

Now add the second port, 53, by entering this port number into the Port range box and clicking "Add Rule".

![image alt text](/images/aws-ec2/image_19.png)

Repeat this for the remaining ports 25250.

Now open TCP ports 1-65535 to all servers within the Security Group by entering this port number 1-65535 into the Port range box, entering the Group ID associated to this "bosh" Security Group (yes, this at first sounds circular, it will eventually make sense) and clicking “Add Rule”.  ![image alt text](/images/aws-ec2/image_20.png)

Now open UDP port 53 (you’ve already opened it for TCP).  In the Create a new rule: dropdown select Custom UPD rule, enter 53 into the Port range and click "Add Rule." Since this is the last port you are adding, click “Apply Rule Changes” to save the changes to this Security Group.

![image alt text](/images/aws-ec2/image_21.png)

### Additional Elastic IPs

Making sure that "N. Virginia" is selected as the AWS Region, click “Elastic IPs” then “Allocate New Address”.

![image alt text](/images/aws-ec2/image_22.png)

Leave "EC2" in the dropdown and confirm by clicking “Yes, Allocate”.

![image alt text](/images/aws-ec2/image_23.png)

Take note of the newly created IP address, you’ll be using it later.  Your address will be different than what is listed here.  Also notice that the first IP address we created is currently allocated to the Micro Bosh instance. ![image alt text](/images/aws-ec2/image_24.png)
