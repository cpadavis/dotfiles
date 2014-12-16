cdef np.ndarray[DTYPE_t, ndim=1] coins = np.array([0, 0, 0, 0, 0, 0, 0])
while coins[6 < max_coins[6]:
    coins[5] = 0
    while coins[5 < max_coins[5]:
        coins[4] = 0
        while coins[4 < max_coins[4]:
            coins[3] = 0
            while coins[3 < max_coins[3]:
                coins[2] = 0
                while coins[2 < max_coins[2]:
                    coins[1] = 0
                    while coins[1 < max_coins[1]:
                        coins[0] = 0
                        while coins[0 < max_coins[0]:
                            if value(coins) == target:
                                valid += 1
                            coins[0] += 1
                        coins[1] += 1
                    coins[2] += 1
                coins[3] += 1
            coins[4] += 1
        coins[5] += 1
    coins[6] += 1
