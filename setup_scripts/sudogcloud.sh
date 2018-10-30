#!/bin/bash

# I use this with Ubuntu 16.04.5, python 3.5 images
# but I think you can also use it with 18.04.5 I think
# TODO I had to mess with a bunch of chmod stuff. find . -type d -exec chmod 755 {} + I think 755 is what i want for drwxr-xr-x

apt-get update
apt-get upgrade
add-apt-repository -y ppa:ubuntugis/ppa
apt update

apt-get install -y git
# get pip and gdal for python
apt-get install -y python-gdal python3-gdal gdal-bin pdal python3-pip

apt-get install -y zsh ack-grep tmux vim ctags bc htop

# rustivus
# things I think you need to do to get rustivus installed.
# this is compiled from a more um free-form session
# so I don't actually know if this will work or not.
RUSTIVUS_VERSION=0.2.8

mkdir ${HOME}/Projects
chmod a+xr ${HOME}/Projects
chown ${USER}:${USER} ${HOME}/Projects

cd ${HOME}/Projects
git clone https://github.com/descarteslabs/rustivus.git
chmod a+xwr rustivus

# copy binaries over
mkdir /opt/
chmod a+xwr /opt/
mkdir /opt/src/
chmod a+xwr /opt/src/
mkdir /opt/src/rustivus
chmod a+xwr /opt/src/rustivus
cp ${HOME}/Projects/rustivus/dalhart-festivus-all.json /opt/src/rustivus/dalhart-festivus-all.json
gsutil cp gs://dl-dev-binaries/rustivus/rustivus-v${RUSTIVUS_VERSION} /opt/src/rustivus/rustivus-v${RUSTIVUS_VERSION}
chmod a+xwr /opt/src/rustivus/rustivus-v${RUSTIVUS_VERSION}

# make and own /festivus
mkdir /festivus
chown ${USER}:${USER} /festivus
chmod a+xwr /festivus

# make rustivus service and enable so that it runs whenever we log in
cat >/lib/systemd/system/rustivus.service <<EOL
[Unit]
Description=Rustivus service for FUSE leveraging GCS

[Service]
ExecStart=/opt/src/rustivus/rustivus-v${RUSTIVUS_VERSION} /festivus --io-threads 4 --service-account /opt/src/rustivus/dalhart-festivus-all.json
Restart=always
RestartSec=15
StandardOutput=syslog
StandardError=syslog
SyslogIdentifier=Rustivus

[Install]
WantedBy=multi-user.target
EOL

chmod a+xwr /lib/systemd/system/rustivus.service

systemctl enable rustivus.service

echo "starting rustivus..."
/opt/src/rustivus/rustivus-v${RUSTIVUS_VERSION} /festivus --service-account /opt/src/rustivus/dalhart-festivus-all.json &

