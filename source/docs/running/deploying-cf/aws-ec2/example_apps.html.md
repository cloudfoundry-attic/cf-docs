---
title: Example apps deployed on CF
---

This portion is taken from Dr. Nic’s [Build your own Heroku With Cloud Foundry](https://github.com/cloudfoundry-community/bosh-cloudfoundry/blob/master/tutorials/build-your-own-heroku-with-cloudfoundry.md) example, substitute the 1.2.3.4 with the ip address you obtained in the previous step, the one we had in the examples in this document is **107.20.148.206**

### Initialize Cloud Foundry
<pre class="terminal">
  gem install cf
  cf target http://api.1.2.3.4.xip.io
  cf login admin
  Password> eaa139af583c
</pre>

<pre class="terminal">
 cf create-org me
 cf create-space production
 cf switch-space production
</pre>

### Deploy first application

<pre class="terminal">
  mkdir apps
  cd apps
  git clone https://github.com/cloudfoundry-community/cf-env.git
  cd cf-env
  bundle
</pre>

<pre class="terminal">
cf push
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
</pre>

Open in a browser: [http://env.1.2.3.4.xip.io](http://env.1.2.3.4.xip.io/)

Success!!

## In Progress:

## Instructions for destroying the Deployments

If you have deployed Cloud Foundry, BOSH and MicroBOSH on AWS you are incurring cost for every hour you are using the servers.  To destroy the servers:

Delete the CF deployment

<pre class="terminal">
  bosh delete deployment tutorial
</pre>

Repoint the target to the MicroBOSH server and destroy the BOSH server, replace the ip address below with the one you created for the BOSH server

<pre class="terminal">
  bosh target 54.204.16.249
  bosh delete deployment bosh**
</pre>

Repoint the target to the MicroBOSH server and destroy the BOSH server, replace the ip address below with the one you created for the BOSH server

<pre class="terminal">
 bosh micro delete
</pre>

Now you can deallocate the Elastic IPs that were created for CF, BOSH and MicroBOSH