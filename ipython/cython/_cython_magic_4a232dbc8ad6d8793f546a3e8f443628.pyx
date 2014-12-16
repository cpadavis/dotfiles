# test some pointer things
cdef double f1(double A, double& B):
    return A
cpdef double f2(double B):
    cdef double A = 1.5
    return f1(A, B*)
