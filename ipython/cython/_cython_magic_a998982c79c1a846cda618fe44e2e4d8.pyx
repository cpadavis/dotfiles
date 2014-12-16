# test some pointer things
cdef void f1(double A, double& B):
    return
cpdef double f2(double B):
    cdef double A = 1.5
    f1(A, B)
    return B
