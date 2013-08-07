---
title: Contacting Service Providers for Support
category: support
---

The first time you create an instance of a given service in a space, an account is created for you on the service provider's system. Because the collaboration model in Cloud Foundry enables transient ownership of orgs and spaces, accounts are created on service provider systems as a user representing the space itself. 

When contacting Marketplace service providers for support, you'll need to give them the space guid containing the service instance you need help with. To find the space guid, navigate to the space in the Cloud Foundry web console. The space guid is the long string after `spaces/` in the URL. 

Example: if your URL looks like `https://console.run.pivotal.io/organizations/c54bf317-d791-4d12-89f0-b56d0936cfdc/spaces/15d10713-847d-437e-9f04-ec0790dbb566` then the space guid is `15d10713-847d-437e-9f04-ec0790dbb566`.
