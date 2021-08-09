#!/bin/bash
#
# Set up environment.

set -e

ENVDIR=$(dirname $(realpath "$0"))

HEADER () {
    echo
    echo "   [===]  $*  [===]"
    echo
}

SYMLINK() {
    local SRC="$1"
    local DST=${2:-$HOME/$(basename $SRC)}
    local DSTDIR=$(dirname $DST)

    if [[ ! -d "$DSTDIR" ]]; then
        mkdir -p "$DSTDIR"
    fi

    if [[ ! -L "$DST" || "$(readlink $DST)" != "$SRC" ]]; then
        ln -svT "$SRC" "$DST"
    else
        echo "$SRC -> $DST"
    fi
}

HEADER 'Basic Dirs'
mkdir -pv $HOME/{src,build,bak,.mem/tmp,.mem/cache,.config,.local/bin}
SYMLINK $HOME/.mem/tmp
SYMLINK $HOME/.mem/cache $HOME/.cache

HEADER 'Configs & Scripts'
SYMLINK $ENVDIR/scripts
SYMLINK $HOME/.config/FreeCAD $HOME/.FreeCAD
LINKED_DIRS="$(find $ENVDIR/full_config  -maxdepth 1 -mindepth 1 -type d)"
for D in $LINKED_DIRS; do
    SYMLINK $D $HOME/.config/$(basename $D)
done

# Only symlink the files in each app dir, so any additional ones the
# app might create won't end up in this repo
for APP in $(find $ENVDIR/config -maxdepth 1 -mindepth 1 -type d | xargs basename -a | tr '\n' ' '); do
    for FILE in $(find $ENVDIR/config/$APP -type f | xargs basename -a | tr '\n' ' '); do
        SYMLINK $ENVDIR/config/$APP/$FILE $HOME/.config/$APP/$FILE
    done
done

HEADER 'Neovim & Vim'
if [[ -f /usr/local/bin/nvim ]]; then
    SYMLINK /usr/local/bin/nvim $HOME/.local/bin/vim
    SYMLINK /usr/local/bin/vim $HOME/.local/bin/oldvim
fi
SYMLINK $HOME/.config/nvim $HOME/.vim
SYMLINK $HOME/.config/nvim/init.vim $HOME/.vimrc

HEADER '~/.rc Files'
for F in $(ls $ENVDIR/dotfiles); do
    SYMLINK $ENVDIR/dotfiles/$F $HOME/.$F
done

HEADER 'Dropbox Dirs'
if [[ ! -d "$HOME/Dropbox" ]]; then
    echo '!!!! Dropbox dir does not exist - skipping related symlinks'
else
    SYMLINK $HOME/Dropbox/Documents $HOME/Documents
    SYMLINK $HOME/Dropbox/Photos $HOME/Pictures
fi

HEADER 'Emoji Prompt'
if [ -f "$HOME/src/Heewa/emoji-prompt/emoji-prompt.sh" ]; then
    SYMLINK $HOME/src/Heewa/emoji-prompt/emoji-prompt.sh $HOME/.emoji-prompt.sh
else
    curl -# 'https://raw.githubusercontent.com/heewa/emoji-prompt/master/emoji-prompt.sh' > $HOME/.emoji-prompt.sh
fi

HEADER 'Emoji Env Vars'
if [ -f "$HOME/src/Heewa/bae/emoji_vars.sh" ]; then
    SYMLINK $HOME/src/Heewa/bae/emoji_vars.sh $HOME/.emoji_vars.sh
else
    curl -# 'https://raw.githubusercontent.com/heewa/bae/master/emoji_vars.sh' > $HOME/.emoji_vars.sh
fi

HEADER 'Tmux'
if [[ ! -e $HOME/.tmux.gpakosz ]]; then
    git clone --depth 1 https://github.com/gpakosz/.tmux $HOME/.tmux.gpakosz
fi
SYMLINK $HOME/.tmux.gpakosz/.tmux.conf $HOME/.tmux.conf

if [[ ! -e $HOME/.tmux/plugins/tpm ]]; then
    git clone --depth 1 https://github.com/tmux-plugins/tpm $HOME/.tmux/plugins/tpm
fi

HEADER 'VimPlug & Plugins'
VIM_PLUG_URL='https://github.com/junegunn/vim-plug/raw/master/plug.vim'
PLUG_FILE="$HOME/.config/nvim/autoload/plug.vim"
if [[ -f $PLUG_FILE ]]; then
    vim -c 'PlugUpgrade | PlugUpdate | qa'
else
    curl --create-dirs -fL -o "$PLUG_FILE" "$VIM_PLUG_URL"
    vim -c 'PlugInstall | qa'
fi

HEADER 'Nerd Fonts'
FONTS=( \
    'Noto/Mono/complete/Noto%20Mono%20Nerd%20Font%20Complete.ttf' \
    'UbuntuMono/Regular/complete/Ubuntu%20Mono%20Nerd%20Font%20Complete.ttf' \
    'SourceCodePro/Regular/complete/Sauce%20Code%20Pro%20Nerd%20Font%20Complete.ttf' \
)
URL="https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/"
if [[ "$(uname)" = "Darwin" ]]; then
    DIR="$HOME/Library/Fonts"
else
    DIR="$HOME/.local/share/fonts"
fi
mkdir -p "$DIR"

GOT_NEW_FONTS=0
for FONT in ${FONTS[@]}; do
    if [[ -f "$DIR/$(basename $FONT)" ]]; then
        echo "  already have $FONT"
    else
        echo "       getting $FONT"
        curl --output-dir "$DIR" -fOLs "$URL$FONT"
        GOT_NEW_FONTS=1
    fi
done

if [[ $(uname) == "Linux" ]]; then

    HEADER 'Rebuilding Fonts'
    if [[ $GOT_NEW_FONTS == 0 ]]; then
        echo 'no new fonts, skipping rebuild'
    else
        sudo --non-interactive fc-cache -f ~/.local/share/fonts || echo '!!!!'
    fi
fi

HEADER 'Pyenv'
if [[ -e "$HOME/.pyenv" ]]; then
    echo 'already have, skipping'
else
    git clone --depth 1 https://github.com/pyenv/pyenv $HOME/.pyenv
fi

HEADER 'Bash Git Prompt'
BGP_DIR="$HOME/.bash-git-prompt"
if [[ -e $BGP_DIR ]]; then
    echo 'already have, skipping'
else
    git clone --depth 1 https://github.com/magicmonty/bash-git-prompt $BGP_DIR
fi

HEADER 'NPM'
which npm && npm config set prefix "$HOME/.npm-global" || echo 'not installed, skipping conf'

if [[ "$(uname)" = "Darwin" ]]; then

    HEADER 'Golang Makefile'
    if [[ -f $HOME/.golang.Makefile ]]; then
        echo 'already have, skipping'
    else
        curl -#sL 'https://gist.githubusercontent.com/heewa/0562f16846aefda88225/raw/Makefile' > $HOME/.golang.Makefile
    fi

fi

HEADER 'Done!'
