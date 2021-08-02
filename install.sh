#!/bin/bash
#
# Set up symlinks to dotfiles & make sure directories I want are there.

# Exit on errors, to force myself to fix this script
set -e

echo
echo '==] Creating home dirs'
for D in src build tmp bin .bash .config/tmux .config/nvim .npm-global; do
    mkdir -pv $HOME/$D
done

LINKED_DIRS='scripts'
echo
echo "==] SymLinking dirs: $LINKED_DIRS"
for D in $LINKED_DIRS; do
    SRC="$PWD/$D"
    DST="$HOME/$D"

    if [[ ! -L "$DST" || "$(readlink $DST)" != "$SRC" ]]; then
        ln -vs $SRC $DST || echo "!!!! $DST already exists"
    fi
done

# XDG Config goes straight into ~/.config/ without rename
echo
echo '==] SymLinking XDG Config in ~/.config/'

link_config() {
    local APP="$1"
    shift
    local FILES="$*"

    for FILE in $FILES; do
        local SRC="$PWD/config/$APP/$FILE"
        local DST="$HOME/.config/$APP/$FILE"
        mkdir -p "$(dirname $DST)"
        ln -vsf "$SRC" "$DST"
    done
}

link_config 'nvim' 'init.vim'
link_config 'alacritty' 'alacritty.yml'
link_config 'kitty' 'kitty.conf'

# .rc files need to be renamed individually
echo
echo '==] SymLinking ~/.rc files'
for F in $(ls dotfiles); do
    SRC="$PWD/dotfiles/$F"
    DST="$HOME/.$F"

    if [[ -d "$SRC" && ( ! -L "$DST" || "$(readlink $DST)" != "$SRC" ) ]]; then
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
echo '==] Downloading and installing vim plug & plugins'
VIM_PLUG_URL='https://github.com/junegunn/vim-plug/raw/master/plug.vim'
curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs "$VIM_PLUG_URL"
vim -c 'PlugInstall | qa' | true

echo
echo '==] Downloading nerd fonts'
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
(
    cd "$DIR"
    for FONT in ${FONTS[@]}; do
        echo "    $FONT"
        curl -fOLs "$URL$FONT"
    done
)

if [[ ! -e "$HOME/.pyenv" ]]; then
    echo
    echo '==] Pyenv'
    git clone --depth 1 git@github.com:pyenv/pyenv.git ~/.pyenv
fi

which npm && npm config set prefix "$HOME/.npm-global" || echo '!!!! NPM not installed, skipping conf'

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
    for package in bash htop pstree tree watch bash-completion curl; do
        brew ls --versions $package || brew install $package
    done

    #echo
    #echo '==] Installing devel-version homebrew packages'
    #for package in go; do
    #    brew ls --versions $package || brew install --devel $package
    #done

    echo
    echo '==] Installing cask homebrew packages'
    for package in alacritty kitty; do
        brew ls --versions $package || brew cask install $package
    done

    echo
    echo '==] Installing HEAD-version homebrew packages'
    for package in bash-git-prompt; do
        brew ls --versions $package || brew install --HEAD $package
    done

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
    if [[ ! $? ]]; then
        echo '**** Need sudo to install linux packages'
    else
        echo '==] Rebuilding fonts'
        sudo fc-cache -f ~/.local/share/fonts

        echo '==] Installing linux packages'
        sudo apt install xsel

        echo '==] Installing alacritty'
        sudo add-apt-repository ppa:mmstick76/alacritty && sudo apt install alacritty || true
    fi

fi # Mac Specific

echo
echo '==] Done'
