---
title: Uploading a BOSH Stemcell
---

This guide describes the process for uploading a [BOSH Stemcell](/docs/running/bosh/components/stemcell.html) to your [BOSH Director](/docs/running/bosh/components/director.html). 

## <a id="prerequisites"></a>Prerequisites ##

A Micro BOSH or Full BOSH should be deployed and targeted. See the steps in [Deploying Micro BOSH](deploying_microbosh.html).

## <a id="download_stemcell"></a>Download BOSH stemcell ###

Using the `stemcells` directory we created when we [deployed Micro BOSH](deploying_microbosh.html#download_stemcell):

<pre class="terminal">
cd ~/bosh-workspace/stemcells
</pre>

Download the latest OpenStack BOSH Stemcell:

<pre class="terminal">
wget http://bosh-jenkins-artifacts.s3.amazonaws.com/last_successful_bosh-stemcell-openstack.tgz
</pre>

## <a id="upload_stemcell"></a>Upload BOSH stemcell ###

Upload the BOSH Stemcell to the BOSH Director using the `bosh upload` command:

<pre class="terminal">
bosh upload stemcell ~/bosh-workspace/stemcells/last_successful_bosh-stemcell-openstack.tgz
</pre>

This command will output:

    Verifying stemcell...
    File exists and readable                                     OK
    Manifest not found in cache, verifying tarball...
    Read tarball                                                 OK
    Manifest exists                                              OK
    Stemcell image file                                          OK
    Writing manifest to cache...
    Stemcell properties                                          OK
    
    Stemcell info
    -------------
    Name:    bosh-stemcell
    Version: 1.5.0.pre.3
    
    Checking if stemcell already exists...
    No
    
    Uploading stemcell...
    
    bosh-stemcell: 100% |oooooooooooooooooooo| 243.1MB  59.2MB/s Time: 00:00:04
    
    Director task 1
    
    Update stemcell
      extracting stemcell archive (00:00:04)                                                            
      verifying stemcell manifest (00:00:00)                                                            
      checking if this stemcell already exists (00:00:00)                                               
      uploading stemcell bosh-stemcell/1.5.0.pre.3 to the cloud (00:00:58)                              
      save stemcell bosh-stemcell/1.5.0.pre.3 (72f212a7-657c-4bd0-ad6b-ce1fdd454b0f) (00:00:00)         
    Done                    5/5 00:01:02                                                                
    
    Task 1 done
    Started		2013-06-17 13:01:07 UTC
    Finished	2013-06-17 13:02:09 UTC
    Duration	00:01:02
    
    Stemcell uploaded and created
    
## <a id="check_stemcell"></a>Check BOSH Stemcell ###

To confirm that the BOSH Stemcell has been loaded into your BOSH Director use the `bosh stemcells` command:
   
    +---------------+-------------+--------------------------------------+
    | Name          | Version     | CID                                  |
    +---------------+-------------+--------------------------------------+
    | bosh-stemcell | 1.5.0.pre.3 | 72f212a7-657c-4bd0-ad6b-ce1fdd454b0f |
    +---------------+-------------+--------------------------------------+
    
    Stemcells total: 1
