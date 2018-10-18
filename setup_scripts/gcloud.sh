#!/bin/bash

# I use this with Ubuntu 16.04.5, python 3.5 images
# but I think you can also use it with 18.04.5 I think

sudo apt-get update
sudo apt-get upgrade

# get pip for python
sudo apt-get install -y python3-pip

# install setuptools
pip3 install setuptools==40.0.0

# Install Tensorflow (v1.10)
pip3 install tensorflow-gpu==1.10

# install Keras
pip3 install keras==2.2.2

# install some python packages
pip3 install cerberus click cython numba matplotlib numpy pandas scikit-image scikit-learn scipy

# setup redis which was used for kstory building deploy
sudo apt-get install -y redis-server
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

echo "Run 'descarteslabs auth login' to login"

# check cuda
cat /usr/include/cudnn.h | grep CUDNN_MAJOR -A 2
nvcc --version
