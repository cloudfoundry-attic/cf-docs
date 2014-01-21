---
title: Validate your OpenStack Instance
---

This page aims to help you validate your target OpenStack in preparation for installing BOSH and deploying Cloud Foundry.

You will need a running OpenStack environment. Note that only [Folsom](https://wiki.openstack.org/wiki/ReleaseNotes/Folsom) and [Grizzly](https://wiki.openstack.org/wiki/ReleaseNotes/Grizzly) OpenStack releases are supported.

Note that the requirements listed here are considered *necessary* but not *sufficient* for BOSH to be able to use your OpenStack deployment. In other words, if you cannot perform any one of these items correctly, then BOSH will not work; however, satisfying all these requirements does not necessarily mean BOSH *will* work.

See [Troubleshooting Cloud Foundry on OpenStack](./troubleshooting.html) for
additional troubleshooting information.

## <a id="api_access"></a>Can access the OpenStack APIs for your instance of OpenStack? ##

You should verify that you have your OpenStack API credentials and can make API calls. Credentials are a combination of your user name, password, and the  tenant (or project) your cloud is running under. Some providers also require you to set the region.

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

Note: It is recommended that you deploy BOSH and Cloud Foundry in a dedicated tenancy. This way, it is easier to keep track of the servers, volumes, security groups, and networks that you create. It also allows you to manage user access.

There is more information on [OpenStack API docs](http://docs.openstack.org/api/quick-start/content/).

## <a id="metadata_service"></a> Can you access OpenStack metadata service from a virtual machine? ##

According to [the OpenStack Documentation](http://docs.openstack.org/grizzly/openstack-compute/admin/content/metadata-service.html), the Compute service uses a special metadata service to enable virtual machine instances to retrieve instance-specific data. The default stemcell for use with BOSH retrieves this metadata for each instance of a virtual machine that OpenStack manages in order to get some data injected by the BOSH director.

You will need to ensure that virtual machines you boot in your OpenStack environment can access the metadata service at http://169.254.169.254.

From your OpenStack dashboard, create a VM and open the console into it through the "Console" tab on its "Instance Detail" page. Wait for the terminal to appear and login.

Then execute the curl command to access the above URL. You should see a list of dates similar to the example below.

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

If you do not see a list like this, consult the OpenStack documentation, or the documentation for your OpenStack distribution, to diagnose and resolve networking issues.

Alternatively, BOSH uses a fallback mechanism [injecting a file](http://docs.openstack.org/grizzly/openstack-compute/admin/content/instance-data.html#inserting_metadata) into the VM.

If the metadata service is not enabled in your OpenStack instance, you can also try inserting a file when booting a VM:

<pre class="terminal">
$ gem install fog
$ fog openstack
>> s = Compute[:openstack].servers.create(name: 'test', flavor_ref: <flavor id>, image_ref: <image id>, personality: [{'path' => 'user_data.json', 'contents' => 'test' }])
>> s.reload
>> s.status
"ACTIVE"

>> s.destroy
</pre>

## <a id="private_ping"></a> Can you ping one virtual machine from another? ##

Cloud Foundry requires that virtual machines be able to communicate with each other over the OpenStack networking stack. If networking is misconfigured for your instance of OpenStack, BOSH may provision VMs, but the deployment of Cloud Foundry will not function correctly because the VMs cannot properly orchestrate over NATS and other underlying technologies.

Try to following to ensure that you can communicate from VM to VM:

Create a security group for your virtual machines called <em>ping-test</em>.

1.  Open the OpenStack dashboard, and click on <em>Access & Security</em> in the left-hand menu.
2.  Click <em>Create Security Group</em> on the upper-right hand corner on the list of security groups.
3.  Under <em>Name</em>, enter <em>ping-test</em>. The <em>Description</em> field requires text, but this text can be anything.
4.  Click <em>Create Security Group</em>.
5.  The list of security groups should now contain <em>ping-test</em>. Find it in the list and click the <em>Edit Rules</em> button.
6.  The list of rules should be blank. Click <em>Add Rule</em>.
7.  For <em>Protocol</em>, select <em>ICMP</em>.
8.  For <em>Type</em>, enter <em>-1</em>.
9.  For <em>Code</em>, enter <em>-1</em>.
10. For <em>Source</em>, select <em>Security Group</em>.
11. For <em>Security Group</em>, select <em>ping-test (Current)</em>.
12. Click <em>Add</em>.

From your OpenStack dashboard, create two VMs and open the console into one of them through the "Console" tab on its "Instance Detail" page. Make sure that you put these virtual machines into the <em>ping-test</em> security group. Wait for the terminal to appear and login.

Look at the list of instances in the OpenStack dashboard and find the IP address of the other virtual machine. At the prompt, issue the following command (assuming your instance receives the IP address <code>172.16.1.2</code>:

<pre class="terminal">
$ ping 172.16.1.2
PING 172.16.1.2 (172.16.1.2) 56(84) bytes of data.
64 bytes from 172.16.1.2: icmp_seq=1 ttl=64 time=0.095 ms
64 bytes from 172.16.1.2: icmp_seq=2 ttl=64 time=0.048 ms
64 bytes from 172.16.1.2: icmp_seq=3 ttl=64 time=0.080 ms
...

</pre>

Note that you can press Ctrl-C to exit the ping program. If you are not able to ping one virtual machine from another, consider the [OpenStack Networking Guide](http://docs.openstack.org/admin-guide-cloud/content/ch_networking.html) for more information.

## <a id="api_access"></a> Can you invoke large numbers of API calls? ##

Your OpenStack might have API throttling (devstack enables throttling by default) which may mean that BOSH requests to OpenStack fail dramatically, or perhaps fail temporarily (while waiting for the API throttle to expire).

Try the following to see if you may be affected by API throttling:

<pre class="terminal">
$ gem install fog
>> 100.times { p Compute[:openstack].servers }
</pre>

If you are running **devstack**, add the following to your `localrc` and at the end of this page you will recreate your devstack without API throttling:

<pre class="bash">
API_RATE_LIMIT=False
</pre>

## <a id="volumes"></a> Can you create and mount a large volume? ##

The [devstack](http://devstack.org/) OpenStack distributions defaults to a very small total volume size (5G). Alternately, your tenancy/project might have only been granted a small quota for volume sizes. You will also want to check that you can access a volume from a virtual machine to ensure that the OpenStack Cinder service is operating correctly.

To verify the ability to provision large volumes, perform the following steps:

1.  Login to your OpenStack dashboard.
2.  Click <em>Volumes</em> from the menu on the left.
3.  Click <em>Create Volume</em>.
4.  For <em>Volume Name</em>, enter "Test Volume".
5.  Put something in the <em>Description</em> field.
6.  It does not matter what you put in the <em>Type</em> field.
7.  For size, enter <em>30</em>.
8.  You should see the volume appear in the list of volumes with the status <em>Available</em>.

If the volume appears with the status <em>Error</em>, you need to check that your OpenStack Cinder Service is configured correctly. See [Cinder Administrator Guide](http://docs.openstack.org/admin-guide-cloud/content/managing-volumes.html) for more information.

To verify that you can attach and mount a volume to an instance, perform the following steps (<em>assumes you have completed the steps above</em>):

1.  From your OpenStack dashboard, create a VM.
2.  Return to the <em>Volumes</em> page, and find <em>Test Volume</em>. Click <em>Edit Attachments</em> on the right.
3.  In the <em>Attach to Instance</em> find the VM you just created.
4.  In the <em>Device Name</em> field, enter <em>/dev/vdb</em>.
5.  Open the console into this virtual machine through the "Console" tab on its "Instance Detail" page.
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

## <a id="cloud-image"></a> Can you upload and deploy an Ubuntu 10.04 64-bit Server Cloud Image? ##

BOSH uses [Stemcells](/docs/running/bosh/components/stemcell.html) as the basis for virtual machine instances that it deploys to various cloud providers. For the OpenStack cloud provider, the BOSH stemcell is based on Ubuntu 10.04 64-bit Server. If you cannot upload this image to the Glance Image Service in your instance of OpenStack, the BOSH director will also have trouble when it tries to upload the stemcell. Similarly, if you cannot boot a virtual machine from this instance and connect to it via SSH, BOSH will also have trouble doing the same.  Additionally, you will want to check that the underlying hardware that runs your OpenStack is compatible with running a 64-bit operating system.

To check that your OpenStack is compatible with Ubuntu 10.04 64-bit Server, you will need to download the image to your Glance Image Service, then separately boot the image as an instance in OpenStack.

To download the image to your Glance Image Service, perform the following steps:

1.  Login to your OpenStack dashboard.
2.  In the menu on the left-hand side, click <em>Images & Snapshots</em>.
3.  You should see a list of images. Click <em>Create Image</em>.
4.  For <em>Name</em>, enter <em>Ubuntu Server 64-bit</em>.
5.  For <em>Image Location</em>, enter <em>http://cloud-images.ubuntu.com/lucid/current/lucid-server-cloudimg-amd64-disk1.img</em>.
6.  For <em>Format</em>, select <em>QCOW2 - QEMU Emulator</em>.
7.  For <em>Minimum Disk</em>, enter 5GB.
8.  For <em>Minimum Ram</em>, enter 1024MB.
9.  Click <em>Create Image</em>.

After the image has download, launch an instance of it from the dashboard and see that you can connect to it. If the image seems to take a significantly long amount of time to boot, it may be that your metadata service is not configured correctly.

## <a id="internal-external-ips"></a> Can networking be configured for both external and internal IPs? ##

BOSH assumes that virtual machines will be connected to two distinct virtual networks: one that is internal and only accessible to the virtual machines themselves, and one that is external (or "public") that allows access from outside the network. In the user interface, these external IP addresses are called <em>floating</em> IPs because they can be dynamically reassigned to virtual machines on the hypervisor with the push of a button.

To confirm that you can assign floating IP addresses to your virtual machines, perform the following steps:

1.  Find a virtual machine you have already provisioned, or provision one if  you do not have one available. In the menu on the left-hand side, if you click <em>Instances</em>, you should see your virtual machine listed.
2.  Ensure that the virtual machine in #1 has booted completely by checking its console window (the "Console" tab on its "Instance Detail" page).
4.  Find your virtual machine in the list of instances and click the button labeled <em>More</em> for that VM.  A list of operations should appear.
5.  Select <em>Associate Floating IP</em> from the list that comes up.
6.  You should be able to pull the drop down the list of public IP addresses from the menu named <em>IP Address</em>. Sometimes, you may need to allocate an additional floating IP address by clicking the plus (+) to the right of this menu, selecting a pool, and clicking <em>Allocate IP</em>.
7.  You should be able to leave the menu <em>Port to be associated</em> alone, but check that it points at the VM you have selected.
8.  Click <em>Associate</em>.

If the steps above do not work for you, consult the [OpenStack Networking Guide](http://docs.openstack.org/admin-guide-cloud/content/ch_networking.html) for more information.

Simply assigning a floating IP address to a virtual machine does not mean that virtual networking is properly configured. You will also need to ensure that the virtual machine can be reached on its floating IP address, so that calls can be made to and from the VM once it's running the BOSH Director or Cloud Foundry. The public-facing router will forward traffic at all ports to your virtual machine, so it is up to the networking configuration of your security group to provide the added layer of security by implementing a firewall.

Create a security group for your public-facing virtual machine called <em>ping-test</em>.

1.  Open the OpenStack dashboard, and click on <em>Access & Security</em> in the left-hand menu.
2.  Click <em>Create Security Group</em> on the upper-right hand corner on the list of security groups.
3.  Under <em>Name</em>, enter <em>ping-test</em>. The <em>Description</em> field requires text, but the the text can be anything.
4.  Click <em>Create Security Group</em>.
5.  The list of security groups should now contain <em>ping-test</em>. Find it in the list and click the <em>Edit Rules</em> button.
6.  The list of rules should be blank. Click <em>Add Rule</em>.
7.  For <em>Protocol</em>, select <em>ICMP</em>.
8.  For <em>Type</em>, enter <em>-1</em>.
9.  For <em>Code</em>, enter <em>-1</em>.
10. For <em>Source</em>, select <em>CIDR</em>.
11. For <em>CIDR</em>, enter <em>0.0.0.0/0</em>.
12. Click <em>Add</em>.

You now need to add your virtual machine to the security group you just created.

1.  Go back to the <em>Instances</em> view and find your VM.
2.  Click the <em>More</em> button to the right of your VM.
3.  Click the <em>Edit Security Groups</em> button in the drop down menu that appears.
4.  Find <em>ping-test</em> in the list under <em>All Security Groups</em> and click the plus (+) to add it to the virtual machine.

Now that the <em>ping-test</em> group has been added to the VM and configured to allow ping traffic through, and the virtual machine has been associated with a floating IP address, you can ping the VM to check that the traffic is properly routed.

At the prompt, issue the following command (assuming your instance receives the IP address <code>9.9.8.7</code>:

<pre class="terminal">
$ ping 9.9.8.7
PING 9.9.8.7 (9.9.8.7) 56(84) bytes of data.
64 bytes from 9.9.8.7: icmp_seq=1 ttl=64 time=0.095 ms
64 bytes from 9.9.8.7: icmp_seq=2 ttl=64 time=0.048 ms
64 bytes from 9.9.8.7: icmp_seq=3 ttl=64 time=0.080 ms
...

</pre>

## <a id="internet"></a> Can access the Internet from within instances? ##

Your deployment of Cloud Foundry will need outbound access to the Internet. For example, the Ruby buildpack will run `bundle install` on users' applications to fetch RubyGems. You can verify that your OpenStack is configured correctly to allow outbound access to the Internet.

From your OpenStack dashboard, create a VM and open the console into it through the "Console" tab on its "Instance Detail" page. Wait for the terminal to appear and login.

<pre class="terminal">
$ curl google.com
...
&lt;H1>301 Moved&lt;/H1>
The document has moved
...
</pre>

If you do not see the output above, consult the OpenStack documentation (or the documentation for your OpenStack distribution) to diagnose and resolve networking issues.

If you are running **devstack**, check that you have an `eth0` and `eth1` network interface when running `ifconfig`. If you only have `eth1`, try adding the following lines to your `localrc` file before recreating your devstack:

<pre class="bash">
PUBLIC_INTERFACE=eth1
FLAT_INTERFACE=eth0
</pre>
