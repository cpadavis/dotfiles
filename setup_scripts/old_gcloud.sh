#!/bin/bash

# I use this with Ubuntu 16.04.5, python 3.5 images
# but I think you can also use it with 18.04.5 I think

apt-get update
apt-get upgrade

apt-get install -y git
# get pip and gdal for python
apt-get install -y python3-pip
apt-get install -y python3-gdal

# install setuptools
pip3 install setuptools==40.0.0

# Install Tensorflow (v1.10)
pip3 install tensorflow-gpu==1.10

# install Keras
pip3 install keras==2.2.2

# install some python packages
pip3 install cerberus click cython google-cloud numba matplotlib numpy pandas scikit-image scikit-learn scipy

# setup redis which was used for kstory building deploy
apt-get install -y redis-server
pip3 install redis

pip3 install "descarteslabs[complete]"
# make sure cloudpickle is the right version for descarteslabs
# not actually sure this will work if cloudpickle got itself installed earlier...
pip3 install cloudpickle==0.4.0

# install appsci things
cd
mkdir Projects
cd Projects
git clone https://github.com/descarteslabs/appsci_utils.git
git clone https://github.com/descarteslabs/appsci_projects.git
cd


# rustivus
# things I think you need to do to get rustivus installed.
# this is compiled from a more um free-form session
# so I don't actually know if this will work or not.
RUSTIVUS_VERSION=0.2.8

cd ~/Projects
git clone https://github.com/descarteslabs/rustivus.git

# copy binaries over
mkdir /opt/src/rustivus
cp rustivus/dalhart-festivus-all.json /opt/src/rustivus/dalhart-festivus-all.json
gsutil cp gs://dl-dev-binaries/rustivus/rustivus-v${RUSTIVUS_VERSION} /opt/src/rustivus/rustivus-v${RUSTIVUS_VERSION}
chmod a+x /opt/src/rustivus/rustivus-v${RUSTIVUS_VERSION}

# make and own /festivus
mkdir /festivus
chown ${USER}:${USER} /festivus

# make rustivus service and enable so that it runs whenever we log in
cat >/lib/systemd/system/rustivus.service <<EOL
[Unit]
Description=Rustivus service for FUSE leveraging GCS

[Service]
ExecStart=/opt/src/rustivus/rustivus-v${RUSTIVUS_VERSION} /festivus --io-threads 4 --service-account /opt/src/rustivus/dalhart-festivus-all.json
Restart=always
RestartSec=15
StandardOutput=syslog
StandardError=syslog
SyslogIdentifier=Rustivus

[Install]
WantedBy=multi-user.target
EOL

systemctl enable rustivus.service

# these are things that will make my dev experience nicer, but I don't think are necessary for running anything
# note that they overlap with the macbook setup.

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
# tmuxline default. promptline is dealt with in zshenv
ln -s ${HOME}/.dotfiles/tmuxline/tmuxline_LuciusLight.conf ${HOME}/.dotfiles/tmuxline/tmuxline.conf

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


# apt-get nice things
apt-get install -y zsh ack-grep tmux vim ctags bc htop

# pip3 install things more todo with coding rather than running
pip3 install ipdb ipython jedi jupyter notebook pep8 pyflakes pylint sympy


# enable widgets with jupyter
jupyter nbextension enable --py widgetsnbextension


# print
echo "-------------"
echo ""

# check cuda
echo "Printing cuda version info"
cat /usr/include/cudnn.h | grep CUDNN_MAJOR -A 2
nvcc --version

echo "Run 'descarteslabs auth login' to login"
echo "change shell with chsh"

echo "starting rustivus..."
/opt/src/rustivus/rustivus-v${RUSTIVUS_VERSION} /festivus --service-account /opt/src/rustivus/dalhart-festivus-all.json
