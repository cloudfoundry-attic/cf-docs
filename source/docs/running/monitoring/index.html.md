---
title: Monitoring
---

How to Monitor a Cloud Foundry Installation (coming soon)

## How Cloud Operators can navigate to a specific app running in a Warden container

### pre-req BOSH setup

- Target a deployment
- bosh target ...

### instructions for finding out the host:port list for a running app:

- bosh vms and find a router ip
- ssh ip
- curl 127.0.0.1:23456 and you should get the routing table returned, the port could vary by configuration, details in https://github.com/cloudfoundry/gorouter/commit/b0aad822d2b6c005e249e391e4e0a38497c3e23c

### instructions for listening to NATS for a new app instance registration:

- set NATS env 
- nats-sub 'router.register' -s $NATS
-- has ip, port, name
-- the ip is the dea ip and port is port app is on

### going to the warden container of an app once you have the ip:port 

- ssh ip, (need a tool to parse /var/vcap/data/dea_next/db/instances.json on port or name)
-- the warden handle in the same json hash as the name/port
-- construct a bash wsh cli and exec
--- you're in the warden