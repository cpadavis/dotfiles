
#TODO: convert into pyx
from __future__ import print_function, division
import numpy as np
# "cimport" is used to import special compile-time information
# about the numpy module (this is stored in a file numpy.pxd which is
# currently part of the Cython distribution).
cimport numpy as np
#from math import sqrt, atan2, cos, sin, exp, floor, ceil
from libc.math cimport sqrt, atan2, cos, sin, exp, floor, ceil

"""
Adaptation of GalSim's adaptive moments code, which is itself an adaptation of
some other code.
"""

DTYPE = np.float
ctypedef np.float_t DTYPE_t

cdef np.ndarray[DTYPE_t, ndim=1] find_ellipmom_1(np.ndarray[DTYPE_t, ndim=2] data,
                          float x0, float y0,
                          float Mxx, float Mxy, float Myy,
                          float max_moment_nsig2):

    cdef float A = 0
    cdef float Bx = 0
    cdef float By = 0
    cdef float Cxx = 0
    cdef float Cxy = 0
    cdef float Cyy = 0
    cdef float rho4w = 0

    cdef int xmin = 0
    cdef int ymin = 0
    cdef int ymax = data.shape[0]
    cdef int xmax = data.shape[1]

    cdef float detM = Mxx * Myy - Mxy * Mxy
    if (detM <= 0) + (Mxx <= 0) + (Myy <= 0):
        print("Error: non positive definite adaptive moments!\n")

    cdef float Minv_xx = Myy / detM
    cdef float TwoMinv_xy = -Mxy / detM * 2.0
    cdef float Minv_yy = Mxx / detM
    cdef float Inv2Minv_xx = 0.5 / Minv_xx  # Will be useful later...

    # rho2 = Minv_xx(x-x0)^2 + 2Minv_xy(x-x0)(y-y0) + Minv_yy(y-y0)^2
    # The minimum/maximum y that have a solution rho2 = max_moment_nsig2 is at:
    #   2*Minv_xx*(x-x0) + 2Minv_xy(y-y0) = 0
    # rho2 = Minv_xx (Minv_xy(y-y0)/Minv_xx)^2
    #           - 2Minv_xy(Minv_xy(y-y0)/Minv_xx)(y-y0)
    #           + Minv_yy(y-y0)^2
    #      = (Minv_xy^2/Minv_xx - 2Minv_xy^2/Minv_xx + Minv_yy) (y-y0)^2
    #      = (Minv_xx Minv_yy - Minv_xy^2)/Minv_xx (y-y0)^2
    #      = (1/detM) / Minv_xx (y-y0)^2
    #      = (1/Myy) (y-y0)^2
    #
    # we are finding the limits for the iy values and then the ix values.
    cdef float y_y0 = sqrt(max_moment_nsig2 * Myy)
    cdef float y1 = -y_y0 + y0
    cdef float y2 = y_y0 + y0

    # stay within image bounds
    cdef int iy1 = max(int(ceil(y1)), ymin)
    cdef int iy2 = min(int(floor(y2)), ymax)
    cdef int y

    cdef float a, b, c, d, sqrtd, inv2a, x1, x2, x_x0, \
        Minv_xx__x_x0__x_x0, rho2, intensity, TwoMinv_xy__y_y0, Minv_yy__y_y0__y_y0
    cdef int ix1, ix2, x

    for y in xrange(iy1, iy2):

        y_y0 = y - y0
        TwoMinv_xy__y_y0 = TwoMinv_xy * y_y0
        Minv_yy__y_y0__y_y0 = Minv_yy * y_y0 ** 2

        # Now for a particular value of y, we want to find the min/max x that satisfy
        # rho2 < max_moment_nsig2.
        #
        # 0 = Minv_xx(x-x0)^2 + 2Minv_xy(x-x0)(y-y0) + Minv_yy(y-y0)^2 - max_moment_nsig2
        # Simple quadratic formula:

        a = Minv_xx
        b = TwoMinv_xy__y_y0
        c = Minv_yy__y_y0__y_y0 - max_moment_nsig2
        d = b * b - 4 * a * c
        sqrtd = sqrt(d)
        inv2a = Inv2Minv_xx
        x1 = inv2a * (-b - sqrtd) + x0
        x2 = inv2a * (-b + sqrtd) + x0

        # stay within image bounds
        ix1 = max(int(ceil(x1)), xmin)
        ix2 = min(int(floor(x2)), xmax)
        if ix1 > ix2:
            print('ix1 > ix2')
            continue

        for x in xrange(ix1, ix2):

            x_x0 = x - x0

            # Compute displacement from weight centroid, then get elliptical
            # radius and weight.
            Minv_xx__x_x0__x_x0 = Minv_xx * x_x0 ** 2
            rho2 = Minv_yy__y_y0__y_y0 + \
                TwoMinv_xy__y_y0 * x_x0 + \
                Minv_xx__x_x0__x_x0

            # this shouldn't happen by construction
            if (rho2 > max_moment_nsig2 + 1e8):
                print('rho2 > max_moment_nsig2 !')
                continue

            intensity = exp(-0.5 * rho2) * data[y, x]  # y,x order!

            A += intensity
            Bx += intensity * x_x0
            By += intensity * y_y0
            Cxx += intensity * x_x0 ** 2
            Cxy += intensity * x_x0 * y_y0
            Cyy += intensity * y_y0 ** 2
            rho4w += intensity * rho2 * rho2

    cdef np.ndarray[DTYPE_t, ndim=1] return_array = np.array([A, Bx, By, Cxx, Cxy, Cyy, rho4w], dtype=DTYPE)
    return return_array

