#!/bin/bash

# I use this with Ubuntu 16.04.5, python 3.5 images

sudo apt-get update
sudo apt-get upgrade

# killllll old cuda andn such
sudo apt-get purge cuda
sudo apt-get purge libcudnn6
sudo apt-get purge libcudnn6-dev
sudo apt-get purge libcudnn7
sudo apt-get purge libcudnn7-dev

# install CUDA toolkit 9.0 and CuDNN 7.2.1
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
sudo apt-get update
sudo apt-get install -y cuda=9.0.176-1
sudo apt-get install -y libcudnn7-dev
sudo apt-get install -y libnccl-dev

# add cuda to path. Also should add this to your .profile or other environment file if you log in
export PATH=/usr/local/cuda-9.0/bin${PATH:+:${PATH}}
export LD_LIBRARY_PATH=/usr/local/cuda-9.0/lib64${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}

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

# Check cuDNN version
cat /usr/include/cudnn.h | grep CUDNN_MAJOR -A 2

# Check Cuda version
nvcc --version
