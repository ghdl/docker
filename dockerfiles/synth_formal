ARG IMAGE="ghdl/synth:beta"

FROM $IMAGE

COPY --from=ghdl/cache:formal /z3 /
COPY --from=ghdl/cache:formal /symbiyosys /

RUN apt-get update -qq \
 && DEBIAN_FRONTEND=noninteractive apt-get -y install --no-install-recommends \
    python3 \
 && apt-get autoclean && apt-get clean && apt-get -y autoremove \
 && rm -rf /var/lib/apt/lists/*
