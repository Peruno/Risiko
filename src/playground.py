"""Im gesamten Dokument wird mit der Michelson'schen Verzögerungstaktik gerechnet."""
from src.functions import *
import matplotlib.pyplot as plt
from numpy import zeros, array, arange
import random


def all_in(a, d, pick_result=True):
    win_verluste = zeros(a)
    win_probs = zeros(a)  # position i: probability for the attacker to win with exactly i losses
    loss_verluste = zeros(d)  # position i: probability for the defender to win with exactly i losses
    loss_verluste_safe = zeros(d)
    loss_probs = zeros(d)
    loss_probs_safe = zeros(d)

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

        result = random.choices(result_list, weights=joined_probs)
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
                result_list.append(f'Rückzug mit 2 Truppen mit einem Verlust des Verteidigers.')
            else:
                result_list.append(f'Rückzug mit 2 Truppen mit {j} Verlusten des Verteigers.')

        result = random.choices(result_list, weights=joined_probs)
        print(result)


all_in(30, 25)
