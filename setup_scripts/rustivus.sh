#!/bin/bash

# things I think you need to do to get rustivus installed.
# this is compiled from a more um free-form session
# so I don't actually know if this will work or not.
VERSION=0.2.8

git clone https://github.com/descarteslabs/rustivus.git

# copy binaries over
sudo mkdir /opt/src/rustivus
sudo cp rustivus/dalhart-festivus-all.json /opt/src/rustivus/dalhart-festivus-all.json
sudo gsutil cp gs://dl-dev-binaries/rustivus/rustivus-v${VERSION} /opt/src/rustivus/rustivus-v${VERSION}
chmod a+x /opt/src/rustivus/rustivus-v${VERSION}

# make and own /festivus
sudo mkdir /festivus
sudo chown ${USER}:${USER} /festivus
/opt/src/rustivus/rustivus-v${VERSION} /festivus --service-account /opt/src/rustivus/dalhart-festivus-all.json

# make rustivus service and enable so that it runs whenever we log in
sudo cat >/lib/systemd/system/rustivus.service <<EOL
[Unit]
Description=Rustivus service for FUSE leveraging GCS

[Service]
ExecStart=/opt/src/rustivus/rustivus-v${VERSION} /festivus --io-threads 4 --service-account /opt/src/rustivus/dalhart-festivus-all.json
Restart=always
RestartSec=15
StandardOutput=syslog
StandardError=syslog
SyslogIdentifier=Rustivus

[Install]
WantedBy=multi-user.target
EOL

sudo systemctl enable rustivus.service
