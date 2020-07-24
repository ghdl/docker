FROM ghdl/vunit:llvm-master AS gtkwave
COPY --from=ghdl/cache:gtkwave ./*.tgz /tmp/
RUN apt-get update -qq \
 && apt-get -y install graphviz libgtk-3-bin libtcl8.6 libtk8.6 xdot \
 && apt-get autoclean -y && apt-get clean -y && apt-get autoremove -y \
 && rm -rf /var/lib/apt/lists/* \
 && GTKWAVE_TGZ=`ls /tmp/gtkwave*` \
 && tar -xzf "$GTKWAVE_TGZ" -C /usr/local \
 && rm -f "$GTKWAVE_TGZ"

#---

FROM gtkwave AS broadway
COPY broadway.sh /etc/broadway.sh
RUN printf "\nsource /etc/broadway.sh\n" >> /etc/bash.bashrc

#---

FROM alpine as get-master
RUN apk add --no-cache --update git && git clone --recurse-submodules https://github.com/VUnit/vunit /tmp/vunit

FROM ghdl/ext:ls-debian AS ls-vunit
COPY --from=get-master /tmp/vunit /tmp/vunit
RUN cd /tmp/vunit \
 && python3 setup.py install \
 && cd .. && rm -rf /tmp/vunit

#---

FROM ls-vunit AS latest
COPY --from=ghdl/cache:gtkwave ./*.tgz /tmp/
RUN apt-get update -qq \
 && apt-get -y install graphviz libgtk-3-bin libtcl8.6 libtk8.6 xdot \
 && apt-get autoclean -y && apt-get clean -y && apt-get autoremove -y \
 && rm -rf /var/lib/apt/lists/* \
 && GTKWAVE_TGZ=`ls /tmp/gtkwave*` \
 && tar -xzf "$GTKWAVE_TGZ" -C /usr/local \
 && rm -f "$GTKWAVE_TGZ"
