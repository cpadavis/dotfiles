from __future__ import print_function, division
import numpy as np
cimport numpy as np
import cython
from cython cimport parallel

DTYPE = int
ctypedef np.int_t DTYPE_t


# auto correlation
@cython.boundscheck(False)
@cython.wraparound(False)
def auto_histogram(
    np.ndarray[DTYPE_t, ndim=2] x,
    float max_r=1,
    int bin_number=10,
    int num_threads=20):
    """
    Calculate histogram up to max_r

    Parameters
    ----------
    x : n x d array
        x[i] returns d dimensional array of locations


    max_r : float
        What is the maximum radius to which we construct the function?

        TODO: If max_r < 0, then becomes the size of each bin

    bin_number : int
        Number of bins used for h

    Returns
    -------
    N : array
        Array of histogram

    """
    cdef int ii, jj, kk, ith, binmid
    cdef float prod

    cdef int numpair = x.shape[0]
    cdef int numdim = x.shape[1]

    cdef np.ndarray[DTYPE_t, ndim=1] N = np.zeros(bin_number, dtype=DTYPE)
    cdef float inv_max_r = 1. / max_r

    with nogil, cython.boundscheck(False), cython.wraparound(False):
        for ii in parallel.prange(numpair-1, schedule='static',
                num_threads=num_threads):
            for jj in xrange(ii + 1, numpair):

                prod = 0
                for kk in xrange(numdim):
                    prod = prod + x[ii, kk] * x[jj, kk]
                #prod = np.dot(x[ii], x[jj])

                if prod < max_r:
                    binmid = <int> (prod * inv_max_r)
                    ith = (bin_number * binmid)

#                     if (ith < 0):
#                         raise ValueError("ith should be >= 0!")
                    if (ith < bin_number):
                        N[ith] += 1

    return N

# cross correlation
@cython.boundscheck(False)
@cython.wraparound(False)
def cross_histogram(
    np.ndarray[DTYPE_t, ndim=2] x1,
    np.ndarray[DTYPE_t, ndim=2] x2,
    float max_r=1,
    int bin_number=10,
    int num_threads=20):
    """
    Calculate histogram up to max_r

    Parameters
    ----------
    x1, x2 : n x d array
        x[i] returns d dimensional array of locations

    max_r : float
        What is the maximum radius to which we construct the function?

        TODO: If max_r < 0, then becomes the size of each bin

    bin_number : int
        Number of bins used for h

    Returns
    -------
    N : array
        Array of histogram

    """
    cdef int ii, jj, kk, ith, binmid
    cdef float prod = 0

    cdef int numpair1 = x1.shape[0]
    cdef int numpair2 = x2.shape[0]
    cdef int numdim = x1.shape[1]

    cdef np.ndarray[DTYPE_t, ndim=1] N = np.zeros(bin_number, dtype=DTYPE)
    cdef float inv_max_r = 1. / max_r

    with nogil, cython.boundscheck(False), cython.wraparound(False):
        for ii in parallel.prange(0, numpair1, schedule='static',
                num_threads=num_threads):
            for jj in xrange(0, numpair2):
                prod = 0.
                for kk in xrange(numdim):
                    prod = prod + x1[ii, kk] * x2[jj, kk]
                #prod = np.dot(x1[ii], x2[jj])

                if prod < max_r:
                    binmid = <int> (prod * inv_max_r)
                    ith = (bin_number * binmid)

#                     if (ith < 0):
#                         raise ValueError("ith should be >= 0!")
                    if (ith < bin_number):
                        N[ith] += 1

    return N
