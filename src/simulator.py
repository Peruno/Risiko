from random import choices, random

import matplotlib.pyplot as plt
from numpy import array, arange

from composite_probabilities import CompositeProbabilities


class Simulator:
    def __init__(self):
        self.probs = CompositeProbabilities()

    def all_in(self, a, d, pick_result=True):

        win_probs = {i: self.probs.p_precise_win(a, d, a - i) for i in range(a)}
        loss_probs = {i: self.probs.p_precise_loss(a, d, d - i) for i in range(d)}

        ymax = int(max(list(win_probs.values()) + list(loss_probs.values())) * 100)

        fig, (ax1, ax2) = plt.subplots(1, 2)
        fig.suptitle(f'{a} Angreifer gegen {d} Verteidiger. \n Gesamtwahrscheinlichkeit für einen Sieg:'
                     f' {float("{0:.1f}".format(sum(list(win_probs.values())) * 100))}%')

        ax1.bar(list(win_probs.keys()), [p * 100 for p in win_probs.values()], color='green')
        ax1.set_xticks(array(range(a)))
        ax1.set_ylim(0, ymax + 1)
        ax1.set_xlabel("Verluste des Angreifers")
        ax1.set_ylabel("Wahrscheinlichkeit in %")

        ax2.bar(list(loss_probs.keys()), [p * 100 for p in loss_probs.values()], color='darkred')
        ax2.set_xlim(d - 0.5, -0.5)
        ax2.set_xticks(array(range(0, d)))
        ax2.set_ylim(0, ymax + 1)
        ax2.yaxis.tick_right()
        ax2.set_xlabel("Verluste des Verteidigers")

        plt.show()

        if pick_result:
            scenario, troop_number = Simulator.determine_result(win_probs, loss_probs)
            Simulator.print_results(scenario, troop_number)

    def safe_attack(self, a, d, pick_result=True):
        from matplotlib import rcParams
        rcParams.update({'figure.autolayout': True})  # making sure the text is in the figure

        win_probs = {i: self.probs.p_precise_win(a, d, a - i) for i in range(a - 2)}
        loss_probs = {i: j for (i, j) in zip(arange(d)[::-1], self.probs.p_safe_stop(a, d)[::-1])}

        ymax = int(max(list(win_probs.values()) + list(loss_probs.values())) * 100)

        fig, (ax1, ax2) = plt.subplots(1, 2)
        fig.suptitle(f'{a} Angreifer gegen {d} Verteidiger. \n Gesamtwahrscheinlichkeit für einen Sieg:'
                     f' {float("{0:.1f}".format(sum(list(win_probs.values())) * 100))}% \n (Sicherer Angriff)')

        ax1.bar(list(win_probs.keys()), [p * 100 for p in win_probs.values()], color='green')
        ax1.set_xticks(array(range(a - 2)))
        ax1.set_ylim(0, ymax + 1)
        ax1.set_xlabel("Verluste des Angreifers")
        ax1.set_ylabel("Wahrscheinlichkeit in %")

        ax2.bar(list(loss_probs.keys()), [p * 100 for p in loss_probs.values()], color='darkred')
        ax2.set_xlim(d - 0.5, -0.5)
        ax2.set_xticks(array(range(0, d)))
        ax2.set_ylim(0, ymax + 1)
        ax2.yaxis.tick_right()
        ax2.set_xlabel("Verluste des Verteidigers \n bei Abbruch des Angriffs")

        plt.show()

        if pick_result:
            scenario, troop_number = Simulator.determine_result(win_probs, loss_probs, is_safe_attack=True)
            Simulator.print_results(scenario, troop_number)

    @staticmethod
    def determine_result(win_probs, loss_probs, is_safe_attack=False):
        if random() < sum(win_probs.values()):
            scenario = "Sieg"
            result = choices(list(win_probs.keys()), weights=list(win_probs.values()))
        elif not is_safe_attack:
            scenario = "Niederlage"
            result = choices(list(loss_probs.keys()), weights=list(loss_probs.values()))
        else:
            scenario = "Rückzug"
            result = choices(list(loss_probs.keys()), weights=list(loss_probs.values()))

        return scenario, result[0]

    @staticmethod
    def print_results(scenario, troop_number):
        if scenario == "Rückzug":
            print("Rückzug des Angreifers mit 2 Truppen!")
            print(f"Verluste des Verteidigers: {troop_number}")

        elif scenario == "Sieg":
            print("Sieg des Angreifers!")
            print(f"Verluste des Angreifers: {troop_number}")

        elif scenario == "Niederlage":
            print("Sieg des Verteidigers!")
            print(f"Verluste des Verteidigers: {troop_number}")
