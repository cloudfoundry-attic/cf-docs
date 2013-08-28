---
title: Troubleshooting Wardenized Services
---

## <a id="intro"></a>Introduction

This document shows how to debug a Wardenized service in a development or production environment.

## <a id=""></a>Debugging

This section includes the following topics, with corresponding examples:

* Checking the status of Warden server
* Checking the log and config of Warden
* Looking into a Warden container
* Service instance logs, data and localdb

### <a id="check-status"></a>Checking Status of Warden Server

The status of a Warden server is monitored by monit. You can see the Warden server status by using the `monit status` command:

<pre class="terminal">
$ monit status
The Monit daemon 5.2.4 uptime: 1d 1h 8m

Process 'warden'
status                            running
monitoring status                 monitored
pid                               4621
parent pid                        1
uptime                            1d 1h 7m
children                          8
memory kilobytes                  37112
memory kilobytes total            41708
memory percent                    0.2%
memory percent total              0.2%
cpu percent                       0.1%
cpu percent total                 0.1%
unix socket response time         0.000s to /tmp/warden.sock [DEFAULT]
data collected                    Tue Jan  8 07:11:52 2013
...
</pre>

If the Warden server is running normally, you can see the server status using `ps` and `grep`:

<pre class="terminal">
$ ps aux | grep warden
root      4621  0.1  0.2 125448 36644 ?        Sl   Jan07   2:37 ruby /var/vcap/data/packages/redis_node_ng/12.2-dev.1/warden/vendor/bundle/ruby/1.9.1/bin/rake warden:start[/var/vcap/jobs/redis_node_ng/config/warden.yml]
root      5342  0.0  0.0   5984   316 ?        S    06:43   0:00 /var/vcap/data/packages/redis_node_ng/12.2-dev.1/warden/src/oom/oom /sys/fs/cgroup/memory/instance-16io51f6jri
root      5592  0.0  0.0   5984   316 ?        S    06:43   0:00 /var/vcap/data/packages/redis_node_ng/12.2-dev.1/warden/src/oom/oom /sys/fs/cgroup/memory/instance-16io51f6jrj
root     15849  0.0  0.0   7688   844 pts/1    S+   07:10   0:00 grep --color=auto warden
</pre>

### <a id="check-log"></a>Checking the log and config of Warden

The config file of Warden is normally found at `/var/vcap/jobs/foo_node_ng/config/warden.yml`:

<pre class="terminal">
$ cat /var/vcap/jobs/redis_node_ng/config/warden.yml
---
server:
container_klass: Warden::Container::Linux
container_grace_time: ~
container_rootfs_path: /var/vcap/data/warden/rootfs
container_depot_path: /var/vcap/store/containers
unix_domain_permissions: 0777
container_rlimits:
  nofile: 2000
  # Redis-server forks a process to do dump,
  # so also increase the maximum number of processes,
  # the default limitation is 1024
  nproc: 2000
quota:
  disk_quota_enabled: false
logging:
file: /var/vcap/sys/log/warden/warden.log  
syslog: vcap.services.redis.warden
level: debug
network:
pool_start_address: 10.254.0.0
pool_size: 4096
user:
pool_start_uid: 10000
pool_size: 4096
</pre>

The rootfs and container depot position is labelled in yellow and they could offer some information on debugging. The Warden log is labelled in green and it records whether the Warden server started correctly and how it handled incoming requests. The socket that the Warden server listens on is found at `/tmp/warden.sock`.

