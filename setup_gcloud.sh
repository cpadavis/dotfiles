#!/bin/bash
sudo apt-get update
sudo apt-get upgrade

# get pip for python
sudo apt-get install python3-pip

# install setuptools
pip3 install setuptools==40.0.0

# Install Tensorflow (v1.10)
pip3 install tensorflow-gpu==1.10

# Install Cuda 9.0
# https://yangcha.github.io/CUDA90/
wget http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1604/x86_64/cuda-repo-ubuntu1604_9.0.176-1_amd64.deb
wget http://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu1604/x86_64/libcudnn7_7.0.5.15-1+cuda9.0_amd64.deb
wget http://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu1604/x86_64/libcudnn7-dev_7.0.5.15-1+cuda9.0_amd64.deb
wget http://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu1604/x86_64/libnccl2_2.1.4-1+cuda9.0_amd64.deb
wget http://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu1604/x86_64/libnccl-dev_2.1.4-1+cuda9.0_amd64.deb
sudo dpkg -i cuda-repo-ubuntu1604_9.0.176-1_amd64.deb
sudo dpkg -i libcudnn7_7.0.5.15-1+cuda9.0_amd64.deb
sudo dpkg -i libcudnn7-dev_7.0.5.15-1+cuda9.0_amd64.deb
sudo dpkg -i libnccl2_2.1.4-1+cuda9.0_amd64.deb
sudo dpkg -i libnccl-dev_2.1.4-1+cuda9.0_amd64.deb
sudo apt-get update
sudo apt-get install cuda=9.0.176-1
sudo apt-get install libcudnn7-dev
sudo apt-get install libnccl-dev

rm cuda-repo-ubuntu1604_9.0.176-1_amd64.deb
rm libcudnn7_7.0.5.15-1+cuda9.0_amd64.deb
rm libcudnn7-dev_7.0.5.15-1+cuda9.0_amd64.deb
rm libnccl2_2.1.4-1+cuda9.0_amd64.deb
rm libnccl-dev_2.1.4-1+cuda9.0_amd64.deb

# also put in profile_gcloud
export PATH=/usr/local/cuda-9.0/bin${PATH:+:${PATH}}
export LD_LIBRARY_PATH=/usr/local/cuda-9.0/lib64${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}

# ctags for vim
sudo apt-get install ctags
sudo apt-get install zsh
sudo apt-get install ack-grep

# install Keras
pip3 install keras==2.2.2

# install some python packages
pip3 install cython ipython numba jedi jupyter matplotlib notebook numpy pandas pep8 pyflakes pylint scikit-learn scipy sympy ipdb

# enable widgets with jupyter
jupyter nbextension enable --py widgetsnbextension

# do linking
cd ~/.dotfiles
# init the vim submodules
git submodule update --init

mkdir ~/ipynbs
mkdir ~/.jupyter

# vim
ln -s ~/.dotfiles/vimrc ~/.vimrc
ln -s ~/.dotfiles/vim ~/.vim
# tmux
ln -s ~/.dotfiles/tmux.conf ~/.tmux.conf
ln -s ~/.dotfiles/tmux ~/.tmux
# ipython
ln -s ~/.dotfiles/ipython ~/.ipython
ln -s ~/.dotfiles/ipython/profile_nbserver/ipython_notebook_config.py ~/.jupyter/jupyter_notebook_config.py
# git
ln -s ~/.dotfiles/gitconfig ~/.gitconfig
# directory colors
ln -s ~/.dotfiles/dircolors-solarized/dircolors.ansi-universal ~/.dircolors
# promptline and tmuxline defaults
ln -s ~/.dotfiles/promptline/promptline_LuciusLight.sh ~/.dotfiles/promptline/promptline.sh
ln -s ~/.dotfiles/tmuxline/tmuxline_LuciusLight.conf ~/.dotfiles/tmuxline/tmuxline.conf

# iterm2 with my modifications
ln -s ~/.dotfiles/iterm2/iterm2_shell_integration.bash ~/.iterm2_shell_integration.bash
ln -s ~/.dotfiles/iterm2/iterm2_shell_integration.zsh ~/.iterm2_shell_integration.zsh
ln -s ~/.dotfiles/iterm2 ~/.iterm2

# bash profile
ln -s ~/.dotfiles/zshenvs/profile_gcloud ~/.profile

# link also zsh
ln -s ~/.dotfiles/zshrc ~/.zshrc
ln -s ~/.dotfiles/zshenvs/zshenv_GCLOUD ~/.zshenv
