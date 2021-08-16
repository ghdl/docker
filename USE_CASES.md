# Ready-to-use demo

Thanks to [play-with-docker (PWD)](https://labs.play-with-docker.com/), any user can try GHDL without installing anything. Shall local execution be preferred, installation/removal is as simple as pulling/removing a docker image.

# Portable environment

The same image can be used in GNU/Linux, macOS and windows. This allows developers to forget about library version collisions, different locations of resources, unsynchronized updates, etc.

This same feature is useful in CI environment. E.g. run a script in travis to compile and test a VHDL design:

``` bash
docker run --rm -t \
  -v /$(pwd):/src \
  -w //src \
  ghdl/ghdl:bullseye-mcode \
  bash -c "$(cat myscript.sh)"
```

# Testable/reproducible issues

On the one hand, the ['Bug report' issue template in ghdl/ghdl](https://github.com/ghdl/ghdl/issues/new?template=bug_report.md) provides an example of how to use [1138-4EB/issue-runner](https://github.com/1138-4EB/issue-runner) in order to allow developers and contributors to share executable Minimal Working Examples (MWEs). This allows to test the code in any of the available [![`ghdl/ghdl`](https://img.shields.io/badge/ghdl/ghdl-*-blue.svg?style=flat-square)](https://hub.docker.com/r/ghdl/ghdl/tags) or [![`ghdl/ext`](https://img.shields.io/badge/ghdl/ghdl-*-blue.svg?style=flat-square)](https://hub.docker.com/r/ghdl/ghdl/tags) docker images, to ensure that i) the possible bug is not already fixed, and ii) the problem is not related to the user's setup/environment.

# Nightly builds / rolling release

Travis-GitHub integration for releases is not really meant for nightly builds. There are external tools, such as [nightlies](https://nightli.es/), to achieve it, but they require quite many permissions on the repository. However, docker images are *rolling releases* by default, and, if wanted, specific versions can be fixed by tagging them. Then, the names of images used all along this document refer to rolling/latest/nightly versions and are updated periodically (through CRON jobs).

<a name="fun"></a>
# Let's have some fun!

As explained in [ghdl/ghdl#489](https://github.com/ghdl/ghdl/pull/489), [![`ghdl/build`](https://img.shields.io/badge/ghdl/build-*-blue.svg?style=flat-square)](https://hub.docker.com/r/ghdl/build/tags) and [![`ghdl/run`](https://img.shields.io/badge/ghdl/run-*-blue.svg?style=flat-square)](https://hub.docker.com/r/ghdl/run/tags) images are only meant to be used during the build process. The ready-to-use artifacts are [![`ghdl/ghdl`](https://img.shields.io/badge/ghdl/ghdl-*-blue.svg?style=flat-square)](https://hub.docker.com/r/ghdl/ghdl/tags) images. Note that each `llvm` image corresponds to a different platform and library version:

- `ubuntu14-llvm-3.8`
- `ubuntu16-llvm-3.9`
- `fedora26-llvm` [4.0]
- `ubuntu18-llvm-5.0`

You need docker installed and the daemon running. If you don't, you can try the images in any of these playgrounds:

- [play-with-docker](https://labs.play-with-docker.com/) (requires Docker ID)
- The public demo of [Portainer](https://github.com/portainer/portainer) (see user and pass in the readme)

We may use any of the images. I will take the smallest image (75MB), [![`ghdl/ghdl`](https://img.shields.io/badge/ghdl/ghdl-bullseye--mcode-blue.svg?style=flat-square)](https://hub.docker.com/r/ghdl/ghdl/tags), and start a container with a shell prompt:

``` bash
$(commnad -v winpty) docker run --rm -it ghdl/ghdl:bullseye-mcode bash
```

> NOTE: `winpty` is required on windows (MSYS2) only.

Then, in the prompt inside the container, we check the version:

``` bash
ghdl --version
```

Now, we will execute the examples of [VUnit/vunit](https://github.com/VUnit/vunit). Since the image contains minimum runtime dependencies for GHDL, we need to install python and git (or curl, wget...). This is debian, so:

``` bash
apt-get install -y git python3-pip
pip3 install vunit_hdl
git clone https://github.com/VUnit/vunit/
```

Ready to go!

``` bash
for f in $(find vunit/examples/vhdl/ -name 'run.py'); do python3 $f; done
```

---

![ghdl_pwd_demo_shell](https://user-images.githubusercontent.com/6628437/33694969-2e7b7030-dafb-11e7-9eba-fb3abae1a161.gif)

# Extended images

A reduced number of carefully crafted images is built on top of [![`ghdl/ghdl`](https://img.shields.io/badge/ghdl/ghdl-*-blue.svg?style=flat-square)](https://hub.docker.com/r/ghdl/ghdl/tags) images. These are meant to let users make the best of GHDL by adding companion tools, such as [VUnit](https://vunit.github.io/) or [gtkwave](https://gtkwave.sourceforge.net/). In order to make the first contact easier for them, these are all based on `debian:bullseye`. Right now, these are available:

- [![`ghdl/ext`](https://img.shields.io/badge/ghdl/ext-vunit-blue.svg?style=flat-square)](https://hub.docker.com/r/ghdl/ext/tags)
  - BASED ON `ghdl/ghdl:bullseye-mcode`
  - python3
  - pip3 install vunit_hdl
  - apt-get install -y curl

- [![`ghdl/ext`](https://img.shields.io/badge/ghdl/ext-vunit--gtkwave-blue.svg?style=flat-square)](https://hub.docker.com/r/ghdl/ext/tags)
  - BASED ON `ghdl/ext:vunit`
  - gtkwave
  - X11 libraries

- [![`ghdl/ext`](https://img.shields.io/badge/ghdl/ext-broadway-blue.svg?style=flat-square)](https://hub.docker.com/r/ghdl/ext/tags)
  - BASED ON `ghdl/ext:vunit-gtkwave`
  - Companion script to launch a [GTK+ Broadway](https://developer.gnome.org/gtk3/stable/gtk-broadway.html) server that allows to access GUI applications in the container through a web browser.

Please, let us know if you think that `llvm` and `gcc` variants are requied for [![`ghdl/ext`](https://img.shields.io/badge/ghdl/ext-*-blue.svg?style=flat-square)](https://hub.docker.com/r/ghdl/ext/tags) images. It is also possible for two (or more) GHDL installations (each one built with a compiler) to somehow coexist in the same machine/container (see [ghdl/ghdl#445](https://github.com/ghdl/ghdl/issues/445)).

---

## Non-GUI environments

Since [![`ghdl/ext`](https://img.shields.io/badge/ghdl/ext-vunit-blue.svg?style=flat-square)](https://hub.docker.com/r/ghdl/ext/tags) is equivalent to [![`ghdl/ghdl`](https://img.shields.io/badge/ghdl/ghdl-bullseye--mcode-blue.svg?style=flat-square)](https://hub.docker.com/r/ghdl/ghdl/tags) + VUnit, the exercise above can be reduced to:

``` bash
# Start a container with option `--interactive`
$(commnad -v winpty) docker run --rm -it ghdl/ext:vunit bash
# In the prompt inside the container:
ghdl --version
mkdir vunit
curl -L https://github.com/VUnit/vunit/archive/v2.2.0.tar.gz | tar xz -C vunit --strip-components=1
for f in $(find vunit/examples/vhdl/ -name 'run.py'); do python3 $f; done
```

Note that, instead of `git`, `curl` was used to download the VUnit repo.

## Environments with GUIs

Let's try [![`ghdl/ext`](https://img.shields.io/badge/ghdl/ext-vunit--gtkwave-blue.svg?style=flat-square)](https://hub.docker.com/r/ghdl/ext/tags) now. We will execute the [full_adder](http://ghdl.readthedocs.io/en/latest/using/QuickStartGuide.html#a-full-adder) example from the docs, which are hosted in [1138-4EB/hwd-ide](https://github.com/1138-4EB/hwd-ide).

> NOTE: [x11docker](https://github.com/mviereck/x11docker) is a helper script to enable GUI apps inside the container to use a X server on the host. If running the example on Windows, [VcXsrv](https://sourceforge.net/projects/vcxsrv/) or [Cygwin/X](https://x.cygwin.com/) are required (see [MSYS2, Cygwin and WSL on MS Windows](https://github.com/mviereck/x11docker#msys2-cygwin-and-wsl-on-ms-windows)).
> When required, `x11docker` use `winpty` under the hood, so it is not required to set it.

``` bash
# Start a container with option `--interactive`
x11docker -i ghdl/ext:vunit-gtkwave bash
# In the prompt inside the container:
mkdir hwd-ide
curl -L https://github.com/1138-4EB/hwd-ide/archive/develop.tar.gz | tar xz -C hwd-ide --strip-components=1
./hwd-ide/examples/full_adder/test.sh
ls -la
gtkwave adder.vcd
```

![ghdl_vunit-gtkwave](https://user-images.githubusercontent.com/6628437/33923787-6178e760-dfd3-11e7-9183-808c85c43f65.gif)

As an alternative to using an X server on the host, a [GTK+ Broadway](https://developer.gnome.org/gtk3/stable/gtk-broadway.html) server can be started. This is a backend for displaying GTK+ applications in a web browser. Precisely, [![`ghdl/ext`](https://img.shields.io/badge/ghdl/ext-broadway-blue.svg?style=flat-square)](https://hub.docker.com/r/ghdl/ext/tags) includes a script that checks if the environment variable `BROADWAY` is not empty, to start it on port `$((8080 + $BROADWAY))`. For example:

``` bash
# Start a container with either `x11docker` or `docker run`:
$(commnad -v winpty) docker run -it \
  -e BROADWAY=5 -p 8085:8085 -- ghdl/ext:broadway bash
# or
x11docker -it -- \
  -e BROADWAY=5 -p 8085:8085 -- ghdl/ext:broadway bash
```

Then, browse `localhost:8085`. An empty white page should be loaded, which means that the server is running, but no GUI app is started yet. Start a GUI app, say `gtkwave`, from the prompt in the container and it will be shown.
