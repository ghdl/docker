# [build] Centos

ARG IMAGE="centos:7"

#---

FROM $IMAGE AS common

RUN yum update -y \
 && yum install -y \
    bzip2 \
    curl \
    flex \
    fontconfig \
    git \
    libX11 \
    make \
    wget \
    zlib-devel

RUN mkdir -p /tmp/gnat \
 && curl -L https://community.download.adacore.com/v1/9682e2e1f2f232ce03fe21d77b14c37a0de5649b?filename=gnat-gpl-2017-x86_64-linux-bin.tar.gz | tar -xz -C /tmp/gnat --strip-components=1 \
 && cd /tmp/gnat \
 && make ins-all prefix="/opt/gnat"

ENV PATH=/opt/gnat/bin:$PATH

#---

FROM common AS gcc-7

RUN yum install -y centos-release-scl \
 && yum install -y \
    devtoolset-8 \
    texinfo

SHELL [ "/usr/bin/scl", "enable", "devtoolset-8" ]

#---

FROM common AS gcc-8

RUN yum install -y --enablerepo=powertools \
    gcc \
    texinfo
