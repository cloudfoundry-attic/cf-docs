---
title: Adding HTTPS support with an SSL proxy
---

It is important to allow HTTPS traffic into your Cloud Foundry and to the users' applications. By default, Cloud Foundry does not enable HTTPS traffic, rather you choose from two options:

* Use external load balancers, such as ELBs on AWS, and register your SSL certificate with it; it then routes traffic internally to the one or more gorouters that you are running.
* Run an SSL proxy in front of your Cloud Foundry's one or more routers (`gorouter`)

This short guide shows the latter: how to run an SSL proxy in front of your Cloud Foundry, and how to update your Cloud Foundry to use it.

