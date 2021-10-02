# [run] Centos

ARG IMAGE="centos:7"

#---

FROM $IMAGE AS common

RUN yum update -y \
 && yum install -y \
    make \
    zlib-devel

ENV CC=gcc

#---

FROM common AS centos7-gcc

RUN yum install -y centos-release-scl \
 && yum install -y devtoolset-8

SHELL [ "/usr/bin/scl", "enable", "devtoolset-8" ]

#---

FROM common AS centos8-gcc

RUN yum install -y --enablerepo=powertools gcc
