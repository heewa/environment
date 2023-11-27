#!/bin/bash

SCRIPT_DIR="$(realpath -s -- "$PWD/$(dirname -- "$0")")"
NIGHTLY_DIR="$SCRIPT_DIR/nightly"
mkdir -p "$NIGHTLY_DIR"

# Get latest
DOWNLOAD_INDEX='https://ziglang.org/download/index.json'
LATEST_URL="$(curl -Ls "$DOWNLOAD_INDEX" | jq --raw-output '.master["x86_64-linux"].tarball')"
LATEST_VER="$(basename -s .tar.xz "$LATEST_URL")"
LATEST_DIR="$NIGHTLY_DIR/$LATEST_VER"
if [[ ! -d "$LATEST_DIR" ]]; then
    cd "$NIGHTLY_DIR" && curl -LS "$LATEST_URL" | tar -Jxv || exit -1
else
    echo "Already have $LATEST_VER"
fi

# Link zig to latest
ln -sf --no-target-directory "$LATEST_DIR" "$NIGHTLY_DIR/latest"

# Clean up every version except latest 2
VERSIONS="$(ls -t -I latest "$NIGHTLY_DIR" | tail -n +3)"
if [[ "$VERSIONS" != "" ]]; then
    echo "Cleaning up $(echo "$VERSIONS" | wc -l) older versions, taking up $(cd $NIGHTLY_DIR && du -shc $VERSIONS | tail -n1 | cut -f1)"

    for VER in $VERSIONS; do
        D="$NIGHTLY_DIR"/"$VER"
        SIZE="$(du -sh "$D" | cut -f1)"
        MTIME="$(stat -c %y "$D")"
        echo "$SIZE $MTIME $VER"
        rm -rf "$D"
    done
fi
