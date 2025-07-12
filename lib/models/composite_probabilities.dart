import 'basic_probabilities.dart';

class CompositeProbabilities {
  late final BasicProbabilities _basicProbs;

  CompositeProbabilities() {
    _basicProbs = BasicProbabilities();
  }

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
}