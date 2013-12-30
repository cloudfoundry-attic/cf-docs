---
title: Using the latest CF-Release
---

## <a id='intro'></a> Introduction ##

[CF-Release](https://github.com/cloudfoundry/cf-release) is the BOSH [release](/docs/running/bosh/reference/index.html#bosh-release) repository for Cloud Foundry. Use this with a custom manifest for your environment to deploy Cloud Foundry. 

This short guide shows how to, after [bootstrapping Bosh](/docs/running/deploying-cf/index.html), create a Cloud Foundry release ready to deploy to your environment. 

NOTE: These instructions are for v145 release of Cloud Foundry. We strongly recommend using the [highest final version tag of cf-release](https://github.com/cloudfoundry/cf-release/releases).

<pre class="terminal">
$ bosh upload release releases/cf-145.yml
</pre>

## <a id='clone'></a> Clone CF-Release ##

Create / find a folder to keep your clone of the CF-Release repository and clone it from Github;

<pre class="terminal">
mkdir -p ~/bosh-workspace/releases
cd ~/bosh-workspace/releases
git clone -b release-candidate git://github.com/cloudfoundry/cf-release.git
cd cf-release
</pre>

## <a id='upload-the-release'></a> Upload the release ##

Releases of Cloud Foundry are published regularly (approximately weekly) and you upload them to your bosh using `bosh upload release` where the cf-145.yml file should be substituted with the cf-release version, which we recommend to be the [highest final version tag of cf-release](https://github.com/cloudfoundry/cf-release/releases):

<pre class="terminal">
$ bosh upload release releases/cf-145.yml

Copying packages
----------------
rootfs_lucid64 (1)            FOUND LOCAL
...
Copying jobs
------------
saml_login (4)                FOUND LOCAL
...
Building tarball
----------------
Generated /tmp/d20130829-912-fq3kkd/d20130829-912-1vco0hv/release.tgz
Release size: 1.0G
...
Release uploaded
</pre>

Check the release has been added successfully by issuing the follow command;

<pre class="terminal">
$ bosh releases

+------+----------+-------------+
| Name | Versions | Commit Hash |
+------+----------+-------------+
| cf   | 145      | 121623ca    |
+------+----------+-------------+
</pre>

This release is now ready to deploy using a deployment file.
