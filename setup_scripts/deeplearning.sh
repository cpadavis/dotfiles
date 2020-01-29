#!/bin/bash

# these are things that will make my dev experience nicer, but I don't think are necessary for running anything
# already assumes you have cloned this repo and are executing inside here
# just niceties for browsing around

# bc to help tmux understand what version it is
sudo apt-get install -y zsh bc

# do linking
cd ${HOME}/.dotfiles
# init the vim submodules
git submodule update --init

mkdir ${HOME}/ipynbs
mkdir ${HOME}/.jupyter

# vim
ln -s ${HOME}/.dotfiles/vimrc ${HOME}/.vimrc
ln -s ${HOME}/.dotfiles/vim ${HOME}/.vim
# tmux
ln -s ${HOME}/.dotfiles/tmux.conf ${HOME}/.tmux.conf
ln -s ${HOME}/.dotfiles/tmux ${HOME}/.tmux
# ipython
ln -s ${HOME}/.dotfiles/ipython ${HOME}/.ipython
ln -s ${HOME}/.dotfiles/ipython/profile_nbserver/ipython_notebook_config.py ${HOME}/.jupyter/jupyter_notebook_config.py
ln -s ${HOME}/.dotfiles/jupyter/lab ${HOME}/.jupyter/lab
# git
ln -s ${HOME}/.dotfiles/gitconfig ${HOME}/.gitconfig
# directory colors
ln -s ${HOME}/.dotfiles/dircolors-solarized/dircolors.ansi-universal ${HOME}/.dircolors

# iterm2 with my modifications
ln -s ${HOME}/.dotfiles/iterm2/iterm2_shell_integration.bash ${HOME}/.iterm2_shell_integration.bash
ln -s ${HOME}/.dotfiles/iterm2/iterm2_shell_integration.zsh ${HOME}/.iterm2_shell_integration.zsh
ln -s ${HOME}/.dotfiles/iterm2 ${HOME}/.iterm2

# bash profile
mv ${HOME}/.profile ${HOME}/.profile.bak
ln -s ${HOME}/.dotfiles/zshenvs/profile_deeplearning ${HOME}/.profile

# link also zsh
ln -s ${HOME}/.dotfiles/zshrc ${HOME}/.zshrc
ln -s ${HOME}/.dotfiles/zshenvs/zshenv_deeplearning ${HOME}/.zshenv

echo "change shell with chsh"
