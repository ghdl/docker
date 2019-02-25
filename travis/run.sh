#! /bin/sh

set -e

cd $(dirname $0)/..

. ./travis/utils.sh

#--

create () {
  for d in build run; do
      currentdir="${scriptdir}/dockerfiles/$d"
      for f in `ls $currentdir`; do
          for tag in `grep -oP "FROM.*AS \K.*" ${currentdir}/$f`; do
              i="${f}-$tag"
              travis_start "$i" "${ANSI_BLUE}[DOCKER build] ${d} : ${f} - ${tag}$ANSI_NOCOLOR"
              docker build -t "ghdl/${d}:$i" --target "$tag" - < "${currentdir}/$f"
              travis_finish "$i"
          done
      done
  done
}

#--

extended() {
  currentdir="${scriptdir}/dockerfiles/ext"
  for f in `ls $currentdir`; do
      for tag in `grep -oP "FROM.*AS do-\K.*" ${currentdir}/$f`; do
          travis_start "$tag" "$ANSI_BLUE[DOCKER build] ext : ${tag}$ANSI_NOCOLOR"
          docker build -t ghdl/ext:${tag} --target do-$tag . -f ${currentdir}/$f
          travis_finish "$tag"
      done
  done
  #docker build -t ghdl/ext:broadway --target do-broadway . -f ./dist/linux/docker/ext/vunit
}

#--

deploy () {
  case $1 in
    "")    FILTER="/";;
    "ext") FILTER="/ext";;
    "pkg") FILTER="/pkg:all";;
    *)     FILTER="/ghdl /pkg";;
  esac

  . "$scriptdir/travis/docker_login.sh"

  for key in $FILTER; do
    for tag in `echo $(docker images ghdl$key* | awk -F ' ' '{print $1 ":" $2}') | cut -d ' ' -f2-`; do
        if [ "$tag" = "REPOSITORY:TAG" ]; then break; fi
        i="`echo $tag | grep -oP 'ghdl/\K.*'`"
        travis_start "$i" "$ANSI_YELLOW[DOCKER push] ${tag}$ANSI_NOCOLOR"
        docker push $tag
        travis_finish "$i"
    done
  done

  docker logout
}

#--

case "$1" in
  -c) create
  ;;
  -e) extended
  ;;
  *)
    deploy $@
esac
