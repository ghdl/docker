<p align="center">
  <img src="./logo.png"/>
</p>

<p align="center">
<!--
  <a title="Read the Docs" href="http://ghdl.readthedocs.io"><img src="https://img.shields.io/readthedocs/ghdl.svg?longCache=true&style=flat-square&logo=read-the-docs&logoColor=e8ecef"></a><!--
  -->
  <a title="Join the chat at https://gitter.im/ghdl1/Lobby" href="https://gitter.im/ghdl1/Lobby?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge"><img src="https://img.shields.io/badge/chat-on%20gitter-4db797.svg?longCache=true&style=flat-square&logo=gitter&logoColor=e8ecef"></a><!--
  -->
  <a title="'daily' workflow Status" href="https://github.com/ghdl/docker/actions"><img alt="'daily' workflow Status" src="https://github.com/ghdl/docker/workflows/daily/badge.svg"></a><!--
  -->
  <a title="'ext' workflow Status" href="https://github.com/ghdl/docker/actions"><img alt="'ext' workflow Status" src="https://github.com/ghdl/docker/workflows/ext/badge.svg"></a><!--
  -->
  <a title="'ghdl' workflow Status" href="https://github.com/ghdl/docker/actions"><img alt="'ghdl' workflow Status" src="https://github.com/ghdl/docker/workflows/ghdl/badge.svg"></a><!--
  -->
  <a title="'cache' workflow Status" href="https://github.com/ghdl/docker/actions"><img alt="'cache' workflow Status" src="https://github.com/ghdl/docker/workflows/cache/badge.svg"></a><!--
  -->
  <a title="'base' workflow Status" href="https://github.com/ghdl/docker/actions"><img alt="'base' workflow Status" src="https://github.com/ghdl/docker/workflows/base/badge.svg"></a><!--
  -->
</p>

This repository contains scripts and YAML workflows for GitHub Actions (GHA) to build and to deploy the docker images that are used and/or published by the [GHDL GitHub organization](https://github.com/ghdl). All of them are pushed to [hub.docker.com/u/ghdl](https://cloud.docker.com/u/ghdl/repository/list).

----

Images for development (i.e., building and/or testing ghdl):

- [![ghdl/build Docker pulls](https://img.shields.io/docker/pulls/ghdl/build?label=ghdl%2Fbuild&style=flat-square)](https://hub.docker.com/r/ghdl/build) images include development depedendencies for [ghdl](https://github.com/ghdl/ghdl).
- [![ghdl/run Docker pulls](https://img.shields.io/docker/pulls/ghdl/run?label=ghdl%2Frun&style=flat-square)](https://hub.docker.com/r/ghdl/run) images include runtime dependencies for [ghdl](https://github.com/ghdl/ghdl).
- [![ghdl/pkg Docker pulls](https://img.shields.io/docker/pulls/ghdl/pkg?label=ghdl%2Fpkg&style=flat-square)](https://hub.docker.com/r/ghdl/pkg) images include [ghdl](https://github.com/ghdl/ghdl) tarballs built in [ghdl/build](https://hub.docker.com/r/ghdl/build/tags) images.
- [![ghdl/cache Docker pulls](https://img.shields.io/docker/pulls/ghdl/cache?label=ghdl%2Fcache&style=flat-square)](https://hub.docker.com/r/ghdl/cache) external dependencies which we want to keep almost in the edge, but are not part of [ghdl](https://github.com/ghdl/ghdl).

Ready-to-use images:

- [![ghdl/ghdl Docker pulls](https://img.shields.io/docker/pulls/ghdl/ghdl?label=ghdl%2Fghdl&style=flat-square)](https://hub.docker.com/r/ghdl/ghdl) images, which are based on correponding [ghdl/run](https://hub.docker.com/r/ghdl/run/tags) images, include [ghdl](https://github.com/ghdl/ghdl) along with minimum runtime dependencies.
- [![ghdl/vunit Docker pulls](https://img.shields.io/docker/pulls/ghdl/vunit?label=ghdl%2Fvunit&style=flat-square)](https://hub.docker.com/r/ghdl/vunit) images, which are based on [`ghdl/ghdl:buster-*`](https://hub.docker.com/r/ghdl/ghdl/tags) images, include [ghdl](https://github.com/ghdl/ghdl) along with [VUnit](https://vunit.github.io/).
  - `*-master` variants include latest VUnit (master branch), while others include the latest stable release (installed through pip).
- [![ghdl/ext Docker pulls](https://img.shields.io/docker/pulls/ghdl/ext?label=ghdl%2Fext&style=flat-square)](https://hub.docker.com/r/ghdl/ext/tags) ready-to-use images with GHDL and complements ([ghdl-language-server](https://github.com/ghdl/ghdl-language-server), [GtkWave](http://gtkwave.sourceforge.net/), [VUnit](https://vunit.github.io/), etc.).
- [![ghdl/synth Docker pulls](https://img.shields.io/docker/pulls/ghdl/synth?label=ghdl%2Fsynth&style=flat-square)](https://hub.docker.com/r/ghdl/synth) images allow to try experimental synthesis features of [ghdl](https://github.com/ghdl/ghdl).

See [USE_CASES.md](./USE_CASES.md) if you are looking for usage examples from a user perspective.

----

## GHA workflows

> NOTE: currently, there is no triggering mechanism set up between [ghdl/ghdl](https://github.com/ghdl/ghdl) and [ghdl/docker](https://github.com/ghdl/docker). All the workflows in this repo are triggered by CRON jobs.

### · [`base.yml`](.github/workflows/base.yml) (8 jobs -max 4-, 40 images) [twice a month]

Build and push all the `ghdl/build:*` and `ghdl/run:*` docker images. :

- A pair of images is created in one job for each of `[ ls-debian, ls-ubuntu ]`.
- One job is created for each of `[ fedora (29 | 30), debian (buster | sid), ubuntu (16 | 18)]`, and six images are created in each job; two (`ghdl/build:*`, `ghdl/run:*`) for each supported backend `[ mcode, llvm*, gcc ]`.

### · [`cache.yml`](.github/workflows/cache.yml) (5 jobs -max 5-, 7 images) [weekly]

Build and push all the images to `ghdl/cache:*` and some to `ghdl/synth:*`. Each of the following images includes a tool on top of a `debian:buster-slim` image:

- `ghdl/synth:yosys`: includes [YosysHQ/yosys](https://github.com/YosysHQ/yosys) (`master`).
- `ghdl/synth:icestorm`: includes [cliffordwolf/icestorm](https://github.com/cliffordwolf/icestorm) (`master`).
- `ghdl/synth:nextpnr`: includes [YosysHQ/nextpnr](https://github.com/YosysHQ/nextpnr) (`master`).

Furthermore:

- `ghdl/cache:yosys-gnat`: includes `libgnat-8` on top of `ghdl/synth:yosys`.
- `ghdl/cache:gtkwave`: contains a tarball with [GtkWave](http://gtkwave.sourceforge.net/) (`gtkwave3-gtk3`) prebuilt for images based on Debian Buster.
- `ghdl/cache:formal`: contains a tarball with [YosysHQ/SymbiYosys](https://github.com/YosysHQ/SymbiYosys) (`master`) and [Z3Prover/z3](https://github.com/Z3Prover/z3) (`master`) prebuilt for images based on Debian Buster.
- `ghdl/synth:symbiyosys`: includes the tarball from `ghdl/cache:formal` and Python3 on top of `ghdl/synth:yosys`.

### · [`ghdl.yml`](.github/workflows/ghdl.yml) (15 jobs -max 3-, 30 images) [weekly]

Build and push almost all the `ghdl/ghdl:*` and `ghdl/pkg:*` images. A pair of images is created in one job for each combination of:

- `[ fedora: [29, 30], debian: [sid], ubuntu: [16, 18] ]` and `[ mcode, llvm*]`.
- `[ fedora: [29, 30], debian: [buster, sid] ]` and `[ gcc* ]`.
- For Debian only, `[buster, sid]` and `[mcode]` and `[--gpl]`.

The procedure in each job is as follows:

- Repo [ghdl/ghdl](https://github.com/ghdl/ghdl) is cloned.
- ghdl is built in the corresponding `ghdl/build:*` image.
- A `ghdl/ghdl:*` image is created based on the corresponding `ghdl/run:*` image.
- The testsuite is executed inside the `ghdl/ghdl:*` image created in the previous step.
- If successful, a `ghdl/pkg:*` image is created with the tarball built in the first step.
- `ghdl/ghdl:*` and `ghdl/pkg:*` images are pushed to [hub.docker.com/u/ghdl](https://cloud.docker.com/u/ghdl/repository/list).

### · [`daily.yml`](.github/workflows/daily.yml) (3 jobs -max 3-, 6 images) [daily]

Complement of `ghdl.yml`, to be run daily. One job is scheduled for each combination of `[ buster ]` and `[ mcode, llvm-7 , gcc-8.3.0 ]`.

### · [`ext.yml`](.github/workflows/ext.yml) (5 jobs -max 4-, 15 images) [twice a week]

Build and push all the `ghdl/vunit:*` and `ghdl/ext:*` images. Four jobs are scheduled:

- `ls`: build and push `ghdl/ext:ls-debian` and `ghdl/ext:ls-ubuntu` (a job for each of them). These include [ghdl/ghdl](https://github.com/ghdl/ghdl), the [ghdl/ghdl-language-server](https://github.com/ghdl/ghdl-language-server) backend and the vscode-client (precompiled but not preinstalled).
- `vunit`: build and push all the `ghdl/vunit:*` images, which are based on the ones created in the daily workflow.
- `gui`: build and push the following images:
  - `ghdl/ext:gtkwave`: includes [GtkWave](http://gtkwave.sourceforge.net/) (gtk3) on top of `ghdl/vunit:llvm-master`.
  - `ghdl/ext:broadway`: adds a script to `ghdl/ext:gtkwave` in order to launch a [Broadway](https://developer.gnome.org/gtk3/stable/gtk-broadway.html) server that allows to use GtkWave from a web browser.
  - `ghdl/ext:ls-vunit`: includes VUnit (`master`) on top of `ghdl/ext:ls-debian`.
  - `ghdl/ext:latest`: includes [GtkWave](http://gtkwave.sourceforge.net/) on top of `ghdl/ext:ls-vunit`.
- `synth`: build and push all the `ghdl/synth:*` images which are not created in workflow `cache`:
  - Repo [tgingold/ghdlsynth-beta](https://github.com/tgingold/ghdlsynth-beta) is cloned and it's build scripts are used to build two images:
    - `ghdl/synth:latest`: includes [ghdl/ghdl](https://github.com/ghdl/ghdl) with synthesis features enabled on top of a `ghdl/run:buster-mcode` image.
    - `ghdl/synth:beta`: includes ghdl from `ghdl/synth:latest` along with ghdlsynth-beta built as a module for [YosysHQ/yosys](https://github.com/YosysHQ/yosys), on top of `ghdl/cache:yosys-gnat`.
  - Then, image `ghdl/synth:formal` is built, which includes the tarball from `ghdl/cache:formal` and Python3 on top of `ghdl/synth:beta`.

## Packaging

Multiple artifacts (i.e. standalone tarballs) of GHDL are generated in these workflows. For example, each job in `daily.yml` generates a tarball that is then installed in a `ghdl/ghdl:*` image and published in a `ghdl/pkg:*` image. These resources might be useful for users/developers who:

- Want to use a base image which is compatible but different from the ones we use. E.g., use `python:3-slim-buster` instead of `debian:buster-slim`.
- Do not want to build and test GHDL every time.

Precisely, this is how images in [VUnit/docker](https://github.com/VUnit/docker/) are built. See [github.com/VUnit/docker/blob/master/run.sh](https://github.com/VUnit/docker/blob/e6cb236d021b42f44640fd0e7b83c0dc4ff22144/run.sh#L36-L54).

However, it is discouraged to use these pre-built tarballs to install GHDL on host systems. Instead, [ghdl/packaging](https://github.com/ghdl/packaging) contains sources for package manager systems, and it provides *nightly builds* of GHDL.
