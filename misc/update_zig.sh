#!/bin/bash

LATEST_URL=$(curl -Ls 'https://ziglang.org/download/index.json' | jq --raw-output '.master["x86_64-linux"].tarball')
LATEST_DIR=$(basename -s .tar.xz "$LATEST_URL")
if [[ -z "$LATEST_URL" || -z "$LATEST_DIR" ]]; then exit -1; fi
if [[ ! -d "./$LATEST_DIR" ]]; then
    curl -LS "$LATEST_URL" | tar -Jxv || exit -1
fi
ln -sf "$LATEST_DIR" latest
