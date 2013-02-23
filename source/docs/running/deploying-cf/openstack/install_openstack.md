---
title: Install OpenStack
---

### OpenStack Code Names

Each OpenStack service has a code name. Code Names used in this document are: 

| Service name            | Code name                       |
| ----------------------- | ------------------------------- |
| Identity                | Keystone                        |
| Compute                 | Nova                            |
| Image                   | Glance                          |
| Dashboard               | Horizon                         |
| Object Storage          | Swift                           |
| Networking              | Quantum                         |

## Version

     OpenStack Essex(2012.1) Ubuntu 12.04

## Prerequisites

### Hardware Requirements
   
* A Box with virtualization enabled
* 64 GB RAM (32 GB is sufficient for deploying Micro BOSH and Wordpress)
* 12 processing cores
* 2 hard drives
* 2 ethernet cards.

### Multi Node Installation (types of nodes required)
 
* 1 Controller 
* x Compute Nodes 
* No special Storage service (Swift) needed
* Nova Volume and Glance will be used for storage 

### Networking Topology

* Flat DHCP (Nova Network service running on Controller Node)

## Prepare System

### Update and upgrade the system

<pre class="terminal">
$ sudo s
$ apt-get update
$ apt-get upgrade
</pre>

Install the `vim` text editor.

<pre class="terminal">
$ apt-get install vim
</pre>

Download the script [here](openstack_scripts/openstack_base_1.sh) and run it: 

<pre class="terminal">
$ ./openstack_base_1.sh
</pre>

This script will install the following programs: 

* `ntp` - keeps all the services in sync across multiple machines
* `tgt` - features an iscsi target, needed for the Nova volume service
* `openiscsi-client` - required to run the Nova compute service

### Update networking configuration

As stated earlier we need 2 network interfaces. The `eth0` interface is the machine's link to the outside world, and `eth1` is the interface used for the virtual machines. We'll also make Nova bridge clients via `eth0` into the internet.

Edit the file `/etc/network/interfaces`:

<pre class="terminal">
$ vim /etc/network/interfaces
</pre>

Change the contents of the file to match this example configuration: 

~~~
   auto lo
   iface lo inet loopback

   auto eth0
   iface eth0 inet static
   address 10.0.0.2
   netmask 255.0.0.0
   gateway 10.0.0.1

   auto eth1
   iface eth1 inet static
   address 192.168.22.1
   netmask 255.255.255.0
~~~

*Note:* Make sure that you have given the actual machine IP under `eth0` as `address`. In this example `10.0.0.2` is the machine IP, which is the OpenStack Controller.

Points to remember:

* Controller Node IP - `10.0.0.2` (we will be using this IP while installing Keystone and Nova)
* `eth1` IP series - `192.168.22.1`

Restart the networking interface:

<pre class="terminal">
$ /etc/network/interfaces restart
</pre>

Download the script [here](openstack_scripts/openstack_base_2.sh) and run it: 

<pre class="terminal">
$ ./openstack_base_2.sh
</pre>

This script will install the following programs: 

* `bridge-utils` - bridges the network interfaces
* `rabbitmq-server`, `memcached`, `python-memcached` - RabbitMQ components required for OpenStack components to communicate each other
* `kvm`, `libvirt-bin` - used by OpenStack to control virtual machines

You can now check the support for the virtualization using the below command, shown with the expected output:

<pre class="terminal">
$ kvm-ok.
INFO: /dev/kvm exists
KVM acceleration can be used
</pre>

## Install MySQL

Nova and Glance will use MySQL to store their runtime data.
 
Download the script [here](openstack_scripts/openstack_mysql.sh) and run it: 

<pre class="terminal">
$ ./openstack_mysql.sh
Enter a password to be used for the OpenStack services to talk to MySQL (users nova, glance, keystone): vmware
</pre>

This script installs MySQL and creates the OpenStack databases and users. The script will prompt for a password, which will be the password of users and databases MySQL. In this example, the password is `vmware`.

During the installation process you will be prompted again for a root password for MySQL. At the end of the MySQL installation you will be prompted for this root password one more time. Enter the same password at each of these three prompts.

After MySQL is running, you should be able to login with any of the OpenStack users and/or the root admin account by doing the following:

<pre class="terminal">
$ mysql -u root -pvmware
$ mysql -u nova -pvmware nova
$ mysql -u keystone -pvmware keystone
$ mysql -u glance -pvmware glance
</pre>

## Install Keystone

The Keystone service manages users and tenants (accounts or projects), and offers a common identity system for all the OpenStack components.

Download the script [here](openstack_scripts/openstack_keystone.sh) and run it:

<pre class="terminal">
$ ./openstack_keystone.sh
Enter a token for the OpenStack services to auth with keystone: admin
Enter the password you used for the MySQL users (nova, glance, keystone): vmware
Enter the email address for service accounts (nova, glance, keystone): user@email.com
</pre>

This script installs Keystone. The script will prompt for a token, the MySQL password provided during the MySQL installation, and your email address. The email address is used to populate the user's information in the database.

