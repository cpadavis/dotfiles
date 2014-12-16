# Same gaussian distribution but now written in Cython
# The %%cython IPython does the following:
# * Call Cython to generate C code for a Python C extension.
# * Compile it into a Python C extension (a shared library)
# * Load it into the current namespace
# If you don't understand these things, don't worry, it basically means:
# * Get full-metal speed easily
cimport cython
from libc.math cimport exp, M_PI, sqrt
@cython.binding(True) # IMPORTANT: this tells Cython to dump the function signature
def gauss_pdf_cython(double x, double mu, double sigma):
    return 1 / sqrt(2 * M_PI) / sigma * exp(-(x - mu) ** 2 / 2. / sigma ** 2)
