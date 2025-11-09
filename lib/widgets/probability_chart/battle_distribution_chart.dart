import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import 'builders/bar_group_builder.dart';
import 'builders/chart_axis_builder.dart';
import 'builders/chart_touch_handler.dart';
import 'models/chart_configuration.dart';
import 'models/chart_data_model.dart';

class BattleDistributionChart extends StatefulWidget {
  final ChartDataModel data;

  const BattleDistributionChart({super.key, required this.data});

  @override
  State<BattleDistributionChart> createState() => _BattleDistributionChartState();
}

class _BattleDistributionChartState extends State<BattleDistributionChart> {
  int? _pressedIndex;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: ChartAxisBuilder.buildTitleWidget(widget.data),
        ),
        Expanded(child: _buildChart()),
      ],
    );
  }

  Widget _buildChart() {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 4.0, bottom: 6.0),
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: widget.data.maxProbabilityPercent,
          barTouchData: ChartTouchHandler.createTouchData(
            data: widget.data,
            maxY: widget.data.maxProbabilityPercent,
            onIndexChanged: (index) => setState(() => _pressedIndex = index),
          ),
          titlesData: ChartAxisBuilder.buildTitlesData(data: widget.data, maxY: widget.data.maxProbabilityPercent),
          borderData: FlBorderData(
            show: true,
            border: Border.all(color: Colors.black, width: ChartConfiguration.borderWidth),
          ),
          gridData: const FlGridData(show: true),
          barGroups: BarGroupBuilder.buildMergedBarGroups(
            data: widget.data,
            pressedIndex: _pressedIndex,
            maxY: widget.data.maxProbabilityPercent,
          ),
        ),
      ),
    );
  }
}
