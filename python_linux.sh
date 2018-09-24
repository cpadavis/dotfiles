# assume we have anaconda installed
# NOTE: the conda ones are probably OK already
pip3 install cython ipython numba jedi jupyter matplotlib notebook numpy pandas pep8 pyflakes pylint scikit-learn scipy sympy yaml
pip3 install easyaccess ipdb
# make treecorr
# cd ~/Projects/DES/TreeCorr; C_INCLUDE_PATH=$C_INCLUDE_PATH:~/.local/anaconda2/include LIBRARY_PATH=$LIBRARY_PATH:~/.local/anaconda2/lib LD_LIBRARY_PATH=$LD_LIBRARY_PATH:~/.local/anaconda2/lib python setup.py install; cd ~/.dotfiles
# TODO: make galsim

