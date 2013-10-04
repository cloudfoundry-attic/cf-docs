---
title: Uploading a BOSH Stemcell
---

This guide describes the process for uploading a [BOSH Stemcell](/docs/running/bosh/components/stemcell.html) to your [BOSH Director](/docs/running/bosh/components/director.html).

## <a id="prerequisites"></a>Prerequisites ##

A Micro BOSH or Full BOSH should be deployed and targeted. See the steps in [Deploying Micro BOSH](deploying_microbosh.html).

## <a id="upload_stemcell"></a>Upload BOSH stemcell ###

Upload a BOSH Stemcell to the BOSH Director using the `bosh upload` command:

<pre class="terminal">
bosh upload stemcell http://bosh-jenkins-artifacts.s3.amazonaws.com/bosh-stemcell/openstack/bosh-stemcell-latest-openstack-kvm-ubuntu.tgz
</pre>

This command will output:

<pre class="terminal">

Using remote stemcell `http://bosh-jenkins-artifacts.s3.amazonaws.com/bosh-stemcell/openstack/bosh-stemcell-latest-openstack-kvm-ubuntu.tgz'

Uploading stemcell...

Director task 1

Update stemcell
  downloading remote stemcell (00:00:49)
  extracting stemcell archive (00:00:04)
  verifying stemcell manifest (00:00:00)
  checking if this stemcell already exists (00:00:00)
  uploading stemcell bosh-openstack-kvm-ubuntu/939 to the cloud (00:00:27)
  save stemcell bosh-openstack-kvm-ubuntu/939 (2214e824-e420-4a43-ac81-b6f600f25f80) (00:00:00)
Done                    6/6 00:02:11

Task 1 done
Started		2013-07-01 08:24:10 UTC
Finished	2013-07-01 08:26:21 UTC
Duration	00:02:11

Stemcell uploaded and created
</pre>

## <a id="check_stemcell"></a>Check BOSH Stemcell ###

To confirm that the BOSH Stemcell has been loaded into your BOSH Director use the `bosh stemcells` command:

<pre class="terminal">
# bosh stemcells
+---------------+---------+--------------------------------------+
| Name          | Version | CID                                  |
+---------------+---------+--------------------------------------+
| bosh-openstack-kvm-ubuntu | 939     | 2214e824-e420-4a43-ac81-b6f600f25f80 |
+---------------+---------+--------------------------------------+

Stemcells total: 1
</pre>

