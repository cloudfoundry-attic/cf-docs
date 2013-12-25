---
title: BOSH Example Manifest
---

This is an example manifest for deploying BOSH via Micro BOSH. The next step would be to deploy Cloud Foundry, which uses the [Cloud Foundry Example Manifest](./cloud-foundry-example-manifest.html).

    ---
    name: example1
    director_uuid: 729b6100-4035-4b35-ab9a-cf8299719fe3
    release:
      name: bosh
      version: 11 # change this when the version of BOSH changes

    networks:
    # all of these settings depend on your own infrastructure setup
    - name: default
      subnets:
      - range: 172.20.128.0/21
        reserved:
        - 172.20.128.2 - 172.20.134.47
        - 172.20.134.64 - 172.20.135.254
        static:
        - 172.20.134.48 - 172.20.134.56
        gateway: 172.20.128.1
        dns:
        - 172.22.22.153 # use your own DNS server IP
        - 172.22.22.154 # here too :)
        cloud_properties:
          name: VLAN1234 #the VLAN that you are deploying BOSH to - provisioned on your vCenter

    resource_pools:
    - name: small
      stemcell:
        name: bosh-vsphere-esxi-ubuntu
        version: latest
      network: default
      size: 5
      cloud_properties:
        ram: 512
        disk: 2048
        cpu: 1
    - name: director
      stemcell:
        name: bosh-vsphere-esxi-ubuntu
        version: latest
      network: default
      size: 1
      cloud_properties:
        ram: 2048
        disk: 8192
        cpu: 2

    compilation:
      workers: 6
      network: default
      cloud_properties:
        ram: 2048
        disk: 4048
        cpu: 4

    update:
      canaries: 1
      canary_watch_time: 60000
      update_watch_time: 60000
      max_in_flight: 1

    jobs:

    - name: nats
      template: nats
      instances: 1
      resource_pool: small
      networks:
      - name: default
        static_ips:
        - 172.20.134.49

    - name: postgres
      template: postgres
      instances: 1
      resource_pool: small
      persistent_disk: 2048
      networks:
      - name: default
        static_ips:
        - 172.20.134.50

    - name: redis
      template: redis
      instances: 1
      resource_pool: small
      networks:
      - name: default
        static_ips:
        - 172.20.134.51

    - name: director
      template: director
      instances: 1
      resource_pool: director
      persistent_disk: 2048
      networks:
      - name: default
        static_ips:
        - 172.20.134.52

    - name: blobstore
      template: blobstore
      instances: 1
      resource_pool: small
      persistent_disk: 20480
      networks:
      - name: default
        static_ips:
        - 172.20.134.53

    - name: health_monitor
      template: health_monitor
      instances: 1
      resource_pool: small
      networks:
      - name: default
        static_ips:
        - 172.20.134.48

    properties:
      env:

      blobstore:
        address: 172.20.134.53
        port: 25251
        backend_port: 25552
        agent:
          user: agent # this creates a read only user for BOSH agents
          password: AgenT # this creates a password for BOSH agents
        director:
          user: director # this creates a read / write user for the BOSH Director
          password: DirectoR # this creates a password BOSH Director

      networks:
        apps: default
        management: default

      nats:
        user: nats
        password: your-nats-password
        address: 172.20.134.49
        port: 4222

      postgres:
        user: bosh
        password: your-postgres-password
        address: 172.20.134.50
        port: 5432
        database: bosh

      redis:
        address: 172.20.134.51
        port: 25255
        password: your-redis-password

      director:
        name: your-director
        address: 172.20.134.52
        port: 25555
        encryption: false
        db:
          user: bosh
          password: your-postgres-password
          host: 172.20.134.50

      hm:
        http:
          port: 25923
          user: admin #can be whatever
          password: admin # can be whatever
        director_account:
          user: admin # can be whatever
          password: admin # can be whatever
        intervals:
          poll_director: 60
          poll_grace_period: 30
          log_stats: 300
          analyze_agents: 60
          agent_timeout: 180
          rogue_agent_alert: 180
        loglevel: info
        email_notifications: false # if this is false you don't need to worry about the smtp section below
        email_recipients:
        - your-operations-team@your-company.com
        smtp:
          from: bhm@yourdomain
          host: smtp.your.domain
          port: 25
          auth: plain
          user: your-smtp-user
          password: your-smtp-password
          domain: localdomain
        tsdb_enabled: false # it this is false you don't have to worry about the tsdb settings. Plus you can't set it to true until you have a complete Cloud Foundry running.
        tsdb:
          address: 172.20.218.14 # opentsdb static IP from your Cloud Foundry deploy (optional)
          port: 4242

      vcenter: # must match your vCenter info
        address: vcenter.your.domain # IP or FQDN of vCenter
        user: domain\bosh-user # user name provisioned for BOSH
        password: bosh-password # passowrd for BOSH
        datacenters:
          - name: CF
            vm_folder: CF_VMs
            template_folder: CF_Templates
            disk_path: CF_Disks
            datastore_pattern: datastore.*
            persistent_datastore_pattern: datastore.*
            allow_mixed_datastores: true
            clusters:
            - BOSH_Cluster:
                resource_pool: CloudFoundry
