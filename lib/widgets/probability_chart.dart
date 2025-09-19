import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

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
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            '${widget.attackers} Angreifer gegen ${widget.defenders} Verteidiger',
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ),
        if (selectedValue != null)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              selectedValue!,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
          ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  flex: 45,
                  child: _buildAttackerChart(),
                ),
                const Expanded(
                  flex: 5,
                  child: SizedBox(),
                ),
                Expanded(
                  flex: 45,
                  child: _buildDefenderChart(),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAttackerChart() {
    final maxY = _calculateMaxY();
    
    return Column(
      children: [
        Text(
          'Angreifer gewinnt (${(widget.totalWinProbability * 100).toStringAsFixed(1)}%)',
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.green),
        ),
        Expanded(
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,
              maxY: maxY,
              barTouchData: BarTouchData(
                touchCallback: (FlTouchEvent event, barTouchResponse) {
                  setState(() {
                    if (barTouchResponse != null &&
                        barTouchResponse.spot != null &&
                        event is FlTapUpEvent) {
                      final index = barTouchResponse.spot!.touchedBarGroupIndex;
                      selectedIndex = index;
                      isAttackerSide = true;
                      selectedValue = 'Angreifer verliert $index Truppen: ${(widget.attackerWinProbabilities[index] * 100).toStringAsFixed(2)}%';
                    } else {
                      selectedValue = null;
                      selectedIndex = null;
                    }
                  });
                },
              ),
              titlesData: FlTitlesData(
                show: true,
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: _calculateLabelInterval(widget.attackerWinProbabilities.length).toDouble(),
                    getTitlesWidget: (value, meta) {
                      final interval = _calculateLabelInterval(widget.attackerWinProbabilities.length);
                      if (value.toInt() % interval != 0) {
                        return const SizedBox.shrink();
                      }
                      return Text(
                        value.toInt().toString(),
                        style: const TextStyle(fontSize: 12),
                      );
                    },
                  ),
                  axisNameWidget: const Text(
                    'Verluste des Angreifers',
                    style: TextStyle(fontSize: 12),
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      final maxY = _calculateMaxY();
                      if (value >= maxY * 0.95) {
                        return const SizedBox.shrink();
                      }
                      return Text(
                        '${value.toStringAsFixed(1)}',
                        style: const TextStyle(fontSize: 11),
                      );
                    },
                  ),
                  axisNameWidget: const Text(
                    'Wahrscheinlichkeit in %',
                    style: TextStyle(fontSize: 12),
                  ),
                ),
                topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              ),
              borderData: FlBorderData(show: true),
              barGroups: widget.attackerWinProbabilities
                  .asMap()
                  .entries
                  .map((entry) => BarChartGroupData(
                        x: entry.key,
                        barRods: [
                          BarChartRodData(
                            toY: entry.value * 100,
                            color: selectedIndex == entry.key && isAttackerSide
                                ? Colors.green.shade700
                                : Colors.green,
                            width: 16,
                            borderRadius: BorderRadius.zero,
                          ),
                        ],
                      ))
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDefenderChart() {
    final maxY = _calculateMaxY();
    
    return Column(
      children: [
        Text(
          'Verteidiger gewinnt (${((1 - widget.totalWinProbability) * 100).toStringAsFixed(1)}%)',
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.red),
        ),
        Expanded(
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,
              maxY: maxY,
              barTouchData: BarTouchData(
                touchCallback: (FlTouchEvent event, barTouchResponse) {
                  setState(() {
                    if (barTouchResponse != null &&
                        barTouchResponse.spot != null &&
                        event is FlTapUpEvent) {
                      final index = barTouchResponse.spot!.touchedBarGroupIndex;
                      final defenderLosses = widget.defenderWinProbabilities.length - 1 - index;
                      final reversedData = widget.defenderWinProbabilities.reversed.toList();
                      selectedIndex = index;
                      isAttackerSide = false;
                      selectedValue = 'Verteidiger verliert $defenderLosses Truppen: ${(reversedData[index] * 100).toStringAsFixed(2)}%';
                    } else {
                      selectedValue = null;
                      selectedIndex = null;
                    }
                  });
                },
              ),
              titlesData: FlTitlesData(
                show: true,
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: _calculateLabelInterval(widget.defenderWinProbabilities.length).toDouble(),
                    getTitlesWidget: (value, meta) {
                      final interval = _calculateLabelInterval(widget.defenderWinProbabilities.length);
                      if (value.toInt() % interval != 0) {
                        return const SizedBox.shrink();
                      }
                      final defenderLosses = widget.defenderWinProbabilities.length - 1 - value.toInt();
                      return Text(
                        defenderLosses.toString(),
                        style: const TextStyle(fontSize: 12),
                      );
                    },
                  ),
                  axisNameWidget: const Text(
                    'Verluste des Verteidigers',
                    style: TextStyle(fontSize: 12),
                  ),
                ),
                leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      final maxY = _calculateMaxY();
                      if (value >= maxY * 0.95) {
                        return const SizedBox.shrink();
                      }
                      return Text(
                        '${value.toStringAsFixed(1)}',
                        style: const TextStyle(fontSize: 11),
                      );
                    },
                  ),
                ),
                topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              ),
              borderData: FlBorderData(show: true),
              barGroups: widget.defenderWinProbabilities
                  .reversed
                  .toList()
                  .asMap()
                  .entries
                  .map((entry) => BarChartGroupData(
                        x: entry.key,
                        barRods: [
                          BarChartRodData(
                            toY: entry.value * 100,
                            color: selectedIndex == entry.key && !isAttackerSide
                                ? Colors.red.shade700
                                : Colors.red,
                            width: 16,
                            borderRadius: BorderRadius.zero,
                          ),
                        ],
                      ))
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }

  double _calculateMaxY() {
    final allValues = [...widget.attackerWinProbabilities, ...widget.defenderWinProbabilities];
    final maxValue = allValues.reduce((a, b) => a > b ? a : b);
    return (maxValue * 100 * 1.1);
  }

  int _calculateLabelInterval(int dataLength) {
    if (dataLength <= 20) return 1;
    return 5;
  }
}