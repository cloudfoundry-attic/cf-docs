---
title: Uploading a BOSH Stemcell
---

This guide describes the process for uploading a [BOSH Stemcell](/docs/running/bosh/components/stemcell.html) to your [BOSH Director](/docs/running/bosh/components/director.html). 

## <a id="prerequisites"></a>Prerequisites ##

A Micro BOSH or Full BOSH should be deployed and targeted. See the steps in [Deploying Micro BOSH](deploying_microbosh.html).

## <a id="upload_stemcell"></a>Upload BOSH stemcell ###

Upload a BOSH Stemcell to the BOSH Director using the `bosh upload` command:

<pre class="terminal">
bosh upload stemcell http://bosh-jenkins-artifacts.s3.amazonaws.com/bosh-stemcell/openstack/latest-bosh-stemcell-openstack.tgz
</pre>

This command will output:

    Using remote stemcell `http://bosh-jenkins-artifacts.s3.amazonaws.com/bosh-stemcell/openstack/latest-bosh-stemcell-openstack.tgz'

    Uploading stemcell...

    Director task 1

    Update stemcell
      downloading remote stemcell (00:00:49)
      extracting stemcell archive (00:00:04)
      verifying stemcell manifest (00:00:00)
      checking if this stemcell already exists (00:00:00)
      uploading stemcell bosh-stemcell/1.5.0.pre.3 to the cloud (00:01:18)
      save stemcell bosh-stemcell/1.5.0.pre.3 (72f212a7-657c-4bd0-ad6b-ce1fdd454b0f) (00:00:00)
    Done                    6/6 00:02:11

    Task 1 done
    Started		2013-07-01 08:24:10 UTC
    Finished	2013-07-01 08:26:21 UTC
    Duration	00:02:11

    Stemcell uploaded and created

## <a id="check_stemcell"></a>Check BOSH Stemcell ###

To confirm that the BOSH Stemcell has been loaded into your BOSH Director use the `bosh stemcells` command:
   
    +---------------+-------------+--------------------------------------+
    | Name          | Version     | CID                                  |
    +---------------+-------------+--------------------------------------+
    | bosh-stemcell | 1.5.0.pre.3 | 72f212a7-657c-4bd0-ad6b-ce1fdd454b0f |
    +---------------+-------------+--------------------------------------+
    
    Stemcells total: 1
