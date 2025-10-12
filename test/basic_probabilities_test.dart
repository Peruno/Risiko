import 'package:flutter_test/flutter_test.dart';
import 'package:risiko_simulator/calculation/basic_probabilities.dart';

void main() {
  group('BasicProbabilities', () {
    late BasicProbabilities basicProbs = BasicProbabilities();
    late Map<String, double> calculatedProbs;

    setUp(() {
      calculatedProbs = _calculateSingleProbabilities();
    });

    group('Single Dice Roll Probabilities', () {
      test('1v1', () {
        final calculated = calculatedProbs['1v1']!;

        final actual = basicProbs.pSingleWin(1, 1);

        expect(calculated, closeTo(actual, 1e-10));
      });

      test('1v2', () {
        final calculated = calculatedProbs['1v2']!;

        final actual = basicProbs.pSingleWin(1, 2);

        expect(calculated, closeTo(actual, 1e-10));
      });

      test('2v1', () {
        final calculated = calculatedProbs['2v1']!;

        final actual = basicProbs.pSingleWin(2, 1);

        expect(calculated, closeTo(actual, 1e-10));
      });

      test('2v2', () {
        final calculated = calculatedProbs['2v2']!;

        final actual = basicProbs.pSingleWin(2, 2);

        expect(calculated, closeTo(actual, 1e-10));
      });

      test('3v1', () {
        final calculated = calculatedProbs['3v1']!;

        final actual = basicProbs.pSingleWin(3, 1);

        expect(calculated, closeTo(actual, 1e-10));
      });

      test('3v2', () {
        final calculated = calculatedProbs['3v2']!;

        final actual = basicProbs.pSingleWin(3, 2);

        expect(calculated, closeTo(actual, 1e-10));
      });
    });
  });
}

Map<String, double> _calculateSingleProbabilities() {
  final probs = <String, double>{};

  int winsForAttacker1v1 = 0;
  for (int a = 1; a <= 6; a++) {
    for (int d = 1; d <= 6; d++) {
      if (d < a) {
        winsForAttacker1v1++;
      }
    }
  }
  probs['1v1'] = winsForAttacker1v1 / (6 * 6);

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

  int winsForAttacker3v1 = 0;
  for (int a1 = 1; a1 <= 6; a1++) {
    for (int a2 = 1; a2 <= 6; a2++) {
      for (int a3 = 1; a3 <= 6; a3++) {
        for (int d1 = 1; d1 <= 6; d1++) {
          if (d1 < _maxOf3(a1, a2, a3)) {
            winsForAttacker3v1++;
          }
        }
      }
    }
  }
  probs['3v1'] = winsForAttacker3v1 / (6 * 6 * 6 * 6);

  int winsForAttacker3v2 = 0;
  for (int a1 = 1; a1 <= 6; a1++) {
    for (int a2 = 1; a2 <= 6; a2++) {
      for (int a3 = 1; a3 <= 6; a3++) {
        for (int d1 = 1; d1 <= 6; d1++) {
          for (int d2 = 1; d2 <= 6; d2++) {
            if (_max(d1, d2) < _maxOf3(a1, a2, a3)) {
              winsForAttacker3v2++;
            }
          }
        }
      }
    }
  }
  probs['3v2'] = winsForAttacker3v2 / (6 * 6 * 6 * 6 * 6);

  return probs;
}

int _max(int a, int b) => a > b ? a : b;

int _maxOf3(int a, int b, int c) => _max(_max(a, b), c);
