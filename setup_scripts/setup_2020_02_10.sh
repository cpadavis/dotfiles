#!/bin/bash
# setup for new vms

# apt-get useful things
apt-add-repository ppa:ubuntugis/ubuntugis-unstable \
 && apt-add-repository ppa:deadsnakes/ppa \
 && apt-get update -y \
 && xargs -a ./packages_2020_02_10.txt apt install -y --no-install-recommends

# install docker-ce
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add - \
 && add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" \
 && apt-get update -y \
 && apt-get install -y docker-ce docker-ce-cli containerd.io


# get rustivus executable
gsutil cp gs://dl-dev-binaries/rustivus/rustivus-v0.2.8 $HOME/.
sudo mkdir /opt/src/
sudo mkdir /opt/src/rustivus/
chmod a+x $HOME/rustivus-v0.2.8
sudo mv $HOME/rustivus-v0.2.8 /opt/src/rustivus/.
# Make rustivus start automatically
git clone https://github.com/descarteslabs/rustivus.git
sudo cp rustivus/dalhart-festivus-all.json /opt/src/rustivus/.
# /opt/src/rustivus/rustivus-v0.2.8 /festivus --service-account /opt/src/rustivus/dalhart-festivus-all.json

# get miniconda
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh \
    && mkdir $HOME/.conda \
    && bash Miniconda3-latest-Linux-x86_64.sh -b \
    && rm -f Miniconda3-latest-Linux-x86_64.sh

# create environment
conda create --name py37 --file py37_2020_02_10.txt
conda activate py37  # TODO: set this as default environment in sh

pip uninstall -y enum34 || true

# setup local dotfiles stuff
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
ln -s ${HOME}/.dotfiles/zshenvs/profile_gcloud ${HOME}/.profile

# link also zsh
ln -s ${HOME}/.dotfiles/zshrc ${HOME}/.zshrc
ln -s ${HOME}/.dotfiles/zshenvs/zshenv_GCLOUD ${HOME}/.zshenv


# enable widgets with jupyter
jupyter labextension install jupyter-leaflet @jupyter-widgets/jupyterlab-manager


echo "change shell with chsh"


# potentially set up cudanow?
