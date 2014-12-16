import numpy as np
# "cimport" is used to import special compile-time information
# about the numpy module (this is stored in a file numpy.pxd which is
# currently part of the Cython distribution).
cimport numpy as np
from libc.math import max, abs

DTYPE = np.int
ctypedef np.int_t DTYPE_t

cdef int value(np.ndarray[DTYPE_t, ndim=1] coins, np.ndarray[DTYPE_t, ndim=1] denominations):
    cdef int val = 0
    cdef int i
    cdef int coin_len = 7
    for i in range(coin_len):
        val += coins[i] * denominations[i]
    return val

cpdef int main():
    cdef int target = 200
    cdef int valid = 1  # for the 200 piece
    cdef int val = 0
    cdef int difference

    
    cdef np.ndarray[DTYPE_t, ndim=1] denominations = np.array([1, 2, 5, 10, 20, 50, 100])
    cdef np.ndarray[DTYPE_t, ndim=1] max_coins = np.array([200, 100, 40, 20, 10, 4, 2])
    
    cdef np.ndarray[DTYPE_t, ndim=1] coins = np.array([0, 0, 0, 0, 0, 0, 0])
    while coins[6] < max_coins[6]:
        for i in range(5 + 1):
            coins[i] = 0
        difference = abs(target - value(coins, denominations))
        max_coins[5] = (difference) / denominations[5] + 1
        while coins[5] < max_coins[5]:
            for i in range(4 + 1):
                coins[i] = 0
            difference = abs(target - value(coins, denominations))
            max_coins[4] = (difference) / denominations[4] + 1
            while coins[4] < max_coins[4]:
                for i in range(3 + 1):
                    coins[i] = 0
                difference = abs(target - value(coins, denominations))
                max_coins[3] = (difference) / denominations[3] + 1
                while coins[3] < max_coins[3]:
                    for i in range(2 + 1):
                        coins[i] = 0
                    difference = abs(target - value(coins, denominations))
                    max_coins[2] = (difference) / denominations[2] + 1
                    while coins[2] < max_coins[2]:
                        for i in range(1 + 1):
                            coins[i] = 0
                        difference = abs(target - value(coins, denominations))
                        max_coins[1] = (difference) / denominations[1] + 1
                        while coins[1] < max_coins[1]:
                            # we know what coins[0] must exactly be
                            coins[0] = 0
                            coins[0] = target - value(coins, denominations)
                            max_coins[0] = coins[0]
                            if coins[0] < 0:
                                continue
                            val = value(coins, denominations)
                            #print(val, coins, max_coins)
                            if val == target:
                                valid += 1
                            coins[1] += 1
                        coins[2] += 1
                    coins[3] += 1
                coins[4] += 1
                print(coins, value(coins, denominations), valid)
            coins[5] += 1
        coins[6] += 1
    return valid

