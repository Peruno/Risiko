from numpy import zeros, array, arange
from probabilities import p_32, p_31, p_22, p_21, p_12, p_11
from math import factorial
from random import choices
from time import time
import matplotlib.pyplot as plt


def p_swin(a, d):
    """Returns the probability to win a single roll of the dices as attacker.
    a: number of atackers
    d: number of defenders"""
    if a == 0:
        return 0
    elif d == 0:
        return 1
    elif a >= 3 and d >= 2:
        return p_32
    elif a >= 3 and d == 1:
        return p_31
    elif a == 2 and d >= 2:
        return p_22
    elif a == 2 and d == 1:
        return p_21
    elif a == 1 and d >= 2:
        return p_12
    elif a == 1 and d == 1:
        return p_11


def p_recursive(a, d):
    """Returns the probability to win an attack with a attackers against d defenders. Careful: for large a and d,
    this function is very slow. Use p_matrix() instead."""
    if a == 0:
        y = 0
    elif d == 0:
        y = 1
    else:
        y = p_swin(a, d) * p_recursive(a, d-1) + (1-p_swin(a, d)) * p_recursive(a-1, d)
    return y


def p_matrix(a, d):
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
                y = p_swin(i, j) * risk_matrix[i][j - 1] + (1-p_swin(i, j)) * risk_matrix[i - 1][j]
            risk_matrix[i][j] = y
    return risk_matrix[a][d]


def p_precise_win(a, d, a_min):
    """Returns the probability to win an attack with a attackers against d defenders and have exactly a_min attackers
    left afterwards."""
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
                y = p_swin(i, j) * win_matrix[i][j - 1]
            elif i > a_min and j == 0:
                y = 0
            elif i > a_min and j > 0:
                y = p_swin(i, j) * win_matrix[i][j - 1] + (1-p_swin(i, j)) * win_matrix[i - 1][j]
            win_matrix[i][j] = y
    return win_matrix[a][d]


def p_precise_loss(a, d, d_min):
    """Returns the probability to lose an attack with a attackers against d defenders with the condition, that there
        are exactly d_min defenders left afterwards."""
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
                y = (1-p_swin(i, j)) * loss_matrix[i - 1][j]
            elif j > d_min and i > 0:
                y = p_swin(i, j) * loss_matrix[i][j - 1] + (1-p_swin(i, j)) * loss_matrix[i - 1][j]
            loss_matrix[i][j] = y
    return loss_matrix[a][d]


def p_safe_stop(a, d):
    """Returns a string of probabilities. Element i (starting at 0) is the probability that the attacker loses
    all attacking units but 2 and that the defender has i losses."""
    probs = []
    for d_losses in range(d-1): # looping over all possible losses except for d-1 (when only 1 defender remains)
        d_left = d - d_losses
        # Binomial distribution
        p = (1-p_32) * p_32**(d-d_left) * (1-p_32)**(a-3) * factorial(d-d_left + a-3)/factorial(d-d_left)/factorial(a-3)
        probs.append(p)

    # Now considering the special case d_left = 1. To deal with that, a matrix of probabilities is introduced:
    # Position ij of this matrix will give the probability that the attack stops with 2 attackers and 1 defender left.
    # The only way to reach this is from (a,d) = (3,1). The probability to reach (2,1) from (3,1) is p=(1-p_31). So
    # the matrix element (3,1) will be assigned the value (1-p_31). Each matrix element's value will be the probability
    # that it reaches (2,1). The value of position (i,j) is calculated by taking (i-1,j) times the probability to reach
    # (i-1,j) from (i,j) plus (i,j-1) times the probability to reach (i,j-1) from (i,j).
    matrix = zeros((a+1, d+1))
    for i in range(3, a+1):  # columns
        for j in range(1, d+1):  # rows
            if j == 1:
                matrix[i][j] = (1-p_31)**(i-2)
            elif i == 3 and j != 1:
                matrix[i][j] = matrix[i][j-1] * p_32
            else:
                matrix[i][j] = matrix[i][j-1] * p_32 + matrix[i-1][j] * (1-p_32)
    probs.append(matrix[a][d])
    return array(probs)


