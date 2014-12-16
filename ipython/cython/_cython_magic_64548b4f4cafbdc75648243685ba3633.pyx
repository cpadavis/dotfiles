# test some pointer things
cpdef double f1(double A, double& B):
    cdef double C = A + B
    return C
cpdef double f2(double& B):
    cdef double A = 1.5
    cdef double E = f1(A, B)
    return E
