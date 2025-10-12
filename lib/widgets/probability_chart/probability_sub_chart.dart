import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

enum ChartType { attacker, defender, merged }

class ProbabilitySubChart extends StatefulWidget {
  final ChartType chartType;
  final List<double>? probabilities;
  final List<double>? attackerProbabilities;
  final List<double>? defenderProbabilities;
  final double totalWinProbability;
  final double maxY;

  const ProbabilitySubChart({
    super.key,
    required this.chartType,
    this.probabilities,
    this.attackerProbabilities,
    this.defenderProbabilities,
    required this.totalWinProbability,
    required this.maxY,
  });

  @override
  State<ProbabilitySubChart> createState() => _ProbabilitySubChartState();
}

class _ProbabilitySubChartState extends State<ProbabilitySubChart> {
  int? _pressedIndex;

  @override
  Widget build(BuildContext context) {
    if (widget.chartType == ChartType.merged) {
      return Column(
        children: [
          _buildMergedTitles(),
          Expanded(child: _buildMergedChart()),
        ],
      );
    }
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
    final displayedData = isAttacker ? widget.probabilities! : widget.probabilities!.reversed.toList();

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: widget.maxY,
        barTouchData: BarTouchData(
          enabled: true,
          allowTouchBarBackDraw: true,
          touchExtraThreshold: EdgeInsets.only(top: widget.maxY),
          touchTooltipData: BarTouchTooltipData(
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              final isAttacker = widget.chartType == ChartType.attacker;
              final losses = isAttacker ? group.x.toInt() : widget.probabilities!.length - 1 - group.x.toInt();
              final probability = (rod.toY).toStringAsFixed(2);
              final label = isAttacker
                  ? 'Sieg mit $losses Verlusten: $probability%'
                  : 'Niederlage mit $losses Verlusten: $probability%';
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
              } else if (event is FlPanEndEvent ||
                  event is FlTapUpEvent ||
                  event is FlTapCancelEvent ||
                  event is FlLongPressEnd) {
                setState(() {
                  _pressedIndex = null;
                });
              }
            } else if (event is FlPanEndEvent ||
                event is FlTapUpEvent ||
                event is FlTapCancelEvent ||
                event is FlLongPressEnd) {
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
    final interval = _calculateLabelInterval(widget.probabilities!.length).toDouble();

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

            final displayValue = isAttacker ? value.toInt() : widget.probabilities!.length - 1 - value.toInt();

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
                color: _pressedIndex == entry.key
                    ? (isAttacker ? Colors.green.shade800 : Colors.red.shade900)
                    : baseColor,
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
    if (dataLength <= 50) return 5;
    return 10;
  }

  Widget _buildMergedTitles() {
    final attackerPercentage = (widget.totalWinProbability * 100).toStringAsFixed(1);
    final defenderPercentage = ((1 - widget.totalWinProbability) * 100).toStringAsFixed(1);

    return Row(
      children: [
        Expanded(
          child: Text(
            'Angreifer gewinnt ($attackerPercentage%)',
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.green),
            textAlign: TextAlign.center,
          ),
        ),
        Expanded(
          child: Text(
            'Verteidiger gewinnt ($defenderPercentage%)',
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.red),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Widget _buildMergedChart() {
    final attackerData = widget.attackerProbabilities!;
    final defenderData = widget.defenderProbabilities!.reversed.toList();
    final totalLength = attackerData.length + defenderData.length;
    final barWidth = _calculateBarWidth(totalLength);

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: widget.maxY,
        barTouchData: BarTouchData(
          enabled: true,
          allowTouchBarBackDraw: true,
          touchExtraThreshold: EdgeInsets.only(top: widget.maxY),
          touchTooltipData: BarTouchTooltipData(
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              if (group.x == attackerData.length) {
                return null;
              }
              final isAttacker = group.x < attackerData.length;
              if (isAttacker) {
                final losses = group.x.toInt();
                final probability = (rod.toY).toStringAsFixed(2);
                return BarTooltipItem(
                  'Sieg mit $losses Verlusten: $probability%',
                  const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                );
              } else {
                final losses = widget.defenderProbabilities!.length - 1 - (group.x.toInt() - attackerData.length - 1);
                final probability = (rod.toY).toStringAsFixed(2);
                return BarTooltipItem(
                  'Niederlage mit $losses Verlusten: $probability%',
                  const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                );
              }
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
              } else if (event is FlPanEndEvent ||
                  event is FlTapUpEvent ||
                  event is FlTapCancelEvent ||
                  event is FlLongPressEnd) {
                setState(() {
                  _pressedIndex = null;
                });
              }
            } else if (event is FlPanEndEvent ||
                event is FlTapUpEvent ||
                event is FlTapCancelEvent ||
                event is FlLongPressEnd) {
              setState(() {
                _pressedIndex = null;
              });
            }
          },
        ),
        titlesData: _buildMergedTitlesData(attackerData.length, defenderData.length),
        borderData: FlBorderData(show: true, border: Border.all(color: Colors.black, width: 2)),
        gridData: const FlGridData(show: true),
        barGroups: _buildMergedBarGroups(attackerData, defenderData, barWidth),
      ),
    );
  }

