# test some pointer things
import numpy as np
cimport numpy as np

DTYPE = np.float64
ctypedef np.float64_t DTYPE_t
cdef np.ndarray[DTYPE_t, ndim=1] f1(double A):
    cdef DTYPE_t a = A
    cdef DTYPE_t b = 2 * A
    cdef np.ndarray[DTYPE_t, ndim=1] return_array = np.array([a, b], dtype=DTYPE)
    return return_array[0]

cpdef double f2(double A):
    cdef double a, b
    a = f1(A)
    return a
