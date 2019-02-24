#!/bin/bash

# annoyance: you have to use python3 and pip3 for everything
# Maintainer: Chris Davis

# install useful gcloud things
export DEBIAN_FRONTEND=noninteractive
export C_INCLUDE_PATH="/usr/include/gdal:$C_INCLUDE_PATH"
export CPLUS_INCLUDE_PATH="/usr/include/gdal:$CPLUS_INCLUDE_PATH"

sudo mkdir -p /opt/src
cd /opt/src

sudo apt-get update -y
sudo apt-get upgrade -y
sudo apt-add-repository -y ppa:ubuntugis/ppa
sudo apt-get update -y
sudo apt-get upgrade -y
# we're a civilized people, so we use tmux and vim
sudo apt-get install -y zsh ack-grep tmux vim ctags bc htop python3 python3-dev python3-gdbm gdal-bin libgdal-dev libgeos-dev gfortran python3-tk python-tk libfftw3-double3 libfftw3-single3 libfftw3-long3 libfftw3-dev libproj-dev unzip gcc python-setuptools python-pip python-dev python3-pip python3-setuptools build-essential libssl-dev python-openssl apt-transport-https ca-certificates software-properties-common
# sudo apt-get install -y pdal

# pip3 install pip==9.0.3

# on 18.04 systems, gsutil is located at /snap/bin , so add that to path
export PATH="$PATH:/snap/bin"

echo "Installing Rustivus"
cd $HOME
gsutil cp gs://dl-dev-binaries/rustivus/rustivus-v0.2.8 $HOME/.
sudo mkdir -p /opt/src/rustivus/
chmod a+x rustivus-v0.2.8
sudo mv rustivus-v0.2.8 /opt/src/rustivus/.

# done in next step
git clone https://github.com/descarteslabs/rustivus.git
sudo cp rustivus/dalhart-festivus-all.json /opt/src/rustivus/.

echo "[Unit]
Description=Rustivus service for FUSE leveraging GCS

[Service]
ExecStart=/opt/src/rustivus/rustivus-v0.2.8 /festivus --io-threads 4 --service-account /opt/src/rustivus/dalhart-festivus-all.json
Restart=always
RestartSec=15
StandardOutput=syslog
StandardError=syslog
SyslogIdentifier=Rustivus

[Install]
WantedBy=multi-user.target" >> tmp.service
sudo cp tmp.service /lib/systemd/system/rustivus.service
sudo chmod u+x /lib/systemd/system/rustivus.service
rm tmp.service

# stop festivus if it is already running
# sudo systemctl stop festivus
# sudo systemctl disable festivus.service
# sudo systemctl stop rustivus
# sudo systemctl disable rustivus.service
sudo systemctl daemon-reload
sudo systemctl enable rustivus.service

sudo systemctl start rustivus

sudo mkdir /festivus

if [ "$GPU" ]; then
    echo "installing gpu"
    pip3 install cerberus click cython futures google-cloud numba matplotlib pandas scikit-image scikit-learn scipy tensorboard protobuf h5py coverage flake8 ipdb ipython jedi jupyter nose notebook pep8 pyflakes pylint sympy "descarteslabs[complete]" numpy cloudpickle==0.4.0 keras setuptools==39.1.0 pyasn1==0.4.4 tensorflow-gpu

else
    echo "installing non-gpu"
    pip3 install cerberus click cython futures google-cloud numba matplotlib pandas scikit-image scikit-learn scipy tensorboard protobuf h5py coverage flake8 ipdb ipython jedi jupyter nose notebook pep8 pyflakes pylint sympy "descarteslabs[complete]" numpy cloudpickle==0.4.0 keras setuptools==39.1.0 pyasn1==0.4.4 tensorflow
fi

# install gdal
# https://stackoverflow.com/questions/51934231/gdal-virtualenv-python-3-6-installation
pip3 install --global-option=build_ext --global-option="-I/usr/include/gdal" GDAL==`gdal-config --version`
