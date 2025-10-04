import 'dart:math' as math;
import 'basic_probabilities.dart';

class CompositeProbabilities {
  late final BasicProbabilities _basicProbs;

  CompositeProbabilities() {
    _basicProbs = BasicProbabilities();
  }

  /// Using the matrix-method to calculate the probability to win an attack with a attackers against d defenders.
  /// Each element given by (i,j) holds the probability to win with i attackers against j defenders. The next element
  /// will always be calculated using the ones before: (i, j-1) and (i-1, j) -> (i, j)
  double pMatrix(int a, int d) {
    if (a < 1) {
      throw ArgumentError('Number of attackers must be at least 1, got: $a');
    }
    if (d < 1) {
      throw ArgumentError('Number of defenders must be at least 1, got: $d');
    }

    final riskMatrix = List.generate(a + 1, (i) => List.filled(d + 1, 0.0));

    for (int i = 0; i <= a; i++) {
      for (int j = 0; j <= d; j++) {
        double y;
        if (i == 0) {
          y = 0.0;
        } else if (j == 0) {
          y = 1.0;
        } else {
          final singleWinProb = _basicProbs.pSingleWin(i, j);
          y = singleWinProb * riskMatrix[i][j - 1] + (1 - singleWinProb) * riskMatrix[i - 1][j];
        }
        riskMatrix[i][j] = y;
      }
    }

    return riskMatrix[a][d];
  }

  /// Returns the probability to win an attack with [a] attackers against [d] defenders
  /// and have exactly [aLeft] attackers left afterward.
  double pPreciseWin(int a, int d, int aLeft) {
    if (a < 1) {
      throw ArgumentError('Number of attackers must be at least 1, got: $a');
    }
    if (d < 1) {
      throw ArgumentError('Number of defenders must be at least 1, got: $d');
    }
    if (aLeft < 0 || aLeft > a) {
      throw ArgumentError('Attackers left must be between 0 and $a, got: $aLeft');
    }

    final winMatrix = List.generate(a + 1, (i) => List.filled(d + 1, 0.0));

    for (int i = 0; i <= a; i++) {
      for (int j = 0; j <= d; j++) {
        double y;
        if (i == 0) {
          y = 0.0;
        } else if (i < aLeft) {
          y = 0.0;
        } else if (i > aLeft && j == 0) {
          y = 0.0;
        } else if (i == aLeft && j == 0) {
          y = 1.0;
        } else {
          final singleWinProb = _basicProbs.pSingleWin(i, j);
          y = singleWinProb * winMatrix[i][j - 1] + (1 - singleWinProb) * winMatrix[i - 1][j];
        }
        winMatrix[i][j] = y;
      }
    }

    return winMatrix[a][d];
  }

  /// Returns the probability to lose an attack with [a] attackers against [d] defenders
  /// with the condition that there are exactly [dLeft] defenders left afterward.
  double pPreciseLoss(int a, int d, int dLeft) {
    if (a < 1) {
      throw ArgumentError('Number of attackers must be at least 1, got: $a');
    }
    if (d < 1) {
      throw ArgumentError('Number of defenders must be at least 1, got: $d');
    }
    if (dLeft < 1 || dLeft > d) {
      throw ArgumentError('Defenders left must be between 1 and $d, got: $dLeft');
    }

    final lossMatrix = List.generate(a + 1, (i) => List.filled(d + 1, 0.0));

    for (int i = 0; i <= a; i++) {
      for (int j = 0; j <= d; j++) {
        double y;
        if (j == 0) {
          y = 0.0;
        } else if (j < dLeft) {
          y = 0.0;
        } else if (i == 0 && j > dLeft) {
          y = 0.0;
        } else if (j == dLeft && i == 0) {
          y = 1.0;
        } else {
          final singleWinProb = _basicProbs.pSingleWin(i, j);
          y = singleWinProb * lossMatrix[i][j - 1] + (1 - singleWinProb) * lossMatrix[i - 1][j];
        }
        lossMatrix[i][j] = y;
      }
    }

    return lossMatrix[a][d];
  }

  /// Returns probabilities for safe attack mode where attacker stops at 2 troops.
  /// Element i is the probability that the attacker loses all attacking units but 2
  /// and that the defender has i losses.
  List<double> pSafeStop(int a, int d) {
    if (a < 3) {
      throw ArgumentError('Safe attack requires at least 3 attackers, got: $a');
    }
    if (d < 1) {
      throw ArgumentError('Number of defenders must be at least 1, got: $d');
    }

    final probs = <double>[];
    final p3v2 = _basicProbs.pSingleWin(3, 2);
    final p3v1 = _basicProbs.pSingleWin(3, 1);

    for (int dLosses = 0; dLosses < d - 1; dLosses++) {
      final dLeft = d - dLosses;
      final p =
          (1 - p3v2) *
          math.pow(p3v2, d - dLeft).toDouble() *
          math.pow(1 - p3v2, a - 3).toDouble() *
          _factorial(d - dLeft + a - 3) /
          (_factorial(d - dLeft) * _factorial(a - 3));
      probs.add(p);
    }

    final matrix = List.generate(a + 1, (i) => List.filled(d + 1, 0.0));

    for (int i = 3; i <= a; i++) {
      for (int j = 1; j <= d; j++) {
        if (j == 1) {
          matrix[i][j] = math.pow(1 - p3v1, i - 2).toDouble();
        } else if (i == 3 && j != 1) {
          matrix[i][j] = matrix[i][j - 1] * p3v2;
        } else {
          matrix[i][j] = matrix[i][j - 1] * p3v2 + matrix[i - 1][j] * (1 - p3v2);
        }
      }
    }

    probs.add(matrix[a][d]);
    return probs;
  }

  double _factorial(int n) {
    if (n < 0) return 0;
    if (n <= 1) return 1;
    return n * _factorial(n - 1);
  }
}
