---
title: Developing Cloud Foundry with Micro Cloud Foundry
---

This document describes an experimental workflow for Cloud Foundry component development by editing code locally and rsync'ing it to a running Micro Cloud Foundry.

## Setup

Download and unzip a test build of MCF with NG components [here](http://download3.vmware.com/cloudfoundry/micro/alpha/micro-demo.zip).

Start the VM in Fusion or Workstation.

Get the URL of the Micro Cloud from the VM console and open it in a browser.

Set the password, private hostname (make up a fake domain) and choose DHCP. Wait about 5 minutes while the jobs are deployed. To watch the status, ssh to the Micro Cloud VM with username root and the password you set and run the following command:

<pre class="terminal">
$ watch -d monit summary
</pre>

### Resolver setup

On OS X, set up a custom resolver for your fake domain:

Create `/etc/resolver/[your_domain]` with these contents:

~~~
    nameserver [your Micro Cloud's IP]
~~~

To test it:

<pre class="terminal">
$ ping something.[your domain]
</pre>

## Targetting with vmc

<pre class="terminal">
$ vmc target ccng.[your domain]

$ vmc login micro@vcap.me
</pre>

The password is "micro".

Create an org and space:

<pre class="terminal">
$ vmc create-org org1

$ vmc logout
$ vmc login micro@vcap.me

$ vmc create-space space1
$ vmc target ccng.[your domain] --ask-space
</pre>

Push a test app using [vmc](../../using/managing-apps/vmc) or another Cloud Foundry [application management tool](../../using/managing-apps).

## Proof of concept development workflow

Set up continuous rsync between your local machine and Micro Cloud (you can install the `brew` command using [OS X homebrew](http://mxcl.github.com/homebrew/)):

<pre class="terminal">
$ ssh-copy-id root@[your domain]

$ brew install watch

$ cd ~/src/dea_ng

$ bundle install

$ watch -n 2 rsync -avz ./ root@[your domain]:/var/vcap/packages/dea_next
</pre>

Change the dea_next code locally, then on the Micro Cloud run:

<pre class="terminal">
$ monit restart dea_next
</pre>

## Logging ##

You can tail the logs on the Micro Cloud Foundry by running:

<pre class="terminal">
ssh root@&lt;your Micro Cloud domain&gt; 'tail -f /var/vcap/sys/log/**/*.log'
</pre>
