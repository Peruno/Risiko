class ChartDataModel {
  final List<DistributionData> attackerDistribution;
  final List<DistributionData> defenderDistribution;
  final double totalAttackerWinProbability;
  final double maxProbabilityPercent;

  const ChartDataModel({
    required this.attackerDistribution,
    required this.defenderDistribution,
    required this.totalAttackerWinProbability,
    required this.maxProbabilityPercent,
  });

  bool get hasAttackerData => attackerDistribution.isNotEmpty;
  bool get hasDefenderData => defenderDistribution.isNotEmpty;
  double get totalDefenderWinProbability => 1.0 - totalAttackerWinProbability;
}

class DistributionData {
  final int losses;
  final double probability;

  const DistributionData({required this.losses, required this.probability});

  double get probabilityPercent => probability * 100;
}
