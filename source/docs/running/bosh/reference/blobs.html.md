---
title: Blobs
---

To create final releases you need to configure your release repository with a blobstore. BOSH uploads final releases to the blobstore, so that the release can later be retreived from another computer.

To prevent the release repository from becoming bloated with large binary files (source tar-balls), large files can be placed in the `blobs` directory, and then uploaded to the blobstore.

For production releases, use either the Atmos or S3 blobstore and configure them as described below.

## <a id='atmos'></a> Atmos ##

Atmos is a shared storage solution from EMC. To use Atmos, edit `config/final.tml` and `config/private.yml`, and add the following. Replace the `url`, `uid` and `secret` values with your account information.

File `config/final.yml`

    ---
    blobstore:
      provider: atmos
      options:
        tag: BOSH
        url: https://blob.cfblob.com
        uid: 1876876dba98981ccd091981731deab2/user1

File `config/private.yml`

    ---
    blobstore_secret: ahye7dAS93kjWOIpqla9as8GBu1=

## <a id='s3'></a>S3 ##

To use S3, a shared storage solution from Amazon, edit `config/final.tml` and `config/private.yml`, and add the following. Replace the `access_key_id`, `bucket_name`, `encryption_key` and `secret_access_key` values with your account information.

File `config/final.yml`

    ---
    blobstore:
      provider: s3
      options:
        access_key_id: KIAK876234KJASDIUH32
        bucket_name: 87623bdc
        encryption_key: sp$abcd123$foobar1234

File `config/private.yml`

    ---
    blobstore_secret: kjhasdUIHIkjas765/kjahsIUH54asd/kjasdUSf

## <a id="local"></a>Local Blobstore Provider ##

If you are trying out BOSH and don't have an Atmos or S3 account, you can use the local blobstore provider (which stores the files on disk instead of a remote server).

File `config/final.yml`

    ---
    blobstore:
      provider: local
      options:
        blobstore_path: /path/to/blobstore/directory

**Note** Use the local should **only** for testing purposes. It can't be shared with others, unless they run on the same system.
