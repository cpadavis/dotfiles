#!/bin/bash

# I use this with Ubuntu 16.04.5, python 3.5 images

sudo apt-get update
sudo apt-get upgrade

# https://yangcha.github.io/CUDA90/

sudo apt-get purge cuda
sudo apt-get purge libcudnn6
sudo apt-get purge libcudnn6-dev
sudo apt-get purge libcudnn7
sudo apt-get purge libcudnn7-dev
sudo apt-get purge libnccl2
sudo apt-get purge libnccl-dev

sudo apt-key adv --fetch-keys http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1604/x86_64/7fa2af80.pub

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
sudo apt-get install libcudnn7
sudo apt-get install libcudnn7-dev
sudo apt-get install libnccl2
sudo apt-get install libnccl-dev

rm cuda-repo-ubuntu1604_9.0.176-1_amd64.deb
rm libcudnn7_7.0.5.15-1+cuda9.0_amd64.deb
rm libcudnn7-dev_7.0.5.15-1+cuda9.0_amd64.deb
rm libnccl2_2.1.4-1+cuda9.0_amd64.deb
rm libnccl-dev_2.1.4-1+cuda9.0_amd64.deb

echo "restart VM to use cuda"