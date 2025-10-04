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

    /// looping over all possible losses except for d-1 (when only 1 defender remains)
    for (int dLosses = 0; dLosses < d - 1; dLosses++) {
      final dLeft = d - dLosses;

      final p =
          (1 - p3v2) *
          math.pow(p3v2, d - dLeft).toDouble() *
          math.pow(1 - p3v2, a - 3).toDouble() *
          binomialCoefficient(d - dLeft + a - 3, d - dLeft);
      probs.add(p);
    }

    /// Now considering the special case d_left = 1. To deal with that, a matrix of probabilities is introduced:
    /// Position ij of this matrix will give the probability that the attack stops with 2 attackers and 1 defender
    /// left. The only way to reach this is from (a,d) = (3,1). The probability to reach (2,1) from (3,
    /// 1) is p=(1-p_31). So the matrix element (3,1) will be assigned the value (1-p_31). Each matrix element's
    /// value will be the probability that it reaches (2,1). The value of position (i,j) is calculated by taking (
    /// i-1,j) times the probability to reach (i-1,j) from (i,j) plus (i,j-1) times the probability to reach (i,
    /// j-1) from (i,j).
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

  double binomialCoefficient(int n, int k) {
    if (n < 0 || k < 0) return 0.0;
    if (n == 0 && k == 0) return 1.0;

    if (k > n) throw ArgumentError('n must be >= k, but got n=$n and k=$k');

    k = math.min(k, n - k);
    double result = 1.0;
    for (int i = 1; i <= k; i++) {
      result *= (n - (k - i));
      result /= i;
    }
    return result;
  }
}
