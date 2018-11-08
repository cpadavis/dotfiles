# test TF
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

print('===== if you got here, tensorflow at least runs on a cpu')

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
while true; do
    read -p "Is this node a GPU? " yn
    case $yn in
        [Yy]* ) pip uninstall tensorflow tensorflow-gpu; pip install --user tensorflow-gpu==1.11; break;;
        [Nn]* ) break;;
        * ) echo "Please answer y or n.";;
    esac
done
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