Set the environment variables using the following command, shown with the expected output:

<pre class="terminal">
$ . ./stackrc 
$ keystone user-list
               id	                  enabled	       email	        name
    b32b9017fb954eeeacb10bebf14aceb3	True	     demo@mail.com	    demo
    bfcbaa1425ae4cd2b8ff1ddcf95c907a	True	     glance@mail.com	glance
    c1ca1604c38443f2856e3818c4ceb4d4	True	     nova@mail.com	    nova
    dd183fe2daac436682e0550d3c339dde	True	     admin@mail.com	    admin
</pre>

Finally, edit the Keystone catalog template:

<pre class="terminal">
$ vim /etc/keystone/default_catalog.templates
</pre>
   
Change the contents of the file to match this example:

~~~
   # translations for keystone compat
   catalog.RegionOne.identity.publicURL = http://10.0.0.2:$(public_port)s/v3.0
   catalog.RegionOne.identity.adminURL = http://10.0.0.2:$(admin_port)s/v2.0
   catalog.RegionOne.identity.internalURL = http://10.0.0.2:$(public_port)s/v2.0
   catalog.RegionOne.identity.name = Identity Service

   # fake compute service for now to help novaclient tests work
   catalog.RegionOne.compute.publicURL = http://10.0.0.2:$(compute_port)s/v1.1/$(tenant_id)s
   catalog.RegionOne.compute.adminURL = http://10.0.0.2:$(compute_port)s/v1.1/$(tenant_id)s
   catalog.RegionOne.compute.internalURL = http://10.0.0.2:$(compute_port)s/v1.1/$(tenant_id)s
   catalog.RegionOne.compute.name = Compute Service

   catalog.RegionOne.volume.publicURL = http://10.0.0.2:8776/v1/$(tenant_id)s
   catalog.RegionOne.volume.adminURL = http://10.0.0.2:8776/v1/$(tenant_id)s
   catalog.RegionOne.volume.internalURL = http://10.0.0.2:8776/v1/$(tenant_id)s
   catalog.RegionOne.volume.name = Volume Service

   catalog.RegionOne.ec2.publicURL = http://10.0.0.2:8773/services/Cloud
   catalog.RegionOne.ec2.adminURL = http://10.0.0.2:8773/services/Admin
   catalog.RegionOne.ec2.internalURL = http://10.0.0.2:8773/services/Cloud
   catalog.RegionOne.ec2.name = EC2 Service

   catalog.RegionOne.image.publicURL = http://10.0.0.2:9292/v1
   catalog.RegionOne.image.adminURL = http://10.0.0.2:9292/v1
   catalog.RegionOne.image.internalURL = http://10.0.0.2:9292/v1
   catalog.RegionOne.image.name = Image Service
~~~

*Note:* Replace the IP address `10.0.0.2` in this example with the actual IP address of the contoller node. In vim the command `:%s/localhost/10.0.0.2/g` can be used to replace the address.

Restart the Keystone service:

<pre class="terminal">
$ service keystone restart
</pre>

## Install Glance

Glance is Openstack's image manager service.

Set up a logical volume for Nova to use for creating snapshots and volumes. Here you need secondary Hard Disk attached to the server. The `lvm2` (logical Volume Manager) program is used to create volumes:

<pre class="terminal">
$ apt-get install lvm2

$ fdisk /dev/sdb

Device contains neither a valid DOS partition table, nor Sun, SGI or OSF disklabel
Building a new DOS disklabel with disk identifier 0xb39fe7af.
Changes will remain in memory only, until you decide to write them.
After that, of course, the previous content won't be recoverable.

Warning: invalid flag 0x0000 of partition table 4 will be corrected by w(rite)

Command (m for help): n
Partition type:
  p   primary (0 primary, 0 extended, 4 free)
  e   extended
Select (default p): p
Partition number (1-4, default 1): 1
First sector (2048-62914559, default 2048): 
Using default value 2048
Last sector, +sectors or +size{K,M,G} (2048-62914559, default 62914559): 
Using default value 62914559

Command (m for help): w
The partition table has been altered!

Calling ioctl() to re-read partition table.
Syncing disks.
pvcreate -ff /dev/sdb1
 Physical volume "/dev/sdb1" successfully created
vgcreate nova-volumes /dev/sdb1
 Volume group "nova-volumes" successfully created
</pre>

Download the script [here](openstack_scripts/openstack_glance.sh) and run it:

<pre class="terminal">
$ ./openstack_glance.sh
</pre>

The script will download an Ubuntu 12.04 LTS cloud image from StackGeek's S3 bucket. 

Now test Glance:

<pre class="terminal">
$ glance index
</pre>

The output should display the newly added image.

## Install Nova

The OpenStack compute service, codenamed Nova, is the most important OpenStack component. 

Create a script called `nova-restart.sh` containing the content below and place it exactly where `install-nova.sh` resides. The `install-nova.sh` script uses this script to restart Nova services. We will execute this file whenever we need to restart nova.

~~~
#!/bin/bash

