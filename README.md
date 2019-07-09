[!['master' Build Status](https://img.shields.io/travis/com/ghdl/docker/master.svg?longCache=true&logo=travis&style=flat-square&label=master)](https://travis-ci.com/ghdl/docker/branches)
[!['mcode' Build Status](https://img.shields.io/travis/com/ghdl/docker/mcode.svg?longCache=true&logo=travis&style=flat-square&label=mcode)](https://travis-ci.com/ghdl/docker/branches)
[!['mcodegpl' Build Status](https://img.shields.io/travis/com/ghdl/docker/mcodegpl.svg?longCache=true&logo=travis&style=flat-square&label=mcodegpl)](https://travis-ci.com/ghdl/docker/branches)
[!['llvm' Build Status](https://img.shields.io/travis/com/ghdl/docker/llvm.svg?longCache=true&logo=travis&style=flat-square&label=llvm)](https://travis-ci.com/ghdl/docker/branches)
[!['gcc' Build Status](https://img.shields.io/travis/com/ghdl/docker/gcc.svg?longCache=true&logo=travis&style=flat-square&label=gcc)](https://travis-ci.com/ghdl/docker/branches)
[!['ext' Build Status](https://img.shields.io/travis/com/ghdl/docker/ext.svg?longCache=true&logo=travis&style=flat-square&label=ext)](https://travis-ci.com/ghdl/docker/branches)

# ghdl/docker

This repository contains scripts to build and to deploy the docker images that are used in the [GHDL GitHub organization](https://github.com/ghdl).
All of them are pushed to [cloud.docker.com/u/ghdl/repository/list](https://cloud.docker.com/u/ghdl/repository/list):

- [`ghdl/build`](https://cloud.docker.com/u/ghdl/repository/docker/ghdl/build/tags): images with development depedendencies for [GHDL](https://github.com/ghdl/ghdl)
- [`ghdl/run`](https://cloud.docker.com/u/ghdl/repository/docker/ghdl/run/tags): images with runtime dependencies for [GHDL](https://github.com/ghdl/ghdl)
- [`ghdl/ghdl`](https://cloud.docker.com/u/ghdl/repository/docker/ghdl/ghdl/tags): ready-to-use images with [GHDL](https://github.com/ghdl/ghdl) and minimum runtime dependencies (based on [`ghdl/run`](https://cloud.docker.com/u/ghdl/repository/docker/ghdl/run/tags))
- [`ghdl/pkg`](https://cloud.docker.com/u/ghdl/repository/docker/ghdl/pkg/tags): images with [GHDL](https://github.com/ghdl/ghdl) tarballs built in [`ghdl/build`](https://cloud.docker.com/u/ghdl/repository/docker/ghdl/build/tags) images
- [`ghdl/ext`](https://cloud.docker.com/u/ghdl/repository/docker/ghdl/ext/tags): ready-to-use images with GHDL and complements ([ghdl-language-server](https://github.com/ghdl/ghdl-language-server), [GtkWave](http://gtkwave.sourceforge.net/), [VUnit](https://vunit.github.io/), [OSVVM](http://osvvm.org/)...)

See [USE_CASES.md](./USE_CASES.md) if you are looking for usage examples from a user perspective.

---

Due to the time limit in Travis CI, and because not all the images need to be updated at the same frequency, several job matrices are defined. Since Travis CI does not support dynamic modification of the `.travis.yml` file, multiple YAML configuration files are used, and each of them is used in a different branch:

## [`.travis.yml`](./.travis.yml)

The default (branches `dev` or `master`). `travis/run.sh -c` is executed in order to build [`ghdl/build`](https://cloud.docker.com/u/ghdl/repository/docker/ghdl/build/tags) and [`ghdl/run`](https://cloud.docker.com/u/ghdl/repository/docker/ghdl/run/tags) images. All of them are pushed to [cloud.docker.com/u/ghdl/repository/list](https://cloud.docker.com/u/ghdl/repository/list).

## [`travis/ymls/buildtest`](./travis/ymls/buildtest)

A base for branches `mcode`, `mcodegpl`, `gpl`, and `gcc`. [ghdl/ghdl](https://github.com/ghdl/ghdl) is cloned, and `./travis/run.sh -b` is executed. For each of the defined platforms:

- GHDL is built in the corresponding [`ghdl/build`](https://cloud.docker.com/u/ghdl/repository/docker/ghdl/build/tags) image.
- A [`ghdl/ghdl`](https://cloud.docker.com/u/ghdl/repository/docker/ghdl/ghdl/tags) image is created based on the corresponding [`ghdl/run`](https://cloud.docker.com/u/ghdl/repository/docker/ghdl/run/tags) image.
- The testsuite is executed inside the [`ghdl/ghdl`](https://cloud.docker.com/u/ghdl/repository/docker/ghdl/ghdl/tags) image created in the previous step.
- If successful, a [`ghdl/pkg`](https://cloud.docker.com/u/ghdl/repository/docker/ghdl/pkg/tags) image is created with the tarball built in the first step.
- [`ghdl/ghdl`](https://cloud.docker.com/u/ghdl/repository/docker/ghdl/ghdl/tags) and [`ghdl/pkg`](https://cloud.docker.com/u/ghdl/repository/docker/ghdl/pkg/tags) images are pushed to [cloud.docker.com/u/ghdl/repository/list](https://cloud.docker.com/u/ghdl/repository/list).

## [`travis/ymls/ext`](./travis/ymls/ext)

Used for branch `ext`. `travis/run.sh -e` is executed in order to build some of [`ghdl/ext`](https://cloud.docker.com/u/ghdl/repository/docker/ghdl/ext/tags) images (tags `ls-debian`, `ls-ubuntu`, `ls-vunit-gtkwave`, `vunit`, `vunit-master`, `vunit-gtkwave` and `broadway`). All of them are pushed to [cloud.docker.com/u/ghdl/repository/list](https://cloud.docker.com/u/ghdl/repository/list).

---

Sources are all kept in branches `dev`|`master`. Any contribution should be made to any of these. Branches `mcode`, `mcodegpl`, `llvm`, `gcc` and `ext` are placeholders, which are expected to always be a single commit ahead of some point in the history of `dev`. [`hrcp.sh`](./hrcp.sh) is used to automatically:

- Hard reset a placeholder branch to `master`.
- Replace `.travis.yml` with the corresponding source from `travis/ymls/`.
- Complete the `.travis.yml` file with the list of platforms.
- Add a single commit with the changes to `.travis.yml`.
- Force push.

Several branches can be updated at once, e.g.: `./hrcp.sh mcode mcodegpl llvm gcc ext pack`.

---

At now, there is no triggering mechanism set up between [ghdl/ghdl](https://github.com/ghdl/ghdl) and [ghdl/docker](https://github.com/ghdl/docker). All the builds in this repo are triggered by CRON jobs:

- `master` is executed monthly.
- `gcc` is executed weekly.
- `mcode`, `mcodegpl`, `llvm` and `ext` are executed daily.
