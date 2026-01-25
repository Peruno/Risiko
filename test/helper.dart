
import 'package:risiko_simulator/calculation/basic_probabilities.dart';

class Helper {

  late BasicProbabilities basicProbabilities = BasicProbabilities();


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
          double singleWinProb = basicProbabilities.pSingleWin(i, j);
          y = singleWinProb * riskMatrix[i][j - 1] +
              (1 - singleWinProb) * riskMatrix[i - 1][j];
        }
        riskMatrix[i][j] = y;
      }
    }

    return riskMatrix[a][d];
  }
}
