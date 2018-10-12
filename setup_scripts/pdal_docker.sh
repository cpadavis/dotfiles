#!/bin/bash

# gets pdal setup on ubuntu 16.04. Requires setting up docker.

# make sure to also run gdal!
# I have no idea what was sufficient! if the below does not work, try the above...
sudo add-apt-repository -y ppa:ubuntugis/ppa
sudo apt update
sudo apt-get install gdal-bin python-gdal python3-gdal

# also need laszip for pdal?
sudo apt-get install cmake
sudo apt-get install zip
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

# get updated version of docker
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt-get update
apt-cache policy docker-ce
sudo apt-get install -y docker-ce
sudo systemctl status docker

# test it runs
sudo docker run hello-world

# try to fix users
sudo usermod -aG docker ${USER}

# now get pdal
sudo docker pull pdal/pdal:1.7
# when we run docker we will need to run e.g.
# sudo docker run -v /home/chris:/data pdal/pdal:1.7 pdal pipeline --nostream /data/Projects/lidar/FL_CollierCo_2007_000747_pipeline.json
# TODO: it would be superdeduper nice if, when I have to make another docker script, this pdal bit can be ingested
