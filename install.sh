#!/bin/bash
#
# Set up symlinks to dotfiles & make sure directories I want are there.

# XDG Config goes straight into ~/.config/ without rename
echo
echo '==] SymLinking XDG Config in ~/.config/'
mkdir -p ~/.config/
ln -vsf $PWD/config/* $HOME/.config/

# .rc files need to be renamed individually
echo
echo '==] SymLinking ~/.rc files'
ln -vsf $PWD/dotfiles/vim ~/.vim
ln -vsf $PWD/dotfiles/vim/vimrc ~/.vimrc
ln -vsf $PWD/dotfiles/screenrc ~/.screenrc
ln -vsf $PWD/dotfiles/gitconfig ~/.gitconfig
ln -vsf $PWD/dotfiles/gitignore ~/.gitignore
ln -vsf $PWD/dotfiles/bashrc ~/.bashrc
ln -vsf $PWD/dotfiles/profile ~/.profile

echo
echo '==] Creating home dirs'
for D in src build tmp scripts .bash; do
    mkdir -v $HOME/$D
done

# Create dropbox symlinks, even if Dropbox isn't updated yet.
echo
echo '==] SymLinking Dropbox Dirs'
for DBoxDir in Documents; do
    if [[ ! -e "$HOME/$DBoxDir" && ! -L "$HOME/$DBoxDir" ]]; then
        ln -vs $HOME/Dropbox/$DBoxDir $HOME/
    elif [[ ! -L "$HOME/$DBoxDir" ]]; then
        echo "~/$DBoxDir exists, but is not a symlink"
        ln -vsFi $HOME/Dropbox/$DBoxDir $HOME/
    elif [[ $(readlink $HOME/$DBoxDir) != "$HOME/Dropbox/$DBoxDir" &&
            $(readlink $HOME/$DBoxDir) != "Dropbox/$DBoxDir" ]]; then
        echo "~/$DBoxDir currently points to $(readlink $HOME/$DBoxDir)"
        ln -vsFi $HOME/Dropbox/$DBoxDir $HOME/
    else
        echo "~/$DBoxDir already points to Dropbox"
    fi
done

# git aware prompt
echo
echo '==] Creating/Updating git aware prompt from git repo'
BASH_GIT_DIR="$HOME/.bash/git-aware-prompt"
if [[ ! -e "$BASH_GIT_DIR" ]]; then
    git clone git://github.com/jimeh/git-aware-prompt.git $BASH_GIT_DIR
else
    pushd $BASH_GIT_DIR
    git checkout master && git pull
    popd
fi

echo
echo '==] Done'
