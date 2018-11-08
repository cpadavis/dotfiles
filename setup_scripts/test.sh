# # install setuptools
# pip3 install setuptools==40.0.0

# install some python packages. I think most required ones will be installed with appsci_utils
# make sure cloudpickle is the right version for descarteslabs
# not actually sure this will work if cloudpickle got itself installed earlier...


# through um MAGIC we make pip3 be the old system pip3 and pip a python3 pip. It's really great, guys. Really. Magically, it breaks pip3.
# note that you still need to say python3 for everything. That can probably be resolved by putting a ln in ~/.local/bin
# pip3 install --user pip

# # all the packages I'm installing below seem overkill, but I haven't yet figured out which will get included in the appsci_utils pip install, and which other useful ones are not...
# while true; do
#     read -p "Is this node a GPU? " yn
#     case $yn in
#         [Yy]* ) pip install --user cerberus click cython google-cloud numba matplotlib pandas scikit-image scikit-learn scipy tensorboard==1.11.0 protobuf h5py coverage flake8 ipdb ipython jedi jupyter nose notebook pep8 pyflakes pylint sympy "descarteslabs[complete]" numpy==1.13.3 cloudpickle==0.4.0 keras==2.2.4 setuptools==39.1.0 pyasn1==0.4.4 tensorflow-gpu==1.11; break;;
#         [Nn]* ) pip install --user cerberus click cython google-cloud numba matplotlib pandas scikit-image scikit-learn scipy tensorboard==1.11.0 protobuf h5py coverage flake8 ipdb ipython jedi jupyter nose notebook pep8 pyflakes pylint sympy "descarteslabs[complete]" numpy==1.13.3 cloudpickle==0.4.0 keras==2.2.4 setuptools==39.1.0 pyasn1==0.4.4 tensorflow==1.11; break;;
#         * ) echo "Please answer y or n.";;
#     esac
# done


# and test TF
echo "#!/usr/bin/python3
import tensorflow as tf
import sys

if len(sys.argv) == 2:
    gpu_num = sys.argv[1]
elif len(sys.argv) > 2:
    raise ValueError('not sure what to do with {0}'.format(str(sys.argv)))
else:
    gpu_num = 0

print('testing cpu at /cpu:0')

with tf.device('/cpu:0'):
    a = tf.constant([1.0, 2.0, 3.0, 4.0, 5.0, 6.0], shape=[2, 3], name='a')
    b = tf.constant([1.0, 2.0, 3.0, 4.0, 5.0, 6.0], shape=[3, 2], name='b')
    c = tf.matmul(a, b)

with tf.Session() as sess:
    for i in range(200):
        if i == 0 or i == 199:
            print (sess.run(c))

print('if you got here, tensorflow at least runs on a cpu')

print('testing gpu at /gpu:{0}'.format(gpu_num))

with tf.device('/gpu:{0}'.format(gpu_num)):
    a = tf.constant([1.0, 2.0, 3.0, 4.0, 5.0, 6.0], shape=[2, 3], name='a')
    b = tf.constant([1.0, 2.0, 3.0, 4.0, 5.0, 6.0], shape=[3, 2], name='b')
    c = tf.matmul(a, b)

with tf.Session() as sess:
    for i in range(200):
        if i == 0 or i == 199:
            print (sess.run(c))" >> test_tf
echo "Testing tensorflow gpu connection"
python3 test_tf

echo "Printing cuda version info"
cat /usr/include/cudnn.h | grep CUDNN_MAJOR -A 2
nvcc --version

nvidia-smi

echo "Testing rustivus ls"
ls /rustivus/dl-kstory/buildings/models/buildings_usa_airbus_20171101.hdf5

git clone https://github.com/descarteslabs/appsci_utils.git

cd appsci_utils
pip install --user -r requirements.txt
pip install --user .
echo "Testing flake8"
flake8
echo "Running unit tests"
python3 -m "nose" --with-coverage --cover-package=appsci_utils
cd $HOME

echo "testing gpu again"
python3 test_tf

echo "Printing cuda version info"
cat /usr/include/cudnn.h | grep CUDNN_MAJOR -A 2
nvcc --version

nvidia-smi

echo "Run 'descarteslabs auth login' to login"
echo "Run niceties.sh if you would like some niceties"
