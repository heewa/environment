#!/bin/bash
#
# Set up prerequisites, assuming you have admin, and should be
# configuring the system and installing things.

set -e

ENVDIR=$(dirname $(realpath "$0"))
ERRS=0

. $ENVDIR/shared.sh

# Install some things before using curl, git, etc

if [[ "$DISTRO" == 'ubuntu' ]]; then

    HEADER 'Apt Repos'
    sudo --non-interactive add-apt-repository --no-update universe
    sudo --non-interactive add-apt-repository --no-update multiverse
    sudo --non-interactive apt update

    HEADER 'Packages'
    sudo --non-interactive apt install git curl neovim tmux xsel wl-clipboard profile-sync-daemon jq

elif [[ "$DISTRO" == 'fedora' ]]; then

    HEADER 'Packages'
    sudo dnf install neovim tmux

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

    HEADER 'Python Packages'
    pip install --upgrade awscli

fi
