#! /bin/sh

set -e

scriptdir=$(dirname $0)

. "$scriptdir/travis/utils.sh"

currentdir="${scriptdir}/dockerfiles/ext"
for f in `ls $currentdir`; do
    for tag in `grep -oP "FROM.*AS do-\K.*" ${currentdir}/$f`; do
        travis_start "$tag" "$ANSI_BLUE[DOCKER build] ext : ${tag}$ANSI_NOCOLOR"
        docker build -t ghdl/ext:${tag} --target do-$tag . -f ${currentdir}/$f
        travis_finish "$tag"
    done
done

#docker build -t ghdl/ext:broadway --target do-broadway . -f ./dist/linux/docker/ext/vunit
