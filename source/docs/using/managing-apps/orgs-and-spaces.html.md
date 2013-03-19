---
title: Organizations and Spaces.
---

## <a id='introduction'></a>Introduction ##

Organizations and Spaces are the main organizational "units" in which applications, services, domains, routes and users are contained. Consider the following illustration that shows the organisational units of Cloud Foundry.

<img src="/images/CF-Arch.png" style='margin:50px auto; display: block;'></img>

## <a id='organizations'></a>Organizations ##

An organization is the top-most meta object within the Cloud Foundry infrastructure. If an account has administrative privileges on a Cloud Foundry instance, it can manage it's organizations.

## <a id='spaces'></a>Spaces ##

An organization can contain multiple spaces, the default for a standard Cloud Foundry install is 'development', 'test' and 'production'. A domain can be mapped to multiple spaces but a route can only be mapped to one application instance and therefore one space.

## <a id='managmement'></a>Management ##

Spaces and Organizations can be managed via [CF](cf/#commands) or via one of the available [API libraries](libs/).
