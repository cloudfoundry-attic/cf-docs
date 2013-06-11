---
title: Packages
---

A package is a collection of source code along with a script that describes how to compile the code to binary format and install the package, with optional dependencies on other prerequisite packages.

## <a id="package-compilation"></a> Package Compilation ##

Packages are compiled on demand during deployment. The [Director](/docs/running/bosh/components/director.html) first checks whether a compiled version of the package already exists for the stemcell version to which the package will be deployed. If a compiled version doesn't already exist, the Director instantiates a compile VM using the same stemcell version to which the package will be deployed. This action gets the package source from the blobstore, compiles it, packages the resulting binaries, and stores the package in the blobstore.

To turn source code into binaries, each package has a `packaging` script that is responsible for the compilation, and is run on the compile VM. The script gets two environment variables set from the BOSH agent:

`BOSH_INSTALL_TARGET`
: Where to install the files the package generates. It is set to `/var/vcap/data/packages/<package name>/<package version>`.

`BOSH_COMPILE_TARGET`
: Directory containing the source. It is the current directory when the `packaging` script is invoked.

When the package is installed a symlink is created from `/var/vcap/packages/<package name>` which points to the latest version of the package. This link should be used when referring to another package in the `packaging` script.

There is an optional `pre_packaging` script, which is run when the source of the package is assembled during the `bosh create release`. It can for instance be used to limit which parts of the source that get packages up and stored in the blobstore. It gets the environment variable `BUILD_DIR` set by the BOSH CLI which is the directory containing the source to be packaged.

## <a id="package-specs"></a>Package Specs ##

The package contents are specified in the `spec` file, which has three sections:

`name`
: Name of the package.

`dependencies`
: Optional list of other packages this package depends on. See the next section, Dependencies.

`files`
: List of files this package contains, which can contain globs. A `*` matches any file and can be restricted by other values in the glob; for example, `*.rb` only matches files ending with `.rb`. A `**` matches directories recursively.

## <a id="dependencies"></a>Dependencies ##

The package `spec` file contains a section that lists other packages that the current package depends on. These dependencies are compile time dependencies, as opposed to the job dependencies, which are runtime dependencies.

When the [Director](/docs/running/bosh/components/director.html) plans the compilation of a package during a deployment, it first makes sure all dependencies are compiled before it proceeds to compile the current package, and that prior to starting the compilation all dependent packages are installed on the compilation VM.
 