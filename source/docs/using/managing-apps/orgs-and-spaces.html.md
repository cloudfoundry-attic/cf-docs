---
title: Organizations and Spaces
---

## <a id='introduction'></a>Introduction ##
Organizations and Spaces are the main organizational units in which applications, services, domains, routes, and users are contained. The following illustration shows the organizational units of Cloud Foundry.

<img src="/images/CF-Arch.png" style='margin:50px auto; display: block;'></img>

## <a id='organizations'></a>Organizations ##

An organization is the top-most meta object within the Cloud Foundry infrastructure. If an account has administrative privileges on a Cloud Foundry instance, it can manage its organizations.

## <a id='spaces'></a>Spaces ##

An organization can contain multiple spaces. The defaults for a standard Cloud Foundry install are **development**, **test**, and **production**. A domain can be mapped to multiple spaces but a route can be mapped to only one application instance and therefore one space.

## <a id='managmement'></a>Management ##

You can manage spaces and organizations with the [CF](/docs/using/managing-apps/cf/index.html) console interface, [API libraries](libs/), or [IDEs](ide/).
