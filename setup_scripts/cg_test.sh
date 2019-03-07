#!/bin/bash

# Maintainer: Chris Davis

# test TF
echo "
import tensorflow as tf
import sys

if len(sys.argv) == 2:
    gpu_num = sys.argv[1]
elif len(sys.argv) > 2:
    raise ValueError('not sure what to do with {0}'.format(str(sys.argv)))
else:
    gpu_num = -1

print('testing cpu at /cpu:0')

with tf.device('/cpu:0'):
    a = tf.constant([1.0, 2.0, 3.0, 4.0, 5.0, 6.0], shape=[2, 3], name='a')
    b = tf.constant([1.0, 2.0, 3.0, 4.0, 5.0, 6.0], shape=[3, 2], name='b')
    c = tf.matmul(a, b)

with tf.Session() as sess:
    for i in range(200):
        if i == 0 or i == 199:
            print (sess.run(c))
        else:
            sess.run(c)

print('===== if you got here, tensorflow at least runs on a cpu')

if gpu_num == -1:
    print('skipping gpu')
    sys.exit()

print('testing gpu at /gpu:{0}'.format(gpu_num))

with tf.device('/gpu:{0}'.format(gpu_num)):
    a = tf.constant([1.0, 2.0, 3.0, 4.0, 5.0, 6.0], shape=[2, 3], name='a')
    b = tf.constant([1.0, 2.0, 3.0, 4.0, 5.0, 6.0], shape=[3, 2], name='b')
    c = tf.matmul(a, b)

with tf.Session() as sess:
    for i in range(200):
        if i == 0 or i == 199:
            print (sess.run(c))
        else:
            sess.run(c)
" >> test_tf.py

python3 test_tf.py 0

echo "Printing cuda version info"
cat /usr/include/cudnn.h | grep CUDNN_MAJOR -A 2
nvcc --version
nvidia-smi
