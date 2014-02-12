---
title: Buildpacks
---
Cloud Foundry uses buildpacks to transform user-provided artifacts into runnable applications.  The functionality of buildpacks varies, but many of them examine the user-provided artifact in order to properly download needed dependencies and configure applications to communicate with bound services.  Heroku developed the buildpack approach and Cloud Foundry embraces it.

* **Cloud Foundry Buildpacks** --- When an artifact is pushed to Cloud Foundry, the system chooses a buildpack automatically.  Buildpacks are designed such that they can examine the artifact and opt to process an artifact.  For information about the built-in candidate buildpacks see:

    * [Java Buildpack][j]
    * [Node.js Buildpack][n]
    * [Ruby Buildpack][r]

<p>

* **External Buildpacks** --- Not all artifacts are support by Cloud Foundry's built-in buildpacks.  If you wish to push an artifact that is not supported, there may be a third-party or community-developed buildpack that you can use.  If no buildpack currently exists, you can customize existing buildpacks or write your own from scratch.  To use a buildpack that is not built-in to Cloud Foundry, you specify the URL of the buildpack when you push an application, using the `-b` qualifier or the `buildpack: ` manifest key.

    * [Cloud Foundry Commmunity Buildpacks][c] --- This page has links to buildpacks contributed by members of the Cloud Foundry Community.
    * [Heroku Third-Party Buildpacks][h] --- This page has links to buildpacks developed for Heroku, which may (but have not been verified to) work with Cloud Foundry.
    * [Custom Buildpacks][u] --- See this page for information about writing a custom buildpack.

[c]: https://github.com/cloudfoundry-community/cf-docs-contrib/wiki/Buildpacks
[h]: https://devcenter.heroku.com/articles/third-party-buildpacks
[j]: /docs/using/deploying-apps/java-buildpack.html
[n]: /docs/using/deploying-apps/node-buildpack.html
[r]: /docs/using/deploying-apps/ruby-buildpack.html
[u]: /docs/using/deploying-apps/custom-buildpacks.html
