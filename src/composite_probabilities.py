from math import factorial
from time import time

from numpy import zeros, array

from src.basic_probabilities import BasicProbabilities


class CompositeProbabilities:
    def __init__(self):
        self.basic_probs = BasicProbabilities()

    def p_recursive(self, a, d):
        """Returns the probability to win an attack with a attackers against d defenders.
        """
        if a == 0:
            return 0
        elif d == 0:
            return 1
        else:
            return self.basic_probs.p_swin(a, d) * self.p_recursive(a, d - 1) + \
                (1 - self.basic_probs.p_swin(a, d)) * self.p_recursive(a - 1, d)

    def p_matrix(self, a, d):
        """Using the matrix-method to calculate the probability to win an attack with a attackers against d defenders.
        Each element given by (i,j) holds the probability to win with i attackers against j defenders. The next element
        will always be calculated using the ones before: (i,j-1) and (i-1,j) -> (i-j)
        """
        risk_matrix = zeros((a + 1, d + 1))
        for i in range(a + 1):
            for j in range(d + 1):
                if j == 0:
                    y = 1
                elif i == 0:
                    y = 0
                else:
                    y = self.basic_probs.p_swin(i, j) * risk_matrix[i][j - 1] + \
                        (1 - self.basic_probs.p_swin(i, j)) * risk_matrix[i - 1][j]
                risk_matrix[i][j] = y
        return risk_matrix[a][d]

    def p_precise_win(self, a, d, a_min):
        """Returns the probability to win an attack with a attackers against d defenders and have exactly a_min
        attackers left afterward.
        """
        win_matrix = zeros((a + 1, d + 1))
        for i in range(a + 1):
            for j in range(d + 1):
                if i == 0:
                    y = 0
                elif i < a_min:
                    y = 0
                elif i == a_min and j == 0:
                    y = 1
                elif i == a_min and j > 0:
                    y = self.basic_probs.p_swin(i, j) * win_matrix[i][j - 1]
                elif i > a_min and j == 0:
                    y = 0
                elif i > a_min and j > 0:
                    y = self.basic_probs.p_swin(i, j) * win_matrix[i][j - 1] + \
                        (1 - self.basic_probs.p_swin(i, j)) * win_matrix[i - 1][j]
                win_matrix[i][j] = y
        return win_matrix[a][d]

    def p_precise_loss(self, a, d, d_min):
        """Returns the probability to lose an attack with a attackers against d defenders with the condition, that there
        are exactly d_min defenders left afterward.
        """
        loss_matrix = zeros((a + 1, d + 1))
        for i in range(a + 1):
            for j in range(d + 1):
                if j == 0:
                    y = 0
                elif j < d_min:
                    y = 0
                elif i == 0 and j > d_min:
                    y = 0
                elif j == d_min and i == 0:
                    y = 1
                elif j == d_min and i > 0:
                    y = (1 - self.basic_probs.p_swin(i, j)) * loss_matrix[i - 1][j]
                elif j > d_min and i > 0:
                    y = self.basic_probs.p_swin(i, j) * loss_matrix[i][j - 1] + \
                        (1 - self.basic_probs.p_swin(i, j)) * loss_matrix[i - 1][j]
                loss_matrix[i][j] = y
        return loss_matrix[a][d]

    def p_safe_stop(self, a, d):
        """Returns a string of probabilities. Element i (starting at 0) is the probability that the attacker loses
        all attacking units but 2 and that the defender has i losses.
        """
        probs = []
        for d_losses in range(d-1):  # looping over all possible losses except for d-1 (when only 1 defender remains)
            d_left = d - d_losses
            # Binomial distribution
            p = (1-self.basic_probs.single_probs["3v2"]) * \
                self.basic_probs.single_probs["3v2"] ** (d-d_left) * \
                (1-self.basic_probs.single_probs["3v2"]) ** (a-3) * \
                factorial(d-d_left + a-3) / factorial(d-d_left) / factorial(a-3)
            probs.append(p)

        # Now considering the special case d_left = 1. To deal with that, a matrix of probabilities is introduced:
        # Position ij of this matrix will give the probability that the attack stops with 2 attackers and 1 defender
        # left. The only way to reach this is from (a,d) = (3,1). The probability to reach (2,1) from (3,
        # 1) is p=(1-p_31). So the matrix element (3,1) will be assigned the value (1-p_31). Each matrix element's
        # value will be the probability that it reaches (2,1). The value of position (i,j) is calculated by taking (
        # i-1,j) times the probability to reach (i-1,j) from (i,j) plus (i,j-1) times the probability to reach (i,
        # j-1) from (i,j).
        matrix = zeros((a+1, d+1))
        for i in range(3, a+1):  # columns
            for j in range(1, d+1):  # rows
                if j == 1:
                    matrix[i][j] = (1-self.basic_probs.single_probs["3v1"])**(i-2)
                elif i == 3 and j != 1:
                    matrix[i][j] = matrix[i][j-1] * self.basic_probs.single_probs["3v2"]
                else:
                    matrix[i][j] = matrix[i][j-1] * self.basic_probs.single_probs["3v2"] + \
                                   matrix[i-1][j] * (1-self.basic_probs.single_probs["3v2"])
        probs.append(matrix[a][d])
        return array(probs)


if __name__ == '__main__':
    composite_probs = CompositeProbabilities()

    start1 = time()
    print(composite_probs.p_matrix(10, 13))
    end1 = time()

    start2 = time()
    print(composite_probs.p_recursive(10, 13))
    end2 = time()

    print('Benötigte Zeit mit matrix Funktion: {:5.3f}s'.format(end1 - start1))
    print('Benötigte Zeit mit matrix2 Funktion: {:5.3f}s'.format(end2 - start2))