  List<BarChartGroupData> _buildMergedBarGroups(List<double> attackerData, List<double> defenderData, double barWidth) {
    final allBars = <BarChartGroupData>[];

    for (int i = 0; i < attackerData.length; i++) {
      allBars.add(
        BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              toY: attackerData[i] * 100,
              color: _pressedIndex == i ? Colors.green.shade800 : Colors.green,
              width: barWidth,
              borderRadius: BorderRadius.zero,
            ),
          ],
        ),
      );
    }

    allBars.add(
      BarChartGroupData(
        x: attackerData.length,
        barRods: [BarChartRodData(toY: widget.maxY, color: Colors.black, width: 2, borderRadius: BorderRadius.zero)],
      ),
    );

    for (int i = 0; i < defenderData.length; i++) {
      final index = attackerData.length + 1 + i;
      allBars.add(
        BarChartGroupData(
          x: index,
          barRods: [
            BarChartRodData(
              toY: defenderData[i] * 100,
              color: _pressedIndex == index ? Colors.red.shade900 : Colors.red,
              width: barWidth,
              borderRadius: BorderRadius.zero,
            ),
          ],
        ),
      );
    }

    return allBars;
  }

  FlTitlesData _buildMergedTitlesData(int attackerLength, int defenderLength) {
    final attackerInterval = _calculateLabelInterval(attackerLength).toDouble();
    final defenderInterval = _calculateLabelInterval(defenderLength).toDouble();

    return FlTitlesData(
      show: true,
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          getTitlesWidget: (value, meta) {
            final x = value.toInt();
            if (x == attackerLength) {
              return const SizedBox.shrink();
            }
            if (x < attackerLength) {
              if (x % attackerInterval.toInt() != 0) {
                return const SizedBox.shrink();
              }
              return Text(x.toString(), style: const TextStyle(fontSize: 12));
            } else {
              final defenderIndex = defenderLength - 1 - (x - attackerLength - 1);
              if ((x - attackerLength - 1) % defenderInterval.toInt() != 0) {
                return const SizedBox.shrink();
              }
              return Text(defenderIndex.toString(), style: const TextStyle(fontSize: 12));
            }
          },
        ),
        axisNameWidget: Row(
          children: [
            Expanded(
              child: Text('Verluste des Angreifers', style: const TextStyle(fontSize: 12), textAlign: TextAlign.center),
            ),
            Expanded(
              child: Text(
                'Verluste des Verteidigers',
                style: const TextStyle(fontSize: 12),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
      leftTitles: AxisTitles(
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
      ),
      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
    );
  }
}
