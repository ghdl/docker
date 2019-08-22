ARG IMAGE="python:3-slim-buster"
ARG LLVM_VER="7"
ARG GNAT_VER="7"
ARG APT_PY=""

#---

FROM $IMAGE AS base

ARG APT_PY

RUN apt-get update -qq \
 && DEBIAN_FRONTEND=noninteractive apt-get -y install --no-install-recommends \
    ca-certificates \
    curl \
    gcc \
    make \
    zlib1g-dev $APT_PY \
 && apt-get autoclean && apt-get clean && apt-get -y autoremove \
 && update-ca-certificates \
 && rm -rf /var/lib/apt/lists/* \
 && pip3 install setuptools wheel

#---

FROM base AS build

ARG LLVM_VER
ARG GNAT_VER

RUN apt-get update -qq \
 && DEBIAN_FRONTEND=noninteractive apt-get -y install --no-install-recommends \
    clang-$LLVM_VER \
    gnat-$GNAT_VER \
    llvm-$LLVM_VER-dev \
    npm \
 && apt-get autoclean && apt-get clean && apt-get -y autoremove \
 && rm -rf /var/lib/apt/lists/* \
 && npm install -g vsce

#---

FROM base AS run

ARG LLVM_VER
ARG GNAT_VER

RUN apt-get update -qq \
 && DEBIAN_FRONTEND=noninteractive apt-get -y install --no-install-recommends \
    libgnat-$GNAT_VER \
    libllvm$LLVM_VER \
    unzip \
 && apt-get autoclean && apt-get clean && apt-get -y autoremove \
 && rm -rf /var/lib/apt/lists/*
