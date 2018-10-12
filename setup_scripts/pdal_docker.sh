#!/bin/bash

# make sure to also run gdal!

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
