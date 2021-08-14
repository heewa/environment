#!/bin/bash
#
# Set up environment.

set -e

ENVDIR=$(dirname $(realpath "$0"))
ERRS=0

. $ENVDIR/shared.sh

HEADER 'Basic Dirs'
mkdir -pv $HOME/{src,build,bak,tmp,.cache,.config,.local/bin} || FAIL DIR

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

HEADER 'Ram Disks'
CHECK_FSTAB () {
    local MNT=$1
    local OPT=$2
    local ENTRY="tmpfs  $MNT  tmpfs  $OPT  0  0"
    local CMD="mount -t tmpfs -o $OPT tmpfs $MNT"

    if ! grep -q "$ENTRY" /etc/fstab; then
        WARN "$MNT missing from /etc/fstab"
        >&2 echo "Add to fstab: $ENTRY"
        >&2 echo "Or manually mount: $CMD"
        FAIL TMPFS
    fi
}
CHECK_FSTAB '/tmp' 'size=5G,rw,nodev,nosuid'
CHECK_FSTAB "$HOME/tmp" "size=10G,rw,nodev,uid=$(id -u),gid=$(id -g),mode=1750,suid,exec"
CHECK_FSTAB "$HOME/.cache" "size=5G,rw,nodev,uid=$(id -u),gid=$(id -g),mode=1750,suid"

HEADER 'Neovim & Vim'
if [[ -f /usr/local/bin/nvim ]]; then
    SYMLINK /usr/local/bin/nvim $HOME/.local/bin/vim
    SYMLINK /usr/local/bin/vim $HOME/.local/bin/oldvim
elif [[ -f /usr/bin/nvim ]]; then
    SYMLINK /usr/bin/nvim $HOME/.local/bin/vim
    SYMLINK /usr/bin/vim $HOME/.local/bin/oldvim
fi
SYMLINK $HOME/.config/nvim $HOME/.vim
SYMLINK $ENVDIR/config/nvim/init.vim $HOME/.vimrc

HEADER '~/.rc Files'
for F in $(ls $ENVDIR/dotfiles); do
    SYMLINK $ENVDIR/dotfiles/$F $HOME/.$F
done

HEADER 'Dropbox Dirs'
if [[ ! -d "$HOME/Dropbox" ]]; then
    WARN '!!!! Dropbox dir does not exist - skipping related symlinks'
else
    SYMLINK $HOME/Dropbox/Documents $HOME/Documents DROPBOX
    SYMLINK $HOME/Dropbox/Photos $HOME/Pictures DROPBOX
fi

HEADER 'Emoji Prompt'
if [ -f "$HOME/src/Heewa/emoji-prompt/emoji-prompt.sh" ]; then
    SYMLINK $HOME/src/Heewa/emoji-prompt/emoji-prompt.sh $HOME/.emoji-prompt.sh EMOJI
elif [[ ! "$IGNORE_EMOJI_ERRS" ]]; then
    curl -# 'https://raw.githubusercontent.com/heewa/emoji-prompt/master/emoji-prompt.sh' > $HOME/.emoji-prompt.sh || FAIL EMOJI
fi

HEADER 'Emoji Env Vars'
if [ -f "$HOME/src/Heewa/bae/emoji_vars.sh" ]; then
    SYMLINK $HOME/src/Heewa/bae/emoji_vars.sh $HOME/.emoji_vars.sh EMOJI
elif [[ ! "$IGNORE_EMOJI_ERRS" ]]; then
    curl -# 'https://raw.githubusercontent.com/heewa/bae/master/emoji_vars.sh' > $HOME/.emoji_vars.sh || FAIL EMOJI
fi

HEADER 'Tmux'
if [[ ! -e $HOME/.tmux.gpakosz ]]; then
    git clone --depth 1 https://github.com/gpakosz/.tmux $HOME/.tmux.gpakosz || FAIL TMUX
fi
SYMLINK $HOME/.tmux.gpakosz/.tmux.conf $HOME/.tmux.conf

if [[ ! -e $HOME/.tmux/plugins/tpm ]]; then
    git clone --depth 1 https://github.com/tmux-plugins/tpm $HOME/.tmux/plugins/tpm || FAIL TMUX
fi

HEADER 'VimPlug & Plugins'
VIM_PLUG_URL='https://github.com/junegunn/vim-plug/raw/master/plug.vim'
PLUG_FILE="$HOME/.config/nvim/autoload/plug.vim"
if [[ ! -f $PLUG_FILE ]]; then
    curl --create-dirs -fL -o "$PLUG_FILE" "$VIM_PLUG_URL" || FAIL VIM
    nvim -c 'PlugInstall | qa' || FAIL VIM
fi

HEADER 'Nerd Fonts'
FONTS=( \
    'Noto/Mono/complete/Noto%20Mono%20Nerd%20Font%20Complete.ttf' \
    'UbuntuMono/Regular/complete/Ubuntu%20Mono%20Nerd%20Font%20Complete.ttf' \
    'SourceCodePro/Regular/complete/Sauce%20Code%20Pro%20Nerd%20Font%20Complete.ttf' \
)
URL="https://raw.githubusercontent.com/ryanoasis/nerd-fonts/master/patched-fonts/"
if [[ "$OS" = 'Darwin' ]]; then
    DIR="$HOME/Library/Fonts"
else
    DIR="$HOME/.local/share/fonts"
fi
mkdir -p "$DIR" || FAIL FONT

GOT_NEW_FONTS=0
for FONT in ${FONTS[@]}; do
    if [[ -f "$DIR/$(basename $FONT)" ]]; then
        echo "  already have $FONT"
    elif [[ ! "$IGNORE_FONT_ERRS" ]]; then
        echo "       getting $FONT"
        curl --output-dir "$DIR" -fOLs "$URL$FONT" || FAIL FONT
        GOT_NEW_FONTS=1
    fi
done

if [[ "$OS" == 'Linux' ]]; then

    HEADER 'Rebuilding Fonts'
    if [[ $GOT_NEW_FONTS == 0 ]]; then
        echo 'no new fonts, skipping rebuild'
    else
        sudo --non-interactive fc-cache -f ~/.local/share/fonts || FAIL FONT
    fi
fi

HEADER 'Pyenv'
if [[ -e "$HOME/.pyenv" ]]; then
    echo 'already have, skipping'
else
    git clone --depth 1 https://github.com/pyenv/pyenv $HOME/.pyenv || FAIL PYENV
fi

HEADER 'Bash Git Prompt'
BGP_DIR="$HOME/.bash-git-prompt"
if [[ -e $BGP_DIR ]]; then
    echo 'already have, skipping'
else
    git clone --depth 1 https://github.com/magicmonty/bash-git-prompt $BGP_DIR || FAIL GITPROMPT
fi

if which npm > /dev/null; then
    HEADER 'NPM'
    npm config set prefix "$HOME/.npm-global" || FAIL NPM
fi

if [[ "$OS" = 'Darwin' ]]; then

    HEADER 'Golang Makefile'
    if [[ -f $HOME/.golang.Makefile ]]; then
        echo 'already have, skipping'
    else
        curl -#sL 'https://gist.githubusercontent.com/heewa/0562f16846aefda88225/raw/Makefile' > $HOME/.golang.Makefile || FAIL GOMAKE
    fi

fi

HEADER "Done, with $ERRS errors!"
exit $ERRS
