---
title: Installing Ruby
---

Ruby can easily be installed on a variety of operating systems. See the [Ruby website](http://www.ruby-lang.org/en/downloads/) for more details, or the operating system-specific sections below for additional suggestions.

The RubyGems package management framework runs on any operating systems supported by Ruby. See the [RubyGems website](http://rubygems.org/) for more details.

**Note:**  See [Installing cf](../../docs/using/managing-apps/cf/index.html#installing) for information about what versions of Ruby the cf command line interface supports.

## <a id="linux"></a>Ruby on Linux ##

There are two good Ruby environment managers available for Unix-like systems --- rvm and rbenv. These environment managers make it easier to manage your Ruby environment and to keep up to date with the latest Ruby releases. These environment managers include RubyGems.

* [rvm installation instructions](https://rvm.io/rvm/install/)
* [rbenv installation instructions](https://github.com/sstephenson/rbenv/#installation)

Ruby can also be installed using the package manager available for each Linux distribution - `apt` on Ubuntu and Debian, `yum` on RedHat/Fedora and Centos, or `yast` on SuSE Linux. When installing via a package manager, install the "ruby" and "rubygems" packages. 

[chruby](https://github.com/postmodern/chruby) is a lightweight alternative to the environment managers listed above --- it simply eases the process of switching among multiple Ruby environments.

## <a id="osx"></a>Ruby on Mac OS X ##

OS X version 10.5 and higher ship with Ruby installed, but it may not be the latest version of Ruby. Use of a Ruby environment manager is recommended, as these make it easier to manage your Ruby environment and to keep up to date with the latest Ruby releases. The rvm and rbenv environment managers  described in [Ruby on Linux](#linux) above run on OS X.  

You can use [Homebrew](http://mxcl.github.com/homebrew/) package manager to install rvm or rbenv, or to directly install supported versions of Ruby and RubyGems.

## <a id="windows"></a>Ruby on Windows ##

The RubyInstaller project can be used to easily install Ruby on Windows.

* [RubyInstaller](http://rubyinstaller.org/)

There is also a Ruby environment manager available for Windows, named pik.

* [pik installation instructions](https://github.com/vertiginous/pik#install)

