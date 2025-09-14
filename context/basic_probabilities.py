class BasicProbabilities:
    def __init__(self):
        """single_probs["ivj"] is the probability that i attackers win a single dice roll against j defenders.
        """
        self.single_probs = {}

        wins_for_attacker_1v1 = 0
        for a in range(1, 7):
            for d in range(1, 7):
                if d < a:
                    wins_for_attacker_1v1 += 1
        self.single_probs["1v1"] = wins_for_attacker_1v1 / 6 ** 2

        wins_for_attacker_1v2 = 0
        for a in range(1, 7):
            for d1 in range(1, 7):
                for d2 in range(1, 7):
                    if max(d1, d2) < a:
                        wins_for_attacker_1v2 += 1
        self.single_probs["1v2"] = wins_for_attacker_1v2 / 6**3

        wins_for_attacker_2v1 = 0
        for a1 in range(1, 7):
            for a2 in range(1, 7):
                for d1 in range(1, 7):
                    if d1 < max(a1, a2):
                        wins_for_attacker_2v1 += 1
        self.single_probs["2v1"] = wins_for_attacker_2v1 / 6**3

        wins_for_attacker_2v2 = 0
        for a1 in range(1, 7):
            for a2 in range(1, 7):
                for d1 in range(1, 7):
                    for d2 in range(1, 7):
                        if max(d1, d2) < max(a1, a2):
                            wins_for_attacker_2v2 += 1
        self.single_probs["2v2"] = wins_for_attacker_2v2 / 6**4

        wins_for_attacker_3v1 = 0
        for a1 in range(1, 7):
            for a2 in range(1, 7):
                for a3 in range(1, 7):
                    for d1 in range(1, 7):
                        if d1 < max(a1, a2, a3):
                            wins_for_attacker_3v1 += 1

        self.single_probs["3v1"] = wins_for_attacker_3v1 / 6**4

        wins_for_attacker_3v2 = 0
        for a1 in range(1, 7):
            for a2 in range(1, 7):
                for a3 in range(1, 7):
                    for d1 in range(1, 7):
                        for d2 in range(1, 7):
                            if max(d1, d2) < max(a1, a2, a3):
                                wins_for_attacker_3v2 += 1
        self.single_probs["3v2"] = wins_for_attacker_3v2 / 6**5

    def p_swin(self, a, d):
        """Returns the probability to win a single roll of the dices as attacker.
        a: number of attackers
        d: number of defenders"""
        if a == 0:
            return 0
        elif d == 0:
            return 1
        elif a >= 3 and d >= 2:
            return self.single_probs["3v2"]
        elif a >= 3 and d == 1:
            return self.single_probs["3v1"]
        elif a == 2 and d >= 2:
            return self.single_probs["2v2"]
        elif a == 2 and d == 1:
            return self.single_probs["2v1"]
        elif a == 1 and d >= 2:
            return self.single_probs["1v2"]
        elif a == 1 and d == 1:
            return self.single_probs["1v1"]


if __name__ == "__main__":
    probs = BasicProbabilities()

    print(f"P(\"3 attackers vs 2 defenders\") = {probs.p_swin(3, 2)}")
    print(f"P(\"3 attackers vs 1 defenders\") = {probs.p_swin(3, 1)}")
    print(f"P(\"2 attackers vs 2 defenders\") = {probs.p_swin(2, 2)}")
    print(f"P(\"2 attackers vs 1 defenders\") = {probs.p_swin(2, 1)}")
    print(f"P(\"1 attackers vs 2 defenders\") = {probs.p_swin(1, 2)}")
    print(f"P(\"1 attackers vs 1 defenders\") = {probs.p_swin(1, 1)}")
