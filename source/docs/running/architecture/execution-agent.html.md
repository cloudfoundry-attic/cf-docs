---
title: Droplet Execution Agent
description: Manages the lifecycle of an application instance. Tracks started instances and broadcasts state messages. 
---

The key functions of a Droplet Execution Agent (DEA) are:

* Manage Warden containers --- The DEA stages applications and runs applications in [Warden](warden.html) containers.

* Stage applications --- When a new application or a new version of an application is pushed to Cloud Foundry, the Cloud Controller selects a DEA from the pool of available DEAs to stage the application. The DEA uses the appropriate buildpack to stage the application --- the result of this process is a droplet. 

* Run droplets --- A DEA manages the lifecycle of each application instance running in it, starting and stopping droplets upon request of the [Cloud Controller](./cloud-controller.html). The DEA monitors the state of a started application instance, and periodically broadcasts application state messages over [NATS](./messaging-nats.html) for consumption by the [Health Manager](./health-manager.html). 


## <a id='directory-server'></a>Directory Server ##

When the DEA receives requests for directories and files, it redirects them to the Directory Server URL. The URL is signed by the DEA, and the Directory Server checks the validity of the URL with the DEA before serving it.  

Configurable Directory Server behaviors are controlled by keys in the DEA's configuration file, `dea.yml`, described below in [DEA Configuration](#dea-configuration). 

The Directory Server is written in Go and can be found in the `go/` directory of the DEA source code repository. It is a replacement for the older directory server that was embedded in the DEA itself.

## <a id='health-checks'></a> DEA Health Checks ##

A DEA periodically checks the health of the applications running in it.

If a URL is mapped to an application, the DEA attempts to connect to the port assigned to the application. If the application port is accepting connections, the DEA will consider that application state to be "Running". If there is no URL mapped to the application, the DEA checks the system process table for the application's process PID; if the PID exists, the DEA will consider that application state to be "Running". 

The DEA also checks for a `AppState` object for the application.


## <a id='usage'></a>Usage ##

You can run the dea executable at the command line by passing the path to the DEA configuration file:

<pre class="terminal">
$ bin/dea config/dea.yml
</pre>

## <a id='dea-configuration'></a>DEA Configuration ##


DEA behavior is configured in `dea.yml`. 

The following is a partial list of the keys that are read from the YAML file:

* `logging` --- A [Steno configuration](http://github.com/cloudfoundry/steno#from-yaml-file).
* `nats_uri` --- A URI of the form `nats://host:port` that the DEA will use to connect to NATS.
* `warden_socket` --- The path to a unix domain socket that the DEA will use to communicate to a warden server.


A sample `dea.yml` file follows:

**Note:**  See https://github.com/cloudfoundry/dea_ng/blob/master/lib/dea/config.rb for optional configuration keys.


``` 

# See src/lib/dea/config.rb for optional config values.

# Base directory for dea, application directories, dea temp files, etc. are all relative to this.
base_dir: /tmp/dea_ng

logging:
  level: debug

resources:
  memory_mb: 2048
  memory_overcommit_factor: 2
  disk_mb: 2048
  disk_overcommit_factor: 2

nats_uri: nats://localhost:4222/

pid_filename: /tmp/dea_ng.pid

warden_socket: /tmp/warden.sock

evacuation_delay_secs: 10

index: 0

staging:
  enabled: true
  platform_config:
    cache: /var/vcap/data/stager/package_cache/ruby
  environment:
    PATH: /usr/local/ruby/bin
    BUILDPACK_CACHE: /var/vcap/packages/buildpack_cache
  memory_limit_mb: 1024
  disk_limit_mb: 2048
  max_staging_duration: 900 # 15 minutes

dea_ruby: /usr/bin/ruby

# For Go-based directory server
directory_server:
  v1_port: 4385
  v2_port: 5678
  file_api_port: 1234
  streaming_timeout: 10
  logging:
    level: info

stacks:
  - lucid64

# Hook scripts for droplet start/stop
# hooks:
#   before_start: path/to/script
#   after_start: path/to/script
#   before_stop: path/to/script
#   after_stop: path/to/script
## <a id='run-standalone'></a>Running the DEA Standalone ##

```

When contributing to DEA it is useful to run it as a standalone component. This section has instructions for doing so on Vagrant 1.1x.

Refer to the [Vagrant documentation](http://docs.vagrantup.com/v2/installation/index.html) for instructions on installing Vagrant.

Follow these steps to set up DEA to run locally on your computer:

<pre class="terminal">
$ git clone http://github.com/cloudfoundry/dea_ng
$ bundle install

# check that your version of vagrant is 1.1 or greater
$ vagrant --version

# create your test VM
$ rake test_vm
</pre>

VM creation is likely to take a while.

If the `rake test_vm` step fails and you see an error similar to "undefined method 'configure' for Vagrant" or "found character that cannot start any token while scanning for the next token", you are using a unsupported version of Vagrant. Install Vagrant version 1.1 or higher.

<pre class="terminal">
# initialize the test VM
$ vagrant up

# shell into the VM
$ vagrant ssh

# start warden
$ cd /warden/warden
$ bundle install
$ rvmsudo bundle exec rake warden:start[config/test_vm.yml] > /tmp/warden.log &

# start the DEA's dependencies
$ cd /vagrant
$ bundle install
$ git submodule update --init
$ foreman start > /tmp/foreman.log &

# run the dea tests
$ bundle exec rspec
</pre>

## <a id='run-standalone'></a>Staging ##

See the [How Applications Are Staged](./how-applications-are-staged.html) page for a description of the application staging flow used by DEA.

These are the stating messages that a DEA publishes on NATS: 

- `staging.advertise` --- Stagers (now DEA's) broadcast their capacity/capability

- `staging.locate` --- Stagers respond to any message on this subject with a
  `staging.advertise` message (CC uses this to bootstrap)

- `staging.<uuid>.start` --- Stagers respond to requests on this subject to stage applicationss

- `staging` --- Stagers (in a queue group) respond to requests to stage an application
  (old protocol)

## <a id='logs'></a>Logs

The DEA's logging is handled by [Steno](https://github.com/cloudfoundry/steno).  The DEA can be configured to log to a file, a syslog server or both. If neither is provided, it will log to its stdout. The logging level specifies the verbosity of the logs (e.g. `warn`, `info`, `debug`).

