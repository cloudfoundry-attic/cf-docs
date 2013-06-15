---
title: Using the latest CF-Release
---

## <a id='intro'></a> Introduction ##

[CF-Release](https://github.com/cloudfoundry/cf-release) is the BOSH [release](/docs/running/bosh/reference#bosh-release) repository for Cloud Foundry. Use this with a custom manifest for your environment to deploy Cloud Foundry. 

This short guide shows how to, after [bootstrapping Bosh](/docs/running/deploying-cf/), create a Cloud Foundry release ready to deploy to your environment. 

## <a id='clone'></a> Clone CF-Release ##

Create / find a folder to keep your clone of the CF-Release repository and clone it from Github;

<pre class="terminal">
$ mkdir -p ~/src/cloudfoundry && cd ~/src/cloudfoundry
$ git clone -b release-candidate git://github.com/cloudfoundry/cf-release.git && cd cf-release

</pre>

## <a id='update'></a> Update the release ##

Run the included update script, ~/src/cloudfoundry/cf-release/update;

<pre class="terminal">
$ ./update
+ git pull
remote: Counting objects: 96, done.
remote: Compressing objects: 100% (42/42), done.
remote: Total 67 (delta 43), reused 45 (delta 25)
Unpacking objects: 100% (67/67), done.
From http://github.com/cloudfoundry/cf-release
   abd53f7..3be3d09  master     -> origin/master
Fetching submodule src/dea_next
remote: Counting objects: 61, done.
remote: Compressing objects: 100% (20/20), done.
remote: Total 40 (delta 22), reused 36 (delta 18)
Unpacking objects: 100% (40/40), done.
From https://github.com/cloudfoundry/dea_ng
   aa33fd9..2ca4fcd  master     -> origin/master
Fetching submodule src/dea_next/buildpacks/vendor/java
remote: Counting objects: 73, done.
remote: Compressing objects: 100% (21/21), done.
remote: Total 65 (delta 9), reused 62 (delta 6)
Unpacking objects: 100% (65/65), done.
From https://github.com/cloudfoundry/cloudfoundry-buildpack-java
   663e463..09875f7  master     -> origin/master
Updating abd53f7..3be3d09
warning: unable to rmdir src/logplex: Directory not empty
Fast-forward
 config/blobs.yml                                   |   16 +-
 jobs/dea_next/templates/drain.rb                   |    2 +-
 jobs/log_server/monit                              |    5 -

...

Submodule path 'src/services': checked out '106ad12b8d21b72ae46379608df2efc8c43f3563'
Submodule 'govendor' (https://github.com/cloudfoundry/vcap-services.git) registered for path 'govendor'
Submodule 'assets' (https://github.com/cloudfoundry/vcap-yeti.git) registered for path 'assets'
</pre>

This is a very simple script that just runs a 'git pull' on the repository and then updates all the submodules. CF-Release is a combination of various other repositories.


## <a id='build-the-release'></a> Build the release ##

At this point if the Bosh CLI is not installed on the local system and targeted at a BOSH / MicroBOSH instance, do so, 
if necessary use this install [guide](/docs/running/bosh/setup/).

When prompted, name your release `appcloud`:

<pre class="terminal">
$ bosh create release --force
Syncing blobs...

Please enter development release name: appcloud

Building DEV release
---------------------------------

Building packages
-----------------
Building backup_manager...
  Final version:   NOT FOUND
  Dev version:     FOUND LOCAL

Building bandwidth_proxy...
  Final version:   FOUND LOCAL

Building buildpack_cache...
  Final version:   NOT FOUND
  Dev version:     FOUND LOCAL

...

Release version: 131.1-dev
Release manifest: /private/tmp/cf-release/dev_releases/appcloud-131.1-dev.yml
</pre>

## <a id='upload-the-release'></a> Upload the release ##

Once the build is complete, the latest development release (that was just generated), can be uploaded to the BOSH / MicroBOSH instance;

<pre class="terminal">
$ bosh upload release

...

Uploading release

...

Task 11 done
Started   2013-03-22 23:07:16 UTC
Finished  2013-03-22 23:07:23 UTC
Duration  00:00:07

Release uploaded
</pre>

Check the release has been added successfully by issuing the follow command;

<pre class="terminal">
$ bosh releases

+----------+------------+-------------+
| Name     | Versions   | Commit Hash |
+----------+------------+-------------+
| appcloud | 131.1-dev  | de134222+   |
+----------+------------+-------------+
(*) Currently deployed

Releases total: 1
</pre>

This release is now ready to deploy using a custom manifest.