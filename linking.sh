# this is a script you should execute after git cloning:

cd ~/.dotfiles
# init the vim submodules
git submodule init

# vim
ln -s ~/.dotfiles/vimrc ~/.vimrc
ln -s ~/.dotfiles/vim ~/.vim
# zshell
ln -s ~/.dotfiles/zshrc ~/.zshrc
# tmux
ln -s ~/.dotfiles/tmux.conf ~/.tmux.conf
# irssi
ln -s ~/.dotfiles/irssi ~/.irssi
# ipython
ln -s ~/.dotfiles/ipython ~/.ipython
# git
ln -s ~/.dotfiles/gitconfig ~/.gitconfig
# directory colors
ln -s ~/.dotfiles/dircolors ~/.dircolors
# powerline
pipi --editable=./powerline
ln -s ~/.dotfiles/powerline/scripts/powerline ~/.local/bin
ln -s ~/.dotfiles/powerline_config ~/.config/powerline


