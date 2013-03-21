---
title: BOSH Reference 
---

##Bosh Release 

A release is a collection of source code, configuration files and startup scripts used to run services, along with a version number that uniquely identifies the components. When creating a new release, you should use a source code manager (like [git](http://git-scm.com/)) to manage new versions of the contained files.

## Release Repository ##

A BOSH Release is built from a directory tree with the contents described in this section. A typical release repository has the following sub-directories:

| Directory 	| Contents 	|
| ------------	| ----------	|
| `jobs` 	| job definitions 	|
| `packages` 	| package definitions 	|
| `config` 	| release configuration files 	|
| `releases` 	| final releases 	|
| `src` 	| source code for packages 	|
| `blobs` 	| large source code bundles 	|

* [jobs](jobs.html)
* [packages](packages.html)
* [config](config.html)
* [releases](releases.html)
* [src](src.html)
* [blobs](blobs.html)

##Bosh CLI

* [BOSH CLI](bosh-cli.html) 

