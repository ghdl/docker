#! /bin/sh

set -e

cd $(dirname $0)/../dockerfiles

. ../travis/utils.sh

export DOCKER_BUILDKIT=1

#--

case "$TRAVIS_COMMIT_MESSAGE" in
  *'[skip]'*)
    SKIP_BUILD=true
  ;;
esac
echo "SKIP_BUILD: $SKIP_BUILD"

#--

build_img () {
  travis_start "$TAG" "[DOCKER build] $DREPO : ${DTAG}"
  DCTX="-"
  case "$1" in
    "--ctx"*)
    DCTX="-f- $(echo $1 | sed 's/--ctx=//g')"
    shift
    ;;
  esac
  printf "· ${ANSI_CYAN}File: ${ANSI_NOCOLOR}"
  echo "$DFILE"
  printf "· ${ANSI_CYAN}Ctx:  ${ANSI_NOCOLOR}"
  echo "$DCTX"
  printf "· ${ANSI_CYAN}Args: ${ANSI_NOCOLOR}"
  echo "$@"
  if [ "x$SKIP_BUILD" = "xtrue" ]; then
    printf "${ANSI_YELLOW}SKIP_BUILD...$ANSI_NOCOLOR\n"
  else
    docker build -t "ghdl/${DREPO}:$DTAG" "$@" $DCTX < $DFILE
  fi
  travis_finish "$TAG"
}

#--

create_distro_images () {
  for tag in mcode llvm gcc; do
    i="${ver}-$tag"
    if [ "x$tag" = "xllvm" ]; then i="$i-$LLVM_VER"; fi
    TAG="$d-$i" \
    DREPO="$d" \
    DTAG="$i" \
    DFILE="${d}_debian" \
    build_img \
    --target="$tag" \
    --build-arg IMAGE="$BASE_IMAGE" \
    --build-arg LLVM_VER="$LLVM_VER" \
    --build-arg GNAT_VER="$GNAT_VER"
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
        TAG="ghdl/$img.ls-$dist" \
        DREPO="$img" \
        DTAG="ls-$dist" \
        DFILE=ls_debian_base \
        build_img \
        --target="$img" \
        --build-arg IMAGE="$BASE_IMAGE" \
        --build-arg LLVM_VER="$LLVM_VER" \
        --build-arg GNAT_VER="$GNAT_VER" \
        --build-arg APT_PY="$APT_PY"
      done
    ;;

    *)
      printf "Build distro images\n"
      for d in build run; do
          case $DISTRO in

            "debian")
              for ver in stretch buster sid; do
                case $ver in
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
                BASE_IMAGE="$DISTRO:$ver-slim"
                create_distro_images
              done
            ;;

            "ubuntu")
              for ver in 14 16 18; do
                case $ver in
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
                BASE_IMAGE="$DISTRO:$ver.04"
                ver="ubuntu$ver"
                create_distro_images
              done
            ;;

            "fedora")
              for f in 28 29 30; do
                for tgt in `grep -oP "FROM.*AS \K.*" ./${d}_fedora`; do
                  i="fedora${f}-$tgt"
                  TAG="$d-$i" DREPO="$d" DTAG="$i" DFILE="${d}_fedora" build_img --target="$tgt" --build-arg IMAGE="fedora:${f}"
                done
              done
            ;;
          esac
      done
    ;;
  esac
}

#--

extended() {
  case $1 in
  vunit)
    export DOCKER_BUILDKIT=0
    for fulltag in buster-mcode buster-llvm-7 buster-gcc-8.3.0; do
      TAG="$(echo $fulltag | sed 's/buster-\(.*\)/\1/g' | sed 's/-.*//g' )"
      for version in stable master; do
        if [ "x$version" = "xmaster" ]; then
          TAG="$TAG-master"
        fi
        DREPO=vunit DTAG="$TAG" DFILE=vunit build_img --target="$version" --build-arg TAG="$fulltag"
      done
    done
  ;;
  *)
    for TAG in gtkwave ls-vunit latest; do
      DREPO=ext DTAG="$TAG" DFILE=gui build_img --target="$TAG"
    done
    TAG="broadway" DREPO=ext DTAG="broadway" DFILE=gui build_img --ctx=.. --target="broadway"
  ;;
  esac
}

#--

synth() {
  case $1 in
  synth)
    for TAG in yosys yosys-gnat; do
      DREPO=synth DTAG="$TAG" DFILE=synth_yosys build_img --target="$TAG"
    done
    travis_start "synth" "[DOCKER build] synth : beta"
    mkdir -p ghdlsynth
    cd ghdlsynth
    curl -fsSL https://codeload.github.com/tgingold/ghdlsynth-beta/tar.gz/master | tar xzf - --strip-components=1
    ./travis.sh
    cd ..
    travis_finish "synth"
  ;;
  formal)
    for TAG in symbiyosys formal; do
      DREPO=synth DTAG="$TAG" DFILE=synth_formal build_img --target="$TAG"
    done
  ;;
  pnr)
    for TAG in icestorm nextpnr; do
      DREPO=synth DTAG="$TAG" DFILE=synth_nextpnr build_img --target="$TAG"
    done
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
  llvm_ver="7"
  if [ "x$distro" = "xubuntu" ]; then
    llvm_ver="6.0"
  fi
  TAG="ls-$distro" DREPO="ext" DTAG="ls-$distro" DFILE=ls_debian build_img --build-arg "DISTRO=$distro" --build-arg LLVM_VER=$llvm_ver
}

#--

deploy () {
  case $1 in
    "")
      FILTER="/build /run";;
    "ext"|"debian"|"ubuntu"|"gui")
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

  . ./docker_login.sh

  for key in $FILTER; do
    for tag in `echo $(docker images "ghdl$key*" | awk -F ' ' '{print $1 ":" $2}') | cut -d ' ' -f2-`; do
      if [ "$tag" = "REPOSITORY:TAG" ]; then break; fi
      i="`echo $tag | grep -oP 'ghdl/\K.*' | sed 's#:#-#g'`"
      travis_start "$i" "[DOCKER push] ${tag}" "$ANSI_YELLOW"
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
  travis_start "build_scratch" "[DOCKER build] ghdl/pkg:${IMAGE_TAG}"
  docker build -t ghdl/pkg:$IMAGE_TAG . -f-<<EOF
FROM scratch
COPY `ls | grep '^ghdl.*\.tgz'` ./
COPY BUILD_TOOLS ./
EOF
  travis_finish "build_scratch"
}

build () {
  CONFIG_OPTS="--default-pic " ./dist/travis/travis-ci.sh
  if [ "$TRAVIS_OS_NAME" != "osx" ]; then
    if [ -f test_ok ]; then
      build_img_pkg
    fi
  fi
}

#--

case "$1" in
  -b)
    cd ../ghdl
    build
  ;;
  -c)
    create
  ;;
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
    cd ../travis
    deploy $@
esac
