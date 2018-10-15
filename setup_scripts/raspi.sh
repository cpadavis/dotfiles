#!/bin/bash

# setup script for getting useful packages for your rasp pi

sudo apt-get update
sudo apt-get upgrade

# for getting bluetooth to work (a real nice nicety)
sudo apt-get install -y bluetooth bluez-utils blueman bluez python-gobject python-gobject-2

# useful niceties
sudo apt-get install -y zsh ack-grep tmux vim ctags bc

# get pip for python
sudo apt-get install -y python3-pip

# to make vim not complain:
pip3 install jedi pep8 pyflakes pylint

# clone dotfiles
cd ${HOME}
git clone https://github.com/cpadavis/dotfiles.git .dotfiles

# do linking
cd ${HOME}/.dotfiles
# init the vim submodules
git submodule update --init

# vim
ln -s ${HOME}/.dotfiles/vimrc ${HOME}/.vimrc
ln -s ${HOME}/.dotfiles/vim ${HOME}/.vim
# tmux
ln -s ${HOME}/.dotfiles/tmux.conf ${HOME}/.tmux.conf
ln -s ${HOME}/.dotfiles/tmux ${HOME}/.tmux
# git
ln -s ${HOME}/.dotfiles/gitconfig ${HOME}/.gitconfig
# directory colors
ln -s ${HOME}/.dotfiles/dircolors-solarized/dircolors.ansi-universal ${HOME}/.dircolors
# tmuxline default. promptline is dealt with in zshenv
ln -s ${HOME}/.dotfiles/tmuxline/tmuxline_SolarizedDark.conf ${HOME}/.dotfiles/tmuxline/tmuxline.conf

# link also zsh
ln -s ${HOME}/.dotfiles/zshrc ${HOME}/.zshrc
ln -s ${HOME}/.dotfiles/zshenvs/zshenv_PI ${HOME}/.zshenv


# echo "changing shell to zsh. First activating sudo"
# sudo -s
# echo /usr/bin/zsh >> /etc/shells
# chsh -s /usr/bin/zsh


# iterm2 with my modifications
ln -s ${HOME}/.dotfiles/iterm2/iterm2_shell_integration.bash ${HOME}/.iterm2_shell_integration.bash
ln -s ${HOME}/.dotfiles/iterm2/iterm2_shell_integration.zsh ${HOME}/.iterm2_shell_integration.zsh
ln -s ${HOME}/.dotfiles/iterm2 ${HOME}/.iterm2
