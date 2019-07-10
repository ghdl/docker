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
          for f in trusty xenial bionic; do
            case $f in
              *trusty*) #14
                LLVM_VER="3.8"
                GNAT_VER="4.6"
              ;;
              *xenial*) #16
                LLVM_VER="3.9"
                GNAT_VER="4.9"
              ;;
              *bionic*) #18
                LLVM_VER="5.0"
                GNAT_VER="7"
              ;;
            esac
            BASE_IMAGE="$DISTRO:$f"
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
          BASE_IMAGE="python:rc-slim-buster"
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
  for f in vunit; do
    for tag in `grep -oP "FROM.*AS do-\K.*" ./dockerfiles/$f`; do
      travis_start "$tag" "$ANSI_BLUE[DOCKER build] ext : ${tag}$ANSI_NOCOLOR"
      docker build -t ghdl/ext:${tag} --target do-$tag . -f ./dockerfiles/$f
      travis_finish "$tag"
    done
  done
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
  -e) extended ;;
  -l) language_server "$2";;
  *)
    deploy $@
esac
