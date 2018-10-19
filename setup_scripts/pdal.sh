#!/bin/bash

# script for pdal setup on ubuntu 18.04 from clean

sudo apt-get update
sudo apt-get upgrade
sudo apt-get install -y python3-pip

# install setuptools
pip3 install setuptools==40.0.0

# install some python packages
pip3 install click cython numba matplotlib numpy pandas scikit-image scikit-learn scipy


pip3 install "descarteslabs[complete]"
# make sure cloudpickle is the right version for descarteslabs
# not actually sure this will work if cloudpickle got itself installed earlier...
pip3 install cloudpickle==0.4.0

echo "Run 'descarteslabs auth login' to login"

# now gdal

sudo add-apt-repository -y ppa:ubuntugis/ppa
sudo apt update
sudo apt-get install -y gdal-bin python-gdal python3-gdal

# also need laszip for pdal?
sudo apt-get install -y cmake zip
git clone https://github.com/LASzip/LASzip.git
cd LASzip
git checkout 3.1.0
cmake .
make
sudo make install
cd ..  # back to dir containing laszip
wget http://lastools.org/download/LAStools.zip
unzip LAStools.zip
cd LAStools
make
sudo cp bin/laszip /usr/local/bin
sudo ln -s /usr/local/bin/laszip /usr/local/bin/laszip-cli
cd ..  # back to directory containing lastools
rm LAStools.zip
rm -rf LASzip
rm -rf LAStools
pip3 install laspy

# and pdal
sudo apt-get install -y pdal

# clone the lidar repo
git clone https://github.com/descarteslabs/lidar.git
cd lidar
git checkout deploy_cpd
cd ..
