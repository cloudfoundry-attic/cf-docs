---
title: Deploying Node.js
---

This page will prepare you for using deploying Node.js apps via the [getting started guide](../../../dotcom/getting-started.html).

<hr>

## <a id='version'></a> Which version of Node? ##

You can specify different versions of Node.js in your package.json file. As of July, 2013, Cloud Foundry uses 0.10.x as the default.

## <a id='packagejson'></a> Do I need a package file? ##

Yes - Cloud Foundry expects a package.json in your Node.js application.

## <a id='nodemodules'></a> Do I need to run NPM? ##

You do not need to run `npm Install` before deploying your application. Cloud Foundry will run it for you. If you would prefer to run `npm install` and create a node_modules folder inside of your application, this is also supported.

## <a id='start'></a> How do I start my app? ##

Node.js applications require a start command, which is saved with other configurations in `manifest.yml`.

You will be asked if you want to save your configuration the first time you deploy. This will save a `manifest.yml` in your application with the settings you entered during the initial push. Edit the `manifest.yml` file and create a start command as follows:

~~~yaml
---
applications:
- name: my-app
  command: node my-app.js
... the rest of your settings  ...
~~~

## <a id='services'></a> How do I bind services? ##

Refer to the [instructions for node.js service bindings](../../services/node-service-bindings.html).