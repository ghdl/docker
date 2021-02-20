# [run] Centos

ARG IMAGE="centos:7"

#---

FROM $IMAGE AS common

RUN yum update -y \
 && yum install -y \
    bzip2 \
    flex \
    fontconfig \
    libX11 \
    zlib-devel

#---

FROM common AS gcc

RUN yum install -y centos-release-scl \
 && yum install -y \
    devtoolset-8

SHELL [ "/usr/bin/scl", "enable", "devtoolset-8" ]

# centos:8
#RUN yum install -y --enablerepo=powertools \
#    gcc \
#    make
