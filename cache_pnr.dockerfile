FROM debian:buster-slim AS base

RUN apt-get update -qq \
 && DEBIAN_FRONTEND=noninteractive apt-get -y install --no-install-recommends \
    ca-certificates \
    curl \
    python3 \
 && apt-get autoclean && apt-get clean && apt-get -y autoremove \
 && update-ca-certificates \
 && rm -rf /var/lib/apt/lists/*

#---

FROM base AS build

RUN apt-get update -qq \
 && DEBIAN_FRONTEND=noninteractive apt-get -y install --no-install-recommends \
    clang \
    make

ENV CXX clang

#---

FROM build AS build-dev

RUN apt-get update -qq \
 && DEBIAN_FRONTEND=noninteractive apt-get -y install --no-install-recommends \
    cmake \
    libboost-all-dev \
    python3-dev

#---

FROM build AS icestorm-build

RUN apt-get update -qq \
 && DEBIAN_FRONTEND=noninteractive apt-get -y install --no-install-recommends \
    pkg-config

RUN mkdir /tmp/icestorm \
 && cd /tmp/icestorm \
 && curl -fsSL https://codeload.github.com/cliffordwolf/icestorm/tar.gz/master | tar xzf - --strip-components=1 \
 && ICEPROG=0 make -j $(nproc) \
 && ICEPROG=0 make DESTDIR=/opt/icestorm install

RUN apt-get update -qq \
 && DEBIAN_FRONTEND=noninteractive apt-get -y install --no-install-recommends \
    libftdi1-dev

RUN cd /tmp/icestorm/iceprog \
 && make -j $(nproc) \
 && make DESTDIR=/opt/iceprog install

#---

FROM base AS icestorm
COPY --from=icestorm-build /opt/icestorm /

#---

FROM alpine as get-trellis
RUN apk add --no-cache --update git && git clone --recurse-submodules https://github.com/SymbiFlow/prjtrellis /tmp/trellis \
 && cd /tmp/trellis \
 && git describe --tags > libtrellis/git_version

#---

FROM build-dev AS trellis-build
COPY --from=get-trellis /tmp/trellis /tmp/trellis

ENV LDFLAGS "-Wl,--copy-dt-needed-entries"

RUN cd /tmp/trellis/libtrellis \
 && cmake -DCURRENT_GIT_VERSION="$(cat git_version)" . \
 && make -j $(nproc) \
 && make DESTDIR=/opt/trellis install

#---

FROM base AS trellis
COPY --from=trellis-build /opt/trellis /

RUN apt-get update -qq \
 && DEBIAN_FRONTEND=noninteractive apt-get -y install --no-install-recommends \
    libboost-all-dev \
 && apt-get autoclean && apt-get clean && apt-get -y autoremove \
 && rm -rf /var/lib/apt/lists/*

#---

FROM debian:buster-slim AS prog
COPY --from=icestorm-build /opt/iceprog /

RUN apt-get update -qq \
 && DEBIAN_FRONTEND=noninteractive apt-get -y install --no-install-recommends \
    libftdi1-2 \
    openocd \
    usbutils \
 && apt-get autoclean && apt-get clean && apt-get -y autoremove \
 && rm -rf /var/lib/apt/lists/*

#---

FROM build-dev AS nextpnr-build-base

ENV LDFLAGS "-Wl,--copy-dt-needed-entries"

RUN apt-get update -qq \
 && DEBIAN_FRONTEND=noninteractive apt-get -y install --no-install-recommends \
    libeigen3-dev \
    libomp-dev

#---

FROM nextpnr-build-base AS nextpnr-ice40-build
COPY --from=icestorm-build /opt/icestorm/usr/local/share/icebox /usr/local/share/icebox

RUN mkdir -p /tmp/nextpnr/build \
 && cd /tmp/nextpnr \
 && curl -fsSL https://codeload.github.com/YosysHQ/nextpnr/tar.gz/master | tar xzf - --strip-components=1 \
 && cd build \
 && cmake .. \
   -DARCH=ice40 \
   -DBUILD_GUI=OFF \
   -DBUILD_PYTHON=ON \
   -DUSE_OPENMP=ON \
 && make -j $(nproc) \
 && make DESTDIR=/opt/nextpnr install

#---

FROM nextpnr-build-base AS nextpnr-ecp5-build
COPY --from=trellis-build /opt/trellis /

RUN mkdir -p /tmp/nextpnr/build \
 && cd /tmp/nextpnr \
 && curl -fsSL https://codeload.github.com/YosysHQ/nextpnr/tar.gz/master | tar xzf - --strip-components=1 \
 && cd build \
 && cmake .. \
   -DARCH=ecp5 \
   -DBUILD_GUI=OFF \
   -DBUILD_PYTHON=ON \
   -DUSE_OPENMP=ON \
 && make -j $(nproc) \
 && make DESTDIR=/opt/nextpnr install

#---

FROM nextpnr-ice40-build AS nextpnr-build
COPY --from=trellis-build /opt/trellis /

RUN cd /tmp/nextpnr/build \
 && cmake .. \
   -DARCH=all \
   -DBUILD_GUI=OFF \
   -DBUILD_PYTHON=ON \
   -DUSE_OPENMP=ON \
 && make -j $(nproc) \
 && make DESTDIR=/opt/nextpnr install

#---

FROM base AS nextpnr-base

RUN apt-get update -qq \
 && DEBIAN_FRONTEND=noninteractive apt-get -y install --no-install-recommends \
    libboost-all-dev \
    libomp5-7 \
 && apt-get autoclean && apt-get clean && apt-get -y autoremove \
 && rm -rf /var/lib/apt/lists/*

#---

FROM nextpnr-base AS nextpnr-ice40
COPY --from=nextpnr-ice40-build /opt/nextpnr /

#---

FROM nextpnr-base AS nextpnr-ecp5
COPY --from=nextpnr-ecp5-build /opt/nextpnr /

#---

FROM nextpnr-base AS nextpnr
COPY --from=nextpnr-build /opt/nextpnr /
