#!/bin/bash

sudo add-apt-repository ppa:graphics-drivers/ppa
sudo apt update
sudo apt-get -y install ubuntu-drivers-common
sudo ubuntu-drivers autoinstall

export CPLUS_INCLUDE_PATH="/usr/include/gdal:$CPLUS_INCLUDE_PATH"
export C_INCLUDE_PATH="/usr/include/gdal:$C_INCLUDE_PATH"

sudo apt install nvidia-cuda-toolkit gcc-6

sudo apt-get update -y
sudo apt-get install -y --no-install-recommends unzip gcc python-setuptools python3-pip build-essential libssl-dev python3-dev python-openssl apt-transport-https ca-certificates software-properties-common
sudo apt-add-repository ppa:ubuntugis/ubuntugis-unstable
sudo apt-get update -y
sudo apt-get install -y --no-install-recommends python3.6 python3.6-dev gdal-bin libgdal-dev python3-gdal python-gdal libgeos-dev gfortran python-tk libfftw3-double3 libfftw3-single3 libfftw3-long3 libfftw3-dev libproj-dev
sudo apt-get install -y --no-install-recommends ack-grep zsh tmux vim ctags bc htop

sudo apt-get install -y build-essential cmake git wget unzip yasm pkg-config libswscale-dev libtbb2 libtbb-dev libjpeg-dev libpng-dev libtiff-dev libavformat-dev libpq-dev

pip3 install setuptools
pip3 install wheel
pip3 install --user Cython google-cloud numba matplotlib pandas scikit-image scikit-learn scipy flake8 coverage h5py protobuf ipython ipdb jedi jupyter nose notebook pep8 pyflakes pylint "descarteslabs[complete]" opencv-python opencv-contrib-python
pip3 install --user tensorflow-gpu

mkdir Projects
cd Projects
git clone https://github.com/descarteslabs/appsci_utils.git
pip3 install --user ~/Projects/appsci_utils
git clone https://github.com/descarteslabs/appsci_projects.git
