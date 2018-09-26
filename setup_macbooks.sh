# this is a script you should execute after git cloning:

cd $HOME/.dotfiles
# init the vim submodules
git submodule update --init

# vim
ln -s $HOME/.dotfiles/vimrc $HOME/.vimrc
ln -s $HOME/.dotfiles/vim $HOME/.vim
# zshell
ln -s $HOME/.dotfiles/zshrc $HOME/.zshrc
read -p "Enter computer name for zshenv: " USER
zshenv_file = $HOME/.dotfiles/zshenvs/zshenv_$USER
echo "Linking $zshenv_file to $HOME/.zshenv"
ln -s $zshenv_file $HOME/.zshenv
echo "Also change your shell to zsh if it is not that already!"
# tmux
ln -s $HOME/.dotfiles/tmux.conf $HOME/.tmux.conf
ln -s $HOME/.dotfiles/tmux $HOME/.tmux
# latexmk
ln -s $HOME/.dotfiles/latexmkrc $HOME/.latexmkrc
# # irssi
# ln -s $HOME/.dotfiles/irssi $HOME/.irssi
# # ipython
ln -s $HOME/.dotfiles/ipython $HOME/.ipython
mkdir $HOME/.jupyter
ln -s $HOME/.dotfiles/ipython/profile_nbserver/ipython_notebook_config.py $HOME/.jupyter/jupyter_notebook_config.py
# git
ln -s $HOME/.dotfiles/gitconfig $HOME/.gitconfig
# directory colors
ln -s $HOME/.dotfiles/dircolors-solarized/dircolors.ansi-universal $HOME/.dircolors
# promptline and tmuxline defaults
ln -s $HOME/.dotfiles/promptline/promptline_SolarizedLight.sh $HOME/.dotfiles/promptline/promptline.sh
ln -s $HOME/.dotfiles/tmuxline/tmuxline_SolarizedLight.conf $HOME/.dotfiles/tmuxline/tmuxline.conf

# iterm2 with my modifications
ln -s $HOME/.dotfiles/iterm2/iterm2_shell_integration.zsh $HOME/.iterm2_shell_integration.zsh
ln -s $HOME/.dotfiles/iterm2 $HOME/.iterm2

# install brew
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
brew doctor
brew install zsh
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

wget https://repo.continuum.io/miniconda/Miniconda3-latest-MacOSX-x86_64.sh -O miniconda.sh
bash miniconda.sh
# install conda
conda install astropy cython ipython libevent jedi jupyter matplotlib notebook numpy pandas pep8 pip pyflakes pylint scikit-learn scipy scons sympy yaml keras
pip3 install easyaccess emcee fitsio healpy chainconsumer ipdb astroquery
