#! /bin/sh
# This script is executed in the travis-ci environment.

set -e

scriptdir=$(dirname $0)

. "$scriptdir/travis/utils.sh"

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
