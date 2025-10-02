import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

enum ChartType { attacker, defender }

class ProbabilitySubChart extends StatelessWidget {
  final ChartType chartType;
  final List<double> probabilities;
  final double totalWinProbability;
  final double maxY;
  final int? selectedIndex;
  final bool isSelected;
  final Function(int index) onBarTap;

  const ProbabilitySubChart({
    super.key,
    required this.chartType,
    required this.probabilities,
    required this.totalWinProbability,
    required this.maxY,
    required this.selectedIndex,
    required this.isSelected,
    required this.onBarTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildTitle(),
        Expanded(child: _buildChart()),
      ],
    );
  }

  Widget _buildTitle() {
    final isAttacker = chartType == ChartType.attacker;
    final percentage = isAttacker
        ? (totalWinProbability * 100).toStringAsFixed(1)
        : ((1 - totalWinProbability) * 100).toStringAsFixed(1);
    final title = isAttacker ? 'Angreifer gewinnt' : 'Verteidiger gewinnt';
    final color = isAttacker ? Colors.green : Colors.red;

    return Text(
      '$title ($percentage%)',
      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: color),
    );
  }

  Widget _buildChart() {
    final isAttacker = chartType == ChartType.attacker;
    final color = isAttacker ? Colors.green : Colors.red;
    final displayData = isAttacker ? probabilities : probabilities.reversed.toList();

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: maxY,
        barTouchData: BarTouchData(
          touchCallback: (FlTouchEvent event, barTouchResponse) {
            if (barTouchResponse != null &&
                barTouchResponse.spot != null &&
                event is FlTapUpEvent) {
              final index = barTouchResponse.spot!.touchedBarGroupIndex;
              onBarTap(index);
            }
          },
        ),
        titlesData: _buildTitlesData(),
        borderData: FlBorderData(show: true),
        barGroups: displayData
            .asMap()
            .entries
            .map((entry) => BarChartGroupData(
                  x: entry.key,
                  barRods: [
                    BarChartRodData(
                      toY: entry.value * 100,
                      color: selectedIndex == entry.key && isSelected
                          ? color.shade700
                          : color,
                      width: 16,
                      borderRadius: BorderRadius.zero,
                    ),
                  ],
                ))
            .toList(),
      ),
    );
  }

  FlTitlesData _buildTitlesData() {
    final isAttacker = chartType == ChartType.attacker;
    final interval = _calculateLabelInterval(probabilities.length).toDouble();

    return FlTitlesData(
      show: true,
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          interval: interval,
          getTitlesWidget: (value, meta) {
            final intervalInt = interval.toInt();
            if (value.toInt() % intervalInt != 0) {
              return const SizedBox.shrink();
            }

            final displayValue = isAttacker
                ? value.toInt()
                : probabilities.length - 1 - value.toInt();

            return Text(
              displayValue.toString(),
              style: const TextStyle(fontSize: 12),
            );
          },
        ),
        axisNameWidget: Text(
          isAttacker ? 'Verluste des Angreifers' : 'Verluste des Verteidigers',
          style: const TextStyle(fontSize: 12),
        ),
      ),
      leftTitles: isAttacker ? _buildLeftTitles() : const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      rightTitles: isAttacker ? const AxisTitles(sideTitles: SideTitles(showTitles: false)) : _buildRightTitles(),
      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
    );
  }

  AxisTitles _buildLeftTitles() {
    return AxisTitles(
      sideTitles: SideTitles(
        showTitles: true,
        getTitlesWidget: (value, meta) {
          if (value >= maxY * 0.95) {
            return const SizedBox.shrink();
          }
          return Text(
            value.toStringAsFixed(1),
            style: const TextStyle(fontSize: 11),
          );
        },
      ),
      axisNameWidget: const Text(
        'Wahrscheinlichkeit in %',
        style: TextStyle(fontSize: 12),
      ),
    );
  }

  AxisTitles _buildRightTitles() {
    return AxisTitles(
      sideTitles: SideTitles(
        showTitles: true,
        getTitlesWidget: (value, meta) {
          if (value >= maxY * 0.95) {
            return const SizedBox.shrink();
          }
          return Text(
            value.toStringAsFixed(1),
            style: const TextStyle(fontSize: 11),
          );
        },
      ),
    );
  }

  int _calculateLabelInterval(int dataLength) {
    if (dataLength <= 20) return 1;
    return 5;
  }
}