#!/bin/bash
#
# Set up environment.

set -e

ENVDIR=$(dirname $(realpath "$0"))
ERRS=0

. $ENVDIR/shared.sh

CHECK_ENVTYPE

if [[ "$ENVTYPE" != 'server' ]]; then

    HEADER 'Basic Dirs'
    mkdir -pv $HOME/{src,build,bak,tmp,.cache,.config,.permcache,.local/bin} || FAIL DIR

fi

HEADER 'Configs'
# Only symlink the files in each app dir, so any additional ones the
# app might create won't end up in this repo
(
    # Change dirs so find gives relative paths
    cd $ENVDIR/config || FAIL

    for APP in $(find . -maxdepth 1 -mindepth 1 -type d | xargs basename -a | tr '\n' ' '); do
        for FILE in $(find $APP -type f); do
            SYMLINK $ENVDIR/config/$FILE $HOME/.config/$FILE
        done
    done
)

HEADER 'Extra Config Symlinks'
(
    SYMLINK $HOME/.config/nvim $HOME/.vim
    SYMLINK $ENVDIR/config/nvim/init.vim $HOME/.vimrc

    SYMLINK $ENVDIR/config/ansible/ansible.cfg $HOME/.ansible.cfg

    SYMLINK $HOME/.config/FreeCAD $HOME/.FreeCAD
)

HEADER 'Slow-sync Configs'
(
    cd $ENVDIR/slow_config || FAIL

    for F in $(find . -type f | cut -b3- ); do
        if [[ ! -f "$HOME/.config/$F" ]]; then
            echo $F
            mkdir -p "$HOME/.config/$(dirname $F)"
            rsync "$F" "$HOME/.config/$F"
        else
            diff -q "$F" "$HOME/.config/$F" > /dev/null || echo "  (skipping modified: $F)"
        fi
    done
)

HEADER 'Synced Configs'
(
    cd $HOME/Sync/config || FAIL SYNCDIR

    for F in $(find . -type f | cut -b3- ); do
        SYMLINK $HOME/Sync/config/$F $HOME/.config/$F SYNCDIR
    done
)

HEADER 'Scripts'
(
    mkdir -p $HOME/scripts || FAIL SCRIPTS

    cd $ENVDIR/scripts || FAIL SCRIPTS
    for F in $(find . -type f | cut -b3- ); do
        SYMLINK $ENVDIR/scripts/$F $HOME/scripts/$F SCRIPTS
    done

    cd $HOME/Sync/scripts || FAIL SYNCDIR
    for F in $(find . -type f | cut -b3- ); do
        SYMLINK $HOME/Sync/scripts/$F $HOME/scripts/$F SYNCDIR
    done
)

if [[ "$ENVTYPE" == 'home' && "$OS" == 'Linux' ]]; then

    HEADER 'DNS'
    for F in $(ls misc/resolved.conf.d); do
        diff -u $PWD/misc/resolved.conf.d/$F /etc/systemd/resolved.conf.d/$F || FAIL DNS
    done

fi

HEADER 'Neovim & Vim'
if [[ $(command -v vim) ]]; then
    VIM="$(readlink -f $(command -v vim))"
    if [[ "$(basename $VIM)" != 'nvim' ]]; then
        SYMLINK "$VIM" $HOME/.local/bin/vim.plain
    fi
fi
if [[ $(command -v nvim) ]]; then
    SYMLINK "$(readlink -f $(command -v nvim))" $HOME/.local/bin/vim
fi

HEADER '~/.rc Files'
(
    cd $ENVDIR/dotfiles || FAIL
    for F in $(find . -type f | cut -sd/ -f2-); do
        SYMLINK $ENVDIR/dotfiles/$F $HOME/.$F
    done
)

HEADER 'Zig'
(
    ZIG_DIR="$HOME/build/zig"
    ZIG_ENV="$ENVDIR/misc/zig"

    cd $ZIG_ENV|| FAIL
    mkdir -p "$ZIG_DIR"
    for F in $(find . -type f | cut -sd/ -f2-); do
        SYMLINK $ZIG_ENV/$F $ZIG_DIR/$F
    done

    UPDATE_ZIG="update_zig.sh"
    SYMLINK "$ENVDIR/misc/zig/$UPDATE_ZIG" "$ZIG_DIR/$UPDATE_ZIG"
)

