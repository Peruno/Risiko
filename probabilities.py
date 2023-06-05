"""
single_probs["ivj"] is the probability that i attackers win a single dice roll against j defenders.
"""


single_probs = {}

# possibility_11 : 1 attacker, 1 defender
wins_for_attacker_1v1 = 0
for j in range(1, 7):
    for i in range(1, 7):
        if i < j:
            wins_for_attacker_1v1 += 1

single_probs["1v1"] = wins_for_attacker_1v1 / 6 ** 2


# possibility_12 : 1 attacker, 2 defenders


wins_for_attacker_1v2 = 0
for j in range(1, 7):
    for i1 in range(1, 7):
        for i2 in range(1, 7):
            if max(i1, i2) < j:
                wins_for_attacker_1v2 += 1

p_1v2 = wins_for_attacker_1v2 / 6**3


single_probs["1v2"] = wins_for_attacker_1v2 / 6**3


# possibility_21 : 2 attackers, 1 defender
wins_for_attacker_2v1 = 0
for j1 in range(1, 7):
    for j2 in range(1, 7):
        for i1 in range(1, 7):
            if i1 < max(j1, j2):
                wins_for_attacker_2v1 += 1

single_probs["2v1"] = wins_for_attacker_2v1 / 6**3


# possibility_22 : 2 attackers, 2 defenders
wins_for_attacker_2v2 = 0
for j1 in range(1, 7):
    for j2 in range(1, 7):
        for i1 in range(1, 7):
            for i2 in range(1, 7):
                if max(i1, i2) < max(j1, j2):
                    wins_for_attacker_2v2 += 1

single_probs["2v2"] = wins_for_attacker_2v2 / 6**4


# possibility_31 : 3 attackers, 1 defender
wins_for_attacker_3v1 = 0
for j1 in range(1, 7):
    for j2 in range(1, 7):
        for j3 in range(1, 7):
            for i1 in range(1, 7):
                if i1 < max(j1, j2, j3):
                    wins_for_attacker_3v1 += 1

single_probs["3v1"] = wins_for_attacker_3v1 / 6**4


# possibility_32 : 3 attackers, 2 defenders
wins_for_attacker_3v2 = 0
for j1 in range(1, 7):
    for j2 in range(1, 7):
        for j3 in range(1, 7):
            for i1 in range(1, 7):
                for i2 in range(1, 7):
                    if max(i1, i2) < max(j1, j2, j3):
                        wins_for_attacker_3v2 += 1

single_probs["3v2"] = wins_for_attacker_3v2 / 6**5


if __name__ == "__main__":
    print(single_probs)
