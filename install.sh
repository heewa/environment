#!/bin/bash
#
# Set up symlinks to dotfiles & make sure directories I want are there.

# Exit on errors, to force myself to fix this script
set -e

echo
echo '==] Creating home dirs'
for D in src build tmp scripts bin .bash .config/tmux .config/nvim; do
    mkdir -pv $HOME/$D
done

# XDG Config goes straight into ~/.config/ without rename
echo
echo '==] SymLinking XDG Config in ~/.config/'
# These need to be treaded indivudually (unless you can bash more cleverly)
echo '  ] nvim'
SRC="$PWD/config/nvim"
DST="$HOME/.config/nvim"
mkdir -p "$DST/autoload"
ln -vsf "$SRC/init.vim" "$DST/"
ln -vsf "$SRC/autoload/plug.vim" "$DST/autoload/"

# .rc files need to be renamed individually
echo
echo '==] SymLinking ~/.rc files'
for F in $(ls dotfiles); do
    SRC="$PWD/dotfiles/$F"
    DST="$HOME/.$F"

    if [[ -d "$SRC" && ( ! -L $"DST" || "$(readlink $DST)" != "$SRC" ) ]]; then
        echo "!!!! $DST already exists"
    else
        ln -vsf $SRC $DST
    fi
done

# Link legacy vim confs to nvim's, and the binary
echo
echo '==] SymLinking vim -> nvim'
ln -vsf $HOME/.config/nvim ~/.vim
ln -vsf $HOME/.config/nvim/init.vim ~/.vimrc
ln -vsf /usr/local/bin/nvim $HOME/bin/vim
ln -vsf /usr/local/bin/vim $HOME/bin/oldvim

echo
echo '==] SymLinking Dropbox Dirs'
if [[ ! -d "$HOME/Dropbox" ]]; then
    echo '!!!! Dropbox dir does not exist - skipping related symlinks'
else
    RELINK_DIR() {
        local SRC="$HOME/Dropbox/$1"
        local DST="$HOME/${2:-$1}"
        local NAME=${2:-$1}

        if [[ ! -e "$DST" && ! -L "$DST" ]]; then
            ln -vs $SRC $DST
        elif [[ ! -L "$DST" ]]; then
            rmdir $DST && ln -vs $SRC $DST
        elif [[ $(readlink "$DST") != "$SRC" ]]; then
            echo "$NAME currently points to $(readlink $DST), relinking..."
            ln -vsfT $SRC $DST
        fi
    }
    RELINK_DIR Documents
    RELINK_DIR Photos Pictures
fi

echo
echo '==] Pretty, pretty emoji prompts'
if [ -f "$HOME/src/Heewa/emoji-prompt/emoji-prompt.sh" ]; then
    echo 'Linking from git repo'
    ln -vsf $HOME/src/Heewa/emoji-prompt/emoji-prompt.sh $HOME/.emoji-prompt.sh
else
    echo 'Downloading from git repo'
    curl -# 'https://raw.githubusercontent.com/heewa/emoji-prompt/master/emoji-prompt.sh' > ~/.emoji-prompt.sh
fi

echo
echo '==] Pretty, pretty emoji env vars'
if [ -f "$HOME/src/Heewa/bae/emoji_vars.sh" ]; then
    echo 'Linking from git repo'
    ln -vsf $HOME/src/Heewa/bae/emoji_vars.sh $HOME/.emoji_vars.sh
else
    echo 'Downloading from git repo'
    curl -# 'https://raw.githubusercontent.com/heewa/bae/master/emoji_vars.sh' > ~/.emoji_vars.sh
fi

echo
echo '==] Tmux'
if [[ ! -e $HOME/.tmux.gpakosz ]]; then
    git clone --depth 1 git@github.com:gpakosz/.tmux.git ~/.tmux.gpakosz
fi
ln -vsf $HOME/.tmux.gpakosz/.tmux.conf $HOME/
if [[ ! -e $HOME/.tmux/plugins/tpm ]]; then
    git clone --depth 1 https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

echo
echo '==] Vim'
# Vim Plug for vim
curl -#fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
# Vim plug for neovim
curl -#fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

echo
echo '==] Downloading nerd fonts'
FONTS=( \
    'Noto/Mono/complete/Noto%20Mono%20Nerd%20Font%20Complete%20Mono.ttf' \
    'UbuntuMono/Regular/complete/Ubuntu%20Mono%20Nerd%20Font%20Complete%20Mono.ttf' \
    'SourceCodePro/Regular/complete/Sauce%20Code%20Pro%20Nerd%20Font%20Complete%20Mono.ttf' \
)
URL="https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/"
if [[ "$(uname)" = "Darwin" ]]; then
    DIR="$HOME/Library/Fonts"
else
    DIR="$HOME/.local/share/fonts"
fi
mkdir -p "$DIR"
(
    cd "$DIR"
    for FONT in ${FONTS[@]}; do
        echo "    $FONT"
        curl -fOLs "$URL$FONT"
    done
)

# Mac Specific
if [[ "$(uname)" = "Darwin" ]]; then

    # Homebrew
    if [[ "$(which brew)" == "" ]]; then
        echo
        echo '==] Installing homebrew'
        /usr/bin/ruby -e "$(curl -#fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    fi

    # Homebrew packages
    echo
    echo '==] Installing homebrew packages'
    for package in htop pstree tree watch bash-completion; do
        brew ls --versions $package || brew install $package
    done

    #echo
    #echo '==] Installing devel-version homebrew packages'
    #for package in go; do
    #    brew ls --versions $package || brew install --devel $package
    #done

    echo
    echo '==] Installing HEAD-version homebrew packages'
    for package in bash-git-prompt; do
        brew ls --versions $package || brew install --HEAD $package
    done

    echo
    echo '==] Installing homebrew packages with options'
    brew ls --versions curl || brew install --with-openssl --with-nghttp2 curl

    echo
    echo '==] Installing python packages'
    pip install --upgrade awscli

    # Golang Makefile
    echo
    echo '==] Getting Golang Makefile from git gist'
    curl -#sL 'https://gist.githubusercontent.com/heewa/0562f16846aefda88225/raw/Makefile' > $HOME/.golang.Makefile

elif [[ $(uname) == "Linux" ]]; then # Linux

    echo
    echo '==] bash git prompt'
    BGP_DIR="$HOME/.bash-git-prompt"
    if [[ ! -e $BGP_DIR ]]; then
        git clone --depth 1 git@github.com:magicmonty/bash-git-prompt.git $BGP_DIR
    fi

    # Avoid all sudo things if don't have password yet
    sudo --non-interactive echo
    if [[ $? ]]; then
        echo '==] Installing linux packages'
        if [[ ! $(which xsel) ]]; then
            echo
            echo '==] xsel, for clipboard stuff'
            sudo apt install xsel
        fi
    else
        echo '**** Need sudo to install linux packages'
    fi

fi # Mac Specific

    if [[ ! -e "$HOME/.pyenv" ]]; then
        echo
        echo '==] Pyenv'
        git clone --depth 1 git@github.com:pyenv/pyenv.git ~/.pyenv
    fi

echo
echo '==] Done'
