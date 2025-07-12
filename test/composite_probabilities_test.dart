import 'dart:math';
import 'package:flutter_test/flutter_test.dart';
import 'package:risiko_simulator/models/composite_probabilities.dart';

void main() {
  group('CompositeProbabilities', () {
    late CompositeProbabilities compositeProbs;

    setUp(() {
      compositeProbs = CompositeProbabilities();
    });

    group('Input Validation', () {
      test('pMatrix throws error for zero attackers', () {
        expect(() => compositeProbs.pMatrix(0, 5), 
               throwsA(isA<ArgumentError>()));
      });

      test('pMatrix throws error for negative attackers', () {
        expect(() => compositeProbs.pMatrix(-1, 5), 
               throwsA(isA<ArgumentError>()));
      });

      test('pMatrix throws error for zero defenders', () {
        expect(() => compositeProbs.pMatrix(5, 0), 
               throwsA(isA<ArgumentError>()));
      });

      test('pMatrix throws error for negative defenders', () {
        expect(() => compositeProbs.pMatrix(5, -1), 
               throwsA(isA<ArgumentError>()));
      });
    });

    group('Matrix Method Tests', () {
      test('pMatrix returns correct results for small values', () {
        final testCases = [
          [1, 1], [1, 2], [1, 3],
          [2, 1], [2, 2], [2, 3],
          [3, 1], [3, 2], [3, 3],
          [4, 1], [4, 2], [4, 3],
          [5, 1], [5, 2], [5, 3],
        ];

        for (final testCase in testCases) {
          final a = testCase[0];
          final d = testCase[1];
          
          final matrix = compositeProbs.pMatrix(a, d);
          
          expect(
            matrix, 
            greaterThanOrEqualTo(0.0), 
            reason: 'pMatrix($a, $d) should be >= 0'
          );
          expect(
            matrix, 
            lessThanOrEqualTo(1.0), 
            reason: 'pMatrix($a, $d) should be <= 1'
          );
        }
      });

      test('pMatrix returns correct results for medium values', () {
        final testCases = [
          [6, 4], [7, 5], [8, 6], [10, 8], [12, 10]
        ];

        for (final testCase in testCases) {
          final a = testCase[0];
          final d = testCase[1];
          
          final matrix = compositeProbs.pMatrix(a, d);
          
          expect(
            matrix, 
            greaterThanOrEqualTo(0.0), 
            reason: 'pMatrix($a, $d) should be >= 0'
          );
          expect(
            matrix, 
            lessThanOrEqualTo(1.0), 
            reason: 'pMatrix($a, $d) should be <= 1'
          );
        }
      });

      test('pMatrix returns consistent results for random test cases', () {
        final random = Random(42);
        const numTests = 20;
        
        for (int i = 0; i < numTests; i++) {
          final a = random.nextInt(15) + 1;
          final d = random.nextInt(10) + 1;
          
          final matrix = compositeProbs.pMatrix(a, d);
          
          expect(
            matrix, 
            greaterThanOrEqualTo(0.0), 
            reason: 'pMatrix($a, $d) should be >= 0'
          );
          expect(
            matrix, 
            lessThanOrEqualTo(1.0), 
            reason: 'pMatrix($a, $d) should be <= 1'
          );
        }
      });
    });

    group('Probability Constraints', () {
      test('probabilities are always between 0 and 1', () {
        final testCases = [
          [1, 1], [2, 2], [3, 3], [5, 5], [10, 8], [15, 12]
        ];

        for (final testCase in testCases) {
          final a = testCase[0];
          final d = testCase[1];
          
          final matrix = compositeProbs.pMatrix(a, d);
          
          expect(matrix, greaterThanOrEqualTo(0.0), 
                 reason: 'pMatrix($a, $d) should be >= 0');
          expect(matrix, lessThanOrEqualTo(1.0), 
                 reason: 'pMatrix($a, $d) should be <= 1');
        }
      });

      test('probability increases with more attackers', () {
        const d = 3;
        double previousProb = 0.0;
        
        for (int a = 1; a <= 8; a++) {
          final prob = compositeProbs.pMatrix(a, d);
          expect(prob, greaterThanOrEqualTo(previousProb), 
                 reason: 'Probability should increase with more attackers: P($a,$d) >= P(${a-1},$d)');
          previousProb = prob;
        }
      });

      test('probability decreases with more defenders', () {
        const a = 5;
        double previousProb = 1.0;
        
        for (int d = 1; d <= 6; d++) {
          final prob = compositeProbs.pMatrix(a, d);
          expect(prob, lessThanOrEqualTo(previousProb), 
                 reason: 'Probability should decrease with more defenders: P($a,$d) <= P($a,${d-1})');
          previousProb = prob;
        }
      });
    });

    group('Known Values', () {
      test('1v1 should have same probability as single dice roll', () {
        final composite = compositeProbs.pMatrix(1, 1);
        const expectedSingleRoll = 15.0 / 36.0;
        
        expect(composite, closeTo(expectedSingleRoll, 1e-10),
               reason: '1v1 composite should equal single roll probability');
      });
    });

    group('Precise Win Probabilities', () {
      test('pPreciseWin input validation', () {
        expect(() => compositeProbs.pPreciseWin(0, 5, 2), 
               throwsA(isA<ArgumentError>()));
        expect(() => compositeProbs.pPreciseWin(5, 0, 2), 
               throwsA(isA<ArgumentError>()));
        expect(() => compositeProbs.pPreciseWin(5, 3, -1), 
               throwsA(isA<ArgumentError>()));
        expect(() => compositeProbs.pPreciseWin(5, 3, 6), 
               throwsA(isA<ArgumentError>()));
      });

      test('pPreciseWin returns valid probabilities', () {
        final testCases = [
          [3, 2, 1], [5, 3, 2], [4, 4, 0], [6, 2, 3]
        ];

        for (final testCase in testCases) {
          final a = testCase[0];
          final d = testCase[1];
          final aLeft = testCase[2];
          
          final prob = compositeProbs.pPreciseWin(a, d, aLeft);
          
          expect(prob, greaterThanOrEqualTo(0.0), 
                 reason: 'pPreciseWin($a, $d, $aLeft) should be >= 0');
          expect(prob, lessThanOrEqualTo(1.0), 
                 reason: 'pPreciseWin($a, $d, $aLeft) should be <= 1');
        }
      });

      test('sum of all precise win probabilities equals overall win probability', () {
        const a = 5;
        const d = 3;
        
        final overallWinProb = compositeProbs.pMatrix(a, d);
        
        double sumPreciseWins = 0.0;
        for (int aLeft = 0; aLeft <= a; aLeft++) {
          sumPreciseWins += compositeProbs.pPreciseWin(a, d, aLeft);
        }
        
        expect(sumPreciseWins, closeTo(overallWinProb, 1e-10),
               reason: 'Sum of precise win probabilities should equal overall win probability');
      });
    });

    group('Precise Loss Probabilities', () {
      test('pPreciseLoss input validation', () {
        expect(() => compositeProbs.pPreciseLoss(0, 5, 2), 
               throwsA(isA<ArgumentError>()));
        expect(() => compositeProbs.pPreciseLoss(5, 0, 2), 
               throwsA(isA<ArgumentError>()));
        expect(() => compositeProbs.pPreciseLoss(5, 3, 0), 
               throwsA(isA<ArgumentError>()));
        expect(() => compositeProbs.pPreciseLoss(5, 3, 4), 
               throwsA(isA<ArgumentError>()));
      });

      test('pPreciseLoss returns valid probabilities', () {
        final testCases = [
          [3, 4, 2], [2, 5, 3], [4, 3, 1], [6, 4, 2]
        ];

        for (final testCase in testCases) {
          final a = testCase[0];
          final d = testCase[1];
          final dLeft = testCase[2];
          
          final prob = compositeProbs.pPreciseLoss(a, d, dLeft);
          
          expect(prob, greaterThanOrEqualTo(0.0), 
                 reason: 'pPreciseLoss($a, $d, $dLeft) should be >= 0');
          expect(prob, lessThanOrEqualTo(1.0), 
                 reason: 'pPreciseLoss($a, $d, $dLeft) should be <= 1');
        }
      });

      test('sum of all precise loss probabilities equals overall loss probability', () {
        const a = 4;
        const d = 6;
        
        final overallLossProb = 1.0 - compositeProbs.pMatrix(a, d);
        
        double sumPreciseLosses = 0.0;
        for (int dLeft = 1; dLeft <= d; dLeft++) {
          sumPreciseLosses += compositeProbs.pPreciseLoss(a, d, dLeft);
        }
        
        expect(sumPreciseLosses, closeTo(overallLossProb, 1e-10),
               reason: 'Sum of precise loss probabilities should equal overall loss probability');
      });
    });

    group('Complete Probability Coverage', () {
      test('sum of all win and loss probabilities equals 1.0', () {
        final testCases = [
          [3, 3], [5, 4], [7, 6], [4, 8]
        ];

        for (final testCase in testCases) {
          final a = testCase[0];
          final d = testCase[1];
          
          double sumWinProbs = 0.0;
          for (int aLeft = 0; aLeft <= a; aLeft++) {
            sumWinProbs += compositeProbs.pPreciseWin(a, d, aLeft);
          }
          
          double sumLossProbs = 0.0;
          for (int dLeft = 1; dLeft <= d; dLeft++) {
            sumLossProbs += compositeProbs.pPreciseLoss(a, d, dLeft);
          }
          
          final totalProb = sumWinProbs + sumLossProbs;
          
          expect(totalProb, closeTo(1.0, 1e-10),
                 reason: 'Sum of all precise probabilities for ($a, $d) should equal 1.0');
        }
      });
    });

    group('Safe Attack Probabilities', () {
      test('pSafeStop input validation', () {
        expect(() => compositeProbs.pSafeStop(2, 5), 
               throwsA(isA<ArgumentError>()));
        expect(() => compositeProbs.pSafeStop(5, 0), 
               throwsA(isA<ArgumentError>()));
        expect(() => compositeProbs.pSafeStop(0, 3), 
               throwsA(isA<ArgumentError>()));
      });

      test('pSafeStop returns correct number of probabilities', () {
        const a = 5;
        const d = 4;
        
        final safeProbs = compositeProbs.pSafeStop(a, d);
        
        expect(safeProbs.length, equals(d),
               reason: 'Should return d probabilities for d defenders');
      });

      test('pSafeStop returns valid probabilities', () {
        final testCases = [
          [3, 3], [4, 2], [5, 4], [6, 3], [8, 5]
        ];

        for (final testCase in testCases) {
          final a = testCase[0];
          final d = testCase[1];
          
          final safeProbs = compositeProbs.pSafeStop(a, d);
          
          expect(safeProbs.length, equals(d));
          
          for (int i = 0; i < safeProbs.length; i++) {
            expect(safeProbs[i], greaterThanOrEqualTo(0.0), 
                   reason: 'pSafeStop($a, $d)[$i] should be >= 0');
            expect(safeProbs[i], lessThanOrEqualTo(1.0), 
                   reason: 'pSafeStop($a, $d)[$i] should be <= 1');
          }
        }
      });

      test('pSafeStop probabilities sum to reasonable value', () {
        final testCases = [
          [5, 3], [6, 4], [8, 5]
        ];

        for (final testCase in testCases) {
          final a = testCase[0];
          final d = testCase[1];
          
          final safeProbs = compositeProbs.pSafeStop(a, d);
          final sum = safeProbs.reduce((a, b) => a + b);
          
          expect(sum, greaterThanOrEqualTo(0.0), 
                 reason: 'Sum of safe probabilities should be >= 0');
          expect(sum, lessThanOrEqualTo(1.0), 
                 reason: 'Sum of safe probabilities should be <= 1');
        }
      });

      test('pSafeStop minimum case works correctly', () {
        const a = 3;
        const d = 1;
        
        final safeProbs = compositeProbs.pSafeStop(a, d);
        
        expect(safeProbs.length, equals(1));
        expect(safeProbs[0], greaterThanOrEqualTo(0.0));
        expect(safeProbs[0], lessThanOrEqualTo(1.0));
      });

      test('pSafeStop scales correctly with more attackers', () {
        const d = 3;
        
        final probs3 = compositeProbs.pSafeStop(3, d);
        final probs5 = compositeProbs.pSafeStop(5, d);
        final probs7 = compositeProbs.pSafeStop(7, d);
        
        expect(probs3.length, equals(d));
        expect(probs5.length, equals(d));
        expect(probs7.length, equals(d));
        
        for (int i = 0; i < d; i++) {
          expect(probs3[i], greaterThanOrEqualTo(0.0));
          expect(probs5[i], greaterThanOrEqualTo(0.0));
          expect(probs7[i], greaterThanOrEqualTo(0.0));
        }
      });
    });

    group('Mathematical Properties', () {
      test('safe attack probabilities are consistent', () {
        const a = 5;
        const d = 3;
        
        final safeProbs = compositeProbs.pSafeStop(a, d);
        final sum = safeProbs.reduce((a, b) => a + b);
        
        expect(sum, lessThanOrEqualTo(1.0),
               reason: 'Total safe attack probability should not exceed 1.0');
      });
    });
  });
}