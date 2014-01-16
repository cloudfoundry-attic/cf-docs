---
title: Troubleshooting Apps
---

### Retrieve an example backend (internal DEA network host:port) for a
particular URL

Send a X-Vcap-Trace header on your request to an app with the appropriate secret
key, and the router will add a X-Vcap-Backend response header identifying the
DEA that was used to service the request.

The value of the X-Vcap-Trace needs to correspond to the router configuration
"trace\_key" as can be seen in the [router config test](https://github.com/cloudfoundry/gorouter/blob/58f54267c43eb52e01b531ee51281f7d48408f3e/src/router/config/config_test.go#L101). If you are using BOSH, that
value is set using "properties.router.trace\_key".

For example, with curl this would be:

```
$ curl -H 'X-Vcap-Trace: 222' http://app.example.com -v
* About to connect() to app.example.com port 80 (#0)
*   Trying 10.242.15.12...
* connected
* Connected to app.example.com (10.242.15.12) port 80 (#0)
> GET / HTTP/1.1
> User-Agent: curl/7.24.0 (x86_64-apple-darwin12.0) libcurl/7.24.0 OpenSSL/0.9.8r zlib/1.2.5
> Host: app.example.com
> Accept: */*
> X-Vcap-Trace: 22
>
< HTTP/1.1 200 OK
< Content-Length: 40
< Content-Type: text/html;charset=utf-8
< Date: Sat, 16 Mar 2013 14:17:21 GMT
< Server: WEBrick/1.3.1 (Ruby/1.9.2/2012-04-20)
< X-Content-Type-Options: nosniff
< X-Frame-Options: SAMEORIGIN
< X-Vcap-Backend: 10.242.15.233:61003
< X-Vcap-Router: 10.242.15.86
< X-Xss-Protection: 1; mode=block
```
The response shows the IP of the router in the X-Vcap-Router header and the
IP:HOST of the backend DEA that responded to this request in the X-Vcap-Backend
header.

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
