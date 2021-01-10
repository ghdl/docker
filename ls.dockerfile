# syntax=docker/dockerfile:experimental

ARG LLVM_VER="7"

#---

FROM ghdl/build:ls AS build

ARG LLVM_VER

RUN mkdir /tmp/ghdl-dist \
 && mkdir -p /tmp/ghdl && cd /tmp/ghdl \
 && curl -fsSL https://codeload.github.com/ghdl/ghdl/tar.gz/master | tar xzf - --strip-components=1 \
 && CONFIG_OPTS="--default-pic" ./scripts/ci-run.sh -b llvm-$LLVM_VER -p ghdl-llvm-fPIC build

RUN mkdir -p /tmp/vscode-repo && cd /tmp/vscode-repo \
 && curl -fsSL https://codeload.github.com/ghdl/ghdl-language-server/tar.gz/master | tar xzf - --strip-components=2 ghdl-language-server-master/vscode-client \
 && npm install \
 && vsce package \
 && mv $(ls vhdl-lsp-*.vsix) /tmp/ghdl/

#---

FROM ghdl/run:ls AS run

RUN --mount=type=cache,from=build,src=/tmp/ghdl,target=/tmp/ghdl \
 tar -xzf /tmp/ghdl/ghdl-llvm-fPIC.tgz -C /usr/local \
 && cd /tmp/ghdl/ \
 && python3 setup.py install \
 && mkdir -p /opt/ghdl \
 && cd /opt/ghdl \
 && cp $(ls /tmp/ghdl/vhdl-lsp-*.vsix) ./ \
 && printf "%s\n" \
'cd $(dirname $0)' \
'vsix_file="$(ls vhdl-lsp-*.vsix)"' \
'vsc_exts="$HOME/.vscode-server/extensions"' \
'mkdir -p $vsc_exts' \
'unzip "$vsix_file"' \
'rm [Content_Types].xml' \
'mv extension.vsixmanifest extension/.vsixmanifest' \
'mv extension "$vsc_exts/tgingold.${vsix_file%.*}"' \
> install_vsix.sh \
 && chmod +x install_vsix.sh \
 && mkdir -p /tmp/files \
 && curl -fsSL https://codeload.github.com/ghdl/ghdl-language-server/tar.gz/master | tar xzf - -C /tmp/files --strip-components=4 ghdl-language-server-master/ghdl-ls/tests/files
