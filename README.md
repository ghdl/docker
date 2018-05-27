# ghdl/docker

This repository contains scripts to build and to deploy the docker images that are used in the [GHDL GitHub organization](https://github.com/ghdl).
All of them are pushed to [hub.docker.com/u/ghdl](https://hub.docker.com/u/ghdl/):

- [`ghdl/build`](https://hub.docker.com/r/ghdl/build/): images with development depedendencies for [GHDL](https://github.com/ghdl/ghdl)
- [`ghdl/run`](https://hub.docker.com/r/ghdl/run/): images with runtime dependencies for [GHDL](https://github.com/ghdl/ghdl)
- [`ghdl/ghdl`](https://hub.docker.com/r/ghdl/ghdl/): ready-to-use images with [GHDL](https://github.com/ghdl/ghdl) and minimum runtime dependencies (based on [`ghdl/run`](https://hub.docker.com/r/ghdl/run/))
- [`ghdl/pkg`](https://hub.docker.com/r/ghdl/pkg/): images with [GHDL](https://github.com/ghdl/ghdl) tarballs built in [`ghdl/build`](https://hub.docker.com/r/ghdl/build/) images
- [`ghdl/ext`](https://hub.docker.com/r/ghdl/ext/): ready-to-use images with GHDL and complements ([GtkWave](http://gtkwave.sourceforge.net/), [VUnit](https://vunit.github.io/), [OSVVM](http://osvvm.org/)...)

See [USE_CASES.md](./USE_CASES.md) if you are looking for usage examples from a user perspective.

---

Due to the time limit in Travis CI, and because not all the images need to be updated at the same frequency, three job matrices are defined. Travis CI does not support dynamic modification of the `.travis.yml` file, so multiple files are used:

- [`.travis.yml`](./.travis.yml): `create.sh` is executed in order to build [`ghdl/build`](https://hub.docker.com/r/ghdl/build/) and [`ghdl/run`](https://hub.docker.com/r/ghdl/run/) images. All of them are pushed to [hub.docker.com/u/ghdl](https://hub.docker.com/u/ghdl/).
- [`.travis-test.yml`](./.travis-test.yml): [ghdl/ghdl](https://github.com/ghdl/ghdl) is cloned, and `travis/buid_test_pkg.sh` is executed. For each of the defined platforms:
  - GHDL is built in the corresponding [`ghdl/build`](https://hub.docker.com/r/ghdl/build/) image.
  - A [`ghdl/ghdl`](https://hub.docker.com/r/ghdl/ghdl/) image is created based on the corresponding [`ghdl/run`](https://hub.docker.com/r/ghdl/run/) image.
  - The testsuite is executed inside the [`ghdl/ghdl`](https://hub.docker.com/r/ghdl/ghdl/) created in the previous step.
  - If successful, a [`ghdl/pkg`](https://hub.docker.com/r/ghdl/pkg/) image is created with the tarball built in the first step.
  - [`ghdl/ghdl`](https://hub.docker.com/r/ghdl/ghdl/) and [`ghdl/pkg`](https://hub.docker.com/r/ghdl/pkg/) images are pushed to [hub.docker.com/u/ghdl](https://hub.docker.com/u/ghdl/).
- [`.travis-ext.yml`](./.travis-ext.yml): `extended.sh` is executed in order to build some of [`ghdl/ext`](https://hub.docker.com/r/ghdl/ext/) images (tags `vunit`, `vunit-master` and `vunit-gtkwave`). All of them are pushed to [hub.docker.com/u/ghdl](https://hub.docker.com/u/ghdl/).

---

However, the sources are all kept in branches `dev` and `master`. Any contribution should be made to any of these. Branches `test` and `ext` are placeholders, which are expected to always be a single commit ahead of some point in the history of `dev`. The following snippet updates either `BRANCH="test"` or `BRANCH="ext"`, after changes are pushed to `master`:

``` bash
git checkout "$BRANCH"
git reset --hard master
cp "".travis-${BRANCH}.yml" .travis.yml
git commit -am "$BRANCH"
```
```
git push origin +"$BRANCH"
```

---

At now, there is no triggering mechanism set up between [ghdl/ghdl](https://github.com/ghdl/ghdl) and [ghdl/docker](https://github.com/ghdl/docker). All the builds in this repo are triggered by CRON jobs:

- `master` runs monthly.
- `test` runs daily.
- `ext` runs daily.
