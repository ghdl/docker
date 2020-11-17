# syntax=docker/dockerfile:experimental

ARG LLVM_VER="7"

#---

FROM ghdl/build:ls AS build

ARG LLVM_VER

RUN mkdir /tmp/ghdl-dist \
 && mkdir -p /tmp/ghdl && cd /tmp/ghdl \
 && curl -fsSL https://codeload.github.com/ghdl/ghdl/tar.gz/master | tar xzf - --strip-components=1 \
 && CONFIG_OPTS="--default-pic" ./dist/ci-run.sh -b llvm-$LLVM_VER -p ghdl-llvm-fPIC build \
 && mv ghdl-llvm-fPIC.tgz /tmp/ghdl-dist/ \
 && rm -rf python/xtools \
 && tar -zcvf /tmp/ghdl-dist/ghdl-py.tgz -C python .

RUN mkdir -p /tmp/vscode-repo && cd /tmp/vscode-repo \
 && curl -fsSL https://codeload.github.com/ghdl/ghdl-language-server/tar.gz/master | tar xzf - --strip-components=2 ghdl-language-server-master/vscode-client \
 && npm install \
 && vsce package \
 && mv $(ls vhdl-lsp-*.vsix) /tmp/ghdl-dist/

#---

FROM ghdl/run:ls AS run

RUN --mount=type=cache,from=build,src=/tmp/ghdl-dist,target=/tmp/ \
 tar -xzf /tmp/ghdl-llvm-fPIC.tgz -C /usr/local \
 && pip3 install /tmp/ghdl-py.tgz \
 && mkdir -p /opt/ghdl \
 && cd /opt/ghdl \
 && cp $(ls /tmp/vhdl-lsp-*.vsix) ./ \
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
