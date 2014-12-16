#!/usr/bin/env python
# correlation_calc.py
from __future__ import print_function, division
import numpy as np
cimport numpy as np
import cython
from cython cimport parallel

cdef extern from "math.h":
    float sin(float x) nogil
    float cos(float x) nogil
    float sqrt(float x) nogil
    float log10(float x) nogil
    float acos(float x) nogil

DTYPE = np.float
ctypedef np.float_t DTYPE_t

DTYPE_hh = np.int
ctypedef np.int_t DTYPE_hh_t

cdef inline float float_min(float a) nogil : return a if a <= 1 else 1

PI180 = np.pi / 180
PI = np.pi

'''
pyx functions which we can use to do the clustering and legendre polynomial stuffs
'''

@cython.boundscheck(False)
@cython.wraparound(False)
def auto_ang_correlate_cython(
        np.ndarray[DTYPE_t, ndim=1] RA, np.ndarray[DTYPE_t, ndim=1] DEC,
        float max_theta=0.7, int bin_number=100,
        int n_logint=10, int logbin=0, int true_acos=0,
        int num_threads=20):

    '''
    n_logint = number of bins per decade if logbinning
    '''
    cdef int numpair = RA.size

    cdef int ii, jj, ith
    cdef np.ndarray[DTYPE_t, ndim=1] x = np.zeros(numpair, dtype=DTYPE)
    for ii in xrange(0, numpair):
        x[ii] = sqrt(1 - cos(PI / 2 - DEC[ii] * PI180)**2) * \
                cos(RA[ii] * PI180)
    cdef np.ndarray[DTYPE_t, ndim=1] y = np.zeros(numpair, dtype=DTYPE)
    for ii in xrange(0, numpair):
        y[ii] = sqrt(1 - cos(PI / 2 - DEC[ii] * PI180)**2) * \
                sin(RA[ii] * PI180)

    cdef np.ndarray[DTYPE_t, ndim=1] z = np.zeros(numpair, dtype=DTYPE)
    for ii in xrange(0, numpair):
        z[ii] = cos(PI / 2 - DEC[ii] * PI180)


    cdef np.ndarray[DTYPE_hh_t, ndim=1] hh = np.zeros(bin_number, dtype=DTYPE_hh)
    cdef float prod

    cdef float I_max_theta = 1. / max_theta

    cdef float min_prod = cos(max_theta)

    with nogil, cython.boundscheck(False), cython.wraparound(False):
        for ii in parallel.prange(numpair-1, schedule='static',
                num_threads=num_threads):
            for jj in xrange(ii+1, numpair):
                prod = x[ii] * x[jj] + y[ii] * y[jj] + z[ii] * z[jj]

                prod = float_min(prod)
                if prod > min_prod:
                    if logbin:
                        if prod != 1:
                            if true_acos:
                                prod = log10(acos(prod))
                            else:
                                prod = 1 - prod
                                prod = 0.5 * \
                                        log10(2 * prod +
                                                0.33333333333 * prod * prod +
                                                0.088888888889 * prod * prod * prod)
                            ith = <int> ( n_logint * (prod - log10(max_theta)) + \
                                    bin_number )
                        else:
                            '''
                            old code said bin_number - 1; I think it should be 0,
                            since acos(1) = 0 -> right on top of each other
                            '''
                            ith = 0  #bin_number - 1  # why?
                    else:
                        if true_acos:
                            prod = acos(prod)
                        else:
                            prod = 1 - prod
                            prod = sqrt(2 * prod + 0.333333333 * prod * prod +
                                    0.0888889 * prod * prod * prod)
                        ith = <int> ( bin_number * prod * I_max_theta)

                    if (ith >= 0) * (ith < bin_number):
                        hh[ith] += 1

    return hh

