# syntax=docker/dockerfile:experimental

FROM ghdl/vunit:llvm-master AS gtkwave
COPY --from=hdlc/pkg:gtkwave /gtkwave /
RUN apt-get update -qq \
 && apt-get -y install graphviz libgtk-3-bin libtcl8.6 libtk8.6 xdot \
 && apt-get autoclean -y && apt-get clean -y && apt-get autoremove -y \
 && rm -rf /var/lib/apt/lists/*

#---

FROM gtkwave AS broadway
COPY broadway.sh /etc/broadway.sh
RUN printf "\nsource /etc/broadway.sh\n" >> /etc/bash.bashrc

#---

FROM alpine as get-master
RUN apk add --no-cache --update git && git clone --recurse-submodules https://github.com/VUnit/vunit /tmp/vunit

FROM ghdl/ext:ls AS ls-vunit
RUN --mount=type=cache,from=get-master,src=/tmp/vunit,target=/tmp/ \
 cd /tmp \
 && pip3 install . \
 && rm -rf .cache

#---

FROM ls-vunit AS latest
COPY --from=hdlc/pkg:gtkwave /gtkwave /
RUN apt-get update -qq \
 && apt-get -y install graphviz libgtk-3-bin libtcl8.6 libtk8.6 xdot \
 && apt-get autoclean -y && apt-get clean -y && apt-get autoremove -y \
 && rm -rf /var/lib/apt/lists/*
