

export OS="$(uname)"
if [[ "$OS" == 'Linux' ]]; then
    export DISTRO="$(grep -s '^ID=' /etc/os-release | cut -d= -f2)"
else
    export DISTRO=''
fi

HEADER () {
    echo
    echo "   [===]  $*  [===]"
    echo
}

WARN () {
    (
        exec 1>&2

        echo
        echo "!!!!  $*"
        echo
    )
}

FAIL () {
    local ERR_TYPE=$1
    local ERR=${2:-1}

    local IGNORE_VAR="IGNORE_${ERR_TYPE}_ERRS"
    ERRS=$(($ERRS + $ERR))

    if [[ "$ERRS" && ! "${!IGNORE_VAR}" ]]; then
        exec 1>&2

        echo
        echo '/---'
        echo "|  Fix & re-run, or ignore by running with: $IGNORE_VAR=1 $0"
        echo '\---------'
        echo

        exit $ERRS
    fi
}

SYMLINK() {
    local SRC="$1"
    local DST=${2:-$HOME/$(basename $SRC)}
    local DSTDIR=$(dirname $DST)
    local ERR_TYPE=${3:-SYMLINK}

    if [[ ! -d "$DSTDIR" ]]; then
        mkdir -p "$DSTDIR" || FAIL "$ERR_TYPE" 1
    fi

    if [[ ! -L "$DST" || "$(readlink $DST)" != "$SRC" ]]; then
        ln -svT "$SRC" "$DST" || FAIL "$ERR_TYPE" 1
    else
        echo "'$DST' -> '$SRC'"
    fi
}
