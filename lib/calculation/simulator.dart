import 'dart:math';
import 'composite_probabilities.dart';

enum BattleOutcome { victory, defeat, retreat }

class BattleResult {
  final BattleOutcome outcome;
  final int losses;
  final double winProbability;
  final Map<int, double> winProbabilities;
  final Map<int, double> lossProbabilities;

  BattleResult({
    required this.outcome,
    required this.losses,
    required this.winProbability,
    required this.winProbabilities,
    required this.lossProbabilities,
  });
}

class Simulator {
  late final CompositeProbabilities _probs;
  final Random _random;

  Simulator({Random? random}) : _random = random ?? Random() {
    _probs = CompositeProbabilities();
  }

  /// Simulates an all-in battle where attacker fights until victory or defeat
  BattleResult allIn(int a, int d, {bool simulateOutcome = true}) {
    if (a < 1) {
      throw ArgumentError('Number of attackers must be at least 1, got: $a');
    }
    if (d < 1) {
      throw ArgumentError('Number of defenders must be at least 1, got: $d');
    }

    final winProbs = <int, double>{};
    for (int i = 0; i < a; i++) {
      winProbs[i] = _probs.pPreciseWin(a, d, a - i);
    }

    final lossProbs = <int, double>{};
    for (int i = 0; i < d; i++) {
      lossProbs[i] = _probs.pPreciseLoss(a, d, d - i);
    }

    final totalWinProb = winProbs.values.reduce((a, b) => a + b);

    if (!simulateOutcome) {
      return BattleResult(
        outcome: BattleOutcome.victory,
        losses: 0,
        winProbability: totalWinProb,
        winProbabilities: winProbs,
        lossProbabilities: lossProbs,
      );
    }

    final result = _determineResult(winProbs, lossProbs, false);
    return BattleResult(
      outcome: result.outcome,
      losses: result.losses,
      winProbability: totalWinProb,
      winProbabilities: winProbs,
      lossProbabilities: lossProbs,
    );
  }

  /// Simulates a safe attack where attacker stops at 2 troops remaining
  BattleResult safeAttack(int a, int d, {bool simulateOutcome = true}) {
    if (a < 3) {
      throw ArgumentError('Safe attack requires at least 3 attackers, got: $a');
    }
    if (d < 1) {
      throw ArgumentError('Number of defenders must be at least 1, got: $d');
    }

    final winProbs = <int, double>{};
    for (int i = 0; i < a - 2; i++) {
      winProbs[i] = _probs.pPreciseWin(a, d, a - i);
    }

    final safeProbs = _probs.pSafeStop(a, d);
    final lossProbs = <int, double>{};
    for (int i = 0; i < safeProbs.length; i++) {
      lossProbs[i] = safeProbs[i];
    }

    final totalWinProb = winProbs.values.reduce((a, b) => a + b);

    if (!simulateOutcome) {
      return BattleResult(
        outcome: BattleOutcome.victory,
        losses: 0,
        winProbability: totalWinProb,
        winProbabilities: winProbs,
        lossProbabilities: lossProbs,
      );
    }

    final result = _determineResult(winProbs, lossProbs, true);
    return BattleResult(
      outcome: result.outcome,
      losses: result.losses,
      winProbability: totalWinProb,
      winProbabilities: winProbs,
      lossProbabilities: lossProbs,
    );
  }

  ({BattleOutcome outcome, int losses}) _determineResult(
    Map<int, double> winProbs,
    Map<int, double> lossProbs,
    bool isSafeAttack,
  ) {
    final totalWinProb = winProbs.values.reduce((a, b) => a + b);

    if (_random.nextDouble() < totalWinProb) {
      final losses = _weightedChoice(winProbs);
      return (outcome: BattleOutcome.victory, losses: losses);
    }

    final losses = _weightedChoice(lossProbs);
    final outcome = isSafeAttack ? BattleOutcome.retreat : BattleOutcome.defeat;
    return (outcome: outcome, losses: losses);
  }

  int _weightedChoice(Map<int, double> probabilities) {
    final totalWeight = probabilities.values.reduce((a, b) => a + b);
    double randomValue = _random.nextDouble() * totalWeight;

    for (final entry in probabilities.entries) {
      randomValue -= entry.value;
      if (randomValue <= 0) {
        return entry.key;
      }
    }

    return probabilities.keys.last;
  }
}
