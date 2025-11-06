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
      axisNameSize: 40,
      sideTitles: SideTitles(
        showTitles: true,
        reservedSize: 30,
        getTitlesWidget: (value, meta) {
          if (value >= widget.maxY * 0.95) {
            return const SizedBox.shrink();
          }
          return Text(value.toStringAsFixed(1), style: const TextStyle(fontSize: 11));
        },
      ),
      axisNameWidget: const Text('Wahrscheinlichkeit in %', style: TextStyle(fontSize: 13)),
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
    if (dataLength <= 80) return 5;
    return 10;
  }

  Map<String, dynamic> _filterSignificantData(List<double> data) {
    int start = 0;
    int end = data.length;

    while (start < data.length && (data[start] * 100).toStringAsFixed(2) == '0.00') {
      start++;
    }

    while (end > start && (data[end - 1] * 100).toStringAsFixed(2) == '0.00') {
      end--;
    }

    return {'data': data.sublist(start, end), 'startIndex': start};
  }

  Widget _buildMergedTitles() {
    final attackerData = widget.attackerProbabilities!;
    final defenderData = widget.defenderProbabilities!.reversed.toList();

    final filteredAttackerData = _filterSignificantData(attackerData);
    final filteredDefenderData = _filterSignificantData(defenderData);

    final hasAttackerData = filteredAttackerData['data'].isNotEmpty;
    final hasDefenderData = filteredDefenderData['data'].isNotEmpty;

    final attackerPercentage = (widget.totalWinProbability * 100).toStringAsFixed(1);
    final defenderPercentage = ((1 - widget.totalWinProbability) * 100).toStringAsFixed(1);

    if (hasAttackerData && !hasDefenderData) {
      return Text(
        'Angreifer gewinnt ($attackerPercentage%)',
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.green),
        textAlign: TextAlign.center,
      );
    } else if (!hasAttackerData && hasDefenderData) {
      return Text(
        'Verteidiger gewinnt ($defenderPercentage%)',
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.red),
        textAlign: TextAlign.center,
      );
    }

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

    final filteredAttackerData = _filterSignificantData(attackerData);
    final filteredDefenderData = _filterSignificantData(defenderData);

    final hasAttackerData = filteredAttackerData['data'].isNotEmpty;
    final hasDefenderData = filteredDefenderData['data'].isNotEmpty;

    final totalLength =
        filteredAttackerData['data'].length +
        filteredDefenderData['data'].length +
        (hasAttackerData && hasDefenderData ? 1 : 0);
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
              final separatorIndex = hasAttackerData ? filteredAttackerData['data'].length : 0;
              if (hasAttackerData && hasDefenderData && group.x == separatorIndex) {
                return null;
              }
              final isAttacker = group.x < separatorIndex;
              if (isAttacker) {
                final losses = filteredAttackerData['startIndex'] + group.x.toInt();
                final probability = (rod.toY).toStringAsFixed(2);
                return BarTooltipItem(
                  'Sieg mit $losses Verlusten: $probability%',
                  const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                );
              } else {
                final adjustedIndex = hasAttackerData && hasDefenderData
                    ? group.x.toInt() - separatorIndex - 1
                    : group.x.toInt();
                final losses =
                    widget.defenderProbabilities!.length - 1 - (filteredDefenderData['startIndex'] + adjustedIndex);
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
        titlesData: _buildMergedTitlesData(
          filteredAttackerData['data'],
          filteredDefenderData['data'],
          filteredAttackerData['startIndex'],
          filteredDefenderData['startIndex'],
          hasAttackerData,
          hasDefenderData,
        ),
        borderData: FlBorderData(show: true, border: Border.all(color: Colors.black, width: 2)),
        gridData: const FlGridData(show: true),
        barGroups: _buildMergedBarGroups(
          filteredAttackerData['data'],
          filteredDefenderData['data'],
          barWidth,
          hasAttackerData,
          hasDefenderData,
        ),
      ),
    );
  }

  List<BarChartGroupData> _buildMergedBarGroups(
    List<double> attackerData,
    List<double> defenderData,
    double barWidth,
    bool hasAttackerData,
    bool hasDefenderData,
  ) {
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

    if (hasAttackerData && hasDefenderData) {
      allBars.add(
        BarChartGroupData(
          x: attackerData.length,
          barRods: [BarChartRodData(toY: widget.maxY, color: Colors.black, width: 2, borderRadius: BorderRadius.zero)],
        ),
      );
    }

    for (int i = 0; i < defenderData.length; i++) {
      final index = hasAttackerData && hasDefenderData ? attackerData.length + 1 + i : i;
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

  FlTitlesData _buildMergedTitlesData(
    List<double> attackerData,
    List<double> defenderData,
    int attackerStartIndex,
    int defenderStartIndex,
    bool hasAttackerData,
    bool hasDefenderData,
  ) {
    final maxDataLength = hasAttackerData && hasDefenderData
        ? (attackerData.length > defenderData.length ? attackerData.length : defenderData.length)
        : (hasAttackerData ? attackerData.length : defenderData.length);
    final interval = _calculateLabelInterval(maxDataLength).toDouble();
    final separatorIndex = hasAttackerData ? attackerData.length : 0;

    Widget axisLabel;
    if (hasAttackerData && !hasDefenderData) {
      axisLabel = const Text('Verluste des Angreifers', style: TextStyle(fontSize: 12), textAlign: TextAlign.center);
    } else if (!hasAttackerData && hasDefenderData) {
      axisLabel = const Text('Verluste des Verteidigers', style: TextStyle(fontSize: 12), textAlign: TextAlign.center);
    } else {
      axisLabel = Row(
        children: [
          Expanded(
            child: Text('Verluste des Angreifers', style: const TextStyle(fontSize: 12), textAlign: TextAlign.center),
          ),
          Expanded(
            child: Text('Verluste des Verteidigers', style: const TextStyle(fontSize: 12), textAlign: TextAlign.center),
          ),
        ],
      );
    }

    return FlTitlesData(
      show: true,
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          getTitlesWidget: (value, meta) {
            final x = value.toInt();
            if (hasAttackerData && hasDefenderData && x == separatorIndex) {
              return const SizedBox.shrink();
            }
            if (x < separatorIndex) {
              final attackerLossValue = attackerStartIndex + x;
              if (attackerLossValue % interval.toInt() != 0) {
                return const SizedBox.shrink();
              }
              return Text(attackerLossValue.toString(), style: const TextStyle(fontSize: 12));
            } else {
              final adjustedX = hasAttackerData && hasDefenderData ? x - separatorIndex - 1 : x;
              final defenderIndex = widget.defenderProbabilities!.length - 1 - (defenderStartIndex + adjustedX);
              if (defenderIndex % interval.toInt() != 0) {
                return const SizedBox.shrink();
              }
              return Text(defenderIndex.toString(), style: const TextStyle(fontSize: 12));
            }
          },
        ),
        axisNameWidget: axisLabel,
      ),
      leftTitles: AxisTitles(
        axisNameSize: 60,
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 40,
          getTitlesWidget: (value, meta) {
            if (value >= widget.maxY * 0.95) {
              return const SizedBox.shrink();
            }
            return Text(value.toStringAsFixed(1), style: const TextStyle(fontSize: 11));
          },
        ),
        axisNameWidget: const Text('Wahrscheinlichkeit in %', style: TextStyle(fontSize: 14)),
      ),
      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
    );
  }
}
