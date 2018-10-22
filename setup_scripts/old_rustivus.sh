#!/bin/bash

# things I think you need to do to get rustivus installed.
# this is compiled from a more um free-form session
# so I don't actually know if this will work or not.
RUSTIVUS_VERSION=0.2.8

cd ~/Projects
git clone https://github.com/descarteslabs/rustivus.git

# copy binaries over
sudo mkdir /opt/src/rustivus
sudo cp rustivus/dalhart-festivus-all.json /opt/src/rustivus/dalhart-festivus-all.json
sudo gsutil cp gs://dl-dev-binaries/rustivus/rustivus-v${RUSTIVUS_VERSION} /opt/src/rustivus/rustivus-v${RUSTIVUS_VERSION}
sudo chmod a+x /opt/src/rustivus/rustivus-v${RUSTIVUS_VERSION}

# make and own /festivus
sudo mkdir /festivus
sudo chown ${USER}:${USER} /festivus

# make rustivus service and enable so that it runs whenever we log in
sudo cat >/lib/systemd/system/rustivus.service <<EOL
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

sudo systemctl enable rustivus.service

sudo /opt/src/rustivus/rustivus-v${RUSTIVUS_VERSION} /festivus --service-account /opt/src/rustivus/dalhart-festivus-all.json
