#!/bin/bash

# Maintainer: Chris Davis

# I use this with Ubuntu 16.04.5, python 3.5 images
sudo apt-get update -y
sudo apt-get upgrade -y
sudo add-apt-repository -y ppa:ubuntugis/ppa
sudo apt update -y
sudo apt-get upgrade -y

# https://yangcha.github.io/CUDA90/

sudo apt-get -y purge cuda
sudo apt-get -y purge libcudnn6
sudo apt-get -y purge libcudnn6-dev
sudo apt-get -y purge libcudnn7
sudo apt-get -y purge libcudnn7-dev
sudo apt-get -y purge libnccl2
sudo apt-get -y purge libnccl-dev

sudo apt-key adv --fetch-keys http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1604/x86_64/7fa2af80.pub

wget http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1604/x86_64/cuda-repo-ubuntu1604_9.0.176-1_amd64.deb
wget http://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu1604/x86_64/libcudnn7_7.2.1.38-1+cuda9.0_amd64.deb
wget http://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu1604/x86_64/libcudnn7-dev_7.2.1.38-1+cuda9.0_amd64.deb
wget http://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu1604/x86_64/libnccl2_2.1.4-1+cuda9.0_amd64.deb
wget http://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu1604/x86_64/libnccl-dev_2.1.4-1+cuda9.0_amd64.deb
sudo dpkg -i cuda-repo-ubuntu1604_9.0.176-1_amd64.deb
sudo dpkg -i libcudnn7_7.2.1.38-1+cuda9.0_amd64.deb
sudo dpkg -i libcudnn7-dev_7.2.1.38-1+cuda9.0_amd64.deb
sudo dpkg -i libnccl2_2.1.4-1+cuda9.0_amd64.deb
sudo dpkg -i libnccl-dev_2.1.4-1+cuda9.0_amd64.deb

sudo apt-get -y update

sudo apt-get -y install cuda=9.0.176-1
sudo apt-get -y install libcudnn7
sudo apt-get -y install libcudnn7-dev
sudo apt-get -y install libnccl2
sudo apt-get -y install libnccl-dev

# append profile info
echo "export PATH=/usr/local/cuda-9.0/bin\${PATH:+:\${PATH}}" >> ~/.profile
echo "export LD_LIBRARY_PATH=/usr/local/cuda-9.0/lib64\${LD_LIBRARY_PATH:+:\${LD_LIBRARY_PATH}}" >> ~/.profile

export GPU=True
