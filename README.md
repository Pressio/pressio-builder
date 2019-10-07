
## pressio-builder

This repo provides scripts and tools to simplify
and automate the building/installation process of `pressio` and its TPLs.

### Building TPLs
To build the TPLs, do the following:
- cd into ./tpls
- bash ./main_tpls.sh -h
and follow the directions.


### Building `pressio`
After you are done with TPLs, build `pressio` by doing:
- cd into ./pressio
- bash ./main_pressio.sh -h
and follow the directions.


### Current versions of tpls used:

* eigen:
  - cloned from: `http://bitbucket.org/eigen/eigen/get/3.3.7.tar.bz2`
  - using version 3.3.7

* gtest:
  - cloned from: `git@github.com:google/googletest.git`
  - using branch: master

* trilinos:
  - cloned from: `git@github.com:trilinos/Trilinos.git`
  - using branch: trilinos-release-12-14-branch

* pybind11:
  - cloned from: `git@github.com:pybind/pybind11.git`
  - using branch: origin/v23

*More details coming soon*
