#!/bin/bash
#
# Set up symlinks to dotfiles & make sure directories I want are there.

echo
echo '==] Creating home dirs'
for D in src build tmp scripts bin .bash; do
    mkdir -v $HOME/$D
done

# XDG Config goes straight into ~/.config/ without rename
echo
echo '==] SymLinking XDG Config in ~/.config/'
mkdir -p ~/.config/
ln -vsf $PWD/config/* $HOME/.config/

# .rc files need to be renamed individually
echo
echo '==] SymLinking ~/.rc files'
ln -vsf $PWD/dotfiles/bash_profile ~/.bash_profile
ln -vsf $PWD/dotfiles/profile ~/.profile
ln -vsf $PWD/dotfiles/bashrc ~/.bashrc
ln -vsfh $PWD/dotfiles/bash_completion.d ~/.bash_completion.d
ln -vsf $PWD/dotfiles/screenrc ~/.screenrc
ln -vsf $PWD/dotfiles/gitconfig ~/.gitconfig
ln -vsf $PWD/dotfiles/gitignore ~/.gitignore
ln -vsf $PWD/dotfiles/git-prompt-colors.sh ~/.git-prompt-colors.sh
ln -vsf $PWD/dotfiles/rmvrc ~/.rvmrc
ln -vsf $PWD/dotfiles/tmux.conf ~/.tmux.conf

# Link legacy vim confs to nvim's, and the binary
echo
echo '==] SymLinking vim -> nvim'
ln -vsfh $HOME/.config/nvim ~/.vim
ln -vsf $HOME/.config/nvim/init.vim ~/.vimrc
ln -vsf /usr/local/bin/nvim $HOME/bin/vim
ln -vsf /usr/local/bin/vim $HOME/bin/oldvim

# Create dropbox symlinks, even if Dropbox isn't updated yet.
echo
echo '==] SymLinking Dropbox Dirs'
for DBoxDir in ''; do
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

echo
echo '==] Pretty, pretty emoji prompts'
if [ -f "$HOME/src/Heewa/emoji-prompt/emoji-prompt.sh" ]; then
    echo 'Linking from git repo'
    ln -vsf $HOME/src/Heewa/emoji-prompt/emoji-prompt.sh $HOME/.emoji-prompt.sh
else
    echo 'Downloading from git repo'
    curl 'https://raw.githubusercontent.com/heewa/emoji-prompt/master/emoji-prompt.sh' > ~/.emoji-prompt.sh
fi

echo
echo '==] Pretty, pretty emoji env vars'
if [ -f "$HOME/src/Heewa/bae/emoji_vars.sh" ]; then
    echo 'Linking from git repo'
    ln -vsf $HOME/src/Heewa/bae/emoji_vars.sh $HOME/.emoji_vars.sh
else
    echo 'Downloading from git repo'
    curl 'https://raw.githubusercontent.com/heewa/bae/master/emoji_vars.sh' > ~/.emoji_vars.sh
fi

echo
echo '==] Vim stuff'
# Vim Plug for vim
curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
# Vim plug for neovim
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# Mac Specific
if [[ "$(uname)" = "Darwin" ]]; then

	# Homebrew
	if [[ "$(which brew)" == "" ]]; then
	    echo
	    echo '==] Installing homebrew'
	    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
	fi

	# Homebrew packages
	echo
	echo '==] Installing homebrew packages'
	for package in "archey git htop memcached mongodb nginx pstree python redis terminal-notifier tree vim w3m watch bash-completion bash-git-prompt"; do
	    if [[ "$(brew info --versions $package)" == "" ]]; then
		brew install $pacakage
	    fi
	done

	echo
	echo '==] Installing devel-version homebrew packages'
	for package in "go"; do
	    if [[ "$(brew info --versions $package)" == "" ]]; then
		brew install --devel $pacakage
	    fi
	done

	echo
	echo '==] Installing homebrew packages with options'
	if [[ "$(brew info --versions curl)" == "" ]]; then
	    brew install --with-openssl --with-nghttp2 curl
	fi

	echo
	echo '==] Installing python packages'
	pip install --upgrade awscli

	# git aware prompt
	echo
	echo '==] Installing HEAD-version homebrew packages'
	for package in "bash-git-prompt"; do
	    if [[ "$(brew info --versions $package)" == "" ]]; then
		brew install --HEAD $pacakage
	    fi
	done

	# a backup implementation
	echo
	echo '==] Creating/Updating a different git aware prompt from git repo'
	BASH_GIT_DIR="$HOME/.bash/git-aware-prompt"
	if [[ ! -e "$BASH_GIT_DIR" ]]; then
	    git clone git://github.com/jimeh/git-aware-prompt.git $BASH_GIT_DIR
	else
	    pushd $BASH_GIT_DIR
	    git checkout master && git pull
	    popd
	fi

	# Golang Makefile
	echo
	echo '==] Getting Golang Makefile from git gist'
	curl -sL 'https://gist.githubusercontent.com/heewa/0562f16846aefda88225/raw/Makefile' > $HOME/.golang.Makefile

else # Mac Specific
    true
fi # Mac Specific

echo
echo '==] Done'
