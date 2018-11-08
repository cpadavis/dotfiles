# install useful gcloud things
sudo apt-get update
sudo apt-get upgrade
sudo add-apt-repository -y ppa:ubuntugis/ppa
sudo apt update
sudo apt-get install -y python-gdal python3-gdal gdal-bin python3-dev python3-pip
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

pip3 install --user pip
pip install --user cerberus click cython google-cloud numba matplotlib pandas scikit-image scikit-learn scipy tensorboard==1.11.0 protobuf h5py coverage flake8 ipdb ipython jedi jupyter nose notebook pep8 pyflakes pylint sympy "descarteslabs[complete]" numpy==1.13.3 cloudpickle==0.4.0 keras==2.2.4 setuptools==39.1.0 pyasn1==0.4.4 tensorflow==1.11 tensorflow-gpu==1.11


if [ ! -e python.sh ]
then
    curl -O https://raw.githubusercontent.com/cpadavis/dotfiles/master/setup_scripts/test.sh
fi

echo "Log out and log back in"
echo "then run sh test.sh"
