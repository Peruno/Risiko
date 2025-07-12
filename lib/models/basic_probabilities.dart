/// Basic probability calculations for Risk battle dice rolls.
/// 
/// This class calculates the probability that attackers win a single dice roll
/// against defenders for all possible combinations (1v1, 1v2, 2v1, 2v2, 3v1, 3v2).
class BasicProbabilities {
  late final Map<String, double> _singleProbs;

  BasicProbabilities() {
    _singleProbs = _calculateSingleProbabilities();
  }

  /// Returns a copy of the single roll probabilities map
  Map<String, double> get singleProbs => Map.from(_singleProbs);

  /// Calculates all single dice roll probabilities
  Map<String, double> _calculateSingleProbabilities() {
    final probs = <String, double>{};

    // 1v1: Single attacker die vs single defender die
    int winsForAttacker1v1 = 0;
    for (int a = 1; a <= 6; a++) {
      for (int d = 1; d <= 6; d++) {
        if (d < a) {
          winsForAttacker1v1++;
        }
      }
    }
    probs['1v1'] = winsForAttacker1v1 / (6 * 6);
    print('Dart 1v1: $winsForAttacker1v1/36 = ${probs['1v1']}');

    // 1v2: Single attacker die vs two defender dice (highest defender die wins)
    int winsForAttacker1v2 = 0;
    for (int a = 1; a <= 6; a++) {
      for (int d1 = 1; d1 <= 6; d1++) {
        for (int d2 = 1; d2 <= 6; d2++) {
          if (_max(d1, d2) < a) {
            winsForAttacker1v2++;
          }
        }
      }
    }
    probs['1v2'] = winsForAttacker1v2 / (6 * 6 * 6);
    print('Dart 1v2: $winsForAttacker1v2/216 = ${probs['1v2']}');

    // 2v1: Two attacker dice vs single defender die (highest attacker die wins)
    int winsForAttacker2v1 = 0;
    for (int a1 = 1; a1 <= 6; a1++) {
      for (int a2 = 1; a2 <= 6; a2++) {
        for (int d1 = 1; d1 <= 6; d1++) {
          if (d1 < _max(a1, a2)) {
            winsForAttacker2v1++;
          }
        }
      }
    }
    probs['2v1'] = winsForAttacker2v1 / (6 * 6 * 6);
    print('Dart 2v1: $winsForAttacker2v1/216 = ${probs['2v1']}');

    // 2v2: Two attacker dice vs two defender dice (highest vs highest)
    int winsForAttacker2v2 = 0;
    for (int a1 = 1; a1 <= 6; a1++) {
      for (int a2 = 1; a2 <= 6; a2++) {
        for (int d1 = 1; d1 <= 6; d1++) {
          for (int d2 = 1; d2 <= 6; d2++) {
            if (_max(d1, d2) < _max(a1, a2)) {
              winsForAttacker2v2++;
            }
          }
        }
      }
    }
    probs['2v2'] = winsForAttacker2v2 / (6 * 6 * 6 * 6);
    print('Dart 2v2: $winsForAttacker2v2/1296 = ${probs['2v2']}');

    // 3v1: Three attacker dice vs single defender die (highest attacker die wins)
    int winsForAttacker3v1 = 0;
    for (int a1 = 1; a1 <= 6; a1++) {
      for (int a2 = 1; a2 <= 6; a2++) {
        for (int a3 = 1; a3 <= 6; a3++) {
          for (int d1 = 1; d1 <= 6; d1++) {
            if (d1 < _max3(a1, a2, a3)) {
              winsForAttacker3v1++;
            }
          }
        }
      }
    }
    probs['3v1'] = winsForAttacker3v1 / (6 * 6 * 6 * 6);
    print('Dart 3v1: $winsForAttacker3v1/1296 = ${probs['3v1']}');

    // 3v2: Three attacker dice vs two defender dice (highest vs highest)
    int winsForAttacker3v2 = 0;
    for (int a1 = 1; a1 <= 6; a1++) {
      for (int a2 = 1; a2 <= 6; a2++) {
        for (int a3 = 1; a3 <= 6; a3++) {
          for (int d1 = 1; d1 <= 6; d1++) {
            for (int d2 = 1; d2 <= 6; d2++) {
              if (_max(d1, d2) < _max3(a1, a2, a3)) {
                winsForAttacker3v2++;
              }
            }
          }
        }
      }
    }
    probs['3v2'] = winsForAttacker3v2 / (6 * 6 * 6 * 6 * 6);
    print('Dart 3v2: $winsForAttacker3v2/7776 = ${probs['3v2']}');

    return probs;
  }

  /// Returns the probability to win a single roll of the dice as attacker.
  /// 
  /// [a]: number of attackers
  /// [d]: number of defenders
  double pSingleWin(int a, int d) {
    if (a == 0) {
      return 0.0;
    } else if (d == 0) {
      return 1.0;
    } else if (a >= 3 && d >= 2) {
      return _singleProbs['3v2']!;
    } else if (a >= 3 && d == 1) {
      return _singleProbs['3v1']!;
    } else if (a == 2 && d >= 2) {
      return _singleProbs['2v2']!;
    } else if (a == 2 && d == 1) {
      return _singleProbs['2v1']!;
    } else if (a == 1 && d >= 2) {
      return _singleProbs['1v2']!;
    } else if (a == 1 && d == 1) {
      return _singleProbs['1v1']!;
    } else {
      throw ArgumentError('Invalid attacker/defender combination: $a vs $d');
    }
  }

  /// Helper function to find maximum of two integers
  int _max(int a, int b) => a > b ? a : b;

  /// Helper function to find maximum of three integers
  int _max3(int a, int b, int c) => _max(_max(a, b), c);
}