@cython.boundscheck(False)
@cython.wraparound(False)
def cross_ang_correlate_cython(
        np.ndarray[DTYPE_t, ndim=1] RA1, np.ndarray[DTYPE_t, ndim=1] DEC1,
        np.ndarray[DTYPE_t, ndim=1] RA2, np.ndarray[DTYPE_t, ndim=1] DEC2,
        float max_theta=0.7, int bin_number=100,
        int n_logint=10, int logbin=0, int true_acos=0,
        int num_threads=20):

    '''
    n_logint = number of bins per decade if logbinning
    '''
    cdef int numpair1 = RA1.size
    cdef int numpair2 = RA2.size


    cdef int ii, jj, ith

    cdef np.ndarray[DTYPE_t, ndim=1] x1 = np.zeros(numpair1, dtype=DTYPE)
    for ii in xrange(0, numpair1):
        x1[ii] = sqrt(1 - cos(PI / 2 - DEC1[ii] * PI180)**2) * \
                cos(RA1[ii] * PI180)
    cdef np.ndarray[DTYPE_t, ndim=1] y1 = np.zeros(numpair1, dtype=DTYPE)
    for ii in xrange(0, numpair1):
        y1[ii] = sqrt(1 - cos(PI / 2 - DEC1[ii] * PI180)**2) * \
                sin(RA1[ii] * PI180)
    cdef np.ndarray[DTYPE_t, ndim=1] z1 = np.zeros(numpair1, dtype=DTYPE)
    for ii in xrange(0, numpair1):
        z1[ii] = cos(PI / 2 - DEC1[ii] * PI180)

    cdef np.ndarray[DTYPE_t, ndim=1] x2 = np.zeros(numpair2, dtype=DTYPE)
    for ii in xrange(0, numpair2):
        x2[ii] = sqrt(1 - cos(PI / 2 - DEC2[ii] * PI180)**2) * \
                cos(RA2[ii] * PI180)
    cdef np.ndarray[DTYPE_t, ndim=1] y2 = np.zeros(numpair2, dtype=DTYPE)
    for ii in xrange(0, numpair2):
        y2[ii] = sqrt(1 - cos(PI / 2 - DEC2[ii] * PI180)**2) * \
                sin(RA2[ii] * PI180)

    cdef np.ndarray[DTYPE_t, ndim=1] z2 = np.zeros(numpair2, dtype=DTYPE)
    for ii in xrange(0, numpair2):
        z2[ii] = cos(PI / 2 - DEC2[ii] * PI180)


    cdef np.ndarray[DTYPE_hh_t, ndim=1] hh = np.zeros(bin_number, dtype=DTYPE_hh)
    cdef float prod

    cdef float I_max_theta = 1. / max_theta

    cdef float min_prod = cos(max_theta)

    with nogil, cython.boundscheck(False), cython.wraparound(False):
        for ii in parallel.prange(numpair1, schedule='static',
                num_threads=num_threads):
            for jj in xrange(0, numpair2):
                prod = x1[ii] * x2[jj] + y1[ii] * y2[jj] + z1[ii] * z2[jj]

                prod = float_min(prod)
                if prod > min_prod:
                    if logbin:
                        if prod != 1:
                            if true_acos:
                                prod = log10(acos(prod))
                            else:
                                prod = 1 - prod
                                prod = 0.5 * \
                                        log10(2 * prod +
                                                0.33333333333 * prod * prod +
                                                0.088888888889 * prod * prod * prod)
                            ith = <int> ( n_logint * (prod - log10(max_theta)) + \
                                    bin_number )
                        else:
                            '''
                            old code said bin_number - 1; I think it should be 0,
                            since acos(1) = 0 -> right on top of each other
                            '''
                            ith = 0  #bin_number - 1  # why?
                    else:
                        if true_acos:
                            prod = acos(prod)
                        else:
                            prod = 1 - prod
                            prod = sqrt(2 * prod + 0.333333333 * prod * prod +
                                    0.0888889 * prod * prod * prod)
                        ith = <int> ( bin_number * prod * I_max_theta )

                    if (ith >= 0) * (ith < bin_number):
                        hh[ith] += 1

    return hh

'''
import correlationpyx
func = correlationpyx.auto_ang_correlate_cython
RA, DEC = np.random.ranf((2,1000)) * 180 / np.pi

w = func(RA, DEC)

import pyfits
hdu = pyfits.open('/Users/cpd/Desktop/catalogs/dr8_run_redmapper_v5.2_lgt20_catalog.fit')
data = hdu[1].data
RAp, DECp = data['RA'].astype(np.float), data['DEC'].astype(np.float)
%timeit -n 4 wp = func(RAp, DECp, num_threads=20)
'''
