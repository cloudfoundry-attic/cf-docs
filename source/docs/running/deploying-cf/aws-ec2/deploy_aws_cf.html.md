---
title: Deployment of CF on AWS
---

These steps will leverage the additional security group and ports opened in the previous step to deploy Cloud Foundry from the BOSH server:

* Obtain and Upload Release

* Upload a Stemcell

* Modify a Deployment Manifest

* Deploy

### Obtain and Upload Release

Original documentation borrowed heavily from [here](http://www.google.com/url?q=http%3A%2F%2Fdocs.cloudfoundry.com%2Fdocs%2Frunning%2Fdeploying-cf%2Fcommon%2Fcf-release.html&sa=D&sntz=1&usg=AFQjCNEnuPr0Fy05RET8NliV2OUS-sjwhw), however you can follow the instructions below.

Create a folder on the local computer to store the CF Release:

<pre class="terminal">
  mkdir -p ~/bosh-workspace/releases/
  cd ~/bosh-workspace/releases/
  git clone -b release-candidate git://github.com/cloudfoundry/cf-release.git
  cd ~/bosh-workspace/releases/cf-release
</pre>
Navigate into the releases folder and pick a recent release then upload:

<pre class="terminal">
  bosh upload release ~/bosh-workspace/releases/cf-release/releases/cf-146.yml
</pre>

Note: if you get a blobstore error "No space left of device…" the local computer ran out of space on the /tmp folder.  To fix this, find a larger local partition and execute the following commands to point /tmp to a larger device.

<pre class="terminal">
  sudo su -
  mkdir /tmp2
  mount --bind /tmp2 /tmp
  sudo chown root.root /tmp
  sudo chmod 1777 /tmp
</pre>

To check that the release was successful:

<pre class="terminal">
  bosh releases
</pre>

### Obtain and Upload Stemcell

These are the exact same instructions that we used to upload the latest stemcell of BOSH onto the Micro BOSH server.

<pre class="terminal">
  bosh upload stemcell https://s3.amazonaws.com/bosh-jenkins-artifacts/bosh-stemcell/aws/bosh-stemcell-1274-aws-xen-ubuntu.tgz
</pre>


After the upload is complete you can see the list of stemcells by calling:

<pre class="terminal">
  bosh stemcells
</pre>

### Modify Deployment Manifest

Create a location to save the file

<pre class="terminal">
  mkdir -p ~/bosh-workspace/deployments/cf
  cd ~/bosh-workspace/deployments/cf
  vi cf.yml
</pre>

Below is a sample deployment manifest known to work with cf-146.  Substitute the new IP address you created in the last step for the address 107.20.148.206 seen below.  Obtain your director_uuid by executing "bosh status" and updating the manifest below no other changes are required unless you are using a different version other than cf-146.

This sample deployment was originally created via the bosh-cloudfoundry gem which is located [here](https://github.com/cloudfoundry-community/bosh-cloudfoundry/blob/master/templates/v146/aws/medium/deployment_file.yml.erb).

<pre class="terminal">

~~~yaml
name: tutorial
director_uuid: cb876e64-c08f-427f-b84f-3d05a5fde145

releases:
 - name: cf
   version: 146

networks:
- name: floating
  type: vip
  cloud_properties: {}
- name: default
  type: dynamic
  cloud_properties:
    security_groups:
    - cf

update:
  canaries: 1
  canary_watch_time: 30000-60000
  update_watch_time: 30000-60000
  max_in_flight: 4

compilation:
  workers: 1
  network: default
  reuse_compilation_vms: true
  cloud_properties:
    instance_type: m1.medium

resource_pools:
  - name: small
    network: default
    size: 4
    stemcell:
      name: bosh-aws-xen-ubuntu
      version: latest
    cloud_properties:
      instance_type: m1.small

  - name: medium
    network: default
    size: 0
    stemcell:
      name: bosh-aws-xen-ubuntu
      version: latest
    cloud_properties:
      instance_type: m1.medium

jobs:
  - name: data
    release: cf
    template:
      - postgres
      - debian_nfs_server
    instances: 1
    resource_pool: small
    persistent_disk: 4096
    networks:
    - name: default
      default:
      - dns
      - gateway
    properties:
      db: databases

  - name: core
    release: cf
    template:
      - nats
      - health_manager_next
      - uaa
    instances: 1
    resource_pool: small
    networks:
    - name: default
      default:
      - dns
      - gateway

  - name: api
    release: cf
    template:
      - cloud_controller_ng
      - gorouter
    instances: 1
    resource_pool: small
    networks:
    - name: default
      default:
      - dns
      - gateway
    - name: floating
      static_ips:
      - 107.20.148.206
    properties:
      db: databases

  - name: dea
    release: cf
    template:
      - dea_next
    instances: 1
    resource_pool: small
    networks:
      - name: default
        default: [dns, gateway]

properties:
  cf:
    name: tutorial
    dns: 107.20.148.206.xip.io
    ip_addresses: ["107.20.148.206"]
    deployment_size: medium
    security_group: cf
    persistent_disk: 4096
    common_password: eaa139af583c
    dea_server_ram: 1500
    dea_container_depot_disk: 10240

  domain: 107.20.148.206.xip.io
  system_domain: 107.20.148.206.xip.io.com
  system_domain_organization: system_domain
  app_domains:
    - 107.20.148.206.xip.io

  networks:
    apps: default
    management: default

  nats:
    address: 0.core.default.tutorial.bosh
    port: 4222
    user: nats
    password: eaa139af583c
    authorization_timeout: 5

  router:
    port: 8081
    status:
      port: 8080
      user: gorouter
      password: eaa139af583c

  dea: &dea
    memory_mb: 1500
    disk_mb: 10240
    directory_server_protocol: http

  dea_next: *dea

  syslog_aggregator:
    address: 0.syslog-aggregator.default.tutorial.bosh
    port: 54321

  nfs_server:
    address: 0.data.default.tutorial.bosh
    network: "*.tutorial.bosh"
    idmapd_domain: 107.20.148.206.xip.io

  debian_nfs_server:
    no_root_squash: true

  databases: &databases
    db_scheme: postgres
    address: 0.data.default.tutorial.bosh
    port: 5524
    roles:
      - tag: admin
        name: ccadmin
        password: eaa139af583c
      - tag: admin
        name: uaaadmin
        password: eaa139af583c
    databases:
      - tag: cc
        name: ccdb
        citext: true
      - tag: uaa
        name: uaadb
        citext: true

  ccdb: &ccdb
    db_scheme: postgres
    address: 0.data.default.tutorial.bosh
    port: 5524
    roles:
      - tag: admin
        name: ccadmin
        password: eaa139af583c
    databases:
      - tag: cc
        name: ccdb
        citext: true

  ccdb_ng: *ccdb

  uaadb:
    db_scheme: postgresql
    address: 0.data.default.tutorial.bosh
    port: 5524
    roles:
      - tag: admin
        name: uaaadmin
        password: eaa139af583c
    databases:
      - tag: uaa
        name: uaadb
        citext: true

  cc_api_version: v2

  cc: &cc
    logging_level: debug
    external_host: api
    srv_api_uri: http://api.107.20.148.206.xip.io
    cc_partition: default
    db_encryption_key: eaa139af583c
    bootstrap_admin_email: admin@107.20.148.206.xip.io
    bulk_api_password: eaa139af583c
    uaa_resource_id: cloud_controller
    staging_upload_user: uploaduser
    staging_upload_password: eaa139af583c
    resource_pool:
      resource_directory_key: cc-resources
      # Local provider when using NFS
      fog_connection:
        provider: Local
    packages:
      app_package_directory_key: cc-packages
    droplets:
      droplet_directory_key: cc-droplets
    default_quota_definition: runaway

  ccng: *cc

  login:
    enabled: false

  uaa:
    url: http://uaa.107.20.148.206.xip.io
    spring_profiles: postgresql
    no_ssl: true
    catalina_opts: -Xmx768m -XX:MaxPermSize=256m
    resource_id: account_manager
    jwt:
      signing_key: |
        -----BEGIN RSA PRIVATE KEY-----
        MIICXAIBAAKBgQDHFr+KICms+tuT1OXJwhCUmR2dKVy7psa8xzElSyzqx7oJyfJ1
        JZyOzToj9T5SfTIq396agbHJWVfYphNahvZ/7uMXqHxf+ZH9BL1gk9Y6kCnbM5R6
        0gfwjyW1/dQPjOzn9N394zd2FJoFHwdq9Qs0wBugspULZVNRxq7veq/fzwIDAQAB
        AoGBAJ8dRTQFhIllbHx4GLbpTQsWXJ6w4hZvskJKCLM/o8R4n+0W45pQ1xEiYKdA
        Z/DRcnjltylRImBD8XuLL8iYOQSZXNMb1h3g5/UGbUXLmCgQLOUUlnYt34QOQm+0
        KvUqfMSFBbKMsYBAoQmNdTHBaz3dZa8ON9hh/f5TT8u0OWNRAkEA5opzsIXv+52J
        duc1VGyX3SwlxiE2dStW8wZqGiuLH142n6MKnkLU4ctNLiclw6BZePXFZYIK+AkE
        xQ+k16je5QJBAN0TIKMPWIbbHVr5rkdUqOyezlFFWYOwnMmw/BKa1d3zp54VP/P8
        +5aQ2d4sMoKEOfdWH7UqMe3FszfYFvSu5KMCQFMYeFaaEEP7Jn8rGzfQ5HQd44ek
        lQJqmq6CE2BXbY/i34FuvPcKU70HEEygY6Y9d8J3o6zQ0K9SYNu+pcXt4lkCQA3h
        jJQQe5uEGJTExqed7jllQ0khFJzLMx0K6tj0NeeIzAaGCQz13oo2sCdeGRHO4aDh
        HH6Qlq/6UOV5wP8+GAcCQFgRCcB+hrje8hfEEefHcFpyKH+5g1Eu1k0mLrxK2zd+
        4SlotYRHgPCEubokb2S1zfZDWIXW3HmggnGgM949TlY=
        -----END RSA PRIVATE KEY-----
      verification_key: |
        -----BEGIN PUBLIC KEY-----
        MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDHFr+KICms+tuT1OXJwhCUmR2d
        KVy7psa8xzElSyzqx7oJyfJ1JZyOzToj9T5SfTIq396agbHJWVfYphNahvZ/7uMX
        qHxf+ZH9BL1gk9Y6kCnbM5R60gfwjyW1/dQPjOzn9N394zd2FJoFHwdq9Qs0wBug
        spULZVNRxq7veq/fzwIDAQAB
        -----END PUBLIC KEY-----
    cc:
      client_secret: eaa139af583c
    admin:
      client_secret: eaa139af583c
    batch:
      username: batchuser
      password: eaa139af583c
    client:
      autoapprove:
        - cf
    clients:
      cf:
        override: true
        authorized-grant-types: password,implicit,refresh_token
        authorities: uaa.none
        scope: cloud_controller.read,cloud_controller.write,openid,password.write,cloud_controller.admin,scim.read,scim.write
        access-token-validity: 7200
        refresh-token-validity: 1209600
    scim:
      users:
      - admin|eaa139af583c|scim.write,scim.read,openid,cloud_controller.admin
      - services|eaa139af583c|scim.write,scim.read,openid,cloud_controller.admin</td>
~~~


Remember to save your changes to the file

### Deploy CF on AWS

Everything is now in place to use the deployment manifest you have created and deploy CF from the BOSH server to AWS. Let’s now do this.

Select the deployment file

<pre class="terminal">
  bosh deployment ~/bosh-workspace/deployments/cf/cf.yml</td>
</pre>


Deploy the BOSH

<pre class="terminal">
  bosh deploy
</pre>


If you receive the following error, try to run "bosh deploy" again

**Error 400007: `api/0' is not running after update**
