#! /bin/sh

set -e

cd $(dirname $0)/..

. ./travis/utils.sh

#--

create_image () {
  for tag in mcode llvm gcc; do
      i="${f}-$tag"
      if [ "x$tag" = "xllvm" ]; then i="$i-$LLVM_VER"; fi
      travis_start "$d-$i" "${ANSI_BLUE}[DOCKER build] ${d} : ${f} - ${tag}$ANSI_NOCOLOR"
      docker build -t "ghdl/${d}:$i" --target "$tag" \
        --build-arg IMAGE="$BASE_IMAGE" \
        --build-arg LLVM_VER="$LLVM_VER" \
        --build-arg GNAT_VER="$GNAT_VER" \
        - < "./dockerfiles/${d}_debian"
      travis_finish "$d-$i"
  done
}

create_distro_images () {
  for d in build run; do
      case $DISTRO in

        "debian")
          for f in stretch buster sid; do
            case $f in
              *stretch*)
                LLVM_VER="4.0"
                GNAT_VER="6"
              ;;
              *buster*)
                LLVM_VER="7"
                GNAT_VER="8"
              ;;
              *sid*)
                LLVM_VER="8"
                GNAT_VER="8"
              ;;
            esac
            BASE_IMAGE="$DISTRO:$f-slim"
            create_image
          done
        ;;

        "ubuntu")
          for f in 14 16 18; do
            case $f in
              14) #trusty
                LLVM_VER="3.8"
                GNAT_VER="4.6"
              ;;
              16) #xenial
                LLVM_VER="3.9"
                GNAT_VER="4.9"
              ;;
              18) #bionic
                LLVM_VER="5.0"
                GNAT_VER="7"
              ;;
            esac
            BASE_IMAGE="$DISTRO:$f.04"
            f="ubuntu$f"
            create_image
          done
        ;;

        "fedora")
          for f in 28 29 30; do
              for tag in `grep -oP "FROM.*AS \K.*" ./dockerfiles/${d}_fedora`; do
                  i="fedora${f}-$tag"
                  travis_start "$d-$i" "${ANSI_BLUE}[DOCKER build] ${d} : fedora${f} - ${tag}$ANSI_NOCOLOR"
                  docker build -t "ghdl/${d}:$i" --target "$tag" --build-arg IMAGE="fedora:${f}" - < "./dockerfiles/${d}_fedora"
                  travis_finish "$d-$i"
              done
          done
        ;;
      esac
  done
}

#--

create () {
  case $DISTRO in
    ls-*)
      dist="$(echo $DISTRO | cut -d - -f2)"
      case "$dist" in
        debian)
          BASE_IMAGE="python:3-slim-buster"
          LLVM_VER="7"
          GNAT_VER="7"
          APT_PY=""
        ;;
        ubuntu)
          BASE_IMAGE="ubuntu:bionic"
          LLVM_VER="6.0"
          GNAT_VER="7"
          APT_PY="python3 python3-pip"
        ;;
      esac
      for img in build run; do
          tag="ghdl/$img:ls-$dist"
          travis_start "ghdl/$img.ls-$dist" "$ANSI_BLUE[DOCKER build] $img : ls-${dist}$ANSI_NOCOLOR"
          docker build -t $tag . -f ./dockerfiles/ls_debian_base --target=$img \
            --build-arg IMAGE="$BASE_IMAGE" \
            --build-arg LLVM_VER="$LLVM_VER" \
            --build-arg GNAT_VER="$GNAT_VER" \
            --build-arg APT_PY="$APT_PY"
          travis_finish "ghdl/$img.ls-$dist"
      done
    ;;

    *)
      create_distro_images
    ;;
  esac
}

#--

extended() {
  case $1 in
  vunit)
    for fulltag in buster-mcode buster-llvm-7 buster-gcc-8.3.0; do
      tag="$(echo $fulltag | sed 's/buster-\(.*\)/\1/g' | sed 's/-.*//g' )"
      for version in stable master; do
        if [ "x$version" = "xmaster" ]; then
          tag="$tag-master"
        fi
        travis_start "$tag" "$ANSI_BLUE[DOCKER build] vunit : ${tag}$ANSI_NOCOLOR"
        docker build -t "ghdl/vunit:$tag" --target "$version" --build-arg TAG="$fulltag" - < ./dockerfiles/vunit
        travis_finish "$tag"
      done
    done
  ;;
  *)
    for tag in `grep -oP "FROM.*AS do-\K.*" ./dockerfiles/gui`; do
      travis_start "$tag" "$ANSI_BLUE[DOCKER build] ext : ${tag}$ANSI_NOCOLOR"
      docker build -t "ghdl/ext:$tag" --target "do-$tag" . -f ./dockerfiles/gui
      travis_finish "$tag"
    done
    docker rmi ghdl/ext:ls-debian
  ;;
  esac
}

#--

