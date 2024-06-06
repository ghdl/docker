<p align="center">
  <a title="Join the chat at https://gitter.im/ghdl1/Lobby" href="https://gitter.im/ghdl1/Lobby?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge"><img src="https://img.shields.io/badge/chat-on%20gitter-4db797.svg?longCache=true&style=flat-square&logo=gitter&logoColor=e8ecef"></a><!--
  -->
  <a title="'base' workflow Status" href="https://github.com/ghdl/docker/actions/workflows/base.yml"><img alt="'base' workflow Status" src="https://img.shields.io/github/actions/workflow/status/ghdl/docker/base.yml?branch=master&longCache=true&style=flat-square&label=base&logo=GitHub%20Actions&logoColor=fff"></a><!--
  -->
  <a title="'test' workflow Status" href="https://github.com/ghdl/docker/actions/workflows/test.yml"><img alt="'test' workflow Status" src="https://img.shields.io/github/actions/workflow/status/ghdl/docker/test.yml?branch=master&longCache=true&style=flat-square&label=test&logo=GitHub%20Actions&logoColor=fff"></a><!--
  -->
  <a title="'bookworm' workflow Status" href="https://github.com/ghdl/docker/actions/workflows/bookworm.yml"><img alt="'bookworm' workflow Status" src="https://img.shields.io/github/actions/workflow/status/ghdl/docker/bookworm.yml?branch=master&longCache=true&style=flat-square&label=bookworm&logo=GitHub%20Actions&logoColor=fff"></a><!--
  -->
</p>

<p align="center">
  <img src="./logo.png"/>
</p>

<p align="center">
  <a title="'vunit' workflow Status" href="https://github.com/ghdl/docker/actions/workflows/vunit.yml"><img alt="'vunit' workflow Status" src="https://img.shields.io/github/actions/workflow/status/ghdl/docker/vunit.yml?branch=master&longCache=true&style=flat-square&label=vunit&logo=GitHub%20Actions&logoColor=fff"></a><!--
  -->
  <a title="'ext' workflow Status" href="https://github.com/ghdl/docker/actions/workflows/ext.yml"><img alt="'ext' workflow Status" src="https://img.shields.io/github/actions/workflow/status/ghdl/docker/ext.yml?branch=master&longCache=true&style=flat-square&label=ext&logo=GitHub%20Actions&logoColor=fff"></a><!--
  -->
  <a title="'cosim' workflow Status" href="https://github.com/ghdl/docker/actions/workflows/cosim.yml"><img alt="'cosim' workflow Status" src="https://img.shields.io/github/actions/workflow/status/ghdl/docker/cosim.yml?branch=master&longCache=true&style=flat-square&label=cosim&logo=GitHub%20Actions&logoColor=fff"></a><!--
  -->
  <a title="'mirror' workflow Status" href="https://github.com/ghdl/docker/actions/workflows/mirror.yml"><img alt="'mirror' workflow Status" src="https://img.shields.io/github/actions/workflow/status/ghdl/docker/mirror.yml?branch=master&longCache=true&style=flat-square&label=mirror&logo=GitHub%20Actions&logoColor=fff"></a><!--
  -->
</p>

