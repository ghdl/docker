# syntax=docker/dockerfile:experimental

ARG TAG="buster-mcode"

#---

FROM ghdl/ghdl:$TAG AS base

ARG PY_PACKAGES

RUN apt-get update -qq \
 && DEBIAN_FRONTEND=noninteractive apt-get -y install --no-install-recommends \
    curl \
    make \
    python3 \
    python3-pip \
 && apt-get autoclean && apt-get clean && apt-get -y autoremove \
 && rm -rf /var/lib/apt/lists/* \
 && pip3 install --upgrade setuptools wheel $PY_PACKAGES \
 && rm -rf ~/.cache

#---

FROM base as stable

RUN pip3 install vunit_hdl \
 && rm -rf ~/.cache

#---

FROM alpine as get-master
RUN apk add --no-cache --update git && git clone --recurse-submodules https://github.com/VUnit/vunit /tmp/vunit

FROM base AS master
RUN --mount=type=cache,from=get-master,src=/tmp/vunit,target=/tmp/vunit \
 cd /tmp/vunit \
 && pip3 install . \
 && rm -rf ~/.cache
