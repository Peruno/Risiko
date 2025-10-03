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
        const expected = 15.0 / 36.0;
        final actual = basicProbs.singleProbs['1v1']!;

        expect(actual, closeTo(expected, 1e-10));
        expect(actual, closeTo(0.4166666666666667, 1e-10));
      });

      test('1v2 probability matches Python reference', () {
        const expected = 55.0 / 216.0;
        final actual = basicProbs.singleProbs['1v2']!;

        expect(actual, closeTo(expected, 1e-10));
        expect(actual, closeTo(0.25462962962962965, 1e-10));
      });

      test('2v1 probability matches Python reference', () {
        const expected = 125.0 / 216.0;
        final actual = basicProbs.singleProbs['2v1']!;

        expect(actual, closeTo(expected, 1e-10));
        expect(actual, closeTo(0.5787037037037037, 1e-10));
      });

      test('2v2 probability matches Python reference', () {
        const expected = 505.0 / 1296.0;
        final actual = basicProbs.singleProbs['2v2']!;

        expect(actual, closeTo(expected, 1e-10));
        expect(actual, closeTo(0.3896604938271605, 1e-10));
      });

      test('3v1 probability matches Python reference', () {
        const expected = 855.0 / 1296.0;
        final actual = basicProbs.singleProbs['3v1']!;

        expect(actual, closeTo(expected, 1e-10));
        expect(actual, closeTo(0.6597222222222222, 1e-10));
      });

      test('3v2 probability matches Python reference', () {
        const expected = 3667.0 / 7776.0;
        final actual = basicProbs.singleProbs['3v2']!;

        expect(actual, closeTo(expected, 1e-10));
        expect(actual, closeTo(0.4715792181069959, 1e-10));
      });
    });
  });
}
