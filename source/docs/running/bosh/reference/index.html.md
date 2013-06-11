---
title: BOSH Reference 
---

## <a id="bosh-release"></a> BOSH release ##

A release is a collection of source code, configuration files, and startup scripts used to run services, along with a version number that uniquely identifies the components. When creating a new release, use a source code manager (like [git](http://git-scm.com/)) to manage new versions of the contained files.

## <a id="release-repositories"></a> Release repositories ##

A BOSH Release is built from a directory tree with the contents described in this section. A typical release repository has the following subdirectories. Click on a directory link for more details.

| Directory 	| Contents 	|
| ------------	| ----------	|
| [jobs](jobs.html) 	| job definitions 	|
| [packages](packages.html) 	| package definitions 	|
| [config](config.html) 	| release configuration files 	|
| [releases](releases.html) 	| final releases 	|
| [src](src.html) 	| source code for packages 	|
| [blobs](blobs.html) 	| large source code bundles 	|


## <a id="bosh-cli"></a> BOSH CLI ##

* [BOSH CLI](bosh-cli.html) 

