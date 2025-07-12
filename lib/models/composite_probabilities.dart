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
    
    final riskMatrix = List.generate(
      a + 1, 
      (i) => List.filled(d + 1, 0.0)
    );

    for (int i = 0; i <= a; i++) {
      for (int j = 0; j <= d; j++) {
        double y;
        if (i == 0) {
          y = 0.0;
        } else if (j == 0) {
          y = 1.0;
        } else {
          final singleWinProb = _basicProbs.pSingleWin(i, j);
          y = singleWinProb * riskMatrix[i][j - 1] +
              (1 - singleWinProb) * riskMatrix[i - 1][j];
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

    final winMatrix = List.generate(
      a + 1, 
      (i) => List.filled(d + 1, 0.0)
    );

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
          y = singleWinProb * winMatrix[i][j - 1] +
              (1 - singleWinProb) * winMatrix[i - 1][j];
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

    final lossMatrix = List.generate(
      a + 1, 
      (i) => List.filled(d + 1, 0.0)
    );

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
          y = singleWinProb * lossMatrix[i][j - 1] +
              (1 - singleWinProb) * lossMatrix[i - 1][j];
        }
        lossMatrix[i][j] = y;
      }
    }

    return lossMatrix[a][d];
  }
}