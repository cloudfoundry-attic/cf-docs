---
title: Agent
---

BOSH Agents listen for instructions from the [BOSH Director](director.html). Every VM contains an Agent. Through the Director-Agent interaction, VMs are given Jobs, or roles, within Cloud Foundry.
If the VM's job is to run MySQL, for example, the Director will send instructions to the Agent about which packages must be installed and what the configurations for those packages are.
