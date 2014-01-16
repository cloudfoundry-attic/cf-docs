---
title: Blobstore
---

The BOSH Blobstore is used to store the content of Releases (BOSH
[Jobs](../reference/jobs.html) and [Packages](../reference/packages.html) in
their source form as well as the compiled image of BOSH Packages.
[Releases](../reference/releases.html) are uploaded by the [BOSH
CLI](../reference/bosh-cli.html) and inserted into the Blobstore by the [BOSH
Director](director.html).
When you deploy a Release, BOSH will orchestrate the compilation of packages and
store the result in the Blobstore.
When BOSH deploys a BOSH Job to a VM, the BOSH Agent will pull the specified Job
and associated BOSH Packages from the Blobstore.

BOSH also uses the Blobstore as an intermediate store for large payloads, such
as log files (see BOSH logs) and output from the BOSH Agent that exceeds the max
size for messages over the message bus.

There are currently three Blobstores supported in BOSH:

1. [Atmos](http://www.emc.com/storage/atmos/atmos.htm)
1. [S3](http://aws.amazon.com/s3/)
1. [simple blobstore server](https://github.com/cloudfoundry/bosh/tree/master/simple_blobstore_server)

For example configurations of each Blobstore, see the Blobs section below.
The default BOSH configuration uses the simple blobstore server, as the load is
very light and low latency is preferred.

###Blobs
To create final releases you need to configure your release repository with a
blobstore.
This is where BOSH will upload the final releases to, so that the release can
later be retrieved from another computer.

To prevent the release repository from becoming bloated with large binary files
(source tar-balls), large files can be placed in the blobs directory, and then
uploaded to the blobstore.

For production releases you should use either the Atmos or S3 blobstore and
configure them as described below.

####Atmos

Atmos is a shared storage solution from EMC.
To use Atmos, edit config/final.tml and config/private.yml, and add the
following (replacing the url, uid, and secret with your account information):

File config/final.yml

    ---
    blobstore:
    provider: atmos
      options:
      tag: BOSH
      url: https://blob.cfblob.com
      uid: 1876876dba98981ccd091981731deab2/user1

File config/private.yml

    ---
    blobstore_secret: ahye7dAS93kjWOIpqla9as8GBu1=

####S3

To use S3, a shared storage solution from Amazon, edit config/final.tml and
config/private.yml, and add the following (replacing the access\_key\_id,
bucket\_name, encryption\_key, and secret\_access_key with your account
information):

File config/final.yml

    ---
    blobstore:
      provider: s3
      options:
        access_key_id: KIAK876234KJASDIUH32
        bucket_name: 87623bdc
        encryption_key: sp$abcd123$foobar1234

File config/private.yml

    ---
    blobstore_secret: kjhasdUIHIkjas765/kjahsIUH54asd/kjasdUSf

####Local

If you are trying out BOSH and don't have an Atmos or S3 account, you can use
the local blobstore provider (which stored the files on disk instead of a remote
server).

File config/final.yml

    ---
    blobstore:
      provider: local
      options:
        blobstore_path: /path/to/blobstore/directory

Note that local should only be used for testing purposes as it can't be shared
with others (unless they run on the same system).