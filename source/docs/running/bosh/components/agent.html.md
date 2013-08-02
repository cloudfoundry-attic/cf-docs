---
title: Agent
---

BOSH Agents listen for instructions from the [BOSH Director](director.html). Every VM contains an Agent. Through the Director-Agent interaction, VMs are given Jobs, or roles, within Cloud Foundry.
If the VM's job is to run MySQL, for example, the Director will send instructions to the Agent about which packages must be installed and what the configurations for those packages are.

Below is an 8 min video explaining the role of the Bosh Agent within each instance. It shows an example bosh deployment - deploying a single server running redis - and look at the high level explanation of how the bosh director communicates with the bosh agent, which communicates with monit, which starts and stops the redis server.


<iframe width="640" height="480" src="https://www.youtube.com/embed/2jpN1mSPZ4Q" frameborder="0" allowfullscreen></iframe>

