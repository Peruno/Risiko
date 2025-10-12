class BasicProbabilities {
  double pSingleWin(int a, int d) {
    if (a == 0) {
      return 0.0;
    } else if (d == 0) {
      return 1.0;
    } else if (a >= 3 && d >= 2) {
      return 3667 / 7776;
    } else if (a >= 3 && d == 1) {
      return 855 / 1296;
    } else if (a == 2 && d >= 2) {
      return 505 / 1296;
    } else if (a == 2 && d == 1) {
      return 125 / 216;
    } else if (a == 1 && d >= 2) {
      return 55 / 216;
    } else if (a == 1 && d == 1) {
      return 15 / 36;
    } else {
      throw ArgumentError('Invalid attacker/defender combination: $a vs $d');
    }
  }
}
