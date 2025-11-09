import '../models/chart_data_model.dart';
import '../models/chart_configuration.dart';

class ChartDataTransformer {
  static ChartDataModel transform({
    required List<double> attackerWinProbabilities,
    required List<double> defenderWinProbabilities,
    required double totalWinProbability,
  }) {
    final attackerDistribution = _filterSignificantData(attackerWinProbabilities, isAttacker: true);
    final reversedDefenderProbs = defenderWinProbabilities.reversed.toList();
    final defenderDistribution = _filterSignificantData(reversedDefenderProbs, isAttacker: false);

    final maxProbability = _calculateMaxProbability(attackerWinProbabilities, defenderWinProbabilities);

    return ChartDataModel(
      attackerDistribution: attackerDistribution,
      defenderDistribution: defenderDistribution,
      totalAttackerWinProbability: totalWinProbability,
      maxProbabilityPercent: maxProbability * 100 * ChartConfiguration.maxYPaddingFactor,
    );
  }

  static List<DistributionData> _filterSignificantData(List<double> probabilities, {required bool isAttacker}) {
    int start = 0;
    int end = probabilities.length;

    while (start < probabilities.length && (probabilities[start] * 100).toStringAsFixed(2) == '0.00') {
      start++;
    }

    while (end > start && (probabilities[end - 1] * 100).toStringAsFixed(2) == '0.00') {
      end--;
    }

    final result = <DistributionData>[];
    for (int i = start; i < end; i++) {
      final losses = isAttacker ? i : probabilities.length - 1 - i;
      result.add(DistributionData(losses: losses, probability: probabilities[i]));
    }

    return result;
  }

  static double _calculateMaxProbability(List<double> attackerProbs, List<double> defenderProbs) {
    final allValues = [...attackerProbs, ...defenderProbs];
    return allValues.reduce((a, b) => a > b ? a : b);
  }
}