if [[ "$ENVTYPE" != 'minimal' ]]; then

    HEADER 'Emoji Prompt'
    if [ -f "$HOME/src/Heewa/emoji-prompt/emoji-prompt.sh" ]; then
        SYMLINK $HOME/src/Heewa/emoji-prompt/emoji-prompt.sh $HOME/.emoji-prompt.sh EMOJI
    elif [[ ! "$IGNORE_EMOJI_ERRS" ]]; then
        GIT_SHALLOW "$HOME/build/emoji-prompt" 'https://github.com/heewa/emoji-prompt' EMOJI
        SYMLINK $HOME/build/emoji-prompt/emoji-prompt.sh $HOME/.emoji-prompt.sh EMOJI
    fi

    HEADER 'Emoji Env Vars'
    if [ -f "$HOME/src/Heewa/bae/emoji_vars.sh" ]; then
        SYMLINK $HOME/src/Heewa/bae/emoji_vars.sh $HOME/.emoji_vars.sh EMOJI
    elif [[ ! "$IGNORE_EMOJI_ERRS" ]]; then
        GIT_SHALLOW "$HOME/build/bae" 'https://github.com/heewa/bae' EMOJI
        SYMLINK $HOME/build/bae/emoji_vars.sh $HOME/.emoji_vars.sh EMOJI
    fi

fi

HEADER 'Tmux & Plugins'
GIT_SHALLOW "$HOME/.tmux/plugins/tmux-sensible" 'https://github.com/tmux-plugins/tmux-sensible' TMUX
GIT_SHALLOW "$HOME/.tmux/gpakosz" 'https://github.com/gpakosz/.tmux' TMUX
SYMLINK $HOME/.tmux/gpakosz/.tmux.conf $HOME/.tmux.conf TMUX

HEADER 'VimPlug & Plugins'
VIM_PLUG_URL='https://github.com/junegunn/vim-plug/raw/master/plug.vim'
PLUG_FILE="$HOME/.config/nvim/autoload/plug.vim"
if [[ ! -f $PLUG_FILE ]]; then
    curl --create-dirs -fL -o "$PLUG_FILE" "$VIM_PLUG_URL" || FAIL VIM

    if [[ "$ENVTYPE" != 'minimal' ]]; then

        nvim -c 'PlugInstall | qa' || FAIL VIM
    fi
fi

if [[ "$ENVTYPE" == 'home' || "$ENVTYPE" == 'work' ]]; then

    HEADER 'Nerd Fonts'
    FONTS=( \
        'UbuntuMono/Regular/UbuntuMonoNerdFontMono-Regular.ttf' \
        'UbuntuMono/Regular/UbuntuMonoNerdFont-Regular.ttf' \
        'SourceCodePro/Regular/SauceCodeProNerdFontMono-Regular.ttf' \
        'SourceCodePro/Regular/SauceCodeProNerdFont-Regular.ttf' \
    )
    URL="https://github.com/ryanoasis/nerd-fonts/raw/HEAD/patched-fonts/"
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
            sudo fc-cache -f ~/.local/share/fonts || FAIL FONT
        fi
    fi

fi

if [[ "$ENVTYPE" != 'minimal' ]]; then

    HEADER 'Pyenv'
    GIT_SHALLOW "$HOME/.pyenv" 'https://github.com/pyenv/pyenv' PYENV

    HEADER 'Bash Git Prompt'
    GIT_SHALLOW "$HOME/.bash-git-prompt" 'https://github.com/magicmonty/bash-git-prompt' GITPROMPT

fi

if [[ "$OS" == 'Darwin' ]]; then

    HEADER 'Golang Makefile'
    (
        if [[ -f $HOME/.golang.Makefile ]]; then
            echo 'already have, skipping'
        else
            curl -#sL 'https://gist.githubusercontent.com/heewa/0562f16846aefda88225/raw/Makefile' > $HOME/.golang.Makefile
        fi
    ) || FAIL GOMAKE

fi

HEADER "Done, with $ERRS errors!"
exit $ERRS
