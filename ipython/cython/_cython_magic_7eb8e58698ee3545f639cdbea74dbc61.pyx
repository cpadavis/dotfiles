import numpy as np
# "cimport" is used to import special compile-time information
# about the numpy module (this is stored in a file numpy.pxd which is
# currently part of the Cython distribution).
cimport numpy as np

from libc.math cimport sqrt, atan2, cos, sin

"""
Adaptation of GalSim's adaptive moments code, which is itself an adaptation of
some other code.

441 mus vs 338 mus for galsim python interface + cpp code (and I only cythonized ellipmom_1 !)
but: that is for a weaker epsilon of 1e-3. 1e-4 makes it take much longer (hits num_iter max)
"""

DTYPE = np.float64
ctypedef np.float64_t DTYPE_t

DTYPE_int = np.int
ctypedef np.int_t DTYPE_int_t

cdef int ndim = 2

cpdef centered_moment(
        np.ndarray[DTYPE_t, ndim=ndim] data,
        np.ndarray[DTYPE_int_t, ndim=ndim] X,
        np.ndarray[DTYPE_int_t, ndim=ndim] Y,
        int q, int p,
        double Mx, double My,
        double amplitude_inv):

    """Calculate the centered moment
    Mpq = sum(data * (X - x) ** p * (Y - y) ** q) / sum(data)
    where x and y are the centroid locations and X and Y are the indices of the
    data array

    Parameters
    ----------
    data : array
        image array

    p, q : floats
        The moments we are interested in. p,q for x,y

    Mx, My : floats
        Centroids of image

    Y, X : array
        arrays each containing the values of each pixel of data

    amplitude_inv : float
        1 / sum(data)

    Returns
    -------
    Mpq : float
        The centered moment M_pq centered about the centroid

    Notes
    -----
    Image convention is data[Y,X]

    If you want to /find/ xbar, ybar, just set them to 0 and (p,q)=(1,0) or
    (0,1)

    If you want to include weights, just multiply your data by them.
    """

    cdef double Mpq = np.sum(data * (X - Mx) ** p * (Y - My) ** q) * amplitude_inv
    return Mpq
