---
title: Developing Cloud Foundry with Micro Cloud Foundry
---

This document describes an experimental workflow for Cloud Foundry component
development by editing code locally and rsyncing it to a running Micro Cloud
Foundry.

# Setup

Download and unzip a test build of MCF with ng components:

http://download3.vmware.com/cloudfoundry/micro/alpha/micro-demo.zip

Start the VM in Fusion or Workstation.

Get the URL of the Micro Cloud from the VM console and open it in a browser.

Set the password, private hostname (make up a fake domain) and choose
DHCP. Wait about 5 minutes while the jobs are deployed. To watch the status,
ssh to the micro cloud with username root and the password you set and run:

    watch -d monit summary

## Resolver setup

On OSX, set up a custom resolver for your fake domain:

Create /etc/resolver/your_domain with these contents:

    nameserver <your Micro Cloud's IP>

To test it:

    ping something.<your domain>

# Targetting with vmc

    vmc target ccng.<your domain>

    vmc login micro@vcap.me

The password is "micro".

Create an org and space:

    vmc create-org org1

    vmc logout
    vmc login micro@vcap.me

    vmc create-space space1
    vmc target ccng.<your domain> --ask-space

vmc push a test app.

Proof of concept development workflow:

Set up continuous rsync between your local machine and Micro Cloud:

    ssh-copy-id root@<your domain>

    brew install watch

    cd ~/src/dea_ng

    watch -n 2 rsync -avz lib/ root@<your domain>:/var/vcap/packages/dea_next/lib

Change the dea_next code locally, then on the Micro Cloud run:

    monit restart dea_next
