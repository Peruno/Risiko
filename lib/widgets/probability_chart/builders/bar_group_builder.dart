import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../models/chart_configuration.dart';
import '../models/chart_data_model.dart';

class BarGroupBuilder {
  static List<BarChartGroupData> buildMergedBarGroups({
    required ChartDataModel data,
    required int? pressedIndex,
    required double maxY,
  }) {
    final allBars = <BarChartGroupData>[];
    final barWidth = ChartConfiguration.calculateBarWidth(
      data.attackerDistribution.length +
          data.defenderDistribution.length +
          (data.hasAttackerData && data.hasDefenderData ? 1 : 0),
    );

    for (int i = 0; i < data.attackerDistribution.length; i++) {
      allBars.add(
        BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              toY: data.attackerDistribution[i].probabilityPercent,
              color: pressedIndex == i ? ChartConfiguration.attackerPressedColor : ChartConfiguration.attackerColor,
              width: barWidth,
              borderRadius: BorderRadius.zero,
            ),
          ],
        ),
      );
    }

    if (data.hasAttackerData && data.hasDefenderData) {
      allBars.add(
        BarChartGroupData(
          x: data.attackerDistribution.length,
          barRods: [
            BarChartRodData(
              toY: maxY,
              color: ChartConfiguration.separatorColor,
              width: ChartConfiguration.separatorWidth,
              borderRadius: BorderRadius.zero,
            ),
          ],
        ),
      );
    }

    for (int i = 0; i < data.defenderDistribution.length; i++) {
      final index = data.hasAttackerData && data.hasDefenderData ? data.attackerDistribution.length + 1 + i : i;
      allBars.add(
        BarChartGroupData(
          x: index,
          barRods: [
            BarChartRodData(
              toY: data.defenderDistribution[i].probabilityPercent,
              color: pressedIndex == index ? ChartConfiguration.defenderPressedColor : ChartConfiguration.defenderColor,
              width: barWidth,
              borderRadius: BorderRadius.zero,
            ),
          ],
        ),
      );
    }

    return allBars;
  }
}
