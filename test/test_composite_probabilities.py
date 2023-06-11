from random import randint
from src.composite_probabilities import CompositeProbabilities

probs = CompositeProbabilities()


def test_recursive_equals_matrix_method():
    for _ in range(10):
        a = randint(1, 12)
        d = randint(1, 12)

        assert probs.p_recursive(a, d) == probs.p_matrix(a, d)


def test_sum_of_precise_win():
    for _ in range(10):
        a = randint(1, 15)
        d = randint(1, 15)

        total_win_prob = 0
        for a_min in range(1, a + 1):
            total_win_prob += probs.p_precise_win(a, d, a_min)

        tolerance = 0.0000001
        assert abs(total_win_prob - probs.p_matrix(a, d)) < tolerance


def test_sum_of_precise_loss():
    for _ in range(10):
        a = randint(1, 15)
        d = randint(1, 15)

        total_loss_prob = 0
        for d_min in range(1, d + 1):
            total_loss_prob += probs.p_precise_loss(a, d, d_min)

        tolerance = 0.0000001
        assert abs(total_loss_prob - (1 - probs.p_matrix(a, d))) < tolerance