synth() {
  case $1 in
  synth)
    travis_start "yosys" "$ANSI_BLUE[DOCKER build] synth : yosys$ANSI_NOCOLOR"
    docker build -t ghdl/synth:yosys --target yosys . -f ./dockerfiles/synth_yosys
    travis_finish "yosys"
    travis_start "yosys-gnat" "$ANSI_BLUE[DOCKER build] synth : yosys-gnat$ANSI_NOCOLOR"
    docker build -t ghdl/synth:yosys-gnat --target yosys-gnat . -f ./dockerfiles/synth_yosys
    travis_finish "yosys-gnat"

    travis_start "synth" "$ANSI_BLUE[DOCKER build] synth : beta$ANSI_NOCOLOR"
    mkdir -p ghdlsynth
    cd ghdlsynth
    curl -fsSL https://codeload.github.com/tgingold/ghdlsynth-beta/tar.gz/master | tar xzf - --strip-components=1
    ./travis.sh
    cd ..
    travis_start "synth" "$ANSI_BLUE[DOCKER build] synth : beta$ANSI_NOCOLOR"
  ;;
  formal)
    travis_start "symbiyosys" "$ANSI_BLUE[DOCKER build] synth : symbiyosys$ANSI_NOCOLOR"
    docker build -t ghdl/synth:symbiyosys --target symbiyosys . -f ./dockerfiles/synth_formal
    travis_finish "symbiyosys"
    travis_start "formal" "$ANSI_BLUE[DOCKER build] synth : formal$ANSI_NOCOLOR"
    docker build -t ghdl/synth:formal --target formal . -f ./dockerfiles/synth_formal
    travis_finish "formal"

    docker rmi ghdl/synth:beta ghdl/synth:yosys
  ;;
  pnr)
    travis_start "icestorm" "$ANSI_BLUE[DOCKER build] synth : icestorm$ANSI_NOCOLOR"
    docker build -t ghdl/synth:icestorm --target icestorm . -f ./dockerfiles/synth_nextpnr
    travis_finish "icestorm"
    travis_start "nextpnr" "$ANSI_BLUE[DOCKER build] synth : nextpnr$ANSI_NOCOLOR"
    docker build -t ghdl/synth:nextpnr --target nextpnr . -f ./dockerfiles/synth_nextpnr
    travis_finish "nextpnr"
  ;;
  *)
    echo "${ANSI_RED}synth: unknown task $1!$ANSI_NOCOLOR"
    exit 1
  ;;
  esac
}

#--

language_server() {
  distro="$1"
  tag="ghdl/ext:ls-$distro"
  llvm_ver="7"
  if [ "x$distro" = "xubuntu" ]; then
    llvm_ver="6.0"
  fi
  travis_start "$tag" "$ANSI_BLUE[DOCKER build] ext : ls-${distro}$ANSI_NOCOLOR"
  docker build -t $tag . -f ./dockerfiles/ls_debian --build-arg DISTRO="$distro" --build-arg LLVM_VER="$llvm_ver"
  travis_finish "$tag"
}

#--

deploy () {
  case $1 in
    "")
      FILTER="/build /run";;
    "ext"|"debian"|"ubuntu")
      FILTER="/ext";;
    "synth"|"formal"|"pnr")
      FILTER="/synth";;
    "vunit")
      FILTER="/vunit";;
    "pkg")
      FILTER="/pkg:all";;
    *)
      FILTER="/ghdl /pkg";;
  esac

  . ./travis/docker_login.sh

  for key in $FILTER; do
    for tag in `echo $(docker images "ghdl$key*" | awk -F ' ' '{print $1 ":" $2}') | cut -d ' ' -f2-`; do
      if [ "$tag" = "REPOSITORY:TAG" ]; then break; fi
      i="`echo $tag | grep -oP 'ghdl/\K.*' | sed 's#:#-#g'`"
      travis_start "$i" "$ANSI_YELLOW[DOCKER push] ${tag}$ANSI_NOCOLOR"
      docker push $tag
      travis_finish "$i"
    done
  done

  docker logout
}

#--

build_img_pkg() {
  IMAGE_TAG=`echo $IMAGE | sed -e 's/+/-/g'`
  if [ "x$EXTRA" != "x" ]; then
    IMAGE_TAG="$IMAGE_TAG-$EXTRA"
  fi
  travis_start "build_scratch" "$ANSI_BLUE[DOCKER build] ghdl/pkg:${IMAGE_TAG}$ANSI_NOCOLOR"
  docker build -t ghdl/pkg:$IMAGE_TAG . -f-<<EOF
FROM scratch
COPY `ls | grep '^ghdl.*\.tgz'` ./
COPY BUILD_TOOLS ./
EOF
  travis_finish "build_scratch"
}

build () {
  cd ghdl
  CONFIG_OPTS="--default-pic " ./dist/travis/travis-ci.sh

  if [ "$TRAVIS_OS_NAME" != "osx" ]; then
    if [ -f test_ok ]; then
      build_img_pkg
    fi
  fi
  cd ..
}

#--

case "$1" in
  -b) build    ;;
  -c) create   ;;
  -e)
    shift
    extended "$@"
  ;;
  -s)
    shift
    synth "$@"
  ;;
  -l)
    shift
    language_server "$@"
  ;;
  *)
    deploy $@
esac
