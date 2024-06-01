# [build] Debian or Ubuntu

ARG IMAGE="debian:bookworm-slim"
ARG LLVM_VER="14"
ARG GNAT_VER="12"

#---

FROM $IMAGE AS mcode

ARG GNAT_VER

RUN apt-get update -qq \
 && DEBIAN_FRONTEND=noninteractive apt-get -y install --no-install-recommends \
    ca-certificates \
    gcc \
    gnat-$GNAT_VER \
    cargo \
    make \
    zlib1g-dev \
 && apt-get autoclean && apt-get clean && apt-get -y autoremove \
 && update-ca-certificates \
 && rm -rf /var/lib/apt/lists/*

#---

FROM mcode AS llvm

ARG LLVM_VER

RUN apt-get update -qq \
 && DEBIAN_FRONTEND=noninteractive apt-get -y install --no-install-recommends \
    clang-$LLVM_VER \
    llvm-$LLVM_VER-dev \
 && apt-get autoclean && apt-get clean && apt-get -y autoremove \
 && rm -rf /var/lib/apt/lists/*

#---

FROM mcode AS gcc

RUN apt-get update -qq \
 && DEBIAN_FRONTEND=noninteractive apt-get -y install curl \
 && DEBIAN_FRONTEND=noninteractive apt-get -y install --no-install-recommends \
    autogen \
    bzip2 \
    dejagnu \
    flex \
    g++ \
    lbzip2 \
    texinfo \
    wget \
    libgmp-dev \
    libmpfr-dev \
    libmpc-dev \
 && apt-get autoclean && apt-get clean && apt-get -y autoremove \
 && rm -rf /var/lib/apt/lists/*
