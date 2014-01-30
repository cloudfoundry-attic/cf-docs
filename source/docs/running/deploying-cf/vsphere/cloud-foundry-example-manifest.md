---
title: Cloud Foundry Example Manifest
---

~~~yaml
---
name: your-deployment
director_uuid: 3350612f-f0e4-41b3-b1b2-3d730f9011a7 # get this from bosh status

releases:
- name: appcloud
  version: latest

compilation:
  workers: 8
  network: default
  cloud_properties:
    ram: 2048
    disk: 8096
    cpu: 4

update:
  canaries: 1
  canary_watch_time: 3000-90000
  update_watch_time: 3000-90000
  max_in_flight: 4

networks:

- name: default
  subnets:
  - range: 172.16.214.0/23
    # Reserved IPs are the IPs that BOSH should not use in the declared range.
    reserved:
    - 172.16.214.2 - 172.16.214.9
    - 172.16.215.245 - 172.16.215.254
    # Static IPs are the IPs that are statically assigned to jobs in this manifest. The BOSH director does not attempt
    # to dynamically assign these to new VMs.
    static:
    - 172.16.214.10 - 172.16.214.140
    gateway: 172.16.214.1
    # If you configured your BOSH/micro-BOSH to enable DNS, leave the DNS section empty. The BOSH director automatically uses the
    # BOSH/micro-BOSH powerDNS IP. If any jobs ever need to resolve DNS entries outside the BOSH powerDNS subdomain
    # (*.microbosh by default), configure the powerDNS recursor in your bosh release.
    dns:
    cloud_properties:
      name: default_vlan
- name: lb
  subnets:
  - range: 172.16.8.1/28
    static:
    - 172.16.8.1 - 172.16.8.2
    dns:
    - 8.8.8.8
    cloud_properties:
      name: lb_vlan

resource_pools:

- name: infrastructure
  network: default
  size: 28
  stemcell:
    name: bosh-vsphere-esxi-ubuntu
    version: 0.6.7
  cloud_properties:
    ram: 4096
    disk: 8192
    cpu: 1
  env:
    bosh:
      # password generated using mkpasswd -m sha-512
      password: $6$leYJSesP$fPm2lwx4Pw/5ZmafFH3h0sMjnMhdH02uC4K7Te0Bu48YhS7o3PFxfsv.V/is.Ty29Ol1j2lvWLcMiE99AvoMy/

- name: deas
  network: default
  size: 1
  stemcell:
    name: bosh-vsphere-esxi-ubuntu
    version: 0.6.7
  cloud_properties:
    ram: 8192
    disk: 16384
    cpu: 4
  env:
    bosh:
      # password generated using mkpasswd -m sha-512
      password: $6$leYJSesP$fPm2lwx4Pw/5ZmafFH3h0sMjnMhdH02uC4K7Te0Bu48YhS7o3PFxfsv.V/is.Ty29Ol1j2lvWLcMiE99AvoMy/

- name: services_3gb
  network: default
  size: 2
  stemcell:
    name: bosh-vsphere-esxi-ubuntu
    version: 0.6.7
  cloud_properties:
    ram: 3072
    disk: 8192
    cpu: 8
  env:
    bosh:
      # password generated using mkpasswd -m sha-512
      password: $6$leYJSesP$fPm2lwx4Pw/5ZmafFH3h0sMjnMhdH02uC4K7Te0Bu48YhS7o3PFxfsv.V/is.Ty29Ol1j2lvWLcMiE99AvoMy/

- name: services_13gb
  network: default
  size: 1
  stemcell:
    name: bosh-vsphere-esxi-ubuntu
    version: 0.6.7
  cloud_properties:
    ram: 13312
    disk: 8192
    cpu: 8
  env:
    bosh:
      # password generated using mkpasswd -m sha-512
      password: $6$leYJSesP$fPm2lwx4Pw/5ZmafFH3h0sMjnMhdH02uC4K7Te0Bu48YhS7o3PFxfsv.V/is.Ty29Ol1j2lvWLcMiE99AvoMy/

- name: services_21gb
  network: default
  size: 2
  stemcell:
    name: bosh-vsphere-esxi-ubuntu
    version: 0.6.7
  cloud_properties:
    ram: 21504
    disk: 8192
    cpu: 8
  env:
    bosh:
      # password generated using mkpasswd -m sha-512
      password: $6$leYJSesP$fPm2lwx4Pw/5ZmafFH3h0sMjnMhdH02uC4K7Te0Bu48YhS7o3PFxfsv.V/is.Ty29Ol1j2lvWLcMiE99AvoMy/

