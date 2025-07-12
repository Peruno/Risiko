import 'basic_probabilities.dart';

/// Composite probability calculations for Risk battle outcomes.
/// 
/// This class calculates the probability that attackers win an entire battle
/// against defenders using matrix-based approaches.
class CompositeProbabilities {
  late final BasicProbabilities _basicProbs;

  CompositeProbabilities() {
    _basicProbs = BasicProbabilities();
  }

  /// Returns the probability to win an attack with [a] attackers against [d] defenders
  /// using a matrix-based dynamic programming approach.
  /// 
  /// Creates a matrix where element (i,j) holds the probability to win with i attackers
  /// against j defenders. Each element is calculated using previously computed values:
  /// (i, j-1) and (i-1, j) to compute (i, j).
  /// 
  /// This approach is more efficient than recursion for large values as it avoids
  /// redundant calculations.
  double pMatrix(int a, int d) {
    // Create a (a+1) x (d+1) matrix initialized with zeros
    final riskMatrix = List.generate(
      a + 1, 
      (i) => List.filled(d + 1, 0.0)
    );

    // Fill the matrix using dynamic programming
    for (int i = 0; i <= a; i++) {
      for (int j = 0; j <= d; j++) {
        double y;
        if (i == 0) {
          // No attackers left - attacker loses
          y = 0.0;
        } else if (j == 0) {
          // No defenders left - attacker wins
          y = 1.0;
        } else {
          // Calculate using previously computed values
          final singleWinProb = _basicProbs.pSingleWin(i, j);
          y = singleWinProb * riskMatrix[i][j - 1] +
              (1 - singleWinProb) * riskMatrix[i - 1][j];
        }
        riskMatrix[i][j] = y;
      }
    }

    return riskMatrix[a][d];
  }
}