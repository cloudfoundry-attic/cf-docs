---
title: Contacting Service Providers for Support
category: support
---

The first time you create an instance of a given service in a space, an account is created for you on the service provider's system. Because the collaboration model in Cloud Foundry enables transient ownership of orgs and spaces, accounts are created on service provider systems as a user representing the space itself. 

When contacting Marketplace service providers for support, you'll need to give them the either the email address for the space the instance was created in, or the guid of the space service instance. 

## Space Email Address

Every space has an email alias. This alias is the address used when creating accounts with service providers. When emails are sent to this alias, the email is forwarded to each user in the space having the SpaceDeveloper role.

The email address is of the form `space-guid-<guid>@email-proxy.run.pivotal.io`, where `<guid>` is the space guid containing the service instance. See below for instructions to determine your space guid. 

## Space GUID

### Using web console

Navigate to the space in the Cloud Foundry web console. The space guid is the long string after `spaces/` in the URL. 

Example: if your URL looks like `https://console.run.pivotal.io/organizations/c54bf317-d791-4d12-89f0-b56d0936cfdc/spaces/15d10713-847d-437e-9f04-ec0790dbb566` then the space guid is `15d10713-847d-437e-9f04-ec0790dbb566`.

### Using CLI

The following command is available for the Ruby CLI (`cf`) only; it is not yet available in the Go CLI (`gcf`).
<pre class="terminal">
$ cf guid space my-space
Listing spaces for 'my-space'...

Found 1 results on 1 pages. First page:
my-space  977a199b-bc79-423f-b85e-72e80f66d93d
</pre>
