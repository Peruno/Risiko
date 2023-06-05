""""p_ij is the probability that i attackers win a single dice roll against j defenders.
    I use range(1, 7) instead of range(6) so that it matches the dice numbers."""

# possibility_11 : 1 attacker, 1 defender
mgl_11 = 0
counter = 0
for j in range(1, 7):
    for i in range(1, 7):
        counter += 1
        if i < j:
            mgl_11 += 1

p_11 = mgl_11 / 6**2


# possibility_12 : 1 attacker, 2 defenders
mgl_12 = 0
for j in range(1, 7):
    for i1 in range(1, 7):
        for i2 in range(1, 7):
            if i1 < j and i2 < j:
                mgl_12 += 1

p_12 = mgl_12 / 6**3


# possibility_21 : 2 attackers, 1 defender
mgl_21 = 0
for j1 in range(1, 7):
    for j2 in range(1, 7):
        for i1 in range(1, 7):
            if i1 < j1 or i1 < j2:
                mgl_21 += 1

p_21 = mgl_21 / 6**3


# possibility_22 : 2 attackers, 2 defenders
mgl_22 = 0
for j1 in range(1, 7):
    for j2 in range(1, 7):
        for i1 in range(1, 7):
            for i2 in range(1, 7):
                if max(i1, i2) < max(j1, j2):
                    mgl_22 += 1

p_22 = mgl_22 / 6**4


# possibility_31 : 3 attackers, 1 defender
mgl_31 = 0
for j1 in range(1, 7):
    for j2 in range(1, 7):
        for j3 in range(1, 7):
            for i1 in range(1, 7):
                if i1 < max(j1, j2, j3):
                    mgl_31 += 1

p_31 = mgl_31 / 6**4


# possibility_32 : 3 attackers, 2 defenders
mgl_32 = 0
for j1 in range(1, 7):
    for j2 in range(1, 7):
        for j3 in range(1, 7):
            for i1 in range(1, 7):
                for i2 in range(1, 7):
                    if max(i1, i2) < max(j1, j2, j3):
                        mgl_32 += 1

p_32 = mgl_32 / 6**5
