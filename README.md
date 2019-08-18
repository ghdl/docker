<p align="center">
  <img src="./logo.png"/>
</p>

<p align="center">
<!--
  <a title="Read the Docs" href="http://ghdl.readthedocs.io"><img src="https://img.shields.io/readthedocs/ghdl.svg?longCache=true&style=flat-square&logo=read-the-docs&logoColor=e8ecef"></a><!--
  -->
  <a title="Join the chat at https://gitter.im/ghdl1/Lobby" href="https://gitter.im/ghdl1/Lobby?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge"><img src="https://img.shields.io/badge/chat-on%20gitter-4db797.svg?longCache=true&style=flat-square&logo=gitter&logoColor=e8ecef"></a>
</p>

This repository contains scripts to build and to deploy the docker images that are used and/or published by the [GHDL GitHub organization](https://github.com/ghdl). All of them are pushed to [hub.docker.com/u/ghdl](https://hub.docker.com/u/ghdl).

For development (i.e., building and/or testing ghdl):

- [![ghdl/build Docker pulls](https://img.shields.io/docker/pulls/ghdl/build?label=ghdl%2Fbuild&style=flat-square)](https://hub.docker.com/r/ghdl/build) images include development depedendencies for [ghdl](https://github.com/ghdl/ghdl).
- [![ghdl/run Docker pulls](https://img.shields.io/docker/pulls/ghdl/run?label=ghdl%2Frun&style=flat-square)](https://hub.docker.com/r/ghdl/run) images include runtime dependencies for [ghdl](https://github.com/ghdl/ghdl).
- [![ghdl/pkg Docker pulls](https://img.shields.io/docker/pulls/ghdl/pkg?label=ghdl%2Fpkg&style=flat-square)](https://hub.docker.com/r/ghdl/pkg) images include [ghdl](https://github.com/ghdl/ghdl) tarballs built in [ghdl/build](https://hub.docker.com/r/ghdl/build/tags) images.

Ready-to-use:

- [![ghdl/ghdl Docker pulls](https://img.shields.io/docker/pulls/ghdl/ghdl?label=ghdl%2Fghdl&style=flat-square)](https://hub.docker.com/r/ghdl/ghdl) images, which are based on correponding [ghdl/run](https://hub.docker.com/r/ghdl/run/tags) images, include [ghdl](https://github.com/ghdl/ghdl) along with minimum runtime dependencies.
- [![ghdl/vunit Docker pulls](https://img.shields.io/docker/pulls/ghdl/vunit?label=ghdl%2Fvunit&style=flat-square)](https://hub.docker.com/r/ghdl/vunit) images, which are based on [`ghdl/ghdl:buster-*`](https://hub.docker.com/r/ghdl/ghdl/tags) images, include [ghdl](https://github.com/ghdl/ghdl) along with [VUnit](https://vunit.github.io/).
- [![ghdl/ext Docker pulls](https://img.shields.io/docker/pulls/ghdl/ext?label=ghdl%2Fext&style=flat-square)](https://hub.docker.com/r/ghdl/ext/tags) ready-to-use images with GHDL and complements ([ghdl-language-server](https://github.com/ghdl/ghdl-language-server), [GtkWave](http://gtkwave.sourceforge.net/), [VUnit](https://vunit.github.io/), etc.).
- [![ghdl/synth Docker pulls](https://img.shields.io/docker/pulls/ghdl/synth?label=ghdl%2Fsynth&style=flat-square)](https://hub.docker.com/r/ghdl/synth) images allow to try experimental synthesis features of [ghdl](https://github.com/ghdl/ghdl).

See [USE_CASES.md](./USE_CASES.md) if you are looking for usage examples from a user perspective.

# Build status

- [!['master' Build Status](https://img.shields.io/travis/com/ghdl/docker/master.svg?longCache=true&logo=travis&style=flat-square&label=master)](https://travis-ci.com/ghdl/docker/branches)

- [!['gcc' Build Status](https://img.shields.io/travis/com/ghdl/docker/gcc.svg?longCache=true&logo=travis&style=flat-square&label=gcc)](https://travis-ci.com/ghdl/docker/branches)
[!['llvm' Build Status](https://img.shields.io/travis/com/ghdl/docker/llvm.svg?longCache=true&logo=travis&style=flat-square&label=llvm)](https://travis-ci.com/ghdl/docker/branches)
[!['mcode' Build Status](https://img.shields.io/travis/com/ghdl/docker/mcode.svg?longCache=true&logo=travis&style=flat-square&label=mcode)](https://travis-ci.com/ghdl/docker/branches)
[!['mcodegpl' Build Status](https://img.shields.io/travis/com/ghdl/docker/mcodegpl.svg?longCache=true&logo=travis&style=flat-square&label=mcodegpl)](https://travis-ci.com/ghdl/docker/branches)
- [!['ext' Build Status](https://img.shields.io/travis/com/ghdl/docker/ext.svg?longCache=true&logo=travis&style=flat-square&label=ext)](https://travis-ci.com/ghdl/docker/branches)
[!['synth' Build Status](https://img.shields.io/travis/com/ghdl/docker/synth.svg?longCache=true&logo=travis&style=flat-square&label=synth)](https://travis-ci.com/ghdl/docker/branches)

# Structure of the repo

Due to the time limit in Travis CI, and because not all the images need to be updated at the same frequency, several job matrices are defined. Since Travis CI does not support dynamic modification of the `.travis.yml` file, multiple YAML configuration files are used, and each of them is used in a different branch:

## [`.travis.yml`](./.travis.yml)

The default (branches `dev` or `master`). `travis/run.sh -c` is executed in order to build [ghdl/build](https://hub.docker.com/r/ghdl/build/tags) and [ghdl/run](https://hub.docker.com/r/ghdl/run/tags) images. All of them are pushed to [cloud.docker.com/u/ghdl/repository/list](https://cloud.docker.com/u/ghdl/repository/list).

## [`travis/ymls/buildtest`](./travis/ymls/buildtest)

A base for branches `mcode`, `mcodegpl`, `llvm`, and `gcc`. [ghdl/ghdl](https://github.com/ghdl/ghdl) is cloned and `./travis/run.sh -b` is executed. For each of the defined platforms:

- GHDL is built in the corresponding [ghdl/build](https://hub.docker.com/r/ghdl/build/tags) image.
- A [ghdl/ghdl](https://hub.docker.com/r/ghdl/ghdl/tags) image is created based on the corresponding [ghdl/run](https://hub.docker.com/r/ghdl/run/tags) image.
- The testsuite is executed inside the [ghdl/ghdl](https://hub.docker.com/r/ghdl/ghdl/tags) image created in the previous step.
- If successful, a [ghdl/pkg](https://hub.docker.com/r/ghdl/pkg/tags) image is created with the tarball built in the first step.
- [ghdl/ghdl](https://hub.docker.com/r/ghdl/ghdl/tags) and [ghdl/pkg](https://hub.docker.com/r/ghdl/pkg/tags) images are pushed to [hub.docker.com/u/ghdl](https://hub.docker.com/u/ghdl).

## [`travis/ymls/ext`](./travis/ymls/ext)

Used for branch `ext`. `travis/run.sh -l <TASK>` and `travis/run.sh -e` are executed in order to build [ghdl/vunit](https://hub.docker.com/r/ghdl/vunit) and [ghdl/ext](https://hub.docker.com/r/ghdl/ext) images.

## [`travis/ymls/synth`](./travis/ymls/synth)

Used for branch `synth`. `travis/run.sh -s <TASK_GROUP>` is executed in order to build [ghdl/synth](https://hub.docker.com/r/ghdl/synth) images (tags `latest`, `beta`, `yosys`, `yosys-gnat`, `symbiyosys`, `formal`, `icestorm` and `nextpnr`).

---

Sources are all kept in branches `dev`|`master`. Any contribution should be made to any of these. Branches `mcode`, `mcodegpl`, `llvm`, `gcc`, `ext` and `synth` are placeholders, which are expected to always be a single commit ahead of some point in the history of `master`. [`hrcp.sh`](./hrcp.sh) is used to automatically:

- Hard reset a placeholder branch to `master`.
- Replace `.travis.yml` with the corresponding source from `travis/ymls/`.
- Complete the `.travis.yml` file with the list of platforms.
- Add a single commit with the changes to `.travis.yml`.
- Force push.

Several branches can be updated at once, e.g.: `./hrcp.sh mcode mcodegpl llvm gcc ext synth`.

---

At now, there is no triggering mechanism set up between [ghdl/ghdl](https://github.com/ghdl/ghdl) and [ghdl/docker](https://github.com/ghdl/docker). All the builds in this repo are triggered by CRON jobs:

- `master` is executed monthly.
- `gcc` and `synth` are executed weekly.
- `mcode`, `mcodegpl`, `llvm` and `ext` are executed daily.
