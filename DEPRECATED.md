# Deprecated images

Some images related to synthesis and PnR were moved to [hdl/containers](https://github.com/hdl/containers) and [hub.docker.com/u/hdlc](https://hub.docker.com/u/hdlc). Some of those are now mirrored to `ghdl/synth:*` for backwards compatibility, but are no longer built in this repository. See workflow [mirror](.github/workflows/mirror.yml).

- `ghdl/synth:beta` includes GHDL along with ghdl-yosys-plugin built as a module for [YosysHQ/yosys](https://github.com/YosysHQ/yosys), and Yosys.
- `ghdl/synth:formal` includes GHDL, ghdl-yosys-plugin, Yosys and Symbiyosys.
- `ghdl/synth:icestorm`: includes [icestorm](https://github.com/cliffordwolf/icestorm) without `iceprog`.
- `ghdl/synth:nextpnr-ice40`: includes [nextpnr](https://github.com/YosysHQ/nextpnr) with support for ICE40 devices only.
- `ghdl/synth:nextpnr-ecp5`: includes [nextpnr](https://github.com/YosysHQ/nextpnr) with support for ECP5 devices only.
- `ghdl/synth:nextpnr`: includes [nextpnr](https://github.com/YosysHQ/nextpnr) with support for all architectures (see [nextpnr: Additional notes for building nextpnr](https://github.com/YosysHQ/nextpnr#additional-notes-for-building-nextpnr)).
- `ghdl/synth:prog`: includes `iceprog` from [icestorm](https://github.com/cliffordwolf/icestorm) and [openocd](http://openocd.org/).
- `ghdl/synth:trellis`: includes [prjtrellis](https://github.com/SymbiFlow/prjtrellis).
- `ghdl/synth:yosys`: includes [yosys](https://github.com/YosysHQ/yosys).
