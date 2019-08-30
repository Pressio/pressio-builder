
## pressio-builder

What is this? This repo provides scripts and tools to simplify
and automate the building process for Pressio and its TPLs.

### Building TPLs
To build the TPLs, do the following:
- cd into ./tpls
- bash ./main_tpls.sh -h
and follow the directions.


### Building Pressio
After you are done with TPLs, build Pressio by doing:
- cd into ./pressio
- bash ./main_pressio.sh -h
and follow the directions.


### Current versions of tpls used:

* eigen:
  cloned from: http://bitbucket.org/eigen/eigen/get/3.3.7.tar.bz2
  using version 3.3.7

* gtest:
  git clone git@github.com:google/googletest.git
  using branch master

* trilinos:
  git clone git@github.com:trilinos/Trilinos.git
  using branch trilinos-release-12-14-branch

* pybind11:
  git clone git@github.com:pybind/pybind11.git
  using branch origin/v23
