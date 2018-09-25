# this is a script you should execute after git cloning:

cd ~/.dotfiles
# init the vim submodules
git submodule update --init

# vim
ln -s ~/.dotfiles/vimrc ~/.vimrc
ln -s ~/.dotfiles/vim ~/.vim
# zshell
ln -s ~/.dotfiles/zshrc ~/.zshrc
echo "Do not forget to link the right zshenv file!"
echo "Also change your shell to zsh if it is not that already!"
# tmux
ln -s ~/.dotfiles/tmux.conf ~/.tmux.conf
ln -s ~/.dotfiles/tmux ~/.tmux
# latexmk
ln -s ~/.dotfiles/latexmkrc ~/.latexmkrc
# # irssi
# ln -s ~/.dotfiles/irssi ~/.irssi
# # ipython
ln -s ~/.dotfiles/ipython ~/.ipython
mkdir ~/.jupyter
ln -s ~/.dotfiles/ipython/profile_nbserver/ipython_notebook_config.py ~/.jupyter/jupyter_notebook_config.py
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

# install brew
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
brew doctor
brew install vim
brew install findutils --with-default-names
brew install gnu-sed --with-default-names
brew install gnu-tar --with-default-names
brew install gnu-which --with-default-names
brew install gnutls --with-default-names
brew install grep --with-default-names
brew install ack
brew install coreutils
brew install binutils
brew install diffutils
brew install gzip
brew install watch
brew install tmux
brew install wget
brew install nmap
brew install gpg
brew install htop
brew install ctags

cd ~/
wget https://repo.continuum.io/miniconda/Miniconda3-latest-MacOSX-x86_64.sh -O ~/miniconda.sh
bash ~/miniconda.sh
# install conda
conda install astropy cython ipython libevent jedi jupyter matplotlib notebook numpy pandas pep8 pip pyflakes pylint scikit-learn scipy scons sympy yaml keras
pip3 install easyaccess emcee fitsio healpy chainconsumer ipdb astroquery
