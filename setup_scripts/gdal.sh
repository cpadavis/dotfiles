#!/bin/bash

# things related to gdal, and also lastools for pdal and lidar point clouds.

# get gdal
# wget http://mirrors.kernel.org/ubuntu/pool/universe/g/gdal/libgdal1h_1.10.1+dfsg-5ubuntu1_amd64.deb
# sudo dpkg -i libgdal1h_1.10.1+dfsg-5ubuntu1_amd64.deb
# sudo apt-get -f install
# sudo dpkg -i libgdal1h_1.10.1+dfsg-5ubuntu1_amd64.deb
# rm libgdal1h_1.10.1+dfsg-5ubuntu1_amd64.deb
# export CPLUS_INCLUDE_PATH=/usr/include/gdal
# export C_INCLUDE_PATH=/usr/include/gdal
# sudo apt-get install libgdal1-dev
# sudo apt-get install python-gdal
# sudo apt-get install python3-gdal

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
