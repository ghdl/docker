# USB/IP protocol support for Docker Desktop

USB/IP protocol allows to pass USB device(s) from server(s) to client(s) over the network. As explained at [kernel.org/doc/readme/tools-usb-usbip-README](https://www.kernel.org/doc/readme/tools-usb-usbip-README), on GNU/Linux, USB/IP is implemented as a few modules kernel with companion userspace tools. However, the default underlying Hyper-V VM machine (based on [Alpine Linux](https://alpinelinux.org/)) shipped with *Docker Desktop* (aka *docker-for-win*/*docker-for-mac*) does not include the required kernel modules. Fortunately, privileged docker containers allow to install missing kernel modules. The script in this subdir supports customizing the native VM in *Docker Desktop* to add USB over IP support.

# Usage

``` bash
# Build kernel modules: in an unprivileged `alpine` container, retrieve the corresponding
# kernel sources, copy runtime config and enable USB/IP features, build `drivers/usb/usbip`
# and save `*.ko` artifacts to relative subdir `dist` on the host.
./run.sh -m

# Load/insert kernel modules: use a privileged `busybox` container to load kernel modules
# `usbip-core.ko` and `vhci-hcd.ko` from relative subdir `dist` on the host to the
# underlying Hyper-V VM.
./run.sh -l

# Build image `vhcli`, using `busybox` as a base, and including the
# [VirtualHere](https://www.virtualhere.com) GNU/Linux client for x86_64 along with the
# `*.ko` files built previously through `./run.sh -m`.
./run.sh -v
```

> NOTE: for manually selecting configuration options, building and inserting modules, see detailed procedure in [gw0/docker-alpine-kernel-modules#usage](https://github.com/gw0/docker-alpine-kernel-modules#usage).

> NOTE: modules will be removed when the Hyper-V VM is restarted (i.e. when the host or *Docker Desktop* are restarted). For a *permanent* install, modules need to be copied to `/lib/modules` in the underlying VM, and `/stc/modules` needs to be configured accordingly. Use `$(command -v winpty) docker run --rm -it --privileged --pid=host alpine nsenter -t 1 -m -u -n -i sh` to access a shell with full permissions on the VM.

## Example session

How to connect a *Docker Desktop* container to *VirtualHere USB Server for Windows*.

- Start [`vhusbdwin64.exe`](https://www.virtualhere.com/sites/default/files/usbserver/vhusbdwin64.exe). on the host
- Ensure that the firewall is not blocking it.

``` bash
# Start container named 'vhclient'
./run.sh -s
# List usb devices available in the container
./run.sh -e lsusb
# LIST hubs/devices found by vhclient
./run.sh -c "LIST"
# Manually add to the client the hub/server running on the host
./run.sh -c "MANUAL HUB ADD,host.docker.internal:7575"

sleep 10

./run.sh -c "LIST"
# Use a remote device in the container
./run.sh -c "USE,<SERVER HOSTNAME>.1"

sleep 4

# Check that the device is now available in the container
./run.sh -e lsusb
```

> IMPORTANT: there is an issue/bug in *Docker Desktop* ([docker/for-win#4548](https://github.com/docker/for-win/issues/4548)) that prevents the container where the USB device is added from seeing it. The workaround is to execute `iceprog` in a sibling container. For example: `docker run --rm --privileged ghdl/synth:icestorm iceprog -t`.

# References

- [gw0/docker-alpine-kernel-modules](https://github.com/gw0/docker-alpine-kernel-modules)
- [virtualhere/docker](https://github.com/virtualhere/docker)
  - [Windows USB Server](https://www.virtualhere.com/windows_server_software)
  - [USB Client](https://www.virtualhere.com/usb_client_software)
  - [Linux Console Client](https://www.virtualhere.com/linux_console)
  - [Client API](https://www.virtualhere.com/client_api)
  - [hub.docker.com/r/virtualhere/virtualhere-client](https://hub.docker.com/r/virtualhere/virtualhere-client)

# Alternatives

Using [VirtualHere](https://www.virtualhere.com) is the only solution we could successfully use in order to share FTDI devices ([icestick](https://www.latticesemi.com/icestick) boards) between a Windows 10 host and a Docker Desktop container running on the same host. However, since the USB/IP protocol is open source, we'd like to try any other (preferredly open and free source) server for Windows along with the default GNU/Linux usbip-tools. Should you know about any, please [let us know](https://github.com/ghdl/docker/issues/new)!

We are aware of [cezuni/usbip-win](https://github.com/cezuni/usbip-win). However, it seems to be in very early development state and the install procedure is quite complex yet.

## Serial devices

Serial (COM) devices can be shared with open source tools. On the one hand, [hub4com](https://sourceforge.net/projects/com0com/files/hub4com/) from project [com0com](http://com0com.sourceforge.net/) allows to publish a port through a RFC2217 server. On the other hand, `socat` can be used to link the network connection to a virtual `tty` device.

```
                   HOST                                           CONTAINER
        ---------------------------                 -------------------------------------
USB <-> | COMX <-> RFC2217 server | <-> network <-> | socat <-> /dev/ttySY <-> app/tool |
        ---------------------------                 -------------------------------------
```

```cmd
REM On the Windows host
com2tcp-rfc2217.bat COM<X> <PORT>
```

```bash
# In the container
socat pty,link=/dev/ttyS<Y> tcp:host.docker.internal:<PORT>
```

It might be possible to replace `hub4com` with [pyserial/pyserial](https://github.com/pyserial/pyserial). However, we have not tested it.

- https://pyserial.readthedocs.io/en/latest/examples.html#single-port-tcp-ip-serial-bridge-rfc-2217
- https://github.com/espressif/esp-idf/issues/204
