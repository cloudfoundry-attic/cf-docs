---
title: Local Setup
---

BOSH CLI is a command line interface used to interact with MicroBOSH and BOSH. Before you can use MicroBOSH or BOSH you need to install BOSH Command Line Interface. The following steps install BOSH CLI. You can install on either a physical or Virtual Machine.

## Prerequistes ##

* Ruby and RubyGems must be installed before installing BOSH CLI. Refer to the [Installing Ruby](/docs/common/install_ruby.html) page for help with Ruby installation. 
* A Git client must be installed in order to pull down the BOSH repository from GitHub. Refer to the [Installing Git](/docs/common/install_git.html) page for help with Git installation. 

## Install Local BOSH ##

Install the BOSH CLI gem:

<pre class="terminal">
$ gem install bosh_cli
</pre>

If you are using the rbenv Ruby environment manager, refresh the list of gems that rbenv knows about: 

<pre class="terminal">
$ rbenv rehash
</pre>

## Install BOSH Releases ##

Clone the BOSH and bosh-release repositories using git:

<pre class="terminal">
$ git clone git@github.com:cloudfoundry/bosh.git
$ git clone git@github.com:cloudfoundry/bosh-release.git
</pre>

Get release 11 from a branch of bosh-release (we are using an old commit during transition to new release functionality):

<pre class="terminal">
$ cd bosh-release
$ git checkout 9e0b649da80a563ba64229069299c57f72ab54ad
</pre>

