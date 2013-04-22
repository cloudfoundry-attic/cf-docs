---
title: Custom Domains
---

## <a id='overview'></a>Custom Domains Overview ##

Cloud Foundry v2 supports using custom domains that have been registered with a 3rd party domain registrar. This involves updating the custom domain name server records (typically an A-record or CName) and configuring the domain in Cloud Foundry and associating it with an application.

## <a id='nameservers'></a>Update Name Servers ##

The first step is to update the domain registrar name servers. You can use an A-record if you plan on using the IP of the Cloud Foundry load balancer IP that typically points to multiple routers. You can use a CName if the front-end load balancer resolves to a domain name of it's own.

You can find the IP for the A-record or the domain for the CName by performing an nslookup on the app-serving domain of the Cloud Foundry instance you are connecting to. For example, if the apps are hosted on cfapps.io, then `nslookup foo.cfapps.io` should resolve to the IP or host for the front-end load-balancer.

    Non-authoritative answer:
	foo.cfapps.io	canonical name = cfrouter-OMITTED.amazonaws.com.
	Name:	cfrouter-OMITTED.amazonaws.com
	Address: 54.236.OMITTED.OMITTED

The example below illustrates configuring mayo.iamjambay.com with an A-record and star.iamjambay.com with a CName.

<img src="name_server_config.png" style='margin:50px auto; display: block;'></img>

It is recommended to confirm the domain resolves correctly by using `nslookup` on the domain. It may take a few minutes for the name servers to update. It may help to flush your local machine's DNS cache.

On OSX 10.7/10.8, you can use `sudo killall -HUP mDNSResponder` 
On Windows, you can using `ipconfig /flushdns` 

## <a id='map'></a>Map Domain and Route ##

Once the name servers are configured with the registrar, you should use the `cf map-domain` command to map the domain to the organization and space and subsequently use the `cf map` command to map a route using that custom domain to the application. For example, let's say there is a domain `iamjambay.com`, an app named `sinatra-hello` and a route named `mayo.iamjambay.com`. The following commands will complete the registration so that iamjambay.com will map to the current organization and space and mayo.iamjambay.com routes to the application. 

    cf map-domain iamjambay.com
    cf map sinatra-hello mayo iamjambay.com
	cf sinatra-hello restart

*Note the restart command, if the application is already running the new route will not be active until the application is restarted*

