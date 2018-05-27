#! /bin/sh

set -e

scriptdir=$(dirname $0)

. "$scriptdir/travis/utils.sh"
. "$scriptdir/travis/ansi_color.sh"
#disable_color

currentdir="${scriptdir}/dockerfiles/run"

for f in `ls $currentdir`; do
    for tag in `grep -oP "FROM.*AS \K.*" ${currentdir}/$f`; do
        fulltag="${f}-${tag}"
        echo "travis_fold:start:$fulltag"
        travis_time_start
        printf "$ANSI_BLUE[DOCKER pull] pkg : ${f} - ${tag}$ANSI_NOCOLOR\n"
        thisimg="ghdl/pkg:$fulltag"
        docker pull $thisimg
        echo "FROM \"$thisimg\" AS $fulltag" >> Dockerfile-from
        echo "COPY --from=$fulltag ./* /$fulltag/" >> Dockerfile-copy
        travis_time_finish
        echo "travis_fold:end:$fulltag"
    done
done

mkdir -pv tmp-pkg && cd tmp-pkg

echo "travis_fold:start:pkg_tmp"
printf "$ANSI_BLUE[DOCKER build] pkg:tmp $ANSI_NOCOLOR\n"
mv ../Dockerfile-from ./Dockerfile
echo "FROM busybox" >> Dockerfile
cat ../Dockerfile-copy >> Dockerfile
rm ../Dockerfile-copy
echo "Dockerfile:"
cat Dockerfile
echo ""
docker build -t ghdl/pkg:tmp .
echo "travis_fold:end:pkg_tmp"

echo "travis_fold:start:pkg_all"
printf "$ANSI_BLUE[DOCKER build] pkg:all $ANSI_NOCOLOR\n"
echo "FROM \"ghdl/pkg:tmp\" AS pkg-tmp" > Dockerfile
echo "FROM busybox" >> Dockerfile
echo "COPY --from=pkg-tmp ./* ./ghdl-pkgs/" >> Dockerfile
docker build -t save_pkg .
echo "travis_fold:end:pkg_all"

docker rmi -f `docker images -q ghdl/pkg:*`
docker tag save_pkg ghdl/pkg:all
docker rmi save_pkg

cd .. && rm -rf tmp-pkg

docker images
