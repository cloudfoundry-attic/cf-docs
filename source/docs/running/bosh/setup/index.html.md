---
title: BOSH CLI Local Setup
---

BOSH CLI is a command line interface used to interact with MicroBOSH and BOSH. Before you can use MicroBOSH or BOSH you need to install BOSH Command Line Interface. The following steps install BOSH CLI. You can install on either a physical or virtual machine.

## Prerequisites ##

* [Install Ruby and RubyGems](/docs/common/install_ruby.html). Requires Ruby 1.9.3 or Ruby 2.0.0.
* [Install a Git client](/docs/common/install_git.html) to pull down BOSH repositories from GitHub. 

## Install Local BOSH ##

Install the BOSH CLI gem:

<pre class="terminal">
$ gem install bosh_cli "~> 1.5.0.pre" --source https://s3.amazonaws.com/bosh-jenkins-gems/
</pre>

If you are using the rbenv Ruby environment manager, refresh the list of gems that rbenv knows about: 

<pre class="terminal">
$ rbenv rehash
</pre>
