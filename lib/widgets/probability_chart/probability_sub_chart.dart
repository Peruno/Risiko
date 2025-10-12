import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

enum ChartType { attacker, defender }

class ProbabilitySubChart extends StatefulWidget {
  final ChartType chartType;
  final List<double> probabilities;
  final double totalWinProbability;
  final double maxY;
  final Function(int index) onBarTap;

  const ProbabilitySubChart({
    super.key,
    required this.chartType,
    required this.probabilities,
    required this.totalWinProbability,
    required this.maxY,
    required this.onBarTap,
  });

  @override
  State<ProbabilitySubChart> createState() => _ProbabilitySubChartState();
}

class _ProbabilitySubChartState extends State<ProbabilitySubChart> {
  int? _pressedIndex;

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
    final isAttacker = widget.chartType == ChartType.attacker;
    final percentage = isAttacker
        ? (widget.totalWinProbability * 100).toStringAsFixed(1)
        : ((1 - widget.totalWinProbability) * 100).toStringAsFixed(1);
    final title = isAttacker ? 'Angreifer gewinnt' : 'Verteidiger gewinnt';
    final color = isAttacker ? Colors.green : Colors.red;

    return Text(
      '$title ($percentage%)',
      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: color),
    );
  }

  Widget _buildChart() {
    final isAttacker = widget.chartType == ChartType.attacker;
    final displayedData = isAttacker ? widget.probabilities : widget.probabilities.reversed.toList();

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: widget.maxY,
        barTouchData: BarTouchData(
          enabled: true,
          touchTooltipData: BarTouchTooltipData(
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              final isAttacker = widget.chartType == ChartType.attacker;
              final losses = isAttacker ? group.x.toInt() : widget.probabilities.length - 1 - group.x.toInt();
              final probability = (rod.toY).toStringAsFixed(1);
              final label = isAttacker ? 'Sieg mit $losses Verlusten: $probability%' : 'Niederlage mit $losses Verlusten: $probability%';
              return BarTooltipItem(
                label,
                const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
              );
            },
          ),
          touchCallback: (FlTouchEvent event, barTouchResponse) {
            if (barTouchResponse != null && barTouchResponse.spot != null) {
              final index = barTouchResponse.spot!.touchedBarGroupIndex;
              if (event is FlPanDownEvent ||
                  event is FlTapDownEvent ||
                  event is FlPanUpdateEvent ||
                  event is FlLongPressMoveUpdate ||
                  event is FlLongPressStart ||
                  event is FlPointerHoverEvent) {
                setState(() {
                  _pressedIndex = index;
                });
              } else if (event is FlPanEndEvent || event is FlTapUpEvent || event is FlTapCancelEvent || event is FlLongPressEnd) {
                setState(() {
                  _pressedIndex = null;
                });
                if (event is! FlLongPressEnd) {
                  widget.onBarTap(index);
                }
              }
            } else if (event is FlPanEndEvent || event is FlTapUpEvent || event is FlTapCancelEvent || event is FlLongPressEnd) {
              setState(() {
                _pressedIndex = null;
              });
            }
          },
        ),
        titlesData: _buildTitlesData(),
        borderData: FlBorderData(show: true),
        gridData: const FlGridData(show: true),
        barGroups: _buildBarGroups(displayedData, isAttacker),
      ),
    );
  }

  FlTitlesData _buildTitlesData() {
    final isAttacker = widget.chartType == ChartType.attacker;
    final interval = _calculateLabelInterval(widget.probabilities.length).toDouble();

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

            final displayValue = isAttacker ? value.toInt() : widget.probabilities.length - 1 - value.toInt();

            return Text(displayValue.toString(), style: const TextStyle(fontSize: 12));
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

  List<BarChartGroupData> _buildBarGroups(List<double> displayedData, bool isAttacker) {
    final baseColor = isAttacker ? Colors.green : Colors.red;
    final barWidth = _calculateBarWidth(displayedData.length);
    return displayedData
        .asMap()
        .entries
        .map(
          (entry) => BarChartGroupData(
            x: entry.key,
            barRods: [
              BarChartRodData(
                toY: entry.value * 100,
                color: _pressedIndex == entry.key ? (isAttacker ? Colors.green.shade800 : Colors.red.shade900) : baseColor,
                width: barWidth,
                borderRadius: BorderRadius.zero,
              ),
            ],
          ),
        )
        .toList();
  }

  double _calculateBarWidth(int dataLength) {
    if (dataLength <= 20) return 16.0;
    if (dataLength <= 50) return 8.0;
    if (dataLength <= 100) return 4.0;
    return 2.0;
  }

  AxisTitles _buildLeftTitles() {
    return AxisTitles(
      sideTitles: SideTitles(
        showTitles: true,
        getTitlesWidget: (value, meta) {
          if (value >= widget.maxY * 0.95) {
            return const SizedBox.shrink();
          }
          return Text(value.toStringAsFixed(1), style: const TextStyle(fontSize: 11));
        },
      ),
      axisNameWidget: const Text('Wahrscheinlichkeit in %', style: TextStyle(fontSize: 12)),
    );
  }

  AxisTitles _buildRightTitles() {
    return AxisTitles(
      sideTitles: SideTitles(
        showTitles: true,
        getTitlesWidget: (value, meta) {
          if (value >= widget.maxY * 0.95) {
            return const SizedBox.shrink();
          }
          return Text(value.toStringAsFixed(1), style: const TextStyle(fontSize: 11));
        },
      ),
    );
  }

  int _calculateLabelInterval(int dataLength) {
    if (dataLength <= 20) return 1;
    return 5;
  }
}
