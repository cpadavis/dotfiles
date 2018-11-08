# install useful gcloud things
sudo apt-get update
sudo apt-get upgrade
sudo add-apt-repository -y ppa:ubuntugis/ppa
sudo apt update
sudo apt-get install -y python-gdal python3-gdal gdal-bin python3-pip
sudo apt-get install -y zsh ack-grep tmux vim ctags bc htop


echo "Rustivus"
cd $HOME
gsutil cp gs://dl-dev-binaries/rustivus/rustivus-v0.2.8 $HOME/.
sudo mkdir /opt/src/
sudo mkdir /opt/src/rustivus/ # will print error if file already exists
chmod a+x ./rustivus-v0.2.8
sudo mv rustivus-v0.2.8 /opt/src/rustivus/.
# Make rustivus start automatically
git clone https://github.com/descarteslabs/rustivus.git
sudo cp rustivus/dalhart-festivus-all.json /opt/src/rustivus/.

echo "[Unit]
Description=Rustivus service for FUSE leveraging GCS

[Service]
ExecStart=/opt/src/rustivus/rustivus-v0.2.8 /rustivus --io-threads 4 --service-account /opt/src/rustivus/dalhart-festivus-all.json
Restart=always
RestartSec=15
StandardOutput=syslog
StandardError=syslog
SyslogIdentifier=Rustivus

[Install]
WantedBy=multi-user.target" >> tmp.service
sudo cp tmp.service /lib/systemd/system/rustivus.service
sudo chmod u+x /lib/systemd/system/rustivus.service
rm tmp.service

sudo systemctl stop festivus
sudo systemctl disable festivus.service
sudo systemctl stop rustivus
sudo systemctl disable rustivus.service
sudo systemctl daemon-reload
sudo systemctl enable rustivus.service

sudo systemctl start rustivus

sudo mkdir /rustivus
# sudo /opt/src/rustivus/rustivus-v0.2.8 /rustivus --io-threads 4 --service-account /opt/src/rustivus/dalhart-festivus-all.json

if [ ! -e python.sh ]
then
    wget https://raw.githubusercontent.com/cpadavis/dotfiles/master/setup_scripts/python.sh
fi


# echo "Testing rustivus ls"
# ls /rustivus/dl-kstory/buildings/models/buildings_usa_airbus_20171101.hdf5
echo "Log out and log back in"
echo "then try executing this line"
echo "ls /rustivus/dl-kstory/buildings/models/buildings_usa_airbus_20171101.hdf5"
echo "then run `sh python.sh`"
## log out of this VM, log back in, and the following should (still) work:
## ls /rustivus/dl-kstory/buildings/models/buildings_usa_airbus_20171101.hdf5
