# test some pointer things
cdef void f1(double A, double& B):
    A += 1
    return
cpdef double f2():
    cdef double A = 1.5
    cdef double B
    f1(A, B)
    return B
