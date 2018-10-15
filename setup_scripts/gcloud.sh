#!/bin/bash

# I use this with Ubuntu 16.04.5, python 3.5 images

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

# add cuda to path. Also should add this to your .profile or other environment file if you log in
export PATH=/usr/local/cuda-9.0/bin${PATH:+:${PATH}}
export LD_LIBRARY_PATH=/usr/local/cuda-9.0/lib64${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}

# install Keras
pip3 install keras==2.2.2

# install some python packages
pip3 install click cython numba matplotlib numpy pandas scikit-image scikit-learn scipy

# setup redis which was used for kstory building deploy
sudo apt-get install redis-server
pip3 install redis


pip3 install "descarteslabs[complete]"
# make sure cloudpickle is the right version for descarteslabs
# not actually sure this will work if cloudpickle got itself installed earlier...
pip3 install cloudpickle==0.4.0

echo "Run 'descarteslabs auth login' to login"
# export DESCARTESLABS_CLIENT_ID=...
# export DESCARTESLABS_CLIENT_SECRET=...
