# https://github.com/ghdl/ghdl/issues/1484
# https://github.com/ghdl/ghdl/issues/1118

#
# Centos 7
#

FROM centos:centos7

RUN yum update -y && yum install -y git curl bzip2 wget flex fontconfig libX11 zlib-devel
RUN yum install -y centos-release-scl && yum install -y devtoolset-8 texinfo
SHELL [ "/usr/bin/scl", "enable", "devtoolset-8" ]

#
# Centos 8
#

#FROM centos:centos8

#RUN yum update -y && yum install -y  git curl bzip2 wget flex fontconfig libX11 zlib-devel
#RUN yum install -y --enablerepo=powertools gcc texinfo make

#
# Common
#

WORKDIR /root

RUN mkdir gnat && \
    curl -L https://community.download.adacore.com/v1/9682e2e1f2f232ce03fe21d77b14c37a0de5649b?filename=gnat-gpl-2017-x86_64-linux-bin.tar.gz | tar -xz -C gnat --strip-components=1
RUN cd gnat && make ins-all prefix="build"

ENV PATH=/root/gnat/build/bin:$PATH

RUN mkdir gcc && curl -L https://codeload.github.com/gcc-mirror/gcc/tar.gz/releases/gcc-8.3.0 | tar -xz -C gcc --strip-components=1
RUN cd gcc && sed -i.bak s/ftp:/http:/g contrib/download_prerequisites && ./contrib/download_prerequisites && cd ..

RUN git clone https://github.com/ghdl/ghdl.git
RUN mkdir -p build/gcc-objs && cd build && ../ghdl/configure --with-gcc=../gcc --prefix=/usr/local && make copy-sources
RUN cd build/gcc-objs && ../../gcc/configure --prefix=/usr/local --enable-languages=c,vhdl --disable-bootstrap --disable-lto --disable-multilib --disable-libssp --disable-libgomp --disable-libquadmath
RUN cd build/gcc-objs && make -j2 && make install && cd .. && make ghdllib && make install

RUN ghdl --version

# docker build -t ghdl-centos7 -f build_centos.dockerfile .
# docker build -t ghdl-centos8 -f build_centos.dockerfile .
