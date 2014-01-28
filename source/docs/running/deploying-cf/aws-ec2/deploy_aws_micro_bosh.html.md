---
title: Deploy Micro Bosh on AWS
---

We will leverage the Elastic IP, Security Group and Key Pair file that we created in Configuring AWS for Micro BOSH](/docs/running/deploying-cf/aws-ec2/configure_aws_micro_bosh.html) to deploy a Micro BOSH server on AWS in four steps:

1. Create Directory Structure

2. Create Micro BOSH Deployment Manifest

3. Find the correct Micro BOSH Stemcell

4. Deploy Manifest

Much of this is borrowed from [here](http://blog.cloudfoundry.com/2012/09/06/deploying-to-aws-using-cloud-foundry-bosh/)

### Create Directory Structure

Create a standard place to store the Deployment Manifest on your local computer:

<pre class="terminal">
mkdir -p ~/bosh-workspace/deployments/microboshes/deployments/microbosh

cd ~/bosh-workspace/deployments/microboshes/deployments/microbosh

touch microbosh.yml
</pre>

**Create Micro BOSH Deployment Manifest**

Now let’s review what the contents of the microbosh.yml deployment manifest file should include. If you did not use the us-east-1a availability zone you will need to adajust that and we are using a small instance type for the micro bosh.  Be sure to replace "x.x.x.x" with the ip address you created in [Configuring AWS for Micro BOSH (Micro Inception)](/docs/running/deploying-cf/aws-ec2/configure_aws_micro_bosh.html) and make sture to replace the aws access credentials with your own.

~~~yaml
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
~~~


Note, Since this is a yml (YAML) file, spacing is extremely important, you’ll receive a syntax error when you get to the "Deploy Manifest" in two more sections.

If you are using the sample manifest provided, here are the things to check:

1. Make sure to update all of the instances of x.x.x.x IP with the appropriate elastic IP created.

2. Add the AWS credentials under the aws section.

3. Verify the aws region added in the manifest.

Save your changes to the file.

**Find the correct Micro BOSH Stemcell**

It is important to deploy the correct AWS image that is compatible with the version of Micro BOSH you will be installing and these will be updated over time.

To obtain the current ami, navigate to [http://bosh_artifacts.cfapps.io](http://bosh_artifacts.cfapps.io) and download the "light-bosh (aws xen ubuntu)" tarball file (.tar.gz).

![image alt text](/source/images/aws-ec2/image_14.png)

This will download the tar file to you local computer.  Extract this file and open the file within named "stemcell.MF" in your text editor.

![image alt text](/source/images/aws-ec2/image_15.png)

This file contains the image name (AMI ID) for this version of the bosh-cli. You will need this AMI ID for the next section.

![image alt text](/source/images/aws-ec2/image_16.png)

### Deploy Manifest

Everything is now in place to use the deployment manifest you have created and deploy Micro BOSH to AWS (the first inception). Let’s now do this.

Enter the deployments folder you created earlier:

<pre class="terminal">
cd ~/bosh-workspace/deployments/microboshes/deployments
</pre>

Select the deployment you called "aws" by telling bosh whish manifect file to use.

<pre class="terminal">
  bosh micro deployment microbosh/microbosh.yml
</pre>

Ignore the error that isn’t an error, it is just letting you know that the director was mapped to port 25555

  ``WARNING! Your target has been changed to `[http://aws:25555](http://aws:25555)``!

Deploy the Micro BOSH AMI using the ami we retrieved from the stem cell config.

<pre class="terminal">
bosh micro deploy ami-979dc6fe
</pre>

If the deployment failed clean it up before trying again. If you get errors regarding your access key signature double check your keys in microbosh.yml and try again. Many of the errors encountered at this stage will likely be related to having missed a step in configurig AWS or an error in microbosh.yml

<pre class="terminal">
bosh micro delete
</pre>

Log into the new Micro BOSH server

<pre class="terminal">
bosh target 54.204.16.249
bosh login
</pre>

The default username and password are "admin" and “admin”.

If the deployment ran successfully you will have a Micro BOSH VM deployed onto AWS.

![image alt text](/source/images/aws-ec2/image_17.png)

A few things to note in the screenshot above:

1. **microbosh** - the name of the instance will match the deployment name

2. **us-east-1a** - this is the availability zone that was in the deployment manifest

3. **bosh** - this was the name of the Key Pair

4. **bosh** - this was the name of the Security Group

5. **54.204.16.249**- this was the Elastic IP address that we created and is the external IP address for the Micro BOSH server
