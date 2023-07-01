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

        win_probs = [probs.p_precise_win(a, d, a_min) for a_min in range(a + 1)]

        tolerance = 0.0000001
        assert abs(sum(win_probs) - probs.p_matrix(a, d)) < tolerance


def test_sum_of_precise_loss():
    for _ in range(10):
        a = randint(1, 15)
        d = randint(1, 15)

        loss_probs = [probs.p_precise_loss(a, d, d_min) for d_min in range(1, d + 1)]

        tolerance = 0.0000001
        assert abs(sum(loss_probs) - (1 - probs.p_matrix(a, d))) < tolerance


def test_sum_of_all_possibilities():
    for _ in range(10):
        a = randint(1, 15)
        d = randint(1, 15)

        loss_probs = [probs.p_precise_loss(a, d, d_min) for d_min in range(1, d + 1)]
        win_probs = [probs.p_precise_win(a, d, a_min) for a_min in range(a + 1)]

        tolerance = 0.000001
        assert abs(1 - (sum(loss_probs) + sum(win_probs))) < tolerance
