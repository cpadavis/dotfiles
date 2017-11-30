# assume we have anaconda installed
# NOTE: the conda ones are probably OK already
conda install astropy cython ipython libevent jedi jupyter matplotlib notebook numpy pandas pep8 pip pyflakes pylint scikit-learn scipy scons sympy yaml
pip install easyaccess emcee fitsio healpy chainconsumer ipdb astroquery
# make treecorr
# cd ~/Projects/DES/TreeCorr; C_INCLUDE_PATH=$C_INCLUDE_PATH:~/.local/anaconda2/include LIBRARY_PATH=$LIBRARY_PATH:~/.local/anaconda2/lib LD_LIBRARY_PATH=$LD_LIBRARY_PATH:~/.local/anaconda2/lib python setup.py install; cd ~/.dotfiles
# TODO: make galsim

