#!/bin/bash
#
# Set up prerequisites, assuming you have admin, and should be
# configuring the system and installing things.

set -e

ENVDIR=$(dirname $(realpath "$0"))
ERRS=0

. $ENVDIR/shared.sh

CHECK_ENVTYPE

# Install some things before using curl, git, etc

if [[ "$DISTRO" == 'ubuntu' ]]; then

    if [[ "$ENVTYPE" == 'home' || "$ENVTYPE" == 'work' ]]; then
        HEADER 'Apt Repos'
        sudo add-apt-repository --no-update universe
        sudo add-apt-repository --no-update multiverse
    fi

    sudo apt update

    HEADER 'Packages'

    PKGS='git curl neovim tmux jq'
    if [[ "$ENVTYPE" == 'home' || "$ENVTYPE" == 'work' ]]; then
        PKGS="$PKGS golang-go xsel wl-clipboard profile-sync-daemon qt5-style-plugins isync notmuch libsecret-tools caca-utils"
    fi

    sudo apt install $PKGS

elif [[ "$DISTRO" == 'fedora' ]]; then

    HEADER 'Packages'

    PKGS='neovim tmux'
    if [[ "$ENVTYPE" == 'home' || "$ENVTYPE" == 'work' ]]; then
        PKGS="$PKGS isync notmuch"
    fi

    sudo dnf install $PKGS

elif [[ "$OS" = 'Darwin' ]]; then

    # Homebrew
    if [[ "$(which brew)" == "" ]]; then
        HEADER 'Homebrew'
        /usr/bin/ruby -e "$(curl -#fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    fi

    # Homebrew packages
    HEADER 'Homebrew Packages'
    for package in bash htop pstree tree watch bash-completion curl; do
        brew ls --versions $package || brew install $package
    done

    HEADER 'Homebrew Casks'
    for package in alacritty kitty; do
        brew ls --versions $package || brew cask install $package
    done

    HEADER 'Homebrew HEAD Packages'
    for package in bash-git-prompt; do
        brew ls --versions $package || brew install --HEAD $package
    done

fi

if [[ "$ENVTYPE" == 'home' || "$ENVTYPE" == 'work' ]]; then

    pip install pipx
    pipx list | grep vdirsyncer || pipx install vdirsyncer[google]
    pipx list | grep khal || pipx install khal

    go install gitlab.com/shackra/goimapnotify@latest

    if [[ "$DISTRO" == 'ubuntu' ]]; then

        HEADER 'Services'

        SERVICES='mbsync.service mbsync.timer goimapnotify@heewab.service vdirsyncer.service vdirsyncer.timer'

        echo 'Enabling:'
        for SERVICE in $SERVICES; do
            echo $SERVICE
            systemctl --user enable $SERVICE
        done

        echo
        echo 'Starting:'
        for SERVICE in $SERVICES; do
            echo $SERVICE
            systemctl --user start $SERVICE
        done

    fi

fi
