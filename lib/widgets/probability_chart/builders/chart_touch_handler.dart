import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../models/chart_configuration.dart';
import '../models/chart_data_model.dart';

class ChartTouchHandler {
  static BarTouchData createTouchData({
    required ChartDataModel data,
    required double maxY,
    required Function(int?) onIndexChanged,
  }) {
    return BarTouchData(
      enabled: true,
      allowTouchBarBackDraw: true,
      touchExtraThreshold: EdgeInsets.only(top: maxY),
      touchTooltipData: BarTouchTooltipData(
        getTooltipItem: (group, groupIndex, rod, rodIndex) => _buildTooltipItem(group, rod, data),
      ),
      touchCallback: (event, response) => _handleTouchEvent(event, response, onIndexChanged),
    );
  }

  static BarTooltipItem? _buildTooltipItem(BarChartGroupData group, BarChartRodData rod, ChartDataModel data) {
    final separatorIndex = data.hasAttackerData ? data.attackerDistribution.length : 0;

    if (data.hasAttackerData && data.hasDefenderData && group.x == separatorIndex) {
      return null;
    }

    final isAttacker = group.x < separatorIndex;

    if (isAttacker) {
      final losses = data.attackerDistribution[group.x.toInt()].losses;
      final probability = rod.toY.toStringAsFixed(2);
      return BarTooltipItem(
        'Sieg mit $losses Verlusten: $probability%',
        const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: ChartConfiguration.tooltipFontSize),
      );
    } else {
      final adjustedIndex = data.hasAttackerData && data.hasDefenderData
          ? group.x.toInt() - separatorIndex - 1
          : group.x.toInt();
      if (adjustedIndex < 0 || adjustedIndex >= data.defenderDistribution.length) {
        return null;
      }
      final losses = data.defenderDistribution[adjustedIndex].losses;
      final probability = rod.toY.toStringAsFixed(2);
      return BarTooltipItem(
        'Niederlage mit $losses Verlusten: $probability%',
        const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: ChartConfiguration.tooltipFontSize),
      );
    }
  }

  static void _handleTouchEvent(FlTouchEvent event, BarTouchResponse? response, Function(int?) onIndexChanged) {
    if (response != null && response.spot != null) {
      final index = response.spot!.touchedBarGroupIndex;
      if (_isTouchStart(event)) {
        onIndexChanged(index);
      } else if (_isTouchEnd(event)) {
        onIndexChanged(null);
      }
    } else if (_isTouchEnd(event)) {
      onIndexChanged(null);
    }
  }

  static bool _isTouchStart(FlTouchEvent event) {
    return event is FlPanDownEvent ||
        event is FlTapDownEvent ||
        event is FlPanUpdateEvent ||
        event is FlLongPressMoveUpdate ||
        event is FlLongPressStart ||
        event is FlPointerHoverEvent;
  }

  static bool _isTouchEnd(FlTouchEvent event) {
    return event is FlPanEndEvent || event is FlTapUpEvent || event is FlTapCancelEvent || event is FlLongPressEnd;
  }
}
