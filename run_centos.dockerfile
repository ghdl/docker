# [run] Centos

ARG IMAGE="centos:7"

#---

FROM $IMAGE AS common

RUN yum update -y \
 && yum install -y \
    make \
    zlib-devel

#---

FROM common AS gcc-7

RUN yum install -y centos-release-scl \
 && yum install -y devtoolset-8

SHELL [ "/usr/bin/scl", "enable", "devtoolset-8" ]

#---

FROM common AS gcc-8

RUN yum install -y --enablerepo=powertools gcc
