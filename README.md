<p align="center">
<!--
  <a title="Read the Docs" href="http://ghdl.readthedocs.io"><img src="https://img.shields.io/readthedocs/ghdl.svg?longCache=true&style=flat-square&logo=read-the-docs&logoColor=e8ecef"></a><!--
  -->
  <a title="Join the chat at https://gitter.im/ghdl1/Lobby" href="https://gitter.im/ghdl1/Lobby?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge"><img src="https://img.shields.io/badge/chat-on%20gitter-4db797.svg?longCache=true&style=flat-square&logo=gitter&logoColor=e8ecef"></a><!--
  -->
  <a title="'base' workflow Status" href="https://github.com/ghdl/docker/actions?query=workflow%3Abase"><img alt="'base' workflow Status" src="https://img.shields.io/github/workflow/status/ghdl/docker/base?longCache=true&style=flat-square&label=base&logo=GitHub%20Actions&logoColor=fff"></a><!--
  -->
  <a title="'test' workflow Status" href="https://github.com/ghdl/docker/actions?query=workflow%3Atest"><img alt="'test' workflow Status" src="https://img.shields.io/github/workflow/status/ghdl/docker/test?longCache=true&style=flat-square&label=test&logo=GitHub%20Actions&logoColor=fff"></a><!--
  -->
  <a title="'buster' workflow Status" href="https://github.com/ghdl/docker/actions?query=workflow%3Abuster"><img alt="'buster' workflow Status" src="https://img.shields.io/github/workflow/status/ghdl/docker/buster?longCache=true&style=flat-square&label=buster&logo=GitHub%20Actions&logoColor=fff"></a><!--
  -->
</p>

<p align="center">
  <img src="./logo.png"/>
</p>

<p align="center">
  <a title="'cache' workflow Status" href="https://github.com/ghdl/docker/actions?query=workflow%3Acache"><img alt="'cache' workflow Status" src="https://img.shields.io/github/workflow/status/ghdl/docker/cache?longCache=true&style=flat-square&label=cache&logo=GitHub%20Actions&logoColor=fff"></a><!--
  -->
  <a title="'synth' workflow Status" href="https://github.com/ghdl/docker/actions?query=workflow%3Asynth"><img alt="'synth' workflow Status" src="https://img.shields.io/github/workflow/status/ghdl/docker/synth?longCache=true&style=flat-square&label=synth&logo=GitHub%20Actions&logoColor=fff"></a><!--
  -->
  <a title="'vunit' workflow Status" href="https://github.com/ghdl/docker/actions?query=workflow%3Avunit"><img alt="'vunit' workflow Status" src="https://img.shields.io/github/workflow/status/ghdl/docker/vunit?longCache=true&style=flat-square&label=vunit&logo=GitHub%20Actions&logoColor=fff"></a><!--
  -->
  <a title="'ext' workflow Status" href="https://github.com/ghdl/docker/actions?query=workflow%3Aext"><img alt="'ext' workflow Status" src="https://img.shields.io/github/workflow/status/ghdl/docker/ext?longCache=true&style=flat-square&label=ext&logo=GitHub%20Actions&logoColor=fff"></a><!--
  -->
  <a title="'cosim' workflow Status" href="https://github.com/ghdl/docker/actions?query=workflow%3Acosim"><img alt="'cosim' workflow Status" src="https://img.shields.io/github/workflow/status/ghdl/docker/cosim?longCache=true&style=flat-square&label=cosim&logo=GitHub%20Actions&logoColor=fff"></a><!--
  -->
</p>

