---
title: Stacks
description: Prebuilt file systems, including an operating system, that support running applications with certain characteristics.
---

A stack is a prebuilt file system, including an operating system, that
supports running applications with certain characteristics. Any DEA can
support exactly one stack. To stage or run a Linux app using MySQL,
a DEA running the `lucid64` stack must be available (and have free memory).

The scripts for building this stack (and later for building
other stacks) reside in the [stacks](http://github.com/cloudfoundry/stacks) project.

## The lucid64 stack

Currently, Cloud Foundry supports one stack: `lucid64`, a Ubuntu 10.04 64-bit system
containing a number of common programs and libraries including:

* MySQL
* PostgreSQL
* sqlite
* imagemagick
* git
* ruby 1.9.3
