---
title: Deploying Micro BOSH
---

Installation of BOSH is done using micro BOSH, which is a single VM that includes all of the BOSH components. If you want to play around with BOSH, or create a simple development setup, you can install micro BOSH using the BOSH Deployer. If you would like to use BOSH in production to manage a distributed system, you also use the BOSH Deployer, install micro BOSH, and then use it as a means to deploy the final distributed system on multiple VMs.

A good way to think about this two step process is to consider that BOSH is a distributed system in itself. Since BOSH's core purpose is to deploy and manage distributed systems, it makes sense that we would use it to deploy itself. On the BOSH team, we gleefully refer to this as [Inception](http://en.wikipedia.org/wiki/Inception).


## <a id="prerequisites"></a>Prerequisites ##

WIP

## <a id="deploy_microbosh"></a>Deploying Micro Bosh ##

### <a id="manifest_file"></a>Create manifest file ###

Create a `deployments` directory to store your deployment manifest files:

    mkdir -p ~/bosh-workspace/deployments/microbosh-openstack
    cd ~/bosh-workspace/deployments/microbosh-openstack

Create a `micro_bosh.yml` file and copy the below content:


~~~yaml
---
name: microbosh-openstack

logging:
  level: DEBUG

network:
  type: manual
  vip: <allocated_floating_ip> # Optional  
  ip: <static_ip>
  cloud_properties:
    net_id: <network_uuid>
    
resources:
  persistent_disk: 16384
  cloud_properties:
    instance_type: <flavor_name>

cloud:
  plugin: openstack
  properties:
    openstack:
      auth_url: http://<identity_server>:5000/v2.0 
      username: <username>
      api_key: <password> 
      tenant: <tenant>
      region: <region> # Optional
      default_security_groups: ["default", <microbosh_security_group>]
      default_key_name: <keypair_name>
      private_key: <path_to_keypar_private_key>

apply_spec:
  properties:
    director:
      max_threads: 3
    ntp:
      - 0.north-america.pool.ntp.org
      - 1.north-america.pool.ntp.org
~~~

Adapt the `micro_bosh.yml` file to your environment settings:

#### <a id="network_properties"></a>Network properties ####

This section sets the network configuration for your Micro Bosh. 

If you are using nova-network, adapt the network section with below settings:

~~~yaml
network:
  type: dynamic
  vip: <allocated_floating_ip> # Optional
~~~        

* The `vip` option is optional, and allows you to associate a floating IP adress to the Micro Bosh vm in case you want to access it from outside of the vm network. If set, it **must** be a previously allocated floating ip.

