# install setuptools
pip3 install setuptools==40.0.0

# Install Tensorflow (v1.10)
pip3 install tensorflow-gpu==1.10

# install Keras
pip3 install keras==2.2.2

# install some python packages. I think most required ones will be installed with appsci_utils
pip3 install cerberus click cython google-cloud numba matplotlib numpy pandas scikit-image scikit-learn scipy Tensorboard
pip3 install "descarteslabs[complete]"
# make sure cloudpickle is the right version for descarteslabs
# not actually sure this will work if cloudpickle got itself installed earlier...
pip3 install cloudpickle==0.4.0



# clone dotfiles
cd ${HOME}
git clone https://github.com/cpadavis/dotfiles.git .dotfiles

# do linking
cd ${HOME}/.dotfiles
# init the vim submodules
git submodule update --init

mkdir ${HOME}/ipynbs
mkdir ${HOME}/.jupyter

# vim
ln -s ${HOME}/.dotfiles/vimrc ${HOME}/.vimrc
ln -s ${HOME}/.dotfiles/vim ${HOME}/.vim
# tmux
ln -s ${HOME}/.dotfiles/tmux.conf ${HOME}/.tmux.conf
ln -s ${HOME}/.dotfiles/tmux ${HOME}/.tmux
# ipython
ln -s ${HOME}/.dotfiles/ipython ${HOME}/.ipython
ln -s ${HOME}/.dotfiles/ipython/profile_nbserver/ipython_notebook_config.py ${HOME}/.jupyter/jupyter_notebook_config.py
# git
ln -s ${HOME}/.dotfiles/gitconfig ${HOME}/.gitconfig
# directory colors
ln -s ${HOME}/.dotfiles/dircolors-solarized/dircolors.ansi-universal ${HOME}/.dircolors
# tmuxline default. promptline is dealt with in zshenv
ln -s ${HOME}/.dotfiles/tmuxline/tmuxline_LuciusLight.conf ${HOME}/.dotfiles/tmuxline/tmuxline.conf

# iterm2 with my modifications
ln -s ${HOME}/.dotfiles/iterm2/iterm2_shell_integration.bash ${HOME}/.iterm2_shell_integration.bash
ln -s ${HOME}/.dotfiles/iterm2/iterm2_shell_integration.zsh ${HOME}/.iterm2_shell_integration.zsh
ln -s ${HOME}/.dotfiles/iterm2 ${HOME}/.iterm2

# bash profile
mv ${HOME}/.profile ${HOME}/.profile.bak
ln -s ${HOME}/.dotfiles/zshenvs/profile_gcloud ${HOME}/.profile

# link also zsh
ln -s ${HOME}/.dotfiles/zshrc ${HOME}/.zshrc
ln -s ${HOME}/.dotfiles/zshenvs/zshenv_GCLOUD ${HOME}/.zshenv

# pip3 install things more todo with coding rather than running
pip3 install flake8 ipdb ipython jedi jupyter notebook pep8 pyflakes pylint sympy


# enable widgets with jupyter
jupyter nbextension enable --py widgetsnbextension


# print
echo "-------------"
echo ""

# check cuda
echo "Printing cuda version info"
cat /usr/include/cudnn.h | grep CUDNN_MAJOR -A 2
nvcc --version

echo "Run 'descarteslabs auth login' to login"
echo "change shell with chsh"

echo "you might need to restart to get everything to work :( sorry"


cd ${HOME}/Projects
git clone https://github.com/descarteslabs/appsci_utils.git
cd ${HOME}/Projects/appsci_utils
pip3 install .
git clone https://github.com/descarteslabs/appsci_projects.git
cd ${HOME}
