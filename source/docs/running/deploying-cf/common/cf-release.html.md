---
title: Using the latest CF-Release
---

## <a id='intro'></a> Introduction ##

[CF-Release](https://github.com/cloudfoundry/cf-release) is the BOSH [release](/docs/running/bosh/reference/index.html#bosh-release) repository for Cloud Foundry. Use this with a custom manifest for your environment to deploy Cloud Foundry. 

This short guide shows how to, after [bootstrapping Bosh](/docs/running/deploying-cf/index.html), create a Cloud Foundry release ready to deploy to your environment. 

NOTE: The commands below show, for example, deployment of the v138 release of Cloud Foundry. In most cases you should deploy the latest release of cloud foundry.  To do so, after the git clone command and the cd into cf-release, list the contents of the releases directory.  In the bosh upload command, replace the cf-138.yml with the yml with the highest release number.  For example, to release v145 execute the following command:

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

Releases of Cloud Foundry are published regularly (approximately weekly) and you upload them to your bosh using `bosh upload release`:

<pre class="terminal">
$ bosh upload release releases/cf-138.yml

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
| cf   | 138      | adca9c45    |
+------+----------+-------------+
</pre>

This release is now ready to deploy using a deployment file.
