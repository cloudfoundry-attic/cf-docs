---
title: BOSH CLI Local Setup
---

[BOSH CLI](/docs/running/bosh/reference/bosh-cli.html) is a command line interface used to interact with MicroBOSH and BOSH. Before you can use MicroBOSH or BOSH you need to install BOSH Command Line Interface. The following steps install BOSH CLI. You can install on either a physical or virtual machine.

## Prerequisites ##

* [Install Ruby and RubyGems](/docs/common/install_ruby.html). Requires Ruby 1.9.3 or Ruby 2.0.0.
* [Install a Git client](/docs/common/install_git.html) to pull down BOSH repositories from GitHub.

## Install Local BOSH ##

Install the BOSH CLI gem:

<pre class="terminal">
$ gem install bosh_cli_plugin_micro --pre
</pre>

If you are using the rbenv Ruby environment manager, refresh the list of gems that rbenv knows about:

<pre class="terminal">
$ rbenv rehash
</pre>

## Next Step: Install Micro BOSH
[Micro BOSH](/docs/running/bosh/components/micro-bosh.html) is a single VM that includes all of the BOSH components. You will use Micro BOSH to deploy BOSH. Installation steps for Micro BOSH are specific to the IaaS layer you are using. Go back to the [Deploying Cloud Foundry page](/docs/running/deploying-cf/) and select the page with your specific IaaS to continue.
