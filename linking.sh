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
# # irssi
# ln -s ~/.dotfiles/irssi ~/.irssi
# # ipython
# ln -s ~/.dotfiles/ipython ~/.ipython
# ln -s ~/.dotfiles/ipython/profile_nbserver/ipython_notebook_config.py ~/.jupyter/jupyter_notebook_config.py
# git
ln -s ~/.dotfiles/gitconfig ~/.gitconfig
# directory colors
ln -s ~/.dotfiles/dircolors-solarized/dircolors.ansi-universal ~/.dircolors
# promptline and tmuxline defaults
ln -s ~/.dotfiles/promptline/promptline_SolarizedLight.sh ~/.dotfiles/promptline/promptline.sh
ln -s ~/.dotfiles/tmuxline/tmuxline_SolarizedLight.conf ~/.dotfiles/tmuxline/tmuxline.conf

# iterm2 with my modifications
ln -s ~/.dotfiles/iterm2/iterm2_shell_integration.zsh ~/.iterm2_shell_integration.zsh
ln -s ~/.dotfiles/iterm2 ~/.iterm2
