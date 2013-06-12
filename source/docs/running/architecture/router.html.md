---
title: (Go)Router
description: Routes incoming traffic to the appropriate component, usually the cloud controller or a running application on a DEA node.
---

The Router routes traffic coming into Cloud Foundry to the appropriate component - usually [Cloud Controller](./cloud-controller.html) or a running application on a [DEA](./execution-agent.html) node. The router is implemented in Go. Implementing a custom router in Go gives full control over every connection to the router, which makes it easier to support WebSockets and other types of traffic (e.g.  via HTTP CONNECT). All routing logic is contained in a single process,
removing unnecessary latency.

## Getting started

The following instructions may help you get started with gorouter in a standalone environment.

### Setup

<pre class="terminal">
$ git clone https://github.com/cloudfoundry/gorouter.git
$ cd gorouter
$ git submodule update --init
$ ./bin/go install router/router
$ gem install nats
</pre>

### Start

<pre class="terminal">
# Start NATS server in daemon mode
$ nats-server -d

# Start gorouter
$ ./bin/router
</pre>

### Usage

When gorouter is used in Cloud Foundry, it receives route updates via [NATS](./messaging-nats.html). Routes that haven't been updated in 2 minutes (by default) are pruned. Therefore, to maintain an active route, it needs to be updated at least every 2 minutes. The format of these route updates are as follows:

~~~json
{
  "host": "127.0.0.1",
  "port": 4567,
  "uris": [
    "my_first_url.vcap.me",
    "my_second_url.vcap.me"
  ],
  "tags": {
    "another_key": "another_value",
    "some_key": "some_value"
  }
}
~~~

Such a message can be sent to both the `router.register` subject to register URIs, and to the `router.unregister` subject to unregister URIs, respectively.

<pre class="terminal">
$ nohup ruby -rsinatra -e 'get("/") { "Hello!" }' &
$ nats-pub 'router.register' '{"host":"127.0.0.1","port":4567,"uris":["my_first_url.vcap.me","my_second_url.vcap.me"],"tags":{"another_key":"another_value","some_key":"some_value"}}'
Published [router.register] : '{"host":"127.0.0.1","port":4567,"uris":["my_first_url.vcap.me","my_second_url.vcap.me"],"tags":{"another_key":"another_value","some_key":"some_value"}}'
$ curl my_first_url.vcap.me:8080
Hello!
</pre>

### Instrumentation

Gorouter provides `/varz` and `/healthz` http endpoints for monitoring.

The `/routes` endpoint returns the entire routing table as JSON. Each route has an associated array of host:port entries.

All of the endpoints require http basic authentication, credentials for which can be acquired through NATS. The `port`, `user` and password (`pass` is the config attribute) can be explicitly set in the gorouter.yml config file's `status` section.

~~~yaml
status:
  port: 8080
  user: some_user
  pass: some_password
~~~

Example interaction with curl:

<pre class="terminal">
$ curl -vvv "http://someuser:somepass@127.0.0.1:8080/routes"
* About to connect() to 127.0.0.1 port 8080 (#0)
*   Trying 127.0.0.1...
* connected
* Connected to 127.0.0.1 (127.0.0.1) port 8080 (#0)
* Server auth using Basic with user 'someuser'
> GET /routes HTTP/1.1
> Authorization: Basic c29tZXVzZXI6c29tZXBhc3M=
> User-Agent: curl/7.24.0 (x86_64-apple-darwin12.0) libcurl/7.24.0 OpenSSL/0.9.8r zlib/1.2.5
> Host: 127.0.0.1:8080
> Accept: */*
> 
< HTTP/1.1 200 OK
< Content-Type: application/json
< Date: Mon, 25 Mar 2013 20:31:27 GMT
< Transfer-Encoding: chunked
< 
{"0295dd314aaf582f201e655cbd74ade5.cloudfoundry.me":["127.0.0.1:34567"],"03e316d6aa375d1dc1153700da5f1798.cloudfoundry.me":["127.0.0.1:34568"]}
</pre>
