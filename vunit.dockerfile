# syntax=docker/dockerfile:experimental

ARG TAG="bookworm-mcode"

#---

FROM ghdl/ghdl:$TAG AS base

ARG PY_PACKAGES

RUN apt-get update -qq \
 && DEBIAN_FRONTEND=noninteractive apt-get -y install --no-install-recommends \
    curl \
    make \
    python3 \
    python3-pip \
    python3-venv \
 && apt-get autoclean && apt-get clean && apt-get -y autoremove \
 && rm -rf /var/lib/apt/lists/*

ENV VIRTUAL_ENV=/opt/venv
RUN python3 -m venv $VIRTUAL_ENV
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

RUN pip3 install -U setuptools wheel $PY_PACKAGES \
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
