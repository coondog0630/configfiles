#!/usr/bin/env bash

# OS independent
# Gem configs
ln -snf $PWD/gem/.gemrc ~/.gemrc
# Irb colors
ln -snf $PWD/irb/.irbrc ~/.irbrc

# Vim
ln -snf $PWD/editors/vim/.vimrc ~/.vimrc
ln -snf $PWD/editors/vim/.vim ~/.vim

# Operating System Specific Configs
system_type=`uname`
# Mac OS X symlinks
if [ $system_type == "Darwin" ]; then
    system_type="macosx"

    # Bash
    ln -snf $PWD/bash/.bashrc.$system_type ~/.bashrc
    ln -snf $PWD/bash/.bash_profile.$system_type ~/.bash_profile
    ln -snf $PWD/bash/.bash_aliases.$system_type ~/.bash_aliases

    # Git Stuff
    ln -snf $PWD/git/.gitconfig.$system_type ~/.gitconfig
    ln -snf $PWD/git/.gitignore.$system_type ~/.gitignore

    # Emacs
    ln -snf $PWD/editors/emacs/.emacs.$system_type ~/.emacs
    ln -snf $PWD/editors/emacs/.emacs.d/plugins ~/.emacs.d/plugins

    # Tmux
    ln -snf $PWD/tmux/.tmux.conf.$system_type ~/.tmux.conf
fi