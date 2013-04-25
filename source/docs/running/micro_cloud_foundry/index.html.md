---
title: Micro Cloud Foundry
---

* [Developing Cloud Foundry with Micro Cloud Foundry](developing_cf.html)

## <a id='intro'></a>Introduction ##

Micro Cloud Foundry is your own portable instance of Cloud Foundry, delivered as a virtual machine image for use with VMWare Workstation, Player or Fusion.

## <a id='installation'></a>Installation ##

A prerequisite to running Micro Cloud Foundry is either VMWare Workstation, VMWare Player or VMWare Fusion, make sure you have one of these installed. Log in to [https://micro.cloudfoundry.com/](https://micro.cloudfoundry.com/) with your Cloud Foundry credentials, after clicking the "Get Micro Cloud Foundry" button. If you don't have an account yet, sign up [here](https://my.cloudfoundry.com/signup).

Generate a domain token and then download the latest version of MCF. The download should be a zip file, decompress the archive to your prefered location and then open the .vmx file in your chosen virtual machine client. Start the virtual machine, once you have agreed to the terms of service select option one to configure.

The first thing to configure is the 'vcap' user password, this is the account used to run all the services on the VM. Next, select the network configuration type; DHCP or static. In most cases, DHCP is most appropriate, although you may wish to configure a static IP address in the absence of a DHCP service on your network. If an http proxy is also in use on the network, configure it at this point also.

At this point, MCF will ask for a domain configuration token. You can generate these at the [MCF DNS configuration](https://micro.cloudfoundry.com/dns) page, once you have one for your desired domain name, enter it at the prompt. MCF should then proceed through the configuration stage, this can take up to five minutes.

## <a id='using-mcf'></a>Using Micro Cloud Foundry ##

Once this is installed the VM should display the main menu for MCF, note the "Current Configuration" section at the top. With CF installed, target the MCF installation using the address displayed in the VM console;

<pre class="terminal">
$ cf target http://api.<mcf domain name>.cloudfoundry.me
Setting target to http://api.<mcf domain name>.cloudfoundry.me... OK
</pre>

Now register the admin account, the email address assigned as the admin account should also be displayed in the "Current Configuration" section;

<pre class="terminal">
$ cf register <admin email>

Password> ********

Confirm Password> ********

Your password strength is: good
Creating user... OK

</pre>

Creating this user first ensures an account with administrative priveleges on this instance of Micro Cloud Foundry. That account can proxy as other users and also manage users too.

## <a id='mcf-default-config'></a>Micro Cloud Foundry Default Configuration ##

This section describes the default configuration of the latest Micro Cloud Foundry.

### <a id='vm-config'></a>Virtual Machine Configuration ###

<table>
  <tr><th>RAM</th><th>Disk</th><th>vCPUs</th></tr>
  <tr><td>2Gb</td><td>16Gb</td><td>2</td></tr>
</table>

### <a id='service-limits'></a>Service Limits ###

<table>
  <tr><th>MySQL</th><th>Postgres</th><th>Mongo</th><th>Redis</th></tr>
  <tr><td>2Gb storage, 256Mb max per instance</td>
    <td>2Gb storage, 256Mb max per instance</td>
    <td>256Mb max per instance</td><td>256Mb max per instance</td></tr>
</table>

### <a id='runtime-versions'></a>Runtime Versions ###

<table>
  <tr><th>Runtime</th><th>Version</th></tr>
  <tr><td>java</td><td>1.6.0_24</td></tr>
  <tr><td>java7</td><td>1.7.0_04</td></tr>
  <tr><td>node</td><td>0.4.12</td></tr>
  <tr><td>node06</td><td>0.6.8</td></tr>
  <tr><td>node08</td><td>0.8.2</td></tr>
  <tr><td>ruby18</td><td>1.8.7p357</td></tr>
  <tr><td>ruby19</td><td>1.9.2p180</td></tr>
</table>


### <a id='frameworks'></a>Frameworks ###

<table>
  <tr><th>Framework</th></tr>
  <tr><td>grails</td></tr>
  <tr><td>java_web</td></tr>
  <tr><td>lift</td></tr>
  <tr><td>node</td></tr>
  <tr><td>play</td></tr>
  <tr><td>rack</td></tr>
  <tr><td>rails3</td></tr>
  <tr><td>sinatra</td></tr>
  <tr><td>spring</td></tr>
  <tr><td>standalone</td></tr>
</table>


### <a id='service-versions'></a>Service Versions ###

<table>
  <tr><th>Service</th><th>Version</th></tr>
  <tr><td>mongodb</td><td>2.0</td></tr>
  <tr><td>mysql</td><td>5.1</td></tr>
  <tr><td>postgresql</td><td>9.0</td></tr>
  <tr><td>rabbitmq</td><td>2.4</td></tr>
  <tr><td>redis</td><td>2.2</td></tr>
</table>

## <a id='using-mcf-console'></a>Using the Micro Cloud Foundry Console ##

When you power on the Micro Cloud Foundry virtual machine, Linux boots and the
console text menu displays. The console menu is the primary administrative
interface for the micro cloud.

The console displays status information at the top, including the Micro Cloud
Foundry version, the host name (Identity), Cloud Foundry account email address (Admin),
and the IP address assigned to the virtual machine.

Choose options from the menu by entering the number and pressing <Enter>. The
console prompts for any information required to perform the task.

1. **refresh console**. Choose this option to redraw the console display, for
example when messages cause the menu to scroll off the display.

2. **refresh DNS**. Update the Micro Cloud Foundry IP address in the DNS
records.

3. **reconfigure vcap password**. Choose this option to change the password for the `root` and `vcap` users.

4. **reconfigure domain**. Choose this option when you create a new domain or
generate a new token for your Micro Cloud Foundry domain. Log in to the [Micro
Cloud Foundry website](https://my.cloudfoundry.com/micro) to manage domains and
retrieve a token to enter at the prompt.

5. **reconfigure network**. Use this option to choose between DHCP and static
network configurations. If you choose **static**, the console prompts for an IP
address, gateway, network mask, and DNS servers.

6. **enable offline mode**. Choose this option to toggle the virtual machine between online and offline modes.

7. **reconfigure proxy**. If you are on a network that requires a proxy, choose
this option and enter the address and port of the proxy, for example: `192.168.1.128:4000`.

8. **services**. Displays the status of the services on the micro cloud.

9. **restart network**. Restart network services on the virtual machine.

10. **restore defaults**.

11. **expert menu**. Displays the Expert menu, where you can set the debug level, display logs, and perform other advanced configurations on your Micro Cloud Foundry.

12. **Help**. Displays a URL for online installation and setup documentation and
the default configuration limits for the virtual machine and services.

13. **shutdown VM**. Shut down the Micro Cloud Foundry virtual machine.

## <a id='mcf-resource-limits'></a>Micro Cloud Foundry Resource Limits ##

Micro Cloud Foundry has the following default resource limits:

+ VM: 2 GB RAM, 16 GB disk
+ MySQL: 2 GB disk, max 256 MB per instance
+ MongoDB: 256 MB per instance
+ Redis: 256 MB per instance

The admin user has the following limits:

+ 2 GB memory
+ Up to 16 provisioned services
+ Up to 16 applications

## <a id='increasing-vm-memory'></a>Increasing Micro Cloud Foundry Virtual Machine Memory ##

The Micro Cloud Foundry virtual machine is initially configured with 2GB memory.
If you need more memory for your applications, follow these steps:

1. Shut down the Micro Cloud Foundry virtual machine.

2. In VMware Workstation for VMware Player, right-click the Micro Cloud Foundry virtual machine, and choose Settings.

3. Click Memory and specify the new memory size in the right panel.

4. Click OK.

5. Start the virtual machine.

6. Select the new highlighted item, **reconfigure memory** from the console menu.

The Micro Cloud Foundry reconfigures the virtual machine and services for the new memory size.

## <a id='switching-networks'></a>Switching between Networks ##

If you switch between networks often and do not need to make your Micro Cloud Foundry VM available to other users, it is easier to configure the VM networking to use NAT instead of the bridged mode. Beginning with version 1.2, NAT is the default mode for the Micro Cloud Foundry VM. If you want to share your cloud with others, you will have to enable bridged mode.

## <a id='logging-in-to-mcf'></a>Logging in to Micro Cloud Foundry ##

Micro Cloud Foundry is a virtual machine with an Ubuntu Linux operating system
and the Cloud Foundry software layer and application services. There is no
graphical desktop environment installed, but you can log in to the virtual
machine and get a bash shell using `ssh`.

It is not a good idea to customize the Cloud Foundry services in any way, since
this introduces a dependency that may not be satisfied when you move
applications to another Cloud Foundry instance.

Some reasons you might log in to Micro Cloud Foundry are:

+   View server log files
+   Check process status or loads, for example, using `top`
+   Troubleshoot DNS problems on your local network

You can log in as `root` or `vcap` using the password you set when you initially
start and configure the Micro Cloud Foundry virtual machine.

From a computer with `ssh` installed, log in to Micro Cloud foundry using a
command like the following:

<pre class="terminal">
$ssh vcap@domain.cloudfoundry.me
</pre>

where *domain* is the domain name you registered for the Micro Cloud Foundry.
You can also use the IP address assigned to the virtual machine, which is
displayed on the console. The password for the vcap user is the one that was set during the configuration procedure.

## Configuring Micro Cloud Foundry Networking

Micro Cloud Foundry provides a network environment similar to Cloud Foundry.
URLs are resolved using DNS to locate the host computer running
your application, the Micro Cloud Foundry virtual machine. The application
processes the request, including parsing the remainder of the URL and the HTTP
request and returning a response to the client. The client browser and
application interact with the network in exactly the same way they do in
production, except the cloud is running on the same host.

Development and deployment tools - `cf` and STS - also work with Micro Cloud
Foundry just as they work with CloudFoundry.com or any local or hosted Cloud
Foundry instance.

To provide a production-like network environment, Micro Cloud Foundry associates
the virtual machine's IP address with *domain*.cloudfoundry.me in DNS. This
requires an Internet connection so that Micro Cloud Foundry can update its
address at `cloudfoundry.me` and so that the URL can be resolved when you access
the application with your browser. When the virtual machine is assigned a new IP
address, for example if you move to a different location, it updates the DNS
records.

If your browser uses a proxy and the DNS lookup is not working, you may have to
exclude `.cloudfoundry.me` from the proxy.

The way you configure the network adaptor in the Micro Cloud Foundry virtual
machine determines who can reach your micro cloud:

- If you choose the Bridged network connection option, your micro cloud gets an
address on the LAN from a DHCP server on the LAN. It can be accessed from other
hosts on the LAN.

- If you choose the NAT network connection option, your micro cloud gets an
address on a network that exists only on the host running the virtual machine.
Your cloud can only be accessed from a browser on the host running the virtual
machine.

Unlike the Bridged network option, with the NAT connection option, you do not
get a new address when you change locations. If you are not sharing your micro
cloud with others and you move around frequently, use the NAT option to avoid
the possibility of lagging DNS updates.

## <a id='working-offline'></a>Working Offline With Micro Cloud Foundry ##

When you install Micro Cloud Foundry using a token from the Cloud Foundry website, it uses dynamic DNS functionality to allow any Internet-connected computer that is on the same network with the VM to connect to it. That is, to get the local network address for the VM requires Internet access, even if you are accessing the VM from the same computer on which it is running. This is called online mode and it requires Internet access.

If you have to work without an Internet connection, you must put Micro Cloud Foundry into offline mode and configure your host to route DNS requests to your Micro Cloud Foundry VM. Also, if you initially configure Micro Cloud Foundry with a domain name instead of a configuration token, you must *always* use offline mode.

Offline mode is only supported with the VM network adapter set to NAT. This means it can only be accessed from the host it is running on. To share your Micro Cloud Foundry with others, you must set the network adapter to Bridged mode and run Micro Cloud Foundry in online mode.

If you use Micro Cloud Foundry in offline mode and still have an active Internet connection, you may experience problems accessing sites on the Internet.

### <a id='configuring-for-offline'></a>Configuring Micro Cloud Foundry for Offline Mode ###

You can configure offline mode manually or use the `cf micro-offline /home/mcf/micro.vmx` command. See [Using the CF micro Commands](#using-the-cf-micro-command) for instructions.

The remainder of this section describes how to configure offline mode manually.

There are three tasks to complete to put Cloud Foundry in offline mode.

**Step 1**. In the VM's Virtual Machine Settings, select Network Adapter and make sure that NAT is selected. If you have to change the setting, restart the virtual machine.

**Step 2**. In the Micro Cloud Foundry console menu, select option 6 to toggle to offline mode.

**Step 3**. Configure your host computer to route DNS requests to the Micro Cloud Foundry VM. This is accomplished in differing ways depending on the OS and whether you use DHCP or a static IP address.  In the instructions that follow, replace the IP number 172.16.52.136 with the IP number shown on the Micro Cloud Foundry console. Replace mydomain.micro with your offline domain name.

### <a id='offline-linux'></a>Linux ###

If you are using DHCP, edit the file `/etc/dhcp3/dhclient.conf` and add this line:

```bash
prepend domain-name-servers 172.16.52.136
```

If the VM is configured with a static IP, edit the file `/etc/resolv.conf` and add the following line before the rest of the name servers:

```bash
nameserver 172.16.52.136
```

### <a id='offline-osx'></a>Mac OS X ###

If you are using DHCP, create the directory `/etc/resolver`, and then create a file with your offline domain name, for example `mydomain.micro`. Add the following line to this file:

```bash
nameserver 172.16.52.136
```

If you configured the Micro Cloud Foundry with a static IP, open the Network Preferences and add 172.16.52.136 first in the list of DNS servers.

### <a id='offline-windows'></a>Windows ###

Follow these steps  whether you configured Micro Cloud Foundry with DHCP or a static IP address:

+ Open the Network and Sharing control panel.
+ Choose Change adapter settings.
+ Right-click VMware Virtual Ethernet Adapter for VMnet8, and choose Properties.
+ Set the preferred DNS server to 172.16.52.136.

## <a id='using-the-cf-micro-command'></a>Using the CF Micro Commands ##

The `cf micro-status`, `cf micro-online` and `cf micro-offline` commands automate the steps described in the previous section. Review that section to understand how the command changes your configuration.

Install the cf gem, or upgrade it if needed. See [CF Installation](/docs/using/managing-apps/cf/) for instructions.

```bash
Usage: 

micro-status  VMX [PASSWORD]   Display Micro Cloud Foundry VM status
micro-offline VMX [PASSWORD]   Micro Cloud Foundry offline mode
micro-online  VMX [PASSWORD]   Micro Cloud Foundry online mode

Options:
      --password PASSWORD    Cleartext password for guest VM vcap user
      --vmx VMX              Path to micro.vmx
```

To reconfigure and control the virtual machine, cf needs paths to the .vmx file.

In the following example, the path to the micro.vmx file is specified. `cf` discovers that the VM is not running and offers to start it.

```bash
$ cf micro-status micro.vmx
Please enter your MCF VM password (vcap user) password> *************
MCF VM is not running. Do you want to start it?> yes
Starting MCF VM... OK
Micro Cloud Foundry VM currently in offline mode
VMX Path: /home/mcf/micro.vmx
Domain: mydomain.cloudfoundry.me
IP Address: 192.168.255.134
```

Execute `cf micro-offline` to work offline.

```bash
$ cf micro-offline /home/mcf/micro.vmx
```

This puts the VM in offline mode (the same as selecting option 6 from the menu) and sets the DNS on your host to query the VM. For actions that require administrative or root privilege, you may be prompted to authenticate.


Execute `cf micro-online` to work online.

```bash
$ cf micro-online /home/mcf/micro.vmx
```

This puts the VM in online mode and reverses the DNS configuration change on your host computer. For actions that require administrative or root privilege, you may be prompted to authenticate.


## <a id='troubleshooting'></a>Troubleshooting Micro Cloud Foundry ##

### <a id='gathering-dubug-info'></a>Gathering Debugging Info ###

If you encounter problems and need help debugging, please do the following:

1.  In the Micro Cloud Foundry console menu, enter 11 to display the Expert menu.

2.  Enter 1 to set the debug level to DEBUG.

3.  Retrieve the `/var/vcap/sys/log/micro/micro.log` file from the VM and attach it to the support ticket. To retrieve the file, log into the VM as vcap, using the password set when the VM was configured. For example, using scp and the IP address shown on the console:

```bash
$ scp vcap@92.168.1.215:/var/vcap/sys/log/micro/micro.log .
```

### <a id='proxy-problems'></a>Proxy Problems ###

If you use a proxy, keep in mind that the proxy may not be able to access your Micro Cloud Foundry VM. For example, if you set the VM's network adaptor to use NAT, there is no way for the proxy to find the VM, so you must exclude your domain system's proxy settings.

Another proxy related problem occurs when the VM's network adaptor uses bridged mode and you have a VPN on your host. The Micro Cloud Foundry VM traffic won't enter the tunnel, and thus cannot reach the proxy.

### <a id='access-problems'></a>Problems Accessing Your Instance ###

If the DNS entry for your Micro Cloud Foundry VM is not up-to-date, accessing your instance can fail. For example:

```bash
$ cf target api.martin.cloudfoundry.me
Host is not valid: 'http://api.martin.cloudfoundry.me'
Would you like see the response [yN]? y
HTTP exception: Errno::ETIMEDOUT:Operation timed out - connect(2)
```

Check the Micro Cloud Foundry console. Choose "1" to refresh the screen. If you see a "DNS out of sync" message like the following:

```bash
Current Configuration:
 Identity:   martin.cloudfoundry.me (DNS out of sync)
 Admin:      martin@englund.nu
 IP Address: 10.21.164.29 (network up)
```

choose "2" to force a DNS update.

If the console DNS status is "ok", then the IP address of the VM matches the IP in DNS. Validate that you do not have a cached entry on your local system with the host command:

```bash
$ host api.martin.cloudfoundry.me
api.martin.cloudfoundry.me is an alias for martin.cloudfoundry.me.
martin.cloudfoundry.me has address 10.21.165.53

```

If the two differ, then you need to flush the DNS cache:

**Mac OS X**

```bash
dscacheutil -flushcache
```

**Linux (Ubuntu)**

```bash
sudo /etc/init.d/nscd restart
```

**Windows**

```bash
ipconfig /flushdns
```

### <a id='cannot-connect'></a>"Cannot connect to cloudfoundry.com" Message When Configuring Micro Cloud VM ###

When you configure the Micro Cloud VM to use DHCP it is assigned an address from the network's DHCP pool. If you continuously create/destroy VMs, for example in a testing environment, and your DHCP addresses have a lease life of 12 to 24 hours, it is possible to exhaust the DHCP pool. You will see a message during the configuration process that you cannot connect to cloudfoundry.com, although you are able to reach cloudfoundry.com with a browser. Restarting your DHCP server should return unused leases to the pool so they can be reused before the lease life expires.
