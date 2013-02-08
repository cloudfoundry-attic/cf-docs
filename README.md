docs
====

This is the Cloud Foundry documentation - including information about running and managing applications on Cloud Foundry, and setting up your own Cloud Foundry instance with VCAP and BOSH. The repository also feeds [cloudfoundry.github.com](http://cloudfoundry.github.com) using [Github Pages](http://pages.github.com/) and [Middleman](http://middlemanapp.com/).

If you have minor changes, you can contribute by forking this repository, modifying the files in `/source/docs`, and creating a GitHub pull request.

If you want to contribute on a larger scale, see the [Pivotal Project for CF Docs](https://www.pivotaltracker.com/projects/713283#).

## Contributing docs

You can either contribute directly within Github or by cloning the repository to your local machine using git.

## Viewing docs locally

These docs are rendered using [middleman](https://github.com/middleman/middleman). To pull down the raw documentation project and view the docs on your local machine using middleman:

```
git clone https://github.com/cloudfoundry/cf-docs.git cloudfoundry-docs
cd cloudfoundry-docs
bundle
middleman server
```

Then view [http://0.0.0.0:4567](http://0.0.0.0:4567) in your browser.

## More help

### Twitter

* Follow the [@cloudfoundry](https://twitter.com/cloudfoundry) twitter account for retweets of blogs and news from the world of Cloud Foundry

### Discussion Groups

* [Using Cloud Foundry](http://stackoverflow.com/questions/tagged/cloudfoundry)
* [Running / Setting up Cloud Foundry](https://groups.google.com/a/cloudfoundry.org/forum/?fromgroups#!forum/vcap-dev)
* [Using BOSH](https://groups.google.com/a/cloudfoundry.org/forum/?fromgroups#!forum/bosh-users)
* [Running / Setting up BOSH](https://groups.google.com/a/cloudfoundry.org/forum/?fromgroups#!forum/bosh-dev)

### Bugs

When you are getting started with Cloud Foundry, and are still learning your way around the Cloud Foundry repositories, you can raise bugs with [cloudfoundry.atlassian.net](http://cloudfoundry.atlassian.net/).

As you grow more experienced, you will discover that many of the sub-projects of Cloud Foundry have their own ticket systems via each project's GitHub Issues.

### Support

* [support.cloudfoundry.com](http://support.cloudfoundry.com)

