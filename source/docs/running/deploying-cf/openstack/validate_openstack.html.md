---
title: Validate your OpenStack Instance
---

This page aims to help you validate your target OpenStack in preparation for installing BOSH and deploying Cloud Foundry.

You will need a running OpenStack environment. Note that only [Folsom](https://wiki.openstack.org/wiki/ReleaseNotes/Folsom) and [Grizzly](https://wiki.openstack.org/wiki/ReleaseNotes/Grizzly) OpenStack releases are supported.

## <a id="api_access"></a>Can access the OpenStack APIs for your instance of OpenStack? ##

You can verify that you have your OpenStack API credentials and can make API calls. Credentials are a combination of your user name, password, and which tenant (or project) your cloud is running under. Some providers also require you to set the region.

Create a `~/.fog` file and copy the below content:

<pre class="yaml">
:openstack:
  :openstack_auth_url:  http://HOST_IP:5000/v2.0/tokens
  :openstack_api_key:   PASSWORD
  :openstack_username:  USERNAME
  :openstack_tenant:    PROJECT_NAME
  :openstack_region:    REGION # Optional
</pre>

NOTE: you need to include `/v2.0/tokens` in the auth URL above.

Install the `fog` application in your terminal, and run it in interactive mode:

<pre class="terminal">
$ gem install fog
$ fog openstack
>> Compute[:openstack].servers
[]
</pre>

The `[]` is an empty array in Ruby. You might see a long list of servers being displayed if your OpenStack tenancy/project already contains provisioned servers.

Note: it is recommended that you deploy BOSH and Cloud Foundry in a dedicated tenancy. Its easier to keep track of the servers, volumes, security groups and networks that you create. It also allows you to manage user access.

There is more information on [OpenStack API docs](http://docs.openstack.org/api/quick-start/content/).

## <a id="metadata_service"></a> Can access OpenStack metadata service from within a virtual machine? ##

According to [the OpenStack Documentation](http://docs.openstack.org/grizzly/openstack-compute/admin/content/metadata-service.html), the Compute service uses a special metadata service to enable virtual machine instances to retrieve instance-specific data. The default stemcell for use with BOSH retrieves this metadata for each instance of a virtual machine that OpenStack manages in order to get some data injected by the BOSH director.

You will need to ensure that virtual machines you boot in your OpenStack environment can access the metadata service at http://169.254.169.254.  

From your OpenStack dashboard, create an VM and open the console into it (the "Console" tab on its "Instance Detail" page). Wait for the terminal to appear and login.

Then execute the curl command to access the above URL.  You should see a list of dates similar to the figure below.

<pre class="terminal">
$ curl http://169.254.169.254

1.0
2007-01-19
2007-03-01
2007-08-29
2007-10-10
2007-12-15
2008-02-01
2008-09-01
2009-04-04

</pre>

If you do not see the output above, please consult the OpenStack documentation (or the documentation for your OpenStack distribution) to diagnose and resolve networking issues.

Alternatively, BOSH uses a fallback mechanism [injecting a file](http://docs.openstack.org/grizzly/openstack-compute/admin/content/instance-data.html#inserting_metadata) into the vm.

So if the metadata service is not enabled in your OpenStack instance, you can also try inserting a file when booting a vm:

<pre class="terminal">
$ gem install fog
$ fog openstack
>> s = Compute[:openstack].servers.create(name: 'test', flavor_ref: <flavor id>, image_ref: <image id>, personality: [{'path' => 'user_data.json', 'contents' => 'test' }])
>> s.reload
>> s.status
"ACTIVE"

>> s.destroy
</pre>

## <a id="private_ping"></a> Can ping one virtual machine from another virtual machine? ##

Cloud Foundry requires that virtual machines be able to communicate with one another over the OpenStack networking stack.  If networking is misconfigured for your instance of OpenStack, BOSH may provision VMs but the deployment of Cloud Foundry will not function correctly because the VMs cannot properly orchestrate over NATS and other underlying technologies.

Try to following to ensure that you can communicate from VM to VM:

Create a security group for your virtual machines called <em>ping-test</em>.

1.  Open the OpenStack dashboard, and click on <em>Access & Security</em> in the left-hand menu.
2.  Click <em>Create Security Group</em> on the upper-right hand corner on the list of security groups.
3.  Under <em>Name</em>, enter <em>ping-test</em>.  You must enter something in the <em>Description</em> field, but it does not matter what it is.
4.  Click <em>Create Security Group</em>.
5.  The list of security groups should now contain <em>ping-test</em>.  Find it in the list and click the <em>Edit Rules</em> button.
6.  The list of rules should be blank.  Click <em>Add Rule</em>.
7.  For <em>Protocol</em>, select <em>ICMP</em>.
8.  For <em>Type</em>, enter <em>-1</em>.
9.  For <em>Code</em>, enter <em>-1</em>.
10. For <em>Source</em>, select <em>Security Group</em>.
11. For <em>Security Group</em>, select <em>ping-test (Current)</em>.
12. Click <em>Add</em>.

From your OpenStack dashboard, create <em>two</em> VMs and open the console into one of them (the "Console" tab on its "Instance Detail" page). Make sure that you put these virtual machines into the <em>ping-test</em> security group.  Wait for the terminal to appear and login.

Look at the list of instances in the OpenStack dashboard and find the IP address of the other virtual machine.  At the prompt, issue the following command (assuming your instance receives the IP address <code>172.16.1.2</code>:

<pre class="terminal">
$ ping 172.16.1.2
PING 172.16.1.2 (172.16.1.2) 56(84) bytes of data.
64 bytes from 172.16.1.2: icmp_seq=1 ttl=64 time=0.095 ms
64 bytes from 172.16.1.2: icmp_seq=2 ttl=64 time=0.048 ms
64 bytes from 172.16.1.2: icmp_seq=3 ttl=64 time=0.080 ms
...

</pre>

Note that you can press Ctrl-C to exit the ping program.  If you are not able to ping one virtual machine from another, consider the [a href="http://docs.openstack.org/admin-guide-cloud/content/ch_networking.html"](OpenStack Networking Guide) for more information.

## <a id="api_access"></a> Can invoke large number of API calls? ##

Your OpenStack might have API throttling (devstack enables throttling by default) which may mean that BOSH requests to OpenStack fail dramatically, or perhaps fail temporarily (whilst waiting for the API throttle to expire).

Try the following to see if you may be affected by API throttling:

<pre class="terminal">
$ gem install fog
>> 100.times { p Compute[:openstack].servers }
</pre>

If you are running **devstack**, add the following to your `localrc` and at the end of this page you will recreate your devstack without API throttling:

<pre class="bash">
API_RATE_LIMIT=False
</pre>

## <a id="volumes"></a> Can create and mount a large volume? ##

The [devstack](http://devstack.org/) OpenStack distributions defaults to a very small total volume size (5G). Alternately, your tenancy/project might have only been granted a small quota for volume sizes.  You will also want to check that you can access a volume from a virtual machine to ensure that the OpenStack Cinder service is operating correctly.

To verify the ability to provision large volumes, perform the following steps:

1.  Login to your OpenStack dashboard.
2.  Click <em>Volumes</em> from the menu on the left.
3.  Click <em>Create Volume</em>.
4.  For <em>Volume Name</em>, enter "Test Volume".
5.  Put something in the <em>Description</em> field.
6.  It does not matter what you put in the <em>Type</em> field.
7.  For size, enter <em>30</em>.
8.  You should see the volume appear in the list of volumes with the status <em>Available</em>.

If the volume appears with the status <em>Error</em> then you need to check that your OpenStack Cinder Service is configured correctly.  See [http://docs.openstack.org/admin-guide-cloud/content/managing-volumes.html](Cinder Administrator Guide) for more information. 

To verify that you can attach and mount a volume to an instance, perform the following steps (<em>assumes you have completed the steps above</em>):

1.  From your OpenStack dashboard, create a VM.
2.  Return to the <em>Volumes</em> page, and find <em>Test Volume</em>.  Click <em>Edit Attachments</em> on the right.
3.  In the <em>Attach to Instance</em> find the VM you just created.
4.  In the <em>Device Name</em> field, enter <em>/dev/vdb</em>. 
5.  Open the console into this virtual machine (the "Console" tab on its "Instance Detail" page). 
6.  At the prompt, type
    <pre class="bash">
    $ sudo fdisk -l
    
	Disk /dev/vdb: 32.2 GB, 32212254720 bytes
	16 heads, 63 sectors/track, 62415 cylinders, total 62914560 sectors
	Units = sectors of 1 * 512 = 512 bytes
	Sector size (logical/physical): 512 bytes / 512 bytes
	I/O size (minimum/optimal): 512 bytes / 512 bytes
	Disk identifier: 0x00000000
	
	Disk /dev/vdb doesn't contain a valid partition table
	</pre>

Next, create a master partition on the disk by entering at the prompt:
<pre class="bash">
$ sudo fdisk /dev/vdb
n
p
1
ENTER
ENTER
t
8e
w
</pre>

Next, create a file system on the disk by entering at the prompt.
<pre class="bash">
$ sudo mkfs.ext3 /dev/vdb1
</pre>

Then, mount the disk to a directory on your VM.
<pre class="bash">
sudo mkdir /disk
sudo mount -t ext3 /dev/vdb1 /disk
</pre>

And check that you can write a file to the disk:
<pre  class="bash">
cd /disk
sudo touch pla
</pre>

If you are running **devstack**, add the following to your `localrc` and at the end of this page you will recreate your devstack with a larger volume backing file:

<pre class="bash">
VOLUME_BACKING_FILE_SIZE=70000M
</pre>

## <a id="cloud-image"></a> Can upload and deploy an Ubuntu 12.04 64-bit Server Cloud Image? ##

BOSH uses [Stemcells](/docs/running/bosh/components/stemcell.html) as the basis for virtual machine instances that it deploys to various cloud providers.  For the OpenStack cloud provider, the BOSH stemcell is based on Ubuntu 12.04 64-bit Server.  If you cannot upload this image to the Glance Image Service in your instance of OpenStack, the BOSH director will also have trouble when it tries to upload the stemcell.  Similarly, if you cannot boot a virtual machine from this instance, and connect to it via SSH, BOSH will also have trouble doing the same.  Additionally, you will want to check that the underlying hardware that runs your OpenStack is compatible with running a 64-bit operating system.

To check that your OpenStack is compatible with Ubuntu 10.04 64-bit Server, you will need to download the image to your Glance Image Service, and then separately boot the image as an instance in OpenStack.

To download the image to your Glance Image Service, perform the following steps:

1.  Login to your OpenStack dashboard.
2.  In the menu on the left-hand side, click <em>Images & Snapshots</em>.
3.  You should see a list of images.  Click <em>Create Image</em>.
4.  For <em>Name</em>, enter <em>Ubuntu Server 64-bit</em>.
5.  For <em>Image Location</em>, enter <em>http://cloud-images.ubuntu.com/lucid/current/lucid-server-cloudimg-amd64-disk1.img</em>.
6.  For <em>Format</em>, select <em>QCOW2 - QEMU Emulator</em>.
7.  For <em>Minimum Disk</em>, enter 5GB.
8.  For <em>Minimum Ram</em>, enter 1024MB.
9.  Click <em>Create Image</em>.

Depending on your server's internet connection, the image may take some time to download.

After the image has download, launch an instance of it from the dashboard and see that you can connect to it. If the image seems to take a significantly long amount of time to boot, it may be that your metadata service is not configured correctly.  

## <a id="internet"></a> Can access the Internet from within instances? ##

Your deployment of Cloud Foundry will need outbound access to the Internet (for example, the Ruby buildpack will run `bundle install` on users' applications to fetch RubyGems). You can verify now that your OpenStack is configured correctly to allow outbound access to the Internet.

From your OpenStack dashboard, create an VM and open the console into it (the "Console" tab on its "Instance Detail" page). Wait for the terminal to appear and login.

<pre class="terminal">
$ curl google.com
...
&lt;H1>301 Moved&lt;/H1>
The document has moved
...
</pre>

If you do not see the output above, please consult the OpenStack documentation (or the documentation for your OpenStack distribution) to diagnose and resolve networking issues.

If you are running **devstack**, perhaps check that you have an `eth0` and `eth1` network interface when running `ifconfig`. If you only have `eth1` perhaps try adding the following lines to your `localrc` file before recreating your devstack:

<pre class="bash">
PUBLIC_INTERFACE=eth1
FLAT_INTERFACE=eth0
</pre>