jobs:

- name: debian_nfs_server
  release: appcloud
  template: debian_nfs_server
  instances: 1
  resource_pool: infrastructure
  persistent_disk: 8192
  networks:
  - name: default
    static_ips:
    - 172.16.214.10

- name: services_nfs
  release: appcloud
  template: debian_nfs_server
  instances: 1
  resource_pool: infrastructure
  persistent_disk: 10240
  properties:
    debian_nfs_server:
      no_root_squash: true
  networks:
  - name: default
    static_ips:
    - 172.16.214.20

- name: syslog_aggregator
  release: appcloud
  template: syslog_aggregator
  instances: 1
  resource_pool: infrastructure
  persistent_disk: 100000
  networks:
  - name: default
    static_ips:
    - 172.16.214.13

- name: nats
  release: appcloud
  template: nats
  instances: 1
  resource_pool: infrastructure
  networks:
  - name: default
    static_ips:
    - 172.16.214.11

- name: hbase_slave
  release: appcloud
  template: hbase_slave
  instances: 3
  resource_pool: infrastructure
  persistent_disk: 2048
  networks:
  - name: default
    static_ips:
    - 172.16.214.22 - 172.16.214.24

- name: hbase_master
  release: appcloud
  template: hbase_master
  instances: 1
  resource_pool: infrastructure
  persistent_disk: 2048
  networks:
  - name: default
    static_ips:
    - 172.16.214.25

- name: opentsdb
  release: appcloud
  template: opentsdb
  instances: 1
  resource_pool: infrastructure
  networks:
  - name: default
    static_ips:
    - 172.16.214.14

- name: collector
  release: appcloud
  template: collector
  instances: 1
  resource_pool: infrastructure
  networks:
  - name: default

- name: dashboard
  release: appcloud
  template: dashboard
  instances: 1
  resource_pool: infrastructure
  networks:
  - name: default

- name: ccdb_ng
  release: appcloud
  template: postgres
  instances: 1
  resource_pool: infrastructure
  persistent_disk: 2048
  networks:
  - name: default
    static_ips:
    - 172.16.214.19
  properties:
    db: ccdb_ng

- name: uaadb
  db_scheme: postgresql
  release: appcloud
  template: postgres
  instances: 1
  resource_pool: infrastructure
  persistent_disk: 2048
  networks:
  - name: default
    static_ips:
    - 172.16.214.15
  properties:
    db: uaadb

- name: vcap_redis
  release: appcloud
  template: vcap_redis
  instances: 1
  resource_pool: infrastructure
  networks:
  - name: default
    static_ips:
    - 172.16.214.16

- name: services_redis
  release: appcloud
  template: vcap_redis
  instances: 1
  resource_pool: infrastructure
  persistent_disk: 2048
  networks:
  - name: default
    static_ips:
    - 172.16.214.82
  properties:
    vcap_redis:
      port: 3456
      password: fksaefblsdf9
      maxmemory: 2000000000
      persistence:
        dir: /var/vcap/store/vcap_redis

- name: uaa
  release: appcloud
  template: uaa
  instances: 1
  resource_pool: infrastructure
  networks:
  - name: default

- name: login
  release: appcloud
  template: login
  instances: 1
  resource_pool: infrastructure
  networks:
  - name: default

- name: cloud_controller_ng
  release: appcloud
  template: cloud_controller_ng
  instances: 1
  resource_pool: infrastructure
  networks:
  - name: default

- name: router
  release: appcloud
  template: gorouter
  instances: 1
  resource_pool: infrastructure
  networks:
  - name: default
    default: [dns, gateway]
  - name: lb
    static_ips:
    - 172.16.8.1

- name: health_manager_next
  release: appcloud
  template: health_manager_next
  instances: 1
  resource_pool: infrastructure
  networks:
  - name: default
    static_ips:
    - 172.16.214.110
  properties:
    cc_props: ccng
    hm_props: health_manager_ccng

- name: dea_next
  release: appcloud
  template: dea_next
  instances: 4
  resource_pool: deas
  update:
    max_in_flight: 8
  networks:
  - name: default
  properties:
    dea_next:
      stacks:
      - lucid64

- name: mysql_node_100
  release: appcloud
  template: mysql_node_ng
  instances: 1
  resource_pool: services_3gb
  persistent_disk: 12058
  properties:
    plan: "100"
  networks:
  - name: default
    static_ips:
    - 172.16.214.40

