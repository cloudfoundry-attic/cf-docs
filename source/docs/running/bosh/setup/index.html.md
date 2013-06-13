---
title: BOSH Local Setup
---

BOSH CLI is a command line interface used to interact with MicroBOSH and BOSH. Before you can use MicroBOSH or BOSH you need to install BOSH Command Line Interface. The following steps install BOSH CLI. You can install on either a physical or virtual machine.

## Prerequisites ##

* [Install Ruby and RubyGems](/docs/common/install_ruby.html). 
* [Install a Git client](/docs/common/install_git.html) to pull down the BOSH repository from GitHub. 

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

Clone the BOSH and bosh-release repositories in git:

<pre class="terminal">
$ git clone git@github.com:cloudfoundry/bosh.git
$ git clone git@github.com:cloudfoundry/bosh-release.git
</pre>

Get release 11 from a branch of bosh-release (we are using an old commit during transition to new release functionality):

<pre class="terminal">
$ cd bosh-release
$ git checkout 9e0b649da80a563ba64229069299c57f72ab54ad
</pre>