# Make sure only root can run our script
if [ "$(id -u)" != "0" ]; then
  echo "You need to be 'root' dude." 1>&2
  exit 1
fi

# stop and start nova
for a in libvirt-bin nova-network nova-compute nova-api nova-objectstore nova-scheduler nova-volume nova-vncproxy; do service "$a" stop; done
for a in libvirt-bin nova-network nova-compute nova-api nova-objectstore nova-scheduler nova-volume nova-vncproxy; do service "$a" start; done
~~~

Download the script [here](openstack_scripts/openstack_nova.sh) and run it. The script prompts for a few items, including your existing network interface's IP address, the fixed network address, and the floating pool addresses:

<pre class="terminal">
$ ./openstack_nova.sh
#######################################################################################
The IP address for eth0 is probably 10.0.1.35. Keep in mind you need an eth1 for this to work.
#######################################################################################
Enter the primary ethernet interface IP: 10.0.1.35
Enter the fixed network (eg. 10.0.2.32/27): 10.0.2.32/27
Enter the fixed starting IP (eg. 10.0.2.33): 10.0.2.33
#######################################################################################
The floating range can be a subset of your current network.  Configure your DHCP server
to block out the range before you choose it here.  An example would be 10.0.1.224-255
#######################################################################################
Enter the floating network (eg. 10.0.1.224/27): 10.0.1.224/27
Enter the floating network size (eg. 32): 32
</pre>

You can now test Nova using these commands:

<pre class="terminal">
$ nova list
$ nova image-list
$ nova-manage version list
2012.1.3-dev (2012.1.3-LOCALBRANCH:LOCALREVISION)
</pre>

## Install Horizon
 
Download the script [here](openstack_scripts/openstack_horizon.sh) and run it:

<pre class="terminal">
$ ./openstack_horizon.sh
</pre>

This script installs the Horizon dashboard.

Restart the Apache web server:

<pre class="terminal">
$ service apache2 restart
</pre>

You can test the Dashboard by entering the URL `http://10.0.0.2` in a browser window, where `10.0.0.2` is the IP address of the controller node where the Dashboard is installed. Use the token and password provided in previous steps to log in: 

~~~
    User ID : admin
    password : vmware
~~~

# Install Additional Compute Nodes

If you want to install additional compute nodes to OpenStack, follow these instructions on a server running 64 bit version of Ubuntu server 12.04.

## Prepare your System

Update and upgrade the system:

<pre class="terminal">
$ sudo su
$ apt-get update
$ apt-get upgrade
</pre>

Install the `vim` text editor.

<pre class="terminal">
$ apt-get install vim
</pre>

## Update network configuration

Install bridge-utils:

<pre class="terminal">
$ apt-get install bridge-utils
</pre>

Edit the file `/etc/network/interfaces`: 

<pre class="terminal">
$ vim /etc/network/interfaces
</pre>

Change the contents of the file to match this example configuration: 

~~~
   auto lo
   iface lo inet loopback

   auto eth0
   iface eth0 inet static
   address 10.0.0.2
   netmask 255.0.0.0
   gateway 10.0.0.1

   auto eth1
   iface eth1 inet static
   address 192.168.22.1
   netmask 255.255.255.0
~~~

*Note:* Make sure that you have given the actual machine IP under `eth0` as `address`. In this example `10.0.0.2` is the machine IP, which is the OpenStack Controller.

Restart the network:

<pre class="terminal">
$ /etc/init.d/networking restart
</pre)

## Install NTP

To keep all the services in sync across multiple machines, install NTP.

<pre class="terminal">
$ apt-get install ntp
</pre>

Edit the file `ntp.conf`:

<pre class="terminal">
$ vim /etc/ntp.conf
</pre>

Add the following line to the file: 

~~~
server 10.0.0.2
~~~

*Note:* Make sure that you have given the actual machine IP of OpenStack controller node.

Restart the NTP service:

<pre class="terminal">
$ service ntp restart
</pre>

## Install Nova

Install the nova-components and dependencies

<pre class="terminal">
$ apt-get install nova-compute
</pre>

Edit the file `/etc/nova/nova.conf`:

<pre class="terminal">
$ vim /etc/nova/nova.conf
</pre>

Copy the contents of the `nova.conf` file from the controller node into this file.

Restart the nova-compute service:

<pre class="terminal">
$ service nova-compute restart
</pre>

Check to make sure the second compute node is detected by Controller node:

<pre class="terminal">
$ nova-manage service list
       Binary                   Host             Zone             Status     State Updated_At
    nova-network             controller          nova             enabled    :-)   2012-04-20 08:58:43
    nova-scheduler           controller          nova             enabled    :-)   2012-04-20 08:58:44
    nova-volume              controller          nova             enabled    :-)   2012-04-20 08:58:44
    nova-compute             controller          nova             enabled    :-)   2012-04-20 08:58:45
    nova-cert                controller          nova             enabled    :-)   2012-04-20 08:58:43
    nova-compute             compute-node        nova             enabled    :-)   2012-04-21 10:22:27
</pre>

*Note:* You can run this command either on controller or compute node.


