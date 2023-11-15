#!/bin/bash

SCRIPT_DIR="$(realpath -s -- "$PWD/$(dirname -- "$0")")"
NIGHTLY_DIR="$SCRIPT_DIR/nightly"
mkdir -p "$NIGHTLY_DIR"

DOWNLOAD_INDEX='https://ziglang.org/download/index.json'
LATEST_URL="$(curl -Ls "$DOWNLOAD_INDEX" | jq --raw-output '.master["x86_64-linux"].tarball')"
LATEST_VER="$(basename -s .tar.xz "$LATEST_URL")"
LATEST_DIR="$NIGHTLY_DIR/$LATEST_VER"
if [[ ! -d "$LATEST_DIR" ]]; then
    cd "$NIGHTLY_DIR" && curl -LS "$LATEST_URL" | tar -Jxv || exit -1
else
    echo "Already have $LATEST_VER"
fi
ln -sf --no-target-directory "$LATEST_DIR" "$NIGHTLY_DIR/latest"