def find_ellipmom_2(data, epsilon=1e-6):

    convergence_factor = 1.0
    guess_sig = 3.0
    x0, y0 = np.array(data.shape) / 2
    Mxx = guess_sig ** 2
    Mxy = 0
    Myy = guess_sig ** 2
    "A parameter for optimizing calculations of adaptive moments by\n"
    "cutting off profiles. This parameter is used to decide how many\n"
    "sigma^2 into the Gaussian adaptive moment to extend the moment\n"
    "calculation, with the weight being defined as 0 beyond this point.\n"
    "i.e., if max_moment_nsig2 is set to 25, then the Gaussian is\n"
    "extended to (r^2/sigma^2)=25, with proper accounting for elliptical\n"
    "geometry.  If this parameter is set to some very large number, then\n"
    "the weight is never set to zero and the exponential function is\n"
    "always called. Note: GalSim script devel/modules/test_mom_timing.py\n"
    "was used to choose a value of 25 as being optimal, in that for the\n"
    "cases that were tested, the speedups were typically factors of\n"
    "several, but the results of moments and shear estimation were\n"
    "changed by <10^-5.  Not all possible cases were checked, and so for\n"
    "use of this code for unusual cases, we recommend that users check\n"
    "that this value does not affect accuracy, and/or set it to some\n"
    "large value to completely disable this optimization.\n"
    max_moment_nsig2 = 25
    bound_correct_wt = 0.25  # Maximum shift in centroids and sigma between
                             # iterations for adaptive moments.

    num_iter = 0

    # Set Amp = -1000 as initial value just in case the while() block below is
    # never triggered; in this case we have at least *something* defined to
    # divide by, and for which the output will fairly clearly be junk.
    Amp = -1000.

    # Iterate until we converge
    while (convergence_factor > epsilon):
        #print(x0, y0, Mxx, Mxy, Myy, num_iter)

        # Get moments
        Amp, Bx, By, Cxx, Cxy, Cyy, rho4 = find_ellipmom_1(data, x0, y0, Mxx, Mxy, Myy, max_moment_nsig2)

        # Compute configuration of the weight function
        two_psi = atan2(2 * Mxy, Mxx - Myy)
        semi_a2 = 0.5 * ((Mxx + Myy) + (Mxx - Myy) * cos(two_psi)) + \
                         Mxy * sin(two_psi)
        semi_b2 = Mxx + Myy - semi_a2

        if semi_b2 <= 0:
            print("Error: non positive-definite weight in find_ellipmom_2.\n")

        shiftscale = sqrt(semi_b2)
        if num_iter == 0:
            shiftscale0 = shiftscale

        # Now compute changes to x0, etc
        dx = 2. * Bx / (Amp * shiftscale)
        dy = 2. * By / (Amp * shiftscale)
        dxx = 4. * (Cxx / Amp - 0.5 * Mxx) / semi_b2
        dxy = 4. * (Cxy / Amp - 0.5 * Mxy) / semi_b2
        dyy = 4. * (Cyy / Amp - 0.5 * Myy) / semi_b2

        if (dx     >  bound_correct_wt): dx     =  bound_correct_wt
        if (dx     < -bound_correct_wt): dx     = -bound_correct_wt
        if (dy     >  bound_correct_wt): dy     =  bound_correct_wt
        if (dy     < -bound_correct_wt): dy     = -bound_correct_wt
        if (dxx    >  bound_correct_wt): dxx    =  bound_correct_wt
        if (dxx    < -bound_correct_wt): dxx    = -bound_correct_wt
        if (dxy    >  bound_correct_wt): dxy    =  bound_correct_wt
        if (dxy    < -bound_correct_wt): dxy    = -bound_correct_wt
        if (dyy    >  bound_correct_wt): dyy    =  bound_correct_wt
        if (dyy    < -bound_correct_wt): dyy    = -bound_correct_wt

        # Convergence tests
        convergence_factor = abs(dx) ** 2
        if (abs(dy) > convergence_factor):
            convergence_factor = abs(dy) ** 2
        if (abs(dxx) > convergence_factor):
            convergence_factor = abs(dxx)
        if (abs(dxy) > convergence_factor):
            convergence_factor = abs(dxy)
        if (abs(dyy) > convergence_factor):
            convergence_factor = abs(dyy)
        convergence_factor = sqrt(convergence_factor)
        if (shiftscale < shiftscale0):
            convergence_factor *= shiftscale0 / shiftscale

        # Now update moments
        x0 += dx * shiftscale
        y0 += dy * shiftscale
        Mxx += dxx * semi_b2
        Mxy += dxy * semi_b2
        Myy += dyy * semi_b2

        num_iter += 1

    A = Amp
    rho4 /= Amp

    return x0, y0, Mxx, Mxy, Myy, A, rho4
