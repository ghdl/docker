# [build] Fedora

ARG IMAGE="fedora:28"

#---

FROM $IMAGE AS mcode

RUN dnf --nodocs -y install \
    diffutils \
    gcc-gnat \
    make \
    zlib-devel \
 && dnf clean all --enablerepo=\*

#---

FROM mcode as common

RUN dnf --nodocs -y install \
    gcc-c++ \
 && dnf clean all --enablerepo=\*

#---

FROM common AS llvm

RUN dnf --nodocs -y install \
    clang \
    llvm-devel \
 && dnf clean all --enablerepo=\*

#---

FROM common AS gcc

RUN dnf --nodocs -y --allowerasing install \
    autogen \
    bzip2 \
    dejagnu \
    flex \
    gcc \
    lbzip2 \
    texinfo \
    wget \
 && dnf clean all
