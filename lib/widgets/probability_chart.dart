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
  String? selectedValue;
  bool isAttackerSide = true;
  int? selectedIndex;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildTitle(),
        if (selectedValue != null) _buildSelectedValueDisplay(),
        Expanded(child: _buildChartsRow()),
      ],
    );
  }

  Widget _buildTitle() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        '${widget.attackers} Angreifer gegen ${widget.defenders} Verteidiger',
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildSelectedValueDisplay() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        selectedValue!,
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        textAlign: TextAlign.center,
      ),
    );
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
              selectedIndex: selectedIndex,
              isSelected: isAttackerSide,
              onBarTap: _onAttackerBarTap,
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
              selectedIndex: selectedIndex,
              isSelected: !isAttackerSide,
              onBarTap: _onDefenderBarTap,
            ),
          ),
        ],
      ),
    );
  }

  void _onAttackerBarTap(int index) {
    setState(() {
      selectedIndex = index;
      isAttackerSide = true;
      selectedValue = 'Angreifer verliert $index Truppen: ${(widget.attackerWinProbabilities[index] * 100).toStringAsFixed(2)}%';
    });
  }

  void _onDefenderBarTap(int index) {
    setState(() {
      final defenderLosses = widget.defenderWinProbabilities.length - 1 - index;
      final reversedData = widget.defenderWinProbabilities.reversed.toList();
      selectedIndex = index;
      isAttackerSide = false;
      selectedValue = 'Verteidiger verliert $defenderLosses Truppen: ${(reversedData[index] * 100).toStringAsFixed(2)}%';
    });
  }

  double _calculateMaxY() {
    final allValues = [...widget.attackerWinProbabilities, ...widget.defenderWinProbabilities];
    final maxValue = allValues.reduce((a, b) => a > b ? a : b);
    return (maxValue * 100 * 1.1);
  }
}