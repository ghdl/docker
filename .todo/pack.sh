#! /bin/sh

set -e

scriptdir=$(dirname $0)

. "$scriptdir/travis/utils.sh"

currentdir="${scriptdir}/dockerfiles/run"

for f in `ls $currentdir`; do
    for tag in `grep -oP "FROM.*AS \K.*" ${currentdir}/$f`; do
        ftag="${f}-${tag}"
        gstart "$ftag" "$ANSI_BLUE[DOCKER pull] pkg : ${f} - ${tag}$ANSI_NOCOLOR"
        img="ghdl/pkg:$ftag"
        docker pull $img
        cat >> Dockerfile-from <<-EOF
FROM $img AS $ftag
EOF
        cat >> Dockerfile-copy <<-EOF
COPY --from=$ftag ./* /$ftag/
EOF
        gend "$ftag"
    done
done

mkdir -pv tmp-pkg && cd tmp-pkg

gstart "pkg_tmp" "$ANSI_BLUE[DOCKER build] pkg:tmp $ANSI_NOCOLOR"
mv ../Dockerfile-from ./Dockerfile
echo "FROM busybox" >> Dockerfile
cat ../Dockerfile-copy >> Dockerfile
rm ../Dockerfile-copy
echo "Dockerfile:"
cat Dockerfile
echo ""
docker build -t ghdl/pkg:tmp .
gend "pkg_tmp"

gstart "pkg_all" "$ANSI_BLUE[DOCKER build] pkg:all $ANSI_NOCOLOR"
echo "FROM \"ghdl/pkg:tmp\" AS pkg-tmp" > Dockerfile
echo "FROM busybox" >> Dockerfile
echo "COPY --from=pkg-tmp ./* ./ghdl-pkgs/" >> Dockerfile
docker build -t save_pkg .
gend "pkg_all"

docker rmi -f `docker images -q ghdl/pkg:*`
docker tag save_pkg ghdl/pkg:all
docker rmi save_pkg

cd .. && rm -rf tmp-pkg

docker images
