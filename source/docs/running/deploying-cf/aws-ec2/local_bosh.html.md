Prepare your local computer for deploying Micro BOSH and is the same regardless of the infrastructure you will deploy to.  You may have some of the steps below already installed if you are a Ruby developer ( and if you are, you know which steps you can skip):

1. Install Ruby

2. Install the Git command line tool

3. Install RubyGems

4. Install Gems for BOSH CLI

### Install Ruby

Ruby 1.9.3 or 2.0.0 must be installed locally on your computer, this can be skipped if you already have Ruby 1.9.3 or 2.0.0 installed.  We recommend doing this with [RVM](https://rvm.io/rvm/install), from a terminal window:

<pre class="terminal">
   curl -L https://get.rvm.io | bash -s stable
   exec $SHELL -l # re-execute your login shell so that the rvm command will be found.
   rvm install 2.0.0
   rvm use 2.0.0
</pre>

There are alternate methodologies mentioned here ([Install Ruby and RubyGems](http://docs.cloudfoundry.com/docs/common/install_ruby.html)) if the above doesn’t work or you want to install Ruby with tools other than RVM.

### Install the Git command line tool

Git will be leveraged for several downloads so the git cli needs to be installed.  Visit [http://git-scm.com/](http://git-scm.com/) for instructions to download and install git on your local system. Then validate that git was installed successfully and is available in your terminal:

<pre class="terminal">
  git --version
  git version 1.8.4.2
</pre>

### Update RubyGems

This installs Ruby’s package management framework, additional details are located [here](http://rubygems.org/pages/download).

<pre class="terminal">
  gem update --system**
</pre>

### Create a new gemset and update package management

<pre class="terminal">
  rvm use 2.0.0@bosh --create
</pre>

For Ubuntu

<pre class="terminal">
  sudo apt-get update
</pre>

For Fedora

<pre class="terminal">
  sudo yum update
</pre>

### Install Gems for BOSH CLI

Run the following command to Install the gems required to run bosh from the command line:

<pre class="terminal">
  gem install bosh_cli_plugin_micro --pre
</pre>

Note: if the step above errors out referencing sqlite, execute "apt-get install sqlite-devel" then try the previous step again.
