import numpy as np
# "cimport" is used to import special compile-time information
# about the numpy module (this is stored in a file numpy.pxd which is
# currently part of the Cython distribution).
cimport numpy as np

DTYPE = np.int
ctypedef np.int_t DTYPE_t

cdef int value(np.ndarray[DTYPE_t, ndim=1] coins, np.ndarray[DTYPE_t, ndim=1] denominations):
    cdef int val = 0
    cdef int i = 0
    cdef int coin_len = 7
    for i in range(coin_len):
        val += coins[i] * denominations[i]
    return val

cpdef int main():
    cdef int target = 200
    cdef int valid = 1  # for the 200 piece
    cdef int val = 0

    
    cdef np.ndarray[DTYPE_t, ndim=1] denominations = np.array([1, 2, 5, 10, 20, 50, 100])
    cdef np.ndarray[DTYPE_t, ndim=1] max_coins = np.array([200, 100, 40, 20, 10, 4, 2])
    
    cdef np.ndarray[DTYPE_t, ndim=1] coins = np.array([0, 0, 0, 0, 0, 0, 0])
#     while coins[6] < max_coins[6]:
#         coins[5] = 0
#         while coins[5] < max_coins[5]:
#             coins[4] = 0
#             while coins[4] < max_coins[4]:
#                 coins[3] = 0
#                 while coins[3] < max_coins[3]:
    coins[2] = 0
    while coins[2] < max_coins[2]:
        coins[1] = 0
        max_coins[1] = value([0] * (1) + coins[1:], denominations) / denominations[1] + 1
        while coins[1] < max_coins[1]:
            coins[0] = 0
            max_coins[0] = value(coins, denominations) + 1
            print(coins, max_coins[1], max_coins[0])
            while coins[0] < max_coins[0]:
                val = value(coins, denominations)
                if val == target:
                    valid += 1
                coins[0] += 1
            coins[1] += 1
        coins[2] += 1
#                     coins[3] += 1
#                 coins[4] += 1
#             coins[5] += 1
#         coins[6] += 1

    return valid

