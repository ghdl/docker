#!/usr/bin/env sh

set -e

cd $(dirname $0)

. ./utils.sh

export DOCKER_BUILDKIT=1

#SKIP_BUILD=true
#SKIP_DEPLOY=true

#--

case "$TRAVIS_COMMIT_MESSAGE" in
  *'[skip]'*)
    SKIP_BUILD=true
  ;;
esac
echo "SKIP_BUILD: $SKIP_BUILD"

#--

build_img () {
  gstart "[DOCKER build] $DREPO : ${DTAG}"
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
    docker build -t "ghdl/${DREPO}:$DTAG" "$@" $DCTX < "${DFILE}".dockerfile
  fi
  gend
}

build_debian_images () {
  for tag in mcode llvm gcc; do
    i="${ITAG}-$tag"
    if [ "x$tag" = "xllvm" ]; then i="$i-$LLVM_VER"; fi
    TAG="$d-$i" \
    DREPO="$d" \
    DTAG="$i" \
    DFILE="${d}_debian" \
    build_img \
    --target="$tag" \
    "$@"
  done
}

#--

create () {
  TASK="$1"
  VERSION="$2"
  case $TASK in
    arch)
      DREPO="build" DTAG="archlinux" DFILE="build_arch" build_img
    ;;

    ls)
      for img in build run; do
        DREPO="$img" \
        DTAG="ls" \
        DFILE=ls_base \
        build_img \
        --target="$img" \
        --build-arg LLVM_VER="9" \
        --build-arg GNAT_VER="9"
      done
    ;;

    *)
      for d in build run; do
          case $TASK in

            "debian")
              case $VERSION in
                *stretch*)
                  LLVM_VER="4.0"
                  GNAT_VER="6"
                ;;
                *buster*)
                  LLVM_VER="7"
                  GNAT_VER="8"
                ;;
                *bullseye*)
                  LLVM_VER="9"
                  GNAT_VER="9"
                ;;
              esac
              ITAG="$VERSION"
              build_debian_images \
                --build-arg IMAGE="$TASK:$VERSION-slim" \
                --build-arg LLVM_VER="$LLVM_VER" \
                --build-arg GNAT_VER="$GNAT_VER"
            ;;

            "ubuntu")
              case $VERSION in
                14) #trusty
                  LLVM_VER="3.8"
                  GNAT_VER="4.6"
                ;;
                16) #xenial
                  LLVM_VER="3.9"
                  GNAT_VER="4.9"
                ;;
                20) #focal
                  LLVM_VER="10"
                  GNAT_VER="9"
                ;;
                22) #jammy
                  LLVM_VER="11"
                  GNAT_VER="10"
                ;;
              esac
              ITAG="ubuntu$VERSION"
              build_debian_images \
                --build-arg IMAGE="$TASK:$VERSION.04" \
                --build-arg LLVM_VER="$LLVM_VER" \
                --build-arg GNAT_VER="$GNAT_VER"
            ;;

            "fedora")
              for tgt in  mcode llvm gcc; do
                i="fedora${VERSION}-$tgt"
                TAG="$d-$i" DREPO="$d" DTAG="$i" DFILE="${d}_fedora" build_img --target="$tgt" --build-arg IMAGE="fedora:${VERSION}"
              done
            ;;

          esac
      done
    ;;
  esac
}

#--

extended() {
  case "$1" in
    vunit)
      for fulltag in bullseye-mcode bullseye-llvm-9 bullseye-gcc-9.1.0; do
        TAG="$(echo $fulltag | sed 's/bullseye-\(.*\)/\1/g' | sed 's/-.*//g' )"
        for version in stable master; do
          PY_PACKAGES=""
          if [ "x$TAG" = "xgcc" ]; then
            PY_PACKAGES="gcovr"
          fi
          if [ "x$version" = "xmaster" ]; then
            TAG="$TAG-master"
          fi
          DREPO=vunit \
          DTAG="$TAG" \
          DFILE=vunit \
          build_img \
          --target="$version" \
          --build-arg TAG="$fulltag" \
          --build-arg PY_PACKAGES="$PY_PACKAGES"
          # Sanity check that the VUnit package works
          docker run --rm ghdl/vunit:$TAG python3 -c "import vunit; print(vunit.__version__)"
        done
      done
    ;;
    gui)
      for TAG in ls-vunit latest; do
        DREPO=ext DTAG="$TAG" DFILE=gui build_img --target="$TAG"
      done
      TAG="broadway" DREPO=ext DTAG="broadway" DFILE=gui build_img --ctx=. --target="broadway"
    ;;
    *)
      printf "${ANSI_RED}ext: unknown task $1!$ANSI_NOCOLOR\n"
      exit 1
    ;;
  esac
}

#--

language_server() {
  DREPO="ext" DTAG="ls" DFILE=ls build_img --build-arg LLVM_VER='9'
}

#--

deploy () {
  case $1 in
    "")
      FILTER="/ghdl /pkg";;
    "base")
      FILTER="/build /run /debug";;
    "ext")
      FILTER="/ext";;
    "synth")
      FILTER="/synth";;
    "vunit")
      FILTER="/vunit";;
    "pkg")
      FILTER="/pkg:all";;
    *)
      FILTER="/";;
  esac

  echo "IMAGES: $FILTER"
  docker images

  for key in $FILTER; do
    for tag in `echo $(docker images "ghdl$key*" | awk -F ' ' '{print $1 ":" $2}') | cut -d ' ' -f2-`; do
      if [ "$tag" = "REPOSITORY:TAG" ]; then break; fi
      i="`echo $tag | grep -oP 'ghdl/\K.*' | sed 's#:#-#g'`"
      gstart "[DOCKER push] ${tag}" "$ANSI_YELLOW"
      if [ "x$SKIP_DEPLOY" = "xtrue" ]; then
        printf "${ANSI_YELLOW}SKIP_DEPLOY...$ANSI_NOCOLOR\n"
      else
        docker push $tag
      fi
      gend
    done
  done
}

#--

build () {
  CONFIG_OPTS="--default-pic " ./scripts/ci-run.sh -c --docker "$@"

  if [ "$GITHUB_OS" != "macOS" ] && [ -f testsuite/test_ok ]; then
    IMAGE_TAG="$(docker images "ghdl/ghdl:*" | head -n2 | tail -n1 | awk -F ' ' '{print $2}')"
    if echo $IMAGE_TAG | grep '\-synth'; then
      BASE_TAG="$IMAGE_TAG"
      IMAGE_TAG="$(echo $BASE_TAG | sed 's/-synth//g')"
      docker tag ghdl/ghdl:$BASE_TAG ghdl/ghdl:$IMAGE_TAG
      docker rmi ghdl/ghdl:$BASE_TAG
    fi
    gstart "[CI] Docker build ghdl/pkg:${IMAGE_TAG}"
    docker build -t "ghdl/pkg:$IMAGE_TAG" . -f-<<EOF
FROM scratch
ADD `ls | grep -v '\.src\.' | grep '^ghdl.*\.tgz'` ./
EOF
    gend
  fi
}

#--

case "$1" in
  -c)
    shift
    create "$@"
  ;;
  -e)
    shift
    extended "$@"
  ;;
  -b)
    shift
    cd ghdl
    build "$@"
  ;;
  -l)
    shift
    language_server "$@"
  ;;
  *)
    deploy $@
esac
