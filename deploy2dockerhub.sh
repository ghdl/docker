#! /bin/sh

set -e

scriptdir=$(dirname $0)

. "$scriptdir/travis/utils.sh"

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
