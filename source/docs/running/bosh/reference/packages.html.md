---
title: Packages
---

## Packages ###

A package is a collection of source code along with a script that contains instruction how to compile it to binary format and install it, with optional dependencies on other pre-requisite packages.

### Package Compilation ###

Packages are compiled on demand during the deployment. The [director](#bosh-director) first checks to see if there already is a compiled version of the package for the stemcell version it is being deployed to, and if it doesn't already exist a compiled version, the director will instantiate a compile VM (using the same stemcell version it is going to be deployed to) which will get the package source from the blobstore, compile it, and then package the resulting binaries and store it in the blobstore.

To turn source code into binaries, each package has a `packaging` script that is responsible for the compilation, and is run on the compile VM. The script gets two environment variables set from the BOSH agent:

`BOSH_INSTALL_TARGET`
: Tells where to install the files the package generates. It is set to `/var/vcap/data/packages/<package name>/<package version>`.

`BOSH_COMPILE_TARGET`
: Tells the the directory containing the source (it is the current directory when the `packaging` script is invoked).

When the package is installed a symlink is created from `/var/vcap/packages/<package name>` which points to the latest version of the package. This link should be used when referring to another package in the `packaging` script.

There is an optional `pre_packaging` script, which is run when the source of the package is assembled during the `bosh create release`. It can for instance be used to limit which parts of the source that get packages up and stored in the blobstore. It gets the environment variable `BUILD_DIR` set by the BOSH CLI which is the directory containing the source to be packaged.

### Package specs ###

The package contents are specified in the `spec` file, which has three sections:

`name`
: The name of the package.

`dependencies`
: An optional list of other packages this package depends on, [see below][Dependencies].

`files`
: A list of files this package contains, which can contain globs. A `*` matches any file and can be restricted by other values in the glob, e.g. `*.rb` only matches files ending with `.rb`. A `**` matches directories recursively.

### Dependencies ###

The package `spec` file contains a section which lists other packages the current package depends on. These dependencies are compile time dependencies, as opposed to the job dependencies which are runtime dependencies.

When the [director](#bosh-director) plans the compilation of a package during a deployment, it first makes sure all dependencies are compiled before it proceeds to compile the current package, and prior to commencing the compilation all dependent packages are installed on the compilation VM.
 