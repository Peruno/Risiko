import 'dart:math';
import 'package:flutter_test/flutter_test.dart';
import 'package:risiko_simulator/models/simulator.dart';
import 'package:risiko_simulator/models/composite_probabilities.dart';

void main() {
  group('Simulator', () {
    late Simulator simulator;
    late Random deterministicRandom;
    late CompositeProbabilities compositeProbs;

    setUp(() {
      deterministicRandom = Random(42);
      simulator = Simulator(random: deterministicRandom);
      compositeProbs = CompositeProbabilities();
    });

    group('All-In Battle Simulation', () {
      test('allIn input validation', () {
        expect(() => simulator.allIn(0, 5), 
               throwsA(isA<ArgumentError>()));
        expect(() => simulator.allIn(5, 0), 
               throwsA(isA<ArgumentError>()));
        expect(() => simulator.allIn(-1, 3), 
               throwsA(isA<ArgumentError>()));
      });

      test('allIn returns valid battle result without simulation', () {
        final result = simulator.allIn(5, 3, simulateOutcome: false);
        
        expect(result.winProbability, greaterThan(0.0));
        expect(result.winProbability, lessThan(1.0));
        expect(result.winProbabilities.length, equals(5));
        expect(result.lossProbabilities.length, equals(3));
        
        for (final prob in result.winProbabilities.values) {
          expect(prob, greaterThanOrEqualTo(0.0));
          expect(prob, lessThanOrEqualTo(1.0));
        }
        
        for (final prob in result.lossProbabilities.values) {
          expect(prob, greaterThanOrEqualTo(0.0));
          expect(prob, lessThanOrEqualTo(1.0));
        }
      });

      test('allIn probabilities sum correctly', () {
        final result = simulator.allIn(4, 3, simulateOutcome: false);
        
        final winSum = result.winProbabilities.values.reduce((a, b) => a + b);
        final lossSum = result.lossProbabilities.values.reduce((a, b) => a + b);
        final totalSum = winSum + lossSum;
        
        expect(totalSum, closeTo(1.0, 1e-10));
        expect(winSum, closeTo(result.winProbability, 1e-10));
      });

      test('allIn simulates outcomes correctly', () {
        final results = <BattleOutcome>[];
        
        for (int i = 0; i < 100; i++) {
          final result = simulator.allIn(5, 3, simulateOutcome: true);
          results.add(result.outcome);
          
          expect([BattleOutcome.victory, BattleOutcome.defeat].contains(result.outcome), 
                 isTrue);
          expect(result.losses, greaterThanOrEqualTo(0));
          
          if (result.outcome == BattleOutcome.victory) {
            expect(result.losses, lessThan(5));
          } else {
            expect(result.losses, lessThan(3));
          }
        }
        
        expect(results.contains(BattleOutcome.victory), isTrue);
        expect(results.contains(BattleOutcome.defeat), isTrue);
        expect(results.contains(BattleOutcome.retreat), isFalse);
      });

      test('allIn small battle scenarios', () {
        final testCases = [
          [1, 1], [2, 1], [1, 2], [3, 2], [2, 3]
        ];

        for (final testCase in testCases) {
          final a = testCase[0];
          final d = testCase[1];
          
          final result = simulator.allIn(a, d, simulateOutcome: false);
          
          expect(result.winProbabilities.length, equals(a));
          expect(result.lossProbabilities.length, equals(d));
          expect(result.winProbability, greaterThan(0.0));
          expect(result.winProbability, lessThan(1.0));
        }
      });
    });

    group('Safe Attack Simulation', () {
      test('safeAttack input validation', () {
        expect(() => simulator.safeAttack(2, 5), 
               throwsA(isA<ArgumentError>()));
        expect(() => simulator.safeAttack(5, 0), 
               throwsA(isA<ArgumentError>()));
        expect(() => simulator.safeAttack(0, 3), 
               throwsA(isA<ArgumentError>()));
      });

      test('safeAttack returns valid battle result without simulation', () {
        final result = simulator.safeAttack(5, 3, simulateOutcome: false);
        
        expect(result.winProbability, greaterThanOrEqualTo(0.0));
        expect(result.winProbability, lessThanOrEqualTo(1.0));
        expect(result.winProbabilities.length, equals(3));
        expect(result.lossProbabilities.length, greaterThan(0));
        
        for (final prob in result.winProbabilities.values) {
          expect(prob, greaterThanOrEqualTo(0.0));
          expect(prob, lessThanOrEqualTo(1.0));
        }
        
        for (final prob in result.lossProbabilities.values) {
          expect(prob, greaterThanOrEqualTo(0.0));
          expect(prob, lessThanOrEqualTo(1.0));
        }
      });

      test('safeAttack simulates outcomes correctly', () {
        final results = <BattleOutcome>[];
        
        for (int i = 0; i < 100; i++) {
          final result = simulator.safeAttack(6, 4, simulateOutcome: true);
          results.add(result.outcome);
          
          expect([BattleOutcome.victory, BattleOutcome.retreat].contains(result.outcome), 
                 isTrue);
          expect(result.losses, greaterThanOrEqualTo(0));
        }
        
        expect(results.contains(BattleOutcome.defeat), isFalse);
      });

      test('safeAttack minimum case', () {
        final result = simulator.safeAttack(3, 1, simulateOutcome: false);
        
        expect(result.winProbabilities.length, equals(1));
        expect(result.lossProbabilities.length, equals(1));
      });

      test('safeAttack larger scenarios', () {
        final testCases = [
          [5, 3], [6, 4], [8, 5], [10, 7]
        ];

        for (final testCase in testCases) {
          final a = testCase[0];
          final d = testCase[1];
          
          final result = simulator.safeAttack(a, d, simulateOutcome: false);
          
          expect(result.winProbabilities.length, equals(a - 2));
          expect(result.lossProbabilities.length, greaterThan(0));
          expect(result.winProbability, greaterThanOrEqualTo(0.0));
          expect(result.winProbability, lessThanOrEqualTo(1.0));
        }
      });
    });

    group('Battle Result Properties', () {
      test('BattleResult contains all required information', () {
        final result = simulator.allIn(5, 3, simulateOutcome: true);
        
        expect(result.outcome, isA<BattleOutcome>());
        expect(result.losses, isA<int>());
        expect(result.winProbability, isA<double>());
        expect(result.winProbabilities, isA<Map<int, double>>());
        expect(result.lossProbabilities, isA<Map<int, double>>());
      });

      test('Battle outcomes are consistent with losses', () {
        for (int i = 0; i < 50; i++) {
          final allInResult = simulator.allIn(4, 3, simulateOutcome: true);
          
          if (allInResult.outcome == BattleOutcome.victory) {
            expect(allInResult.winProbabilities.keys.contains(allInResult.losses), 
                   isTrue);
          } else if (allInResult.outcome == BattleOutcome.defeat) {
            expect(allInResult.lossProbabilities.keys.contains(allInResult.losses), 
                   isTrue);
          }
          
          final safeResult = simulator.safeAttack(5, 3, simulateOutcome: true);
          
          if (safeResult.outcome == BattleOutcome.victory) {
            expect(safeResult.winProbabilities.keys.contains(safeResult.losses), 
                   isTrue);
          } else if (safeResult.outcome == BattleOutcome.retreat) {
            expect(safeResult.lossProbabilities.keys.contains(safeResult.losses), 
                   isTrue);
          }
        }
      });
    });

    group('Deterministic Testing', () {
      test('deterministic random produces consistent results', () {
        final sim1 = Simulator(random: Random(123));
        final sim2 = Simulator(random: Random(123));
        
        final result1 = sim1.allIn(5, 3, simulateOutcome: true);
        final result2 = sim2.allIn(5, 3, simulateOutcome: true);
        
        expect(result1.outcome, equals(result2.outcome));
        expect(result1.losses, equals(result2.losses));
      });
    });

    group('Integration with Probability Calculations', () {
      test('allIn win probability matches matrix calculation', () {
        final result = simulator.allIn(4, 3, simulateOutcome: false);
        final directProb = compositeProbs.pMatrix(4, 3);
        
        expect(result.winProbability, closeTo(directProb, 1e-10));
      });

      test('probability distributions are mathematically sound', () {
        final testCases = [
          [3, 2], [4, 3], [5, 4], [6, 5]
        ];

        for (final testCase in testCases) {
          final a = testCase[0];
          final d = testCase[1];
          
          final allInResult = simulator.allIn(a, d, simulateOutcome: false);
          final winSum = allInResult.winProbabilities.values.reduce((a, b) => a + b);
          final lossSum = allInResult.lossProbabilities.values.reduce((a, b) => a + b);
          
          expect(winSum + lossSum, closeTo(1.0, 1e-10),
                 reason: 'All-in probabilities should sum to 1.0 for ($a, $d)');
          
          if (a >= 3) {
            final safeResult = simulator.safeAttack(a, d, simulateOutcome: false);
            final safeWinSum = safeResult.winProbabilities.values.reduce((a, b) => a + b);
            final safeLossSum = safeResult.lossProbabilities.values.reduce((a, b) => a + b);
            
            expect(safeWinSum + safeLossSum, lessThanOrEqualTo(1.0),
                   reason: 'Safe attack probabilities should not exceed 1.0 for ($a, $d)');
          }
        }
      });
    });
  });
}