If you are using the new [OpenStack Networking](http://www.openstack.org/software/openstack-networking/) component, adapt the network section with below settings:

1. If your network has DHCP enabled, you can let OpenStack pick an IP address:

~~~yaml
network:
  type: dynamic
  vip: <allocated_floating_ip> # Optional
  cloud_properties:
    net_id: <network_uuid>
~~~ 

* The `vip` option is optional, and allows you to associate a floating IP adress to the Micro Bosh vm in case you want to access it from outside of the vm network. If set, it **must** be a previously allocated floating ip.
* The `net_id` option sets the OpenStack network to use. It **must** be an existing Network UUID (you can list your OpenStack networks using the command `quantum net-list`).

1. If you want to set the Micro Bosh IP address manually: 

~~~yaml
network:
  type: manual
  vip: <allocated_floating_ip> # Optional 
  ip: <static_ip>
  cloud_properties:
    net_id: <network_uuid>
~~~        

* The `vip` option is optional, and allows you to associate a floating IP adress to the Micro Bosh vm in case you want to access it from outside of the vm network. If set, it **must** be a previously allocated floating ip.
* The `static_ip` option sets the IP address to assign to the Micro Bosh vm. It **must** be an IP address belowing to the IP range of one of the network subnets set in `net_id`.
* The `net_id` option sets the OpenStack network to use. It **must** be an existing Network UUID (you can list your OpenStack networks using the command `quantum net-list`).

#### <a id="resources_properties"></a>Resources properties ####

This section sets the resources configuration for your Micro Bosh. 

~~~yaml
resources:
  persistent_disk: 16384
  cloud_properties:
    instance_type: <flavor_name>
~~~ 

* The `persistent_disk` indicates that a new 16Gb volume will be created and attached to the Micro Bosh vm. On this disk, Micro Bosh will store the data, so in case you reboot or when upgrading the Micro Bosh vm, no data will be lost.
* The `instance_type` set the OpenStack flavor used for the Micro Bosh vm. Remember that this flavor **must** have ephemeral disk. 

#### <a id="cloud_properties"></a>Cloud properties ####

This section sets the cloud configuration for your Micro Bosh. 

~~~yaml
cloud:
  plugin: openstack
  properties:
    openstack:
      auth_url: http://<identity_server>:5000/v2.0 
      username: <username>
      api_key: <password> 
      tenant: <tenant>
      region: <region> # Optional
      default_security_groups: ["default", <microbosh_security_group>]
      default_key_name: <keypair_name>
      private_key: <path_to_keypar_private_key>
~~~ 

* The `auth_url` option set your [OpenStack identity](http://www.openstack.org/software/openstack-shared-services/) server.
* The `username`, `api_key` and `tenant` options sets your OpenStack credentials.
* The `region` option is optional, and allows you to set the OpenStack region to be used.
* The `default_security_groups` option set the security groups used by Micro Bosh. The `microbosh_security_group` **must** be an existing security group (check the [prerequisites](#prerequisites) section).
* The `default_key_name` and `private_key` options sets the key pair used by Micro Bosh. The `keypair_name` **must** be an existing keypair (check the [prerequisites](#prerequisites) section).


#### <a id="apply_spec_properties"></a>Apply Spec properties ####

This section sets the specification configuration for your Micro Bosh. 

~~~yaml
apply_spec:
  properties:
    director:
      max_threads: 3
    ntp:
      - 0.north-america.pool.ntp.org
      - 1.north-america.pool.ntp.org
~~~

* The `properties` option allows you to add or override the settings to be applied to your Micro Bosh (by default it will use the [micro](https://github.com/cloudfoundry/bosh/blob/master/release/micro/openstack.yml) apply spec).

In this example we override (`director.max_threads`) and add (`ntp`) properties:

* `director.max_threads` sets the number of concurrent threads Micro Bosh [director](/docs/running/bosh/components/director.html) will use to perform some actions (ie: the number of parallel `create vm` tasks), so set this option according to your OpenStack environment (if not set, the default is 32 concurrent threads). 
* `ntp` sets the [Internet Time Servers](http://www.ntp.org/) to be used to synchronize the clocks of new vms.

### <a id="download_stemcell"></a>Download stemcell ###

Create a `stemcells` directory to store your stemcell files:

    mkdir -p ~/bosh-workspace/stemcells
    cd ~/bosh-workspace/stemcells

Download the latest OpenStack Micro Bosh stemcell:

    wget http://bosh-jenkins-artifacts.s3.amazonaws.com/last_successful_micro-bosh-stemcell-openstack.tgz

### <a id="deploy"></a>Deploy Micro Bosh ###

Set the Micro Bosh deployment file to use:

    cd ~/bosh-workspace/deployments
    bosh micro deployment microbosh-openstack

This command will output:

    WARNING! Your target has been changed to `https://<microbosh_ip_address>:25555'!
    Deployment set to '~/bosh-workspace/deployments/microbosh-openstack/micro_bosh.yml'

Deploy the Micro Bosh:

    bosh micro deploy ~/bosh-workspace/stemcells/last_successful_micro-bosh-stemcell-openstack.tgz
 
This command will output:

    Deploying new micro BOSH instance `microbosh-openstack/micro_bosh.yml' to `https://<microbosh_ip_address>:25555' (type 'yes' to continue): yes
    
    Verifying stemcell...
    File exists and readable                                     OK
    Manifest not found in cache, verifying tarball...
    Read tarball                                                 OK
    Manifest exists                                              OK
    Stemcell image file                                          OK
    Writing manifest to cache...
    Stemcell properties                                          OK
    
    Stemcell info
    -------------
    Name:    micro-bosh-stemcell
    Version: 1.5.0.pre.3
    
    
    Deploy Micro BOSH
      unpacking stemcell (00:00:02)                                                                     
      uploading stemcell (00:00:35)                                                                     
      creating VM from 04a1bdfe-4479-492e-8622-54380032a13a (00:01:21)                                  
      waiting for the agent (00:01:20)                                                                  
      create disk (00:00:05)                                                                            
      mount disk (00:00:14)                                                                             
      stopping agent services (00:00:01)                                                                
      applying micro BOSH spec (00:00:16)                                                               
      starting agent services (00:00:00)                                                                
      waiting for the director (00:00:15)                                                               
    Done                    11/11 00:04:19                                                              
    WARNING! Your target has been changed to `https://<microbosh_ip_address>:25555'!
    Deployment set to '~/bosh-workspace/deployments/microbosh-openstack/micro_bosh.yml'
    Deployed `microbosh-openstack/micro_bosh.yml' to `https://<microbosh_ip_address>:25555', took 00:04:19 to complete

### <a id="troubleshooting"></a>Troubleshooting ###

If for some reason the deploy process gets stucked or fails, you can check the log file located at `~/bosh-workspace/deployments/microbosh-openstack/bosh_micro_deploy.log`:

    # Logfile created on 2013-06-14 13:02:00 +0200 by logger.rb/31641
    I, [2013-06-14T13:02:00.661999 #11533] [0x12b6ff0]  INFO -- : No existing deployments found (will save to /Users/frodenas/deployments/bosh-deployments.yml)
    I, [2013-06-14T13:02:26.993498 #13692] [0x366ff0]  INFO -- : No existing deployments found (will save to /Users/frodenas/deployments/bosh-deployments.yml)
    I, [2013-06-14T13:03:10.489924 #13692] [0x366ff0]  INFO -- : bosh_registry is ready on port 25889
    I, [2013-06-14T13:03:13.135552 #13692] [0x366ff0]  INFO -- : Loading yaml from /tmp/d20130614-13692-15wkgqb/sc-20130614-13692-7eo4zq/stemcell.MF
    I, [2013-06-14T13:03:19.602096 #13692] [create_stemcell(/tmp/d20130614-13692-15wkgqb/sc-20130614-13692-7eo4zq/image...)]  INFO -- : Creating new image...
    I, [2013-06-14T13:03:19.602298 #13692] [create_stemcell(/tmp/d20130614-13692-15wkgqb/sc-20130614-13692-7eo4zq/image...)]  INFO -- : Extracting stemcell file to `/tmp/d20130614-13692-15wkgqb/d20130614-13692-2sfodm'...

    ...

    D, [2013-06-14T13:07:36.134753 #13692] [0x366ff0] DEBUG -- : Waiting for director to be ready: #<Errno::ECONNREFUSED: Connection refused - connect(2) (https://<microbosh_ip_address>:25555)>
    I, [2013-06-14T13:07:36.171820 #13692] [0x366ff0]  INFO -- : Director is ready: {"name"=>"microbosh-openstack", "uuid"=>"fd581363-02cd-41c6-8bed-87780391cff7", "version"=>"1.5.0.pre.3 (release:bef17df0 bosh:bef17df0)", "user"=>nil, "cpi"=>"openstack", "features"=>{"dns"=>
    {"status"=>true, "extras"=>{"domain_name"=>"microbosh"}}, "compiled_package_cache"=>{"status"=>false}}}

## <a id="test_microbosh"></a>Testing your Micro Bosh ##

### <a id="microbosh_target"></a>Set target ###

To set your Micro Bosh target use the `target` command:

    bosh target http://<microbosh_ip_address>

This command will ask for the admin credentials. Enter `admin` when prompted for both `username` and `password`.

    Target set to `microbosh-openstack'
    Your username: admin
    Enter password: *****
    Logged in as `admin'

### <a id="microbosh_create_user"></a>Create a new user ###

To create a new user use the `create user` command:

    bosh create user
    Enter new username: frodenas
    Enter new password: ********
    Verify new password: ********
    User `frodenas' has been created

Then you can login with the new user credentials:

    bosh login
    Your username: frodenas
    Enter password: ********
    Logged in as `frodenas'

### <a id="microbosh_status"></a>Check status ###

To check the status of your Micro Bosh use the `status` command:

    bosh status

This command will output:

    Config
                 /Users/frodenas/.bosh_config
    
    Director
      Name       microbosh-openstack
      URL        https://<microbosh_ip_address>:25555
      Version    1.5.0.pre.3 (release:bef17df0 bosh:bef17df0)
      User       frodenas
      UUID       fd581363-02cd-41c6-8bed-87780391cff7
      CPI        openstack
      dns        enabled (domain_name: microbosh)
      compiled_package_cache disabled
    
    Deployment
      not set

### <a id="microbosh_ssh"></a>SSH ###

You can ssh to your Micro Bosh vm using the private key set at the [cloud properties](#cloud_properties) section of your Micro Bosh deployment file: 

    ssh -i <path_to_keypar_private_key> vcap@<microbosh_ip_address>

Then you can sudo to get root privileges (default password for root user is `c1oudc0w`). All Bosh data is located at `/var/vcap` directory.


## <a id="delete_microbosh"></a>Deleting your Micro Bosh ##

If you want to delete your Micro Bosh environment (vm, persistent disk and stemcell) use the `micro delete` command:

    cd ~/bosh-workspace/deployments
    bosh micro delete

This command will output:

    You are going to delete micro BOSH deployment `microbosh-openstack'.
    
    THIS IS A VERY DESTRUCTIVE OPERATION AND IT CANNOT BE UNDONE!
    
    Are you sure? (type 'yes' to continue): yes
    
    Delete micro BOSH
      stopping agent services (00:00:01)                                                                
      unmount disk (00:00:06)                                                                           
      detach disk (00:00:06)                                                                            
      delete disk (00:02:25)                                                                            
      delete VM (00:00:10)                                                                              
      delete stemcell (00:00:03)                                                                        
    Done                    7/7 00:02:53                                                                
    Deleted deployment 'microbosh-openstack', took 00:02:53 to complete
