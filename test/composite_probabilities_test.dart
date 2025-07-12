import 'dart:math';
import 'package:flutter_test/flutter_test.dart';
import 'package:risiko_simulator/models/composite_probabilities.dart';

void main() {
  group('CompositeProbabilities', () {
    late CompositeProbabilities compositeProbs;

    setUp(() {
      compositeProbs = CompositeProbabilities();
    });

    group('Edge Cases', () {
      test('pMatrix handles a=0 (no attackers)', () {
        for (int d = 0; d <= 5; d++) {
          final matrix = compositeProbs.pMatrix(0, d);
          expect(matrix, equals(0.0), reason: 'pMatrix(0, $d) should be 0.0');
        }
      });

      test('pMatrix handles d=0 (no defenders)', () {
        for (int a = 1; a <= 5; a++) {
          final matrix = compositeProbs.pMatrix(a, 0);
          expect(matrix, equals(1.0), reason: 'pMatrix($a, 0) should be 1.0');
        }
      });

      test('pMatrix handles (0,0) case', () {
        // This is a bit of an edge case - 0 attackers vs 0 defenders
        // Based on the logic: if a == 0, return 0; else if d == 0, return 1
        // So (0,0) should return 0 since a == 0 is checked first
        final matrix = compositeProbs.pMatrix(0, 0);
        expect(matrix, equals(0.0), reason: 'pMatrix(0, 0) should be 0.0');
      });
    });

    group('Matrix Method Tests', () {
      test('pMatrix returns correct results for small values', () {
        // Test various small combinations
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
        // Test some medium-sized combinations
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
        final random = Random(42); // Use fixed seed for reproducible tests
        const numTests = 20;
        
        for (int i = 0; i < numTests; i++) {
          // Generate random values with reasonable bounds
          final a = random.nextInt(15) + 1; // 1 to 15 attackers
          final d = random.nextInt(10) + 1; // 1 to 10 defenders
          
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
        // For a fixed number of defenders, more attackers should increase win probability
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
        // For a fixed number of attackers, more defenders should decrease win probability
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
        // For 1 attacker vs 1 defender, the composite probability should equal
        // the single dice roll probability since it's just one roll
        final composite = compositeProbs.pMatrix(1, 1);
        const expectedSingleRoll = 15.0 / 36.0; // 1v1 probability
        
        expect(composite, closeTo(expectedSingleRoll, 1e-10),
               reason: '1v1 composite should equal single roll probability');
      });
    });
  });
}