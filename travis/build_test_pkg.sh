#! /bin/bash
# This script is executed in the travis-ci environment.

build_img_pkg() {
    travis_start "build_scratch" "$ANSI_BLUE[DOCKER build] ghdl/pkg:${IMAGE_TAG}$ANSI_NOCOLOR"
    cd tmp-img
    docker build -t ghdl/ghdl:$IMAGE_TAG . -f-<<EOF
FROM scratch
COPY $PKG ./
COPY BUILD_TOOLS ./
EOF
    cd .. && rm -rf tmp-img
    travis_finish "build_scratch"
}

#---

set -e

. ./dist/travis/travis-ci.sh

if [ "$TRAVIS_OS_NAME" != "osx" ]; then
  if [ -f test_ok ]; then
    build_img_pkg
  fi
fi
