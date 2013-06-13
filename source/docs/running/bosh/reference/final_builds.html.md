---
title: Final builds
---

The (hidden) `.final_builds` contains a single `index.yml` for each job and package within all public final releases (even if they are no longer in current final releases).

For a simple bosh release with [one package and one job](https://github.com/cloudfoundry-community/redis-boshrelease/tree/master/.final_builds):

    $ tree .final_builds
    .final_builds
    ├── jobs
    │   └── redis
    │       └── index.yml
    └── packages
        └── redis
            └── index.yml

For the large Cloud Foundry release ([cf-release](https://github.com/cloudfoundry/cf-release/tree/master/.final_builds)):

    $ tree .final_builds
    .final_builds
    ├── jobs
    │   ├── atmos_gateway
    │   │   └── index.yml
    │   ├── backup_manager
    │   │   └── index.yml
    │   ├── ccdb
    │   │   └── index.yml
    │   ├── ccdb_postgres
    │   │   └── index.yml
    │   ├── cloud_controller_ng
    │   │   └── index.yml
    ...
    └── packages
        ├── atmos_gateway
        │   └── index.yml
        ├── backup_manager
        │   └── index.yml
        ├── bandwidth_proxy
        │   └── index.yml
        ├── cloud_controller
        │   └── index.yml
        ├── cloud_controller_ng
        │   └── index.yml
        ├── common
        │   └── index.yml
        ...
        └── warden
            └── index.yml

    161 directories, 159 files

Each `index.yml` contains one or more references to blobs (tgz files) within the bosh release's public blobstore.

For example, from `packages/redis/index.yml` above:

<pre class="yaml">
---
builds:
  !binary "MDY3Y2QwMjVmNjFlZjAxNjI1NzFhYTg2NTQwYTE1OGMwOWE3YzM2Ng==":
    blobstore_id: b51c851a-eab2-41cd-8b76-f714b1adb6bb
    version: 1
    sha1: !binary |-
      OGJlZjUyYzQ2ZmRlNWI5ZWMwYzliYzVkY2I2YjQ2MjYxYmYzYTEwOA==
</pre>