This repository contains scripts and YAML workflows for GitHub Actions (GHA) to build and to deploy the docker images that are used and/or published by the [GHDL GitHub organization](https://github.com/ghdl). All of them are pushed to [hub.docker.com/u/ghdl](https://cloud.docker.com/u/ghdl/repository/list).

----

Images for development (i.e., building and/or testing ghdl):

- [![ghdl/build Docker pulls](https://img.shields.io/docker/pulls/ghdl/build?label=ghdl%2Fbuild&style=flat-square)](https://hub.docker.com/r/ghdl/build) images include development depedendencies for [ghdl](https://github.com/ghdl/ghdl).
- [![ghdl/run Docker pulls](https://img.shields.io/docker/pulls/ghdl/run?label=ghdl%2Frun&style=flat-square)](https://hub.docker.com/r/ghdl/run) images include runtime dependencies for [ghdl](https://github.com/ghdl/ghdl).
- [![ghdl/pkg Docker pulls](https://img.shields.io/docker/pulls/ghdl/pkg?label=ghdl%2Fpkg&style=flat-square)](https://hub.docker.com/r/ghdl/pkg) images include the content of [ghdl](https://github.com/ghdl/ghdl) tarballs built in [ghdl/build](https://hub.docker.com/r/ghdl/build/tags) images.
- [![ghdl/cache Docker pulls](https://img.shields.io/docker/pulls/ghdl/cache?label=ghdl%2Fcache&style=flat-square)](https://hub.docker.com/r/ghdl/cache) external dependencies which we want to keep almost in the edge, but are not part of [ghdl](https://github.com/ghdl/ghdl).

Ready-to-use images:

- [![ghdl/ghdl Docker pulls](https://img.shields.io/docker/pulls/ghdl/ghdl?label=ghdl%2Fghdl&style=flat-square)](https://hub.docker.com/r/ghdl/ghdl) images, which are based on correponding [ghdl/run](https://hub.docker.com/r/ghdl/run/tags) images, include [ghdl](https://github.com/ghdl/ghdl) along with minimum runtime dependencies. GHDL is built with the experimental `--synth` feature enabled.
- [![ghdl/vunit Docker pulls](https://img.shields.io/docker/pulls/ghdl/vunit?label=ghdl%2Fvunit&style=flat-square)](https://hub.docker.com/r/ghdl/vunit) images, which are based on [`ghdl/ghdl:buster-*`](https://hub.docker.com/r/ghdl/ghdl/tags) images, include [ghdl](https://github.com/ghdl/ghdl) along with [VUnit](https://vunit.github.io/).
  - `*-master` variants include latest VUnit (master branch), while others include the latest stable release (installed through pip).
- [![ghdl/ext Docker pulls](https://img.shields.io/docker/pulls/ghdl/ext?label=ghdl%2Fext&style=flat-square)](https://hub.docker.com/r/ghdl/ext/tags) GHDL and complements ([ghdl-language-server](https://github.com/ghdl/ghdl-language-server), [GtkWave](http://gtkwave.sourceforge.net/), [VUnit](https://vunit.github.io/), etc.).
- [![ghdl/synth Docker pulls](https://img.shields.io/docker/pulls/ghdl/synth?label=ghdl%2Fsynth&style=flat-square)](https://hub.docker.com/r/ghdl/synth) images allow to generate and program bitstreams from HDL sources with open source tools: [ghdl](https://github.com/ghdl/ghdl), [yosys](https://github.com/YosysHQ/yosys), [nextpnr](https://github.com/YosysHQ/nextpnr) (`master`), [icestorm](https://github.com/cliffordwolf/icestorm), [prjtrellis](https://github.com/SymbiFlow/prjtrellis), etc.
- [![ghdl/cosim Docker pulls](https://img.shields.io/docker/pulls/ghdl/cosim?label=ghdl%2Fcosim&style=flat-square)](https://hub.docker.com/r/ghdl/cosim/tags) GHDL and other tools for co-simulation such as [SciPy](https://www.scipy.org/), [Xyce](https://xyce.sandia.gov/) or [GNU Octave](https://www.gnu.org/software/octave/).

See [USE_CASES.md](./USE_CASES.md) if you are looking for usage examples from a user perspective.

## GHA workflows

> NOTE: currently, there is no triggering mechanism set up between [ghdl/ghdl](https://github.com/ghdl/ghdl) and [ghdl/docker](https://github.com/ghdl/docker). All the workflows in this repo are triggered by CRON jobs.

### · [base](.github/workflows/base.yml) (8 jobs -max 4-, 40 images) [twice a month]

Build and push all the `ghdl/build:*` and `ghdl/run:*` docker images. :

- A pair of images is created in one job for each of `[ ls-debian, ls-ubuntu ]`.
- One job is created for each of `[ fedora (31 | 32), debian (buster | bullseye), ubuntu (18 | 20)]`, and six images are created in each job; two (`ghdl/build:*`, `ghdl/run:*`) for each supported backend `[ mcode, llvm*, gcc ]`.

### · [cache](.github/workflows/cache.yml) (5 jobs -max 4-, 11 images) [weekly]

Build and push all the images to `ghdl/cache:*` and some to `ghdl/synth:*`. Each of the following images includes a tool on top of a `debian:buster-slim` image:

- `ghdl/synth:yosys`: includes [yosys](https://github.com/YosysHQ/yosys) (`master`).
- `ghdl/synth:icestorm`: includes [icestorm](https://github.com/cliffordwolf/icestorm) (`master`) without `iceprog`.
- `ghdl/synth:trellis`: includes [prjtrellis](https://github.com/SymbiFlow/prjtrellis) (`master`).
- `ghdl/synth:prog`: includes `iceprog` from [icestorm](https://github.com/cliffordwolf/icestorm) (`master`) and [openocd](http://openocd.org/).
- `ghdl/synth:nextpnr-ice40`: includes [nextpnr](https://github.com/YosysHQ/nextpnr) (`master`) with support for ICE40 devices only.
- `ghdl/synth:nextpnr-ecp5`: includes [nextpnr](https://github.com/YosysHQ/nextpnr) (`master`) with support for ECP5 devices only.
- `ghdl/synth:nextpnr`: includes [nextpnr](https://github.com/YosysHQ/nextpnr) (`master`) with support for all architectures (see [nextpnr: Additional notes for building nextpnr](https://github.com/YosysHQ/nextpnr#additional-notes-for-building-nextpnr)).

Furthermore:

- `ghdl/cache:yosys-gnat`: includes `libgnat-8` on top of `ghdl/synth:yosys`.
- `ghdl/cache:gtkwave`: contains a tarball with [GtkWave](http://gtkwave.sourceforge.net/) (`gtkwave3-gtk3`), prebuilt for images based on Debian Buster.
- `ghdl/cache:formal`: contains a tarball with [SymbiYosys](https://github.com/YosysHQ/SymbiYosys) (`master`) and [z3](https://github.com/Z3Prover/z3) (`master`), prebuilt for images based on Debian Buster.
- `ghdl/synth:symbiyosys`: includes the tarball from `ghdl/cache:formal` and Python3 on top of `ghdl/synth:yosys`.

### · [test](.github/workflows/test.yml) (15 jobs -max 3-, 30 images) [weekly]

Build and push almost all the `ghdl/ghdl:*` and `ghdl/pkg:*` images. A pair of images is created in one job for each combination of:

- `[ fedora: [31, 32], debian: [bullseye], ubuntu: [18, 20] ]` and `[mcode, llvm*]`.
- `[ fedora: [31, 32], debian: [buster, bullseye] ]` and `[gcc*]`.
- For Debian only, `[buster, bullseye]` and `[mcode]` and `[--gpl]`.

The procedure in each job is as follows:

- Repo [ghdl/ghdl](https://github.com/ghdl/ghdl) is cloned.
- ghdl is built in the corresponding `ghdl/build:*` image.
- A `ghdl/ghdl:*` image is created based on the corresponding `ghdl/run:*` image.
- The testsuite is executed inside the `ghdl/ghdl:*` image created in the previous step.
- If successful, a `ghdl/pkg:*` image is created from `scratch`, with the content of the tarball built in the first step.
- `ghdl/ghdl:*` and `ghdl/pkg:*` images are pushed to [hub.docker.com/u/ghdl](https://cloud.docker.com/u/ghdl/repository/list).

> NOTE: images with GCC backend include `lcov` for code coverage analysis.

### · [buster](.github/workflows/buster.yml) (3 jobs -max 3-, 6 images) [triggered by ghdl/ghdl nightly job]

Complement of `ghdl.yml`, to be run after each successful run of the main workflow in ghdl/ghdl. One job is scheduled for each combination of `[ buster ]` and `[ mcode, llvm-7 , gcc-8.3.0 ]`.

### · [synth](.github/workflows/synth.yml) (1 jobs, 2 images) [triggered after workflow 'buster']

Build and push all the `ghdl/synth:*` images which are not created in workflow `cache`. Repo [tgingold/ghdlsynth-beta](https://github.com/tgingold/ghdlsynth-beta) is cloned and its CI script is used to build two images:
  - `ghdl/synth:beta` includes ghdl from `ghdl/pkg:buster-mcode` along with ghdlsynth-beta built as a module for [YosysHQ/yosys](https://github.com/YosysHQ/yosys), on top of `ghdl/cache:yosys-gnat`.
  - `ghdl/synth:formal` includes the tarball from `ghdl/cache:formal` and Python3 on top of `ghdl/synth:beta`.

### · [vunit](.github/workflows/vunit.yml) (1 job, 6 images) [triggered after workflow 'buster']

Build and push all the `ghdl/vunit:*` images, which are based on the ones created in the 'buster' workflow.
- Two versions are published for each backend: one with latest stable VUnit (from PyPI) and one with the latest `master` (from Git).
- Images with GCC backend include `lcov` and `gcovr` for code coverage analysis.

### · [ext](.github/workflows/ext.yml) (3 jobs -max 2-, 6 images) [triggered after workflow 'vunit']

Build and push all the `ghdl/ext:*` images:

- `ls`: `ghdl/ext:ls-debian` and `ghdl/ext:ls-ubuntu` (a job for each of them). These include [ghdl/ghdl](https://github.com/ghdl/ghdl), the [ghdl/ghdl-language-server](https://github.com/ghdl/ghdl-language-server) backend and the vscode-client (precompiled but not preinstalled).
- `gui`:
  - `ghdl/ext:gtkwave`: includes [GtkWave](http://gtkwave.sourceforge.net/) (gtk3) on top of `ghdl/vunit:llvm-master`.
  - `ghdl/ext:broadway`: adds a script to `ghdl/ext:gtkwave` in order to launch a [Broadway](https://developer.gnome.org/gtk3/stable/gtk-broadway.html) server that allows to use GtkWave from a web browser.
  - `ghdl/ext:ls-vunit`: includes VUnit (`master`) on top of `ghdl/ext:ls-debian`.
  - `ghdl/ext:latest`: includes [GtkWave](http://gtkwave.sourceforge.net/) on top of `ghdl/ext:ls-vunit`.

### · [cosim](.github/workflows/cosim.yml) [weekly]

See [ghdl/ghdl-cosim: docker](https://github.com/ghdl/ghdl-cosim/tree/master/docker) and [ghdl.github.io/ghdl-cosim/vhpidirect/examples/vffi_user](https://ghdl.github.io/ghdl-cosim/vhpidirect/examples/vffi_user.html).

## Packaging

Multiple artifacts of GHDL are generated in these workflows. For example, each job in `test.yml` generates a tarball that is then installed in a `ghdl/ghdl:*` image, and the content is published in a `ghdl/pkg:*` image. These resources might be useful for users/developers who:

- Want to use a base image which is compatible but different from the ones we use. E.g., use `python:3-slim-buster` instead of `debian:buster-slim`.
- Do not want to build and test GHDL every time.

However, it is discouraged to use these pre-built artifacts to install GHDL on host systems.

<!--
Instead, [ghdl/packaging](https://github.com/ghdl/packaging) contains sources for package manager systems, and it provides *nightly builds* of GHDL.
-->
