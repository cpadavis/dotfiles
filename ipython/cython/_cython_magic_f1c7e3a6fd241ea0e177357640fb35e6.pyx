#!/usr/bin/env python
"""
File: correlation.py
Author: Chris Davis
Description: Code to calculate correlation functions.

TODO: cythonize
TODO: test on CMB cl codes...
"""

from __future__ import print_function, division
import numpy as np
cimport numpy as np
import cython
from cython cimport parallel

DTYPE = np.float
ctypedef np.float_t DTYPE_t

# auto correlation
@cython.boundscheck(False)
@cython.wraparound(False)
def auto_correlation(
    np.ndarray[DTYPE_t, ndim=2] x,
    np.ndarray[DTYPE_t, ndim=1] w,
    float max_r=1,
    int bin_number=10,
    int num_threads=20):
    """
    Calculate autocorrelation weighted w up to radius max_r

    Parameters
    ----------
    x : n x d array
        x[i] returns d dimensional array of locations

    w : n array
        w[i] is the weight of the ith point
        e.g. x[:, 0][:, None] to weight by value of 0th dim of x

    max_r : float
        What is the maximum radius to which we construct the function?

        TODO: If max_r < 0, then becomes the size of each bin

    bin_number : int
        Number of bins used for h

    Returns
    -------
    h : array
        Array of correlation function

    """
    cdef int ii, jj, kk, ith, binmid
    cdef float prod

    cdef int numpair = x.shape[0]
    cdef int numdim = x.shape[1]

    cdef np.ndarray[DTYPE_t, ndim=1] h = np.zeros(bin_number, dtype=DTYPE)
    cdef np.ndarray[DTYPE_t, ndim=1] N = np.zeros(bin_number, dtype=DTYPE)
    cdef float inv_max_r = 1. / max_r

    with nogil, cython.boundscheck(False), cython.wraparound(False):
        for ii in parallel.prange(numpair-1, schedule='static',
                num_threads=num_threads):
            for jj in xrange(ii + 1, numpair):

                prod = sum([x[ii][kk] * x[jj][kk] for kk in xrange(numdim)])
                #prod = np.dot(x[ii], x[jj])

                if prod < max_r:
                    binmid = <int> (prod * inv_max_r)
                    ith = (bin_number * binmid)

                    if (ith < 0):
                        raise ValueError("ith should be >= 0!")
                    if (ith < bin_number):
                        h[ith] += w[ii] * w[jj]
                        N[ith] += 1
                        
    for ith in xrange(0, bin_number):
        h[ith] /= N[ith]

    return h

# cross correlation
def cross_correlation(
    np.ndarray[DTYPE_t, ndim=2] x1,
    np.ndarray[DTYPE_t, ndim=1] w1,
    np.ndarray[DTYPE_t, ndim=2] x2,
    np.ndarray[DTYPE_t, ndim=1] w2,
    float max_r=1,
    int bin_number=10,
    int num_threads=20):
    """
    Calculate autocorrelation weighted w up to radius max_r

    Parameters
    ----------
    x1, x2 : n x d array
        x[i] returns d dimensional array of locations

    w1, w2 : n array
        w[i] is the weight of the ith point
        e.g. x[:, 0][:, None] to weight by value of 0th dim of x

    max_r : float
        What is the maximum radius to which we construct the function?

        TODO: If max_r < 0, then becomes the size of each bin

    bin_number : int
        Number of bins used for h

    Returns
    -------
    h : array
        Array of correlation function

    """
    cdef int ii, jj, kk, ith, binmid
    cdef float prod = 0

    cdef int numpair1 = x1.shape[0]
    cdef int numpair2 = x2.shape[0]
    cdef int numdim = x1.shape[1]

    cdef np.ndarray[DTYPE_t, ndim=1] h = np.zeros(bin_number, dtype=DTYPE)
    cdef np.ndarray[DTYPE_t, ndim=1] N = np.zeros(bin_number, dtype=DTYPE)
    cdef float inv_max_r = 1. / max_r

    with nogil, cython.boundscheck(False), cython.wraparound(False):
        for ii in parallel.prange(0, numpair1, schedule='static',
                num_threads=num_threads):
            for jj in xrange(0, numpair2):
                prod = 0.
                for kk in xrange(numdim):
                    prod = prod + x1[ii][kk] * x2[jj][kk]
                #prod = np.dot(x1[ii], x2[jj])

                if prod < max_r:
                    binmid = <int> (prod * inv_max_r)
                    ith = (bin_number * binmid)

                    if (ith < 0):
                        raise ValueError("ith should be >= 0!")
                    if (ith < bin_number):
                        h[ith] += w1[ii] * w2[jj]
                        N[ith] += 1
                        
    for ith in xrange(0, bin_number):
        h[ith] /= N[ith]

    return h
