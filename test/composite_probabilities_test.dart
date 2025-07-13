import 'dart:math';
import 'package:flutter_test/flutter_test.dart';
import 'package:risiko_simulator/models/composite_probabilities.dart';

void main() {
  group('CompositeProbabilities', () {
    late CompositeProbabilities compositeProbs;

    setUp(() {
      compositeProbs = CompositeProbabilities();
    });

    group('Precise Win Probabilities', () {
      test('sum of all precise win probabilities equals overall win probability', () {
        const a = 10;
        const d = 7;
        
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
      test('pSafeStop returns correct number of probabilities', () {
        const a = 5;
        const d = 4;
        
        final safeProbs = compositeProbs.pSafeStop(a, d);
        
        expect(safeProbs.length, equals(d),
               reason: 'Should return d probabilities for d defenders');
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
    });
  });
}