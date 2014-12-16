# test some pointer things
cpdef double f1(double A, double& B):
    cdef double C = A + B
    return C
cpdef double f2(double D):
    cdef double B = 1
    cdef double D = f1(1.5, B)
    return D