- name: mysql_gateway
  release: appcloud
  template: mysql_gateway
  instances: 1
  resource_pool: infrastructure
  networks:
  - name: default
  properties:
    uaa_client_id: "vmc"
    uaa_endpoint: https://uaa.your.domain.org
    uaa_client_auth_credentials:
      username: your-admin@your-org.com
      password: your-admin-password

- name: mongodb_node_100
  release: appcloud
  template: mongodb_node_ng
  instances: 1
  resource_pool: services_21gb
  persistent_disk: 63729
  properties:
    plan: "100"
  networks:
  - name: default
    static_ips:
    - 172.16.214.50

- name: mongodb_gateway
  release: appcloud
  template: mongodb_gateway
  instances: 1
  resource_pool: infrastructure
  networks:
  - name: default
  properties:
    uaa_client_id: "vmc"
    uaa_endpoint: https://uaa.your.domain.org
    uaa_client_auth_credentials:
      username: your-admin@your-org.com
      password: your-admin-password

- name: redis_node_100
  release: appcloud
  template: redis_node_ng
  instances: 1
  resource_pool: services_13gb
  persistent_disk: 7168
  properties:
    plan: "100"
  networks:
  - name: default
    static_ips:
    - 172.16.214.60

- name: redis_gateway
  release: appcloud
  template: redis_gateway
  instances: 1
  resource_pool: infrastructure
  networks:
  - name: default
  properties:
    uaa_client_id: "vmc"
    uaa_endpoint: https://uaa.your.domain.org
    uaa_client_auth_credentials:
      username: your-admin@your-org.com
      password: your-admin-password

- name: rabbit_node_100
  release: appcloud
  template: rabbit_node_ng
  instances: 1
  resource_pool: services_21gb
  persistent_disk: 3072
  properties:
    plan: "100"
  networks:
  - name: default
    static_ips:
    - 172.16.214.70

- name: rabbit_gateway
  release: appcloud
  template: rabbit_gateway
  instances: 1
  resource_pool: infrastructure
  networks:
  - name: default
  properties:
    uaa_client_id: "vmc"
    uaa_endpoint: https://uaa.your.domain.org
    uaa_client_auth_credentials:
      username: your-admin@your-org.com
      password: the_admin_pw

- name: postgresql_node_100
  release: appcloud
  template: postgresql_node_ng
  instances: 1
  resource_pool: services_3gb
  persistent_disk: 15861
  properties:
    plan: "100"
  networks:
  - name: default
    static_ips:
    - 172.16.214.80

- name: postgresql_gateway
  release: appcloud
  template: postgresql_gateway
  instances: 1
  resource_pool: infrastructure
  networks:
  - name: default
  properties:
    uaa_client_id: "vmc"
    uaa_endpoint: https://uaa.your.domain.org
    uaa_client_auth_credentials:
      username: your-admin@your-org.com
      password: the_admin_pw

- name: backup_manager
  release: appcloud
  template: backup_manager
  instances: 1
  resource_pool: infrastructure
  networks:
  - name: default
    static_ips:
    - 172.16.214.90

- name: service_utilities
  release: appcloud
  template: service_utilities
  instances: 1
  resource_pool: infrastructure
  networks:
  - name: default
    static_ips:
    - 172.16.214.91

- name: serialization_data_server
  release: appcloud
  template: serialization_data_server
  instances: 1
  resource_pool: infrastructure
  networks:
  - name: default
    static_ips:
    - 172.16.214.92

properties:
  domain: cf.your.domain.org

  networks:
    apps: default
    management: default

  nats:
    user: nats
    password: asdfasdfasdf
    address: 172.16.214.11
    port: 4222

