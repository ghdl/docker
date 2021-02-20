# Contributing

Contributions are welcome!

## Adding a new distro

### Add Dockerfiles

Create `build_<DISTRO>.dockerfile` and `run_<DISTRO>.dockerfile` in the root directory.

* Add one [stage](https://docs.docker.com/develop/develop-images/multistage-build/)
  for each (supported) backend: `mcode`, `llvm` and/or `gcc`.
* Sometimes could be useful to add a `common` stage for shared resources
  (see `build_fedora.dockerfile` or `run_fedora.dockerfile`).
  On the other hand, can be situations where the same backend needs a different stage
  according to the OS versions (see `build_centos.dockerfile` or `run_centos.dockerfile`).
* Images should contain the dependencies for building or installing GHDL only.
  Do not include the actual building/installation procedures in the dockerfiles.
* In `run.sh`, add a new `case` inside of `create ()`.
  It must deal with the `<DISTRO>`, its `<VERSIONS>` and the `<TARGET>` stages.

> You can execute `./run.sh <DISTRO> <VERSION>` to locally build the containers.

### Continuous Integration (CI)

* Add the desidered `<DISTRO>` and its `<VERSIONS>` to the matrix of the `base.yml` CI workflow:
```yaml
matrix:
  include: [
    { distro: arch,     version: ''        },
    { distro: debian,   version: buster    },
    ...
    { distro: <DISTRO>, version: <VERSION> },
```
* Add the desidered `<DISTRO><VERSION>` and `<BACKEND>` to the matrix of the `test.yml` CI workflow:
```yaml
matrix:
  include: [
    ...
    { distro: ubuntu20,          backend: mcode ,      args: "" },
    { distro: fedora32,          backend: mcode ,      args: "" },
    ...
    { distro: <DISTRO><VERSION>, backend: `<BACKEND>`, args: "" },
```

> **NOTE:** in some `<DISTROS>` the `<VERSION>` of the backend (in case of `llvm` and `gcc`)
> needs to be specified (something like `<BACKEND>-<VERSION>`, see `test.yml`).
