import 'package:flutter_test/flutter_test.dart';
import 'package:risiko_simulator/models/basic_probabilities.dart';

void main() {
  group('BasicProbabilities', () {
    late BasicProbabilities basicProbs;

    setUp(() {
      basicProbs = BasicProbabilities();
    });

    group('Single Dice Roll Probabilities', () {
      test('1v1 probability matches Python reference', () {
        // Python reference: 15/36 = 0.4166666666666667
        const expected = 15.0 / 36.0;
        final actual = basicProbs.singleProbs['1v1']!;
        
        expect(actual, closeTo(expected, 1e-10));
        expect(actual, closeTo(0.4166666666666667, 1e-10));
      });

      test('1v2 probability matches Python reference', () {
        // Python reference: 55/216 = 0.25462962962962965
        const expected = 55.0 / 216.0;
        final actual = basicProbs.singleProbs['1v2']!;
        
        expect(actual, closeTo(expected, 1e-10));
        expect(actual, closeTo(0.25462962962962965, 1e-10));
      });

      test('2v1 probability matches Python reference', () {
        // Python reference: 125/216 = 0.5787037037037037
        const expected = 125.0 / 216.0;
        final actual = basicProbs.singleProbs['2v1']!;
        
        expect(actual, closeTo(expected, 1e-10));
        expect(actual, closeTo(0.5787037037037037, 1e-10));
      });

      test('2v2 probability matches Python reference', () {
        // Python reference: 505/1296 = 0.3896604938271605
        const expected = 505.0 / 1296.0;
        final actual = basicProbs.singleProbs['2v2']!;
        
        expect(actual, closeTo(expected, 1e-10));
        expect(actual, closeTo(0.3896604938271605, 1e-10));
      });

      test('3v1 probability matches Python reference', () {
        // Python reference: 855/1296 = 0.6597222222222222
        const expected = 855.0 / 1296.0;
        final actual = basicProbs.singleProbs['3v1']!;
        
        expect(actual, closeTo(expected, 1e-10));
        expect(actual, closeTo(0.6597222222222222, 1e-10));
      });

      test('3v2 probability matches Python reference', () {
        // Python reference: 3667/7776 = 0.4715792181069959
        const expected = 3667.0 / 7776.0;
        final actual = basicProbs.singleProbs['3v2']!;
        
        expect(actual, closeTo(expected, 1e-10));
        expect(actual, closeTo(0.4715792181069959, 1e-10));
      });
    });

    group('pSingleWin method', () {
      test('returns 0 for 0 attackers', () {
        expect(basicProbs.pSingleWin(0, 5), equals(0.0));
      });

      test('returns 1 for 0 defenders', () {
        expect(basicProbs.pSingleWin(5, 0), equals(1.0));
      });

      test('returns correct probability for 3v2 scenario', () {
        expect(basicProbs.pSingleWin(3, 2), equals(basicProbs.singleProbs['3v2']));
        expect(basicProbs.pSingleWin(4, 3), equals(basicProbs.singleProbs['3v2']));
        expect(basicProbs.pSingleWin(10, 5), equals(basicProbs.singleProbs['3v2']));
      });

      test('returns correct probability for 3v1 scenario', () {
        expect(basicProbs.pSingleWin(3, 1), equals(basicProbs.singleProbs['3v1']));
        expect(basicProbs.pSingleWin(5, 1), equals(basicProbs.singleProbs['3v1']));
      });

      test('returns correct probability for 2v2 scenario', () {
        expect(basicProbs.pSingleWin(2, 2), equals(basicProbs.singleProbs['2v2']));
        expect(basicProbs.pSingleWin(2, 3), equals(basicProbs.singleProbs['2v2']));
      });

      test('returns correct probability for 2v1 scenario', () {
        expect(basicProbs.pSingleWin(2, 1), equals(basicProbs.singleProbs['2v1']));
      });

      test('returns correct probability for 1v2 scenario', () {
        expect(basicProbs.pSingleWin(1, 2), equals(basicProbs.singleProbs['1v2']));
        expect(basicProbs.pSingleWin(1, 5), equals(basicProbs.singleProbs['1v2']));
      });

      test('returns correct probability for 1v1 scenario', () {
        expect(basicProbs.pSingleWin(1, 1), equals(basicProbs.singleProbs['1v1']));
      });

      test('throws error for invalid combinations', () {
        expect(() => basicProbs.pSingleWin(-1, 1), throwsArgumentError);
      });
    });

    group('Python Reference Value Verification', () {
      test('all calculated probabilities are valid', () {
        final probs = basicProbs.singleProbs;
        
        // All probabilities should be between 0 and 1
        for (final prob in probs.values) {
          expect(prob, greaterThanOrEqualTo(0.0));
          expect(prob, lessThanOrEqualTo(1.0));
        }
        
        // Attacker advantage should increase with more dice
        expect(probs['3v1']!, greaterThan(probs['2v1']!));
        expect(probs['2v1']!, greaterThan(probs['1v1']!));
        
        // Defender advantage should show when they have more dice
        expect(probs['1v1']!, greaterThan(probs['1v2']!));
        expect(probs['2v1']!, greaterThan(probs['2v2']!));
        expect(probs['3v1']!, greaterThan(probs['3v2']!));
      });
    });
  });
}