---
title: Execution Agent (DEA)
---

The DEA is written in Ruby and takes care of managing an application instance's lifecycle. It can be instructed by the [Cloud Controller](./cloud-controller.html) to start and stop application instances. It keeps track of all started instances, and periodically broadcasts messages about their state over [NATS](./messaging-nats.html) (meant to be picked up by the [Health Manager](./health-manager.html)).

The advantages of this generation of the DEA over the previous (and first) generation DEA is that is more modular and has better test coverage. A breaking change between the two is that this version of the DEA depends on [Warden](./warden.html) to run application instances.

### Directory server

The directory server is written in Go and can be found in the `go/` directory of the DEA source code repository. It is a replacement for the older directory server that was embedded in the DEA itself.

Requests for directories/files are handled by the DEA, which responds with a HTTP redirect to a URL that hits the directory server directly.  The URL is signed by the DEA, and the directory server checks the validity of the URL with the DEA before serving it.

## Usage

You can run the dea executable at the command line by passing the path to a YAML configuration file:

<pre class="terminal">
$ bin/dea config/dea.yml
</pre>

### Configuration

The following is a partial list of the keys that are read from the YAML file:

* `logging` - a [Steno configuration](http://github.com/cloudfoundry/steno#from-yaml-file)
* `nats_uri` - a URI of the form `nats://host:port` that the DEA will use to connect to NATS.
* `warden_socket` - the path to a unix domain socket that the DEA will use to communicate to a warden server.

### Running the DEA in the provided Vagrant VM

When contributing to DEA it is useful to run it as a standalone component. This test configuration uses Vagrant 1.1x.

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

Creating the test VM is likely to take a while.

Note that if the `rake test_vm` step fails and you see an error like "undefined method 'configure' for Vagrant" or "found character that cannot start any token while scanning for the next token" it means the version of Vagrant is too old. Install Vagrant version 1.1 or higher.

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

## Staging

See the [How Applications Are Staged](./how-applications-are-staged.html) page for a description of the application staging flow used by DEA.

### NATS Messaging

These are the messages that DEA will publish on NATS: 

- `staging.advertise`: Stagers (now DEA's) broadcast their capacity/capability

- `staging.locate`: Stagers respond to any message on this subject with a
  `staging.advertise` message (CC uses this to bootstrap)

- `staging.<uuid>.start`: Stagers respond to requests on this subject to stage apps

- `staging`: Stagers (in a queue group) respond to requests to stage an app
  (old protocol)

## Logs

The DEA's logging is handled by [Steno](https://github.com/cloudfoundry/steno).  The DEA can be configured to log to a file, a syslog server or both. If neither is provided, it will log to its stdout. The logging level specifies the verbosity of the logs (e.g. `warn`, `info`, `debug`).

