---
title: BOSH Reference 
---

## <a id="bosh-release"></a> BOSH release ##

A bosh release currently has two distinct purposes. Firstly, it contains published, final releases that can be uploaded to any bosh. Secondly, it contains the source to create new unpublished, development releases. Unpublished, development releases can be promoted into published, final releases.

As an example, if you wanted to use a final release they only need to get the release repository (as a git clone or compressed package) and run a single bosh command:

<pre class="terminal">
$ git clone git@github.com:cloudfoundry-community/redis-boshrelease.git
$ cd redis-boshrelease
$ bosh upload release releases/redis-1.yml

Copying packages
----------------
redis (1)                     FOUND REMOTE
Downloading b51c851a-eab2-41cd-8b76-f714b1adb6bb...

Copying jobs
------------
redis (1)                     FOUND REMOTE
Downloading 7b088545-1abf-4c52-a75d-efcc9172e04c...

Building tarball
----------------
Release size: 985.5K
...
Uploading release
...
Release has been created
  redis/1 (00:00:00)                                                                                
Done                    1/1 00:00:00
</pre>

Your bosh would now have this release ready for you to create one or more deployments.

<pre class="terminal">
$ bosh releases

+----------+------------+-------------+
| Name     | Versions   | Commit Hash |
+----------+------------+-------------+
| redis    | 1          | 59e77715+   |
+----------+------------+-------------+
</pre>

Published final releases have a simple versioning system. Each has a single integer version, one greater than the previous final release.

## <a id="release-repositories"></a> Release repositories ##

A BOSH Release is built from a directory tree with the contents described in this section. A typical release repository has the following subdirectories. Click on a directory link for more details.

| Directory 	| Contents 	|
| ------------	| ----------	|
| [releases](releases.html) 	| publish final releases 	|
| [.final_builds](final_builds.html) 	| final release builds in blobstore 	|
| [config](config.html) 	| release configuration files 	|
| [jobs](jobs.html) 	| job definitions 	|
| [packages](packages.html) 	| package definitions 	|
| [src](src.html) 	| source code for packages 	|
| [blobs](blobs.html) 	| local cache of large source code bundles 	|


## <a id="bosh-cli"></a> BOSH CLI ##

* [BOSH CLI](bosh-cli.html) 

