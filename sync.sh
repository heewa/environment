#!/bin/bash
#
# Sync confs that change too frequently to be symlinked

set -e

ENVDIR=$(dirname $(realpath "$0"))
ERRS=0

. $ENVDIR/shared.sh

DIFFSYNC() {
    local FN="$1"
    local CONTENT="$2"
    local SRC="$HOME/.config/$FN"
    local DST="$ENVDIR/slow_config/$FN"

    if [[ "$CONTENT" == "" ]]; then
        CONTENT="$(cat $FN)"
    fi

    echo "$CONTENT" | diff -q - "$DST" > /dev/null || ( echo $F; echo "$CONTENT" > "$DST" )
}

cd $HOME/.config

HEADER 'Kicad'
for F in $(find kicad -type f); do
    SRC="$HOME/.config/$F"
    if [[ "${F##*.}" == 'json' ]]; then
        CONTENT="$(cat "$SRC" | jq 'delpaths([["window"], ["system"], ["find_replace"], ["lib_tree", "column_width"]])')"
    else
        CONTENT="$(cat "$SRC" | grep -v '^file[0-9]\|MostRecentlyUsedPath\|^WorkingDir=\|^LibeditFrame\(Pos\|Size\)')"
    fi
    DIFFSYNC "$F" "$CONTENT"
done

HEADER 'Hexchat'
F=hexchat/servlist.conf
DIFFSYNC "$F" "$(grep -v '^P=.' $HOME/.config/$F)"

echo
