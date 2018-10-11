#!/bin/bash

# these are things that will make my dev experience nicer, but I don't think are necessary for running anything
# note that they overlap with the macbook setup.

# apt-get nice things
sudo apt-get install zsh
sudo apt-get install ack-grep
sudo apt-get install tmux
sudo apt-get install bc  # used with tmux
sudo apt-get install vim
sudo apt-get install ctags  # used with vim


echo "changing shell to zsh. First activating sudo"
sudo -s
echo /usr/bin/zsh >> /etc/shells
chsh -s /usr/bin/zsh

# pip3 install things more todo with coding rather than running
pip3 install ipdb ipython jedi jupyter notebook pep8 pyflakes pylint sympy


# enable widgets with jupyter
jupyter nbextension enable --py widgetsnbextension

# clone dotfiles
cd ${HOME}
git clone https://github.com/cpadavis/dotfiles.git .dotfiles

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
# git
ln -s ${HOME}/.dotfiles/gitconfig ${HOME}/.gitconfig
# directory colors
ln -s ${HOME}/.dotfiles/dircolors-solarized/dircolors.ansi-universal ${HOME}/.dircolors
# promptline and tmuxline defaults
ln -s ${HOME}/.dotfiles/promptline/promptline_LuciusLight.sh ${HOME}/.dotfiles/promptline/promptline.sh
ln -s ${HOME}/.dotfiles/tmuxline/tmuxline_LuciusLight.conf ${HOME}/.dotfiles/tmuxline/tmuxline.conf

# iterm2 with my modifications
ln -s ${HOME}/.dotfiles/iterm2/iterm2_shell_integration.bash ${HOME}/.iterm2_shell_integration.bash
ln -s ${HOME}/.dotfiles/iterm2/iterm2_shell_integration.zsh ${HOME}/.iterm2_shell_integration.zsh
ln -s ${HOME}/.dotfiles/iterm2 ${HOME}/.iterm2

# bash profile
ln -s ${HOME}/.dotfiles/zshenvs/profile_gcloud ${HOME}/.profile

# link also zsh
ln -s ${HOME}/.dotfiles/zshrc ${HOME}/.zshrc
ln -s ${HOME}/.dotfiles/zshenvs/zshenv_GCLOUD ${HOME}/.zshenv