Warden uses [Steno](https://github.com/cloudfoundry/steno) for logging. You can use `steno-prettify` to make it more human readable. `steno-prettify` is a gem that is installed with Warden so you can use it without additional installation after going into the `warden` directory:

<pre class="terminal">
$ bundle exec steno-prettify /var/vcap/sys/log/warden/warden.log
2013-01-07 06:04:04.743379 Warden::Server pid=4621  tid=5798 fid=ee62 warden/server.rb/run!:240    DEBUG -- rlimit_nofile: 1024 => 32768
2013-01-07 06:04:05.372339 Warden::Container::Linux pid=4621  tid=5798 fid=ee62 container/spawn.rb/set_deferred_success:131    DEBUG -- Exited with status 0 (0.626s): [["/var/vcap/data/packages/redis_node_ng/12.2-dev.1/warden/src/closefds/closefds", "/var/vcap/data/packages/redis_node_ng/12.2-dev.1/warden/src/closefds/closefds"], "/var/vcap/data/packages/redis_node_ng/12.2-dev.1/warden/root/linux/setup.sh"]
2013-01-07 06:04:05.373243 Warden::Server pid=4621  tid=5798 fid=2add warden/server.rb/block (2 levels) in run!:282     INFO -- Listening on /tmp/warden.sock, and ready for action.
2013-01-07 06:04:21.776618 Warden::Server::Drainer pid=4621  tid=5798 fid=ee62 warden/server.rb/register_connection:53    DEBUG -- Connection registered: #<Warden::Server::ClientConnection:0x000000028fd7c8>
2013-01-07 06:04:21.777053 Warden::Server::Drainer pid=4621  tid=5798 fid=ee62 warden/server.rb/unregister_connection:60    DEBUG -- Connection unregistered: #<Warden::Server::ClientConnection:0x000000028fd7c8>
2013-01-07 06:04:31.784353 Warden::Server::Drainer pid=4621  tid=5798 fid=ee62 warden/server.rb/register_connection:53    DEBUG -- Connection registered: #<Warden::Server::ClientConnection:0x000000028e8df0>
2013-01-07 06:04:31.950572 Warden::Server::Drainer pid=4621  tid=5798 fid=ee62 warden/server.rb/unregister_connection:60    DEBUG -- Connection unregistered: #<Warden::Server::ClientConnection:0x000000028e8df0>
...
</pre>

You can also redirect the prettified log to a file to make it easier for navigation.

### <a id="looking"></a>Looking into a Warden container

You can use the Warden client to talk to existing Warden containers and perform operations. The Warden client normally sits in `/path_to_warden_packages/bin/warden`:

<pre class="terminal">
$ ./bin/warden
warden> list
handles[0] : 16io51f6jri
handles[1] : 16io51f6jrj
</pre>

The Warden container is identified by its handle on a single node. You can run a script to get information in a Warden container:

<pre class="terminal">
$ ./bin/warden
warden> run --handle 16io51f6jri --script "echo hello world"
hello world
...
</pre>

In order to run operations with root privileges, you can use the `--privileged` option:

<pre class="terminal">
$ ./bin/warden
warden> run --handle 16io51f6jri --script "sudo echo hello world" --privileged
hello world
...
</pre>

The `help` option will give you more information on how to run a command or script within a Warden container.

There are other ways to check whether the process is running. For example, given that you have a container with handle `16io51f6jri` running `redis-server`, you can find the corresponding process tree:

<pre class="terminal">
$ ps auxf
...
root      5291  0.0  0.0  14564   496 ?        S    06:43   0:00 wshd: 16io51f6jri                                                        
10000     5351  0.0  0.0  17708  1220 ?        Ss   06:43   0:00  \_ /bin/bash
10000     5353  0.1  0.0  36220  1772 ?        Sl   06:43   0:12      \_ /var/vcap/packages/redis26/bin/redis-server /var/vcap/store/redis/instances/9407af2c-0628-484b-a5f8-5c8634421a35/redis.conf
...
</pre>

and

<pre class="terminal">
$ pstree -p 5291
wshd(5291)───bash(5351)───redis-server(5353)─┬─{redis-server}(5362)
                                             └─{redis-server}(5363)
</pre>

Its corresponding PID of `wshd` will be put into the corresponding Warden depot directory:

<pre class="terminal">
$ cat /var/vcap/store/containers/16io51f6jri/run/wshd.pid
5291
</pre>

### <a id="service-data"></a>Service instance logs, data and localdb

The data of the service sits in `/var/vcap/store/#{service_name}/instances/#{uuid}`:

<pre class="terminal">
$ ls /var/vcap/store/redis/instances/
2b4e0275-7da1-4da7-88c1-7c907b6b1b8c  5e8bbae6-2c3d-429e-bec7-a5b695d2c4f4
</pre>

The instance data directory normally contains the service PID, data directory and the instance specific config file. The log file of the instance sits in `/var/vcap/sys/service-log/#{service_name}/#{uuid}`:

<pre class="terminal">
$ ls /var/vcap/sys/service-log/redis/
2b4e0275-7da1-4da7-88c1-7c907b6b1b8c  5e8bbae6-2c3d-429e-bec7-a5b695d2c4f4
</pre>

Besides the service log, this directory also contains the `warden_service_ctl.log` and `warden_service_ctl.err.log`. `warden_service_ctl` is a script that controls the start, stop and status of the service instance.

The local sqlite database also includes valuable information for debugging issues with a service instance. The local sqlite database sits in `/var/vcap/store/#{service_name}/#{service_node.db}`. You can use the pre-installed `sqlite3` binary to look into the sqlite database:

<pre class="terminal">
$ /var/vcap/packages/sqlite/bin/sqlite3 /var/vcap/store/redis/redis_node.db
SQLite version 3.7.5
Enter ".help" for instructions
Enter SQL statements terminated with a ";"

sqlite> .table
vcap_services_redis_node_provisioned_services

sqlite> PRAGMA table_info(vcap_services_redis_node_provisioned_services);
0|name|VARCHAR(50)|1||1
1|port|INTEGER|0||0
2|password|VARCHAR(50)|1||0
3|plan|INTEGER|1||0
4|pid|INTEGER|0||0
5|memory|INTEGER|0||0
6|container|VARCHAR(50)|0||0
7|ip|VARCHAR(50)|0||0
8|version|VARCHAR(50)|0||0

sqlite> select * from vcap_services_redis_node_provisioned_services;
5e8bbae6-2c3d-429e-bec7-a5b695d2c4f4|5000|0508e659-c6d0-4d6f-b64f-4ab1049984c7|1|0|20|16j9dohgvks|10.254.0.2|2.6
2b4e0275-7da1-4da7-88c1-7c907b6b1b8c|5001|cd189a0e-144c-44fa-8e36-281c38e52e5c|1|0|20|16j9dohgvkt|10.254.0.6|2.6
</pre>

Some useful operations are listed above to show the table name, schema and values with the table that is used by the service node. The start, stop, and check_status operations on the instance are all done by the `warden_service_ctl` script. On the node, it sits in `/var/vcap/store/#{service_name}_common/bin`:

<pre class="terminal">
$ ls /var/vcap/store/redis_common/bin/
utils.sh  warden_service_ctl
</pre>

Service node code will use the `warden_service_ctl` script to start, stop, and ping the status of the service instance. You can also use the script manually with Warden client to start and stop the instance but it is dangerous to do that manually.

## <a id="services"></a>Service specific issue

### <a id="services-mongo"></a>MongoDB proxy

MongoDB has a corresponding proxy and they won’t be able to work without it. Mongodb will have their proxy running within Warden:

<pre class="terminal">
$ cat /var/vcap/store/containers/16iod87tbpe/run/wshd.pid
2398
$ pstree -p 2398
wshd(2398)───bash(2457)───mongod(2459)─┬─proxyctl(2470)─┬─{proxyctl}(2472)
                                       │                ├─{proxyctl}(2473)
                                       │                ├─{proxyctl}(2474)
                                       │                └─{proxyctl}(2475)
                                       ├─{mongod}(2497)
                                       ├─{mongod}(2499)
                                       ├─{mongod}(2500)
                                       ├─{mongod}(2501)
                                       ├─{mongod}(2502)
                                       ├─{mongod}(2503)
                                       ├─{mongod}(2504)
                                       └─{mongod}(2505)
</pre>

### <a id="services-rabbit"></a>RabbitMQ daylimit daemon

RabbitMQ has a daylimit daemon to monitor the bandwidth outside Warden container (monitored by monit) and it will take care of the bandwidth of each RabbitMQ instance. A RabbitMQ instance will be able to work without the daylimit daemon, while the daylimit daemon will block an instance when the throughput reaches its day limit.

