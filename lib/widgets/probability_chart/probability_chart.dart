import 'package:flutter/material.dart';

import 'probability_sub_chart.dart';

class ProbabilityChart extends StatefulWidget {
  final List<double> attackerWinProbabilities;
  final List<double> defenderWinProbabilities;
  final int attackers;
  final int defenders;
  final double totalWinProbability;

  const ProbabilityChart({
    super.key,
    required this.attackerWinProbabilities,
    required this.defenderWinProbabilities,
    required this.attackers,
    required this.defenders,
    required this.totalWinProbability,
  });

  @override
  State<ProbabilityChart> createState() => _ProbabilityChartState();
}

class _ProbabilityChartState extends State<ProbabilityChart> {
  @override
  Widget build(BuildContext context) {
    return Column(children: [Expanded(child: _buildChartsRow())]);
  }

  Widget _buildChartsRow() {
    final maxY = _calculateMaxY();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            flex: 45,
            child: ProbabilitySubChart(
              chartType: ChartType.attacker,
              probabilities: widget.attackerWinProbabilities,
              totalWinProbability: widget.totalWinProbability,
              maxY: maxY,
            ),
          ),
          const Expanded(flex: 5, child: SizedBox()),
          Expanded(
            flex: 45,
            child: ProbabilitySubChart(
              chartType: ChartType.defender,
              probabilities: widget.defenderWinProbabilities,
              totalWinProbability: widget.totalWinProbability,
              maxY: maxY,
            ),
          ),
        ],
      ),
    );
  }

  double _calculateMaxY() {
    final allValues = [...widget.attackerWinProbabilities, ...widget.defenderWinProbabilities];
    final maxValue = allValues.reduce((a, b) => a > b ? a : b);
    return (maxValue * 100 * 1.1);
  }
}
