# this is a script you should execute after git cloning:

cd ~/.dotfiles
# init the vim submodules
git submodule update --init

# vim
ln -s ~/.dotfiles/vimrc ~/.vimrc
ln -s ~/.dotfiles/vim ~/.vim
# zshell
ln -s ~/.dotfiles/zshrc ~/.zshrc
# tmux
ln -s ~/.dotfiles/tmux.conf ~/.tmux.conf
ln -s ~/.dotfiles/tmux ~/.tmux
# irssi
ln -s ~/.dotfiles/irssi ~/.irssi
# ipython
ln -s ~/.dotfiles/ipython ~/.ipython
ln -s ~/.dotfiles/ipython/profile_nbserver/ipython_notebook_config.py ~/.jupyter/jupyter_notebook_config.py
# git
ln -s ~/.dotfiles/gitconfig ~/.gitconfig
# directory colors
ln -s ~/.dotfiles/dircolors-solarized/dircolors.ansi-universal ~/.dircolors
# promptline and tmuxline defaults
ln -s ~/.dotfiles/promptline_SolarizedLightVIM_inspirational.sh ~/.dotfiles/promptline.sh
ln -s ~/.dotfiles/tmuxline_SolarizedLightVIM.conf ~/.dotfiles/tmuxline.conf
