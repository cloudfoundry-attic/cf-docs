---
title: Organizations and Spaces
---


Organizations and Spaces are the main organizational units in which applications, services, domains, routes, and users are contained. The following illustration shows the organizational units of Cloud Foundry.

<img src="/images/CF-Arch.png" style='margin:50px auto; display: block;'></img>

## <a id='organizations'></a>Organizations ##

An organization is the top-most meta object within the Cloud Foundry infrastructure. If an account has administrative privileges on a Cloud Foundry instance, it can manage its organizations.

## <a id='spaces'></a>Spaces ##

An organization can contain multiple spaces. The defaults for a standard Cloud Foundry install are **development**, **test**, and **production**. A domain can be mapped to multiple spaces but a route can be mapped to only one space.

## <a id='domains'></a>Domains ##

A domain is a domain-name like acme.com or foo.net. For the https://console.run.pivotal.io hosted instance of Cloud Foundry, end-user organizations and spaces are able to use the system domain of "cfapps.io" by default as well as custom domains that are registered to the organization. Domains can also be multi-level and contain sub-domains like the "store" in "store.acme.com". Domain objects belong to an organization and are associated with zero or many spaces within the organization. Domain objects are not directly bound to apps, but a child of a domain object called a route is. For more information, see [About Domains, Subdomains and Routes](../managing-apps/custom-domains/index.html).

## <a id='routes'></a>Routes ##

A route, based on a domain with an optional host as a prefix, may be associated with one or more applications. For example, "www" is the host and "acme.com" is the domain when using the route "www.acme.com". It is also possible to have a route that represents "acme.com" without a host. For more information, see [About Domains, Subdomains and Routes](../managing-apps/custom-domains/index.html).

## <a id='managmement'></a>Management ##

You can manage spaces and organizations with the [CF](/docs/using/managing-apps/cf/index.html) command line interface, [API libraries](libs/), or [IDEs](ide/).
