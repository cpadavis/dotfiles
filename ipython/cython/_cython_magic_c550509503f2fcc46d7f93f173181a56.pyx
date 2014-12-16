import numpy as np
# "cimport" is used to import special compile-time information
# about the numpy module (this is stored in a file numpy.pxd which is
# currently part of the Cython distribution).
cimport numpy as np

cdef int target = 200
cdef int valid = 1  # for the 200 piece
cdef int coin_len = 7

DTYPE = np.int
ctypedef np.int_t DTYPE_t

cdef np.ndarray[DTYPE_t, ndim=1] denominations = np.array([1, 2, 5, 10, 20, 50, 100])
cdef np.ndarray[DTYPE_t, ndim=1] max_coins = np.array([200, 100, 40, 20, 10, 4, 2])

cpdef int value(np.ndarray[DTYPE_t, ndim=1] coins):
    cdef int val = 0
    cdef int i
    for i in range(coin_len):
        val += coins[i] * denominations[i]
    return val
