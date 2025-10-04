import 'package:flutter_test/flutter_test.dart';
import 'package:risiko_simulator/models/basic_probabilities.dart';

void main() {
  group('BasicProbabilities', () {
    late BasicProbabilities basicProbs = BasicProbabilities();

    group('Single Dice Roll Probabilities', () {
      test('1v1 probability matches Python reference', () {
        const expected = 15 / 36;
        final actual = basicProbs.pSingleWin(1, 1);

        expect(actual, closeTo(expected, 1e-10));
      });

      test('1v2 probability matches Python reference', () {
        const expected = 55 / 216;
        final actual = basicProbs.pSingleWin(1, 2);

        expect(actual, closeTo(expected, 1e-10));
      });

      test('2v1 probability matches Python reference', () {
        const expected = 125 / 216;
        final actual = basicProbs.pSingleWin(2, 1);

        expect(actual, closeTo(expected, 1e-10));
      });

      test('2v2 probability matches Python reference', () {
        const expected = 505 / 1296;
        final actual = basicProbs.pSingleWin(2, 2);

        expect(actual, closeTo(expected, 1e-10));
      });

      test('3v1 probability matches Python reference', () {
        const expected = 855 / 1296;
        final actual = basicProbs.pSingleWin(3, 1);

        expect(actual, closeTo(expected, 1e-10));
      });

      test('3v2 probability matches Python reference', () {
        const expected = 3667 / 7776;
        final actual = basicProbs.pSingleWin(3, 2);

        expect(actual, closeTo(expected, 1e-10));
      });
    });
  });
}