This repository contains scripts and YAML workflows for GitHub Actions (GHA) to build and to deploy the container images that are used and/or published by the [GHDL GitHub organization](https://github.com/ghdl). All of them are pushed to [hub.docker.com/u/ghdl](https://cloud.docker.com/u/ghdl/repository/list).

----

**ATTENTION: Some images related to synthesis and PnR were moved to [hdl/containers](https://github.com/hdl/containers) and [hub.docker.com/u/hdlc](https://hub.docker.com/u/hdlc)**. See [DEPRECATED](DEPRECATED.md).

----

Images for development (i.e., building and/or testing ghdl):

- [![ghdl/build Docker pulls](https://img.shields.io/docker/pulls/ghdl/build?label=ghdl%2Fbuild&style=flat-square)](https://hub.docker.com/r/ghdl/build) images include development/build depedendencies for [ghdl](https://github.com/ghdl/ghdl).
- [![ghdl/run Docker pulls](https://img.shields.io/docker/pulls/ghdl/run?label=ghdl%2Frun&style=flat-square)](https://hub.docker.com/r/ghdl/run) images include runtime dependencies for [ghdl](https://github.com/ghdl/ghdl).
- [![ghdl/pkg Docker pulls](https://img.shields.io/docker/pulls/ghdl/pkg?label=ghdl%2Fpkg&style=flat-square)](https://hub.docker.com/r/ghdl/pkg) images include the content of [ghdl](https://github.com/ghdl/ghdl) tarballs built in [ghdl/build](https://hub.docker.com/r/ghdl/build/tags) images.
- [![ghdl/debug Docker pulls](https://img.shields.io/docker/pulls/ghdl/debug?label=ghdl%2Fdebug&style=flat-square)](https://hub.docker.com/r/ghdl/debug) image is based on `ghdl/build:buster-mcode` and `ghdl/pkg:buster-mcode`; includes Python pip, GNAT GPS, Graphviz and GDB.

Ready-to-use images:

- [![ghdl/ghdl Docker pulls](https://img.shields.io/docker/pulls/ghdl/ghdl?label=ghdl%2Fghdl&style=flat-square)](https://hub.docker.com/r/ghdl/ghdl) images, which are based on correponding [ghdl/run](https://hub.docker.com/r/ghdl/run/tags) images, include [ghdl](https://github.com/ghdl/ghdl) along with minimum runtime dependencies.
- [![ghdl/vunit Docker pulls](https://img.shields.io/docker/pulls/ghdl/vunit?label=ghdl%2Fvunit&style=flat-square)](https://hub.docker.com/r/ghdl/vunit) images, which are based on [`ghdl/ghdl:bookworm-*`](https://hub.docker.com/r/ghdl/ghdl/tags) images, include [ghdl](https://github.com/ghdl/ghdl) along with [VUnit](https://vunit.github.io/).
  - `*-master` variants include latest VUnit (master branch), while others include the latest stable release (installed through pip).
- [![ghdl/ext Docker pulls](https://img.shields.io/docker/pulls/ghdl/ext?label=ghdl%2Fext&style=flat-square)](https://hub.docker.com/r/ghdl/ext/tags) GHDL and complements ([ghdl-language-server](https://github.com/ghdl/ghdl-language-server), [GtkWave](http://gtkwave.sourceforge.net/), [VUnit](https://vunit.github.io/), etc.).
- [![ghdl/cosim Docker pulls](https://img.shields.io/docker/pulls/ghdl/cosim?label=ghdl%2Fcosim&style=flat-square)](https://hub.docker.com/r/ghdl/cosim/tags) GHDL and other tools for co-simulation such as [SciPy](https://www.scipy.org/), [Xyce](https://xyce.sandia.gov/) or [GNU Octave](https://www.gnu.org/software/octave/).

See [USE_CASES.md](./USE_CASES.md) if you are looking for usage examples from a user perspective.

## GHA workflows

### · [base](.github/workflows/base.yml)

Build and push all the `ghdl/build:*` and `ghdl/run:*` docker images. :

- A pair of images is created in one job for `[ ls ]`.
- One job is created for each of `[ fedora (37 | 38), debian (buster | bullseye | bookworm), ubuntu (20 | 22)]`, and six images are created in each job; two (`ghdl/build:*`, `ghdl/run:*`) for each supported backend `[ mcode, llvm*, gcc ]`.
  - `ghdl/debug:base` is created in the `debian buster` job.
  - `ghdl/build:doc` is created in the `debian bookworm` job.

### · [test](.github/workflows/test.yml)

Build and push almost all the `ghdl/ghdl:*` and `ghdl/pkg:*` images. A pair of images is created in one job for each combination of:

- `[ fedora: [37, 38], debian: [bullseye], ubuntu: [20, 22] ]` and `[mcode, llvm*]`.
- `[ fedora: [37, 38], debian: [bullseye] ]` and `[gcc*]`.
- For Debian only, `[bullseye, bookworm]` and `[mcode]` and `[--gpl]`.
- For Debian Buster, only `[mcode]`.
  - `ghdl/debug` is created in this job.

The procedure in each job is as follows:

- Repo [ghdl/ghdl](https://github.com/ghdl/ghdl) is cloned.
- ghdl is built in the corresponding `ghdl/build:*` image.
- A `ghdl/ghdl:*` image is created based on the corresponding `ghdl/run:*` image.
- The testsuite is executed inside the `ghdl/ghdl:*` image created in the previous step.
- If successful, a `ghdl/pkg:*` image is created from `scratch`, with the content of the tarball built in the first step.
- `ghdl/ghdl:*` and `ghdl/pkg:*` images are pushed to [hub.docker.com/u/ghdl](https://cloud.docker.com/u/ghdl/repository/list).

> NOTE: images with GCC backend include `lcov` for code coverage analysis.

### · [bookworm](.github/workflows/bookworm.yml) [scheduled daily]

Complement of `ghdl.yml`, to be run after each successful run of the main workflow in ghdl/ghdl. One job is scheduled for each combination of `[ bookworm ]` and `[ mcode, llvm-14 , gcc-12.3.0 ]`.

### · [vunit](.github/workflows/vunit.yml) [triggered after workflow 'bookworm']

Build and push all the `ghdl/vunit:*` images, which are based on the ones created in the 'bookworm' workflow.
- Two versions are published for each backend: one with latest stable VUnit (from PyPI) and one with the latest `master` (from Git).
- Images with GCC backend include `lcov` and `gcovr` for code coverage analysis.

### · [ext](.github/workflows/ext.yml) [triggered after workflow 'vunit']

Build and push all the `ghdl/ext:*` images:

- `ls`: **ghdl/ext:ls-debian** and **ghdl/ext:ls-ubuntu** (a job for each of them). These include [ghdl/ghdl](https://github.com/ghdl/ghdl), the [ghdl/ghdl-language-server](https://github.com/ghdl/ghdl-language-server) backend and the vscode-client (precompiled but not preinstalled).
- `gui`:
  - **ghdl/ext:gtkwave**: includes [GtkWave](http://gtkwave.sourceforge.net/) (gtk3) on top of *ghdl/vunit:llvm-master*.
  - **ghdl/ext:broadway**: adds a script to *ghdl/ext:gtkwave* in order to launch a [Broadway](https://developer.gnome.org/gtk3/stable/gtk-broadway.html) server that allows to use GtkWave from a web browser.
  - **ghdl/ext:ls-vunit**: includes VUnit (`master`) on top of *ghdl/ext:ls-debian*.
  - **ghdl/ext:latest**: includes [GtkWave](http://gtkwave.sourceforge.net/) on top of `ghdl/ext:ls-vunit`.

### · [cosim](.github/workflows/cosim.yml)

See [ghdl/ghdl-cosim: docker](https://github.com/ghdl/ghdl-cosim/tree/master/docker) and [ghdl.github.io/ghdl-cosim/vhpidirect/examples/vffi_user](https://ghdl.github.io/ghdl-cosim/vhpidirect/examples/vffi_user.html).

- **ghdl/cosim:mcode**: based on *ghdl/ghdl:bookworm-mcode*, includes GCC.
- **ghdl/cosim:py**: based on *ghdl/ghdl:bookworm-llvm-7*, includes Python.
  - **ghdl/cosim:vunit-cocotb**: based on *ghdl/cosim:py*, includes [VUnit](https://vunit.github.io/), [cocotb](https://docs.cocotb.org/) and `g++` (required by cocotb).
    - **ghdl/cosim:matplotlib**: based on *ghdl/cosim:vunit-cocotb*, includes `pytest`, `matplotlib`, `numpy` and Imagemagick.
    - **ghdl/cosim:octave**: based on *ghdl/cosim:vunit-cocotb*, includes [GNU Octave](https://www.gnu.org/software/octave/).
    - **ghdl/cosim:xyce**: based on *ghdl/cosim:vunit-cocotb*, includes [Xyce](https://xyce.sandia.gov/).

NOTE: `*-slim` variants of `matplotlib`, `octave` and `xyce` images are provided too. Those are based on *ghdl/cosim:py*, instead of *ghdl/cosim:vunit-cocotb*.

## Packaging

Multiple artifacts of GHDL are generated in these workflows. For example, each job in `test.yml` generates a tarball that is then installed in a `ghdl/ghdl:*` image, and the content is published in a `ghdl/pkg:*` image. These resources might be useful for users/developers who:

- Want to use a base image which is compatible but different from the ones we use. E.g., use `python:3-slim-bookworm` instead of `debian:bookworm-slim`.
- Do not want to build and test GHDL every time.

However, it is discouraged to use these pre-built artifacts to install GHDL on host systems.

<!--
Instead, [ghdl/packaging](https://github.com/ghdl/packaging) contains sources for package manager systems, and it provides *nightly builds* of GHDL.
-->
