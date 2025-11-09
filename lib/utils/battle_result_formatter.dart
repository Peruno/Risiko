import 'package:risiko_simulator/state/battle_state.dart';

import '../calculation/simulator.dart';

class BattleResultFormatter {
  final BattleResult result;
  final AttackMode? selectedAttackMode;

  BattleResultFormatter({required this.result, this.selectedAttackMode});

  String formatProbabilities() {
    final buffer = StringBuffer();

    buffer.writeln('Angreifer gewinnt: ${(result.winProbability * 100).toStringAsFixed(1)}%');
    if (selectedAttackMode == AttackMode.safe) {
      final retreatProb = result.lossProbabilities.values.reduce((a, b) => a + b);
      buffer.writeln('Rückzug: ${(retreatProb * 100).toStringAsFixed(1)}%');
    } else {
      buffer.writeln('Verteidiger gewinnt: ${((1 - result.winProbability) * 100).toStringAsFixed(1)}%');
    }

    return buffer.toString();
  }

  String formatBattleOutcome() {
    final buffer = StringBuffer();

    buffer.write(formatProbabilities());
    buffer.writeln('');

    switch (result.outcome) {
      case BattleOutcome.victory:
        buffer.writeln('🟢 SIEG DES ANGREIFERS!');
        buffer.writeln('Verluste des Angreifers: ${result.losses}');
        break;
      case BattleOutcome.defeat:
        buffer.writeln('🔴 SIEG DES VERTEIDIGERS!');
        buffer.writeln('Verluste des Verteidigers: ${result.losses}');
        break;
      case BattleOutcome.retreat:
        buffer.writeln('🟡 RÜCKZUG DES ANGREIFERS!');
        buffer.writeln('Verluste des Verteidigers: ${result.losses}');
        break;
    }

    return buffer.toString();
  }
}
