# test some pointer things
import numpy as np
cimport numpy as np

DTYPE = np.float64
ctypedef np.float64_t DTYPE_t
cdef np.ndarray[DTYPE_t] f1(double A):
    cdef DTYPE_t a = 2 * A
    cdef DTYPE_t b = 4 ** A
    cdef np.ndarray[DTYPE_t] return_array = np.array([A, A + 5, a, b], dtype=DTYPE)
    return return_array

cpdef np.ndarray[DTYPE_t] f2(double A):
    return f1(A)