def all_in(a, d, pick_result=True):
    win_verluste = zeros(a)
    win_probs = zeros(a)  # position i: probability for the attacker to win with exactly i losses
    loss_verluste = zeros(d)  # position i: probability for the defender to win with exactly i losses
    loss_probs = zeros(d)

    # attacker wins
    for i in range(a):
        win_verluste[i] = i
        win_probs[i] = p_precise_win(a, d, a - i)

    # attacker loses
    for i in range(d):
        loss_verluste[i] = i
        loss_probs[i] = p_precise_loss(a, d, d - i)

    ymax = int(max(max(win_probs), max(loss_probs))*100)

    fig, (ax1, ax2) = plt.subplots(1, 2)
    fig.suptitle(f'{a} Angreifer gegen {d} Verteidiger. \n Gesamtwahrscheinlichkeit für einen Sieg:'
                 f' {float("{0:.1f}".format(sum(win_probs)*100))}%')

    ax1.bar(array(win_verluste), array(win_probs*100), color='darkred')
    ax1.set_xticks(array(range(a)))
    ax1.set_ylim(0, ymax + 1)
    ax1.set_xlabel("Verluste des Angreifers")
    ax1.set_ylabel("Wahrscheinlichkeit in %")

    ax2.bar(loss_verluste, loss_probs*100, color='green')
    ax2.set_xlim(d-0.5, -0.5)
    ax2.set_xticks(array(range(0, d)))
    ax2.set_ylim(0, ymax + 1)
    ax2.yaxis.tick_right()
    ax2.set_xlabel("Verluste des Verteidigers")

    plt.show()

    if pick_result:
        joined_probs = list(win_probs) + list(loss_probs)
        result_list = []
        for i in range(a):
            if i == 0:
                result_list.append(f'Sieg des Angreifers ohne Verluste.')
            elif i == 1:
                result_list.append(f'Sieg des Angreifers mit einem Verlust.')
            else:
                result_list.append(f'Sieg des Angreifers mit {i} Verlusten.')

        for j in range(d):
            if j == 0:
                result_list.append(f'Sieg des Verteidigers ohne Verluste.')
            elif j == 1:
                result_list.append(f'Sieg des Verteidigers mit einem Verlust.')
            else:
                result_list.append(f'Sieg des Verteidigers mit {j} Verlusten.')

        result = choices(result_list, weights=joined_probs) # from the random module
        print(result)
        print(sum(joined_probs))


def safe_attack(a, d, pick_result=True):
    from matplotlib import rcParams
    rcParams.update({'figure.autolayout': True})  # making sure the text is in the figure

    win_verluste = arange(a-2)
    win_probs = zeros(a-2)  # position i: probability for the attacker to win with exactly i losses
    retreat_def_losses = arange(d)  # position i: probability to lose i defenders

    # attacker wins
    for i in range(a-2):
        win_probs[i] = p_precise_win(a, d, a - i)

    # attacker retreats
    retreat_probs = p_safe_stop(a, d)

    ymax = int(max(max(win_probs), max(retreat_probs)) * 100)

    fig, (ax1, ax2) = plt.subplots(1, 2)
    fig.suptitle(f'{a} Angreifer gegen {d} Verteidiger. \n Gesamtwahrscheinlichkeit für einen Sieg:'
                 f' {float("{0:.1f}".format(sum(win_probs) * 100))}% \n (Sicherer Angriff)')

    ax1.bar(array(win_verluste), array(win_probs * 100), color='darkred')
    ax1.set_xticks(array(range(a-2)))
    ax1.set_ylim(0, ymax + 1)
    ax1.set_xlabel("Verluste des Angreifers")
    ax1.set_ylabel("Wahrscheinlichkeit in %")

    ax2.bar(retreat_def_losses[::-1], retreat_probs[::-1] * 100, color='green') # reversing order
    ax2.set_xlim(d - 0.5, -0.5)
    ax2.set_xticks(array(range(0, d)))
    ax2.set_ylim(0, ymax + 1)
    ax2.yaxis.tick_right()
    ax2.set_xlabel("Verluste des Verteidigers \n bei Abbruch des Angriffs")

    plt.show()

    if pick_result:
        joined_probs = list(win_probs) + list(retreat_probs)
        result_list = []
        for i in range(a-2):
            if i == 0:
                result_list.append(f'Sieg des Angreifers ohne Verluste.')
            elif i == 1:
                result_list.append(f'Sieg des Angreifers mit einem Verlust.')
            else:
                result_list.append(f'Sieg des Angreifers mit {i} Verlusten.')

        for j in range(d):
            if j == 0:
                result_list.append(f'Rückzug mit 2 Truppen ohne Verluste des Verteidigers.')
            elif j == 1:
                result_list.append(f'Rückzug mit 2 Truppen bei einem Verlust des Verteidigers.')
            else:
                result_list.append(f'Rückzug mit 2 Truppen bei {j} Verlusten des Verteigers.')

        result = choices(result_list, weights=joined_probs)
        print(result)


if __name__ == '__main__not':
    start1 = time()
    print(p_matrix(15, 25))
    end1 = time()

    start2 = time()
    print(p_recursive(15, 20))
    end2 = time()

    print('Benötigte Zeit mit matrix Funktion: {:5.3f}s'.format(end1 - start1))
    print('Benötigte Zeit mit matrix2 Funktion: {:5.3f}s'.format(end2 - start2))

