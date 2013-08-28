---
title: Configure SSL-Enabled Custom Domain
---


This page has has instructions for setting up an SSL-enabled custom domain using CloudFlare, a content distribution network. In the resulting configuration, traffic to and from your application running on Cloud Foundry will be routed via CloudFlare.

browser  < --- ssl --- >  CloudFlare proxy  < --- ssl --- >  Cloud Foundry

To enable this, you will configure CloudFlare’s “Full SSL” option for the domain. You can use a CloudFlare-generated SSL certificate between the browser and the CloudFlare server, or if you prefer, configure CloudFlare to use a certificate you provide. A Cloud Foundry-generated SSL certificate will be used between the CloudFlare proxy and the application on Cloud Foundry.

It is assumed that your domain is already registered. To complete this procedure, you must be able to access the DNS registrar for the domain. Note that you do not need to change DNS registrars. The only change you will make with your registrar is to point the authoritative name servers to CloudFlare's name servers.  

It is recommended that you download the zone file for the domain from your DNS provider, for use in [Step 5 - Configure DNS Records](#configure).

## <a id='sign-up'></a>Step 1 - Get CloudFlare Account ##

Go to https://www.cloudflare.com/, and click **Sign up** in the upper right of the page. On the registration page, enter your email address, username, and password. Accept CLloudFlare's terms of use, and click **Create account now**. 

![Register](/images/cloudflare-register.png)


## <a id='add-site'></a>Step 2 - Add Domain to CloudFlare ##

On the CloudFlare "Add a website" page, enter the name of your custom domain and click **Add website**. CloudFlare will query authoritative DNS servers for the DNS records registered for the domain. 

![Add a Web Site](/images/uber0.png)


## <a id='scan'></a>Step 3 - Wait for Scan to Complete ##

When the scan is complete, a **Domain records scanned** callout appears. Click **Continue Setup**.

![Scanning](/images/scan-complete.png)

## <a id='configure'></a>Step 4 - Configure DNS Records ##

The CloudFlare "Configure Your DNS Records" lists the records it obtained for the domain. In the row for your domain name -- "uberconnected.com" in the example --- the cloud icon in the "Active" column should be orange.

To ensure your DNS records are correct and complete, Pivotal recommends you download the zone file for the domain from your DNS provider, and then upload it to CloudFlare --- click the **Upload a zone file** link to do so. 

If you prefer, you can click **Add** to define additional records, if necessary. 

When done, click **I've added all missing records, continue**. 

![Add a Web Site](/images/config-dns.png)

## <a id='settings'></a>Step 5 - Choose Settings ##

On the "Settings for <YourDomain>" page:

*  **Choose a plan** --- Select "Pro" or "Business". You can only configure SSL for a domain if you have a paid CloudFlare plan. If you wish to use your own SSL certificate, rather that a CloudFlare-generated certificate for communications betwen browsers and the CloudFlare proxy.
*  **Performance** --- This configures a performance profile. You can choose any of the available options. See  The options are:
    * **CDN only (safest)** --- This is the default.  
    * **CDN + Basic Optimizations** 
    * **CDN + Full Optimizations**
* **Security** --- This setting controls CloudFlare's protection behavior relative to which visitors are shown a captcha/challenge page. The options are:
    * **I'm under attack!** --- Should only be used when a site is having a DDoS attack. Visitors will receive an interstitial page for about five seconds while we analyze the traffic and behavior to make sure it is a legitimate human visitor trying to access your site.
    * **High** --- Challenge all visitors that have exhibited threatening behavior within the last 14 days.
    * **Medium**
    * **Low** --- Challenge only the most threatening visitors. CloudFlaree recommends this as initial setting.  starting out at low.
    * **Essentially off** --- Act only against the most grievous offenders. 
*  **Automatiac IPV6** --- The options are: 
    * **Full IPv6 Gateway** --- Enables IPv6 on all subdomains that are CloudFlare enabled (marked by an orange cloud in your DNS settings)
    * **Safe IPv6 Gateway** Will only create an IPv6-specific subdomain for your site (www.ipv6.yoursite.com).


![Add a Web Site](/images/uber2.png)

Click **Continue**.

## <a id='ssl'></a>Step 6 - Confirm SSL ##

On the "Confirm SSL" page, you can select:

* Automatic SSL Configuration --- If you select this option, CloudFlare will generate an SSL certificate. Note that you can replace it with your own certificate.

* Manual SSL Configuration --- 

![Add a Web Site](/images/uber3.png)

## <a id='settings'></a>Step 7 - Update Name Servers ##

The "Update Name Servers" page lists your current name servers, and the CloudFlare name servers with which to replace them.

Log on to your domain name registrar and open that page for name server management. Replace the currently configured name servers with the CloudFlare name servers.

Click **I've updated my nameservers, continue** on the "update your name servers page."

## <a id='settings'></a>Step 9 - Setup Complete ##

![Add a Web Site](/images/uber7.png)

## <a id='review'></a>Reviewing CloudFlare Configuration Options ##
Click the **Websites** link at the top of any CloudFlare.com page to view the "My WebSites* page.

Click the gear icon in the row for your domain, and choose **CloudFlare settings** from the menu. The **CloudFlare settings** page has several tabs that describe CloudFlare configuration options. In particular, see the **Security** and **Performance** tabs to understand more about the options you configured, and alternative settings.

![Add a Web Site](/images/my-websites.png)





















<pre class="terminal">
c

</pre>

 