#required for uaa batch until it is removed
  ccdb:
    address: 127.0.0.1
    port: 12345
    roles:
    - tag: admin
      name: a-ccdb-user-name
      password: a-ccdb-password
    databases:
    - tag: cc
      name: foobar

  ccdb_ng:
    address: 172.16.214.19
    port: 5524
    pool_size: 10
    roles:
    - tag: admin
      name: ccadmin
      password: asdfasdf80456
    databases:
    - tag: cc
      name: appcloud
      citext: true

  health_manager_ccng:
    shadow_mode: disable
    cc_partition: ng

  uaadb:
    address: 172.16.214.15
    port: 2544
    roles:
    - tag: admin
      name: root
      password: asdfsadf9089089345
    databases:
    - tag: uaa
      name: uaa

  cc:
    srv_api_uri: http://ccng.your.domain.com

  ccng:
    srv_api_uri: http://ccng.your.domain.com
    external_host: ccng
    logging_level: debug
    bulk_api_password: asdfjklhsadfhljkfas
    uaa_resource_id: cloud_controller
    staging_upload_user: jkfgjkfg
    staging_upload_password: lfgklfgfg

  vcap_redis:
    address: 172.16.214.16
    port: 5454
    password: jkfgkjfgjkfgjkfgjk
    maxmemory: 2000000000 # 2GB

  router:
    status:
      port: 8080
      user: 0dfg0dfg0dfg
      password: kdfgkdfgkdfgdfg4

  dashboard:
    uaa:
      client_id: dashboard
      client_secret: 0dfgmsfgngrioger
    users:
      - [dash-user, dash-password]

  dea:
    max_memory: 8192

  dea_next:
    memory_mb: 8192
    memory_overcommit_factor: 4
    disk_mb: 16384
    disk_overcommit_factor: 4
    num_instances: 256

  nfs_server:
    address: 172.16.214.10
    network: 172.16.214.0/23

  hbase_master:
    address: 172.16.214.25
    hbase_master:
      port: 60000
      webui_port: 60010
      heap_size: 1024
    hbase_zookeeper:
      heap_size: 1024
    hadoop_namenode:
      port: 9000

  opentsdb:
    address: 172.16.214.14
    port: 4242

  hbase_slave:
    hbase_regionserver:
      port: 60020
      heap_size: 1024
    addresses:
    - 172.16.214.22
    - 172.16.214.23
    - 172.16.214.24

  service_plans:
    mysql:
      "100":
        description: "Shared server, shared VM, 1MB memory, 10MB storage, 10 connections"
        free: true
        job_management:
          high_water: 900
          low_water: 100
        configuration:
          capacity: 500
          max_db_size: 10
          key_buffer: 512
          innodb_buffer_pool_size: 512
          max_allowed_packet: 16
          thread_cache_size: 128
          query_cache_size: 128
          max_long_query: 3
          max_long_tx: 30
          max_clients: 10
          max_connections: 1000
          table_open_cache: 2000
          innodb_tables_per_database: 50
          connection_pool_size:
            min: 5
            max: 10
          backup:
            enable: true
          lifecycle:
            enable: true
            serialization: enable
            snapshot:
              quota: 1
          warden:
            enable: false
    postgresql:
      "100":
        description: "Shared server, shared VM, 1MB memory, 10MB storage, 10 connections"
        free: true
        job_management:
          high_water: 900
          low_water: 100
        configuration:
          capacity: 500
          max_db_size: 10
          max_long_query: 3
          max_long_tx: 10
          max_clients: 10
          max_connections: 1000
          shared_buffers: 320
          effective_cache_size: 1142
          shmmax: 397410304
          checkpoint_segments: 16
          checkpoint_segments_max: 50
          maintenance_work_mem: 30
          backup:
            enable: true
          lifecycle:
            enable: true
            serialization: enable
            snapshot:
              quota: 1
          warden:
            enable: false
    mongodb:
      "100":
        description: "Dedicated server, shared VM, 250MB storage, 10 connections"
        free: true
        job_management:
          high_water: 230
          low_water: 20
        configuration:
          capacity: 125
          max_clients: 10
          quota_files: 4
          quota_data_size: 240
          enable_journaling: true
          backup:
            enable: true
          lifecycle:
            enable: true
            serialization: enable
            snapshot:
              quota: 1
    redis:
      "100":
        description: "Dedicated server, shared VM, 20MB memory, 50 connections"
        free: true
        job_management:
          high_water: 410
          low_water: 40
        configuration:
          capacity: 220
          max_memory: 20
          memory_overhead: 20
          max_clients: 50
          persistent: true
          backup:
            enable: true
          lifecycle:
            enable: true
            serialization: enable
            snapshot:
              quota: 1
    rabbit:
      "100":
        description: "Dedicated server, shared VM, 1MB messages/day, 10 connections"
        free: true
        job_management:
          high_water: 280
          low_water: 20
        configuration:
          capacity: 150
          max_disk: 10
          max_clients: 10
          vm_memory_high_watermark: 0.00587
          free_disk_low_water: 0.01832
          bandwidth_quotas:
            per_day: 1
            per_second: 0.01
          filesystem_quota: true

  serialization_data_server:
    upload_token: asdf9asd9asd9ad9ads9ads
    use_nginx: true
    upload_timeout: 10
    port: 8080
    upload_file_expire_time: 600
    purge_expired_interval: 30

  service_backup:
    nfs_server:
      address: 172.16.214.20
      export_dir: /var/vcap/store/shared

  service_migration:
    nfs_server:
      address: 172.16.214.20
      export_dir: /var/vcap/store/shared

  service_backup_manager:
    enable: true

  service_snapshot_manager:
    enable: true

  service_job_manager:
    # enable: true

  service_lifecycle:
    download_url: service-serialization.cf.your.domain.com
    mount_point: /var/vcap/service_lifecycle
    tmp_dir: /var/vcap/service_lifecycle/tmp_dir
    resque:
      host: 172.16.214.82
      port: 3456
      password: sfgasdgfasdfg
    nfs_server:
      address: 172.16.214.20
      export_dir: /var/vcap/store/shared
    serialization_data_server:
    - 172.16.214.92

  mysql_gateway:
    token: uiasdfkasdfophasdfkjadsf
    default_plan: "100"
    supported_versions: ["5.5"]
    version_aliases:
      current: "5.5"
    cc_api_version: v2
  mysql_node:
    password: adfsadfsadsv
    supported_versions: ["5.5"]
    default_version: "5.5"
    max_tmp: 1024

  redis_gateway:
    token: u9sadfy9adfspsadonjasdfhjopadfs
    default_plan: "100"
    supported_versions: ["2.6"]
    version_aliases:
      current: "2.6"
    cc_api_version: v2
  redis_node:
    command_rename_prefix: foobar
    supported_versions: ["2.6"]
    default_version: "2.6"

  mongodb_gateway:
    token: asdfasdfadfs090uadsf9fsrg
    default_plan: "100"
    supported_versions: ["2.2"]
    version_aliases:
      current: "2.2"
    cc_api_version: v2
  mongodb_node:
    supported_versions: ["2.2"]
    default_version: "2.2"
    max_tmp: 900

  rabbit_gateway:
    token: asdfuiasdfojiasdfjosadfjks
    default_plan: "100"
    supported_versions: ["2.8"]
    version_aliases:
      current: "2.8"
    cc_api_version: v2
  rabbit_node:
    supported_versions: ["2.8"]
    default_version: "2.8"

  postgresql_gateway:
    token: asdfg0uadsfophiasdfhophoads
    supported_plan: "100"
    supported_versions: ["9.1"]
    version_aliases:
      current: "9.1"
    cc_api_version: v2
  postgresql_node:
    supported_versions: ["9.1"]
    default_version: "9.1"
    password: puafsp0uadfsophdsafjoidfs

  syslog_aggregator:
    address: 172.16.214.13
    port: 54321

  uaa:
    catalina_opts: -Xmx768m -XX:MaxPermSize=256m
    url: http://uaa.cf.your.domain.com
    resource_id: account_manager
    client_secret: somesecret
    token_secret: tokensecret
    cc:
      token_secret: asdfasdfasdfadfs
      client_secret: asdfasdfasdffth
    admin:
      client_secret: erthth45ydbgaerg
    login:
      client_secret: 457dgnsrgw457sdg
    batch:
      username: sdfgjwetrysdgf
      password: 235dshsbsdgssd
    client:
      override: true
      autoapprove:
        - vmc
        - my
        - portal
        - micro
        - support-signon
        - login
    clients:
      dashboard:
        secret: w4ydbsbJUetdrgdsg
        scope: openid,dashboard.user
        authorities: uaa.admin,uaa.resource,tokens.read,scim.read,scim.write
        authorized-grant-types: client_credentials,authorization_code,refresh_token
      portal:
        override: true
        id: portal
        scope: scim.write,scim.read,openid,cloud_controller.read,cloud_controller.write
        authorities: scim.write,scim.read,openid,cloud_controller.read,cloud_controller.write,password.write,uaa.admin
        secret: portalsecret
        authorized-grant-types: authorization_code,client_credentials,password,implicit
        access-token-validity: 1209600
        refresh-token-validity: 1209600
      support-services:
        scope: scim.write,scim.read,openid,cloud_controller.read,cloud_controller.write
        secret: ssosecretsso
        id: support-services
        authorized-grant-types: authorization_code,client_credentials
        redirect-uri: http://support-signon.cf.your.domain.com
        authorities: portal.users.read
        access-token-validity: 1209600
        refresh-token-validity: 1209600
      vmc:
        override: true
        authorized-grant-types: implicit
        authorities: uaa.none
        redirect-uri: http://uaa.cloudfoundry.com/redirect/vmc,https://uaa.cloudfoundry.com/redirect/vmc
        scope: cloud_controller.read,cloud_controller.write,openid,password.write,cloud_controller.admin,scim.read,scim.write
    scim:
      users:
      - your-admin@your-org.com|your-admin-password|scim.write,scim.read,openid,cloud_controller.admin
      - dash-user|dash-password|openid,dashboard.user
~~~

