#!/bin/bash

# script for pdal setup on ubuntu 18.04 from clean

sudo apt-get update
sudo apt-get upgrade

# now pdal

sudo add-apt-repository -y ppa:ubuntugis/ppa
sudo apt update
sudo apt-get install -y gdal-bin python-gdal python3-gdal pdal

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
