import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../models/chart_configuration.dart';
import '../models/chart_data_model.dart';

class ChartAxisBuilder {
  static FlTitlesData buildTitlesData({required ChartDataModel data, required double maxY}) {
    return FlTitlesData(
      show: true,
      bottomTitles: _buildBottomTitles(data),
      leftTitles: _buildLeftTitles(maxY),
      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
    );
  }

  static AxisTitles _buildBottomTitles(ChartDataModel data) {
    final maxDataLength = data.hasAttackerData && data.hasDefenderData
        ? (data.attackerDistribution.length > data.defenderDistribution.length
              ? data.attackerDistribution.length
              : data.defenderDistribution.length)
        : (data.hasAttackerData ? data.attackerDistribution.length : data.defenderDistribution.length);

    final interval = ChartConfiguration.calculateLabelInterval(maxDataLength).toDouble();
    final separatorIndex = data.hasAttackerData ? data.attackerDistribution.length : 0;

    return AxisTitles(
      sideTitles: SideTitles(
        showTitles: true,
        getTitlesWidget: (value, meta) {
          final x = value.toInt();

          if (data.hasAttackerData && data.hasDefenderData && x == separatorIndex) {
            return const SizedBox.shrink();
          }

          if (x < separatorIndex) {
            final lossValue = data.attackerDistribution[x].losses;
            if (lossValue % interval.toInt() != 0) {
              return const SizedBox.shrink();
            }
            return Text(lossValue.toString(), style: const TextStyle(fontSize: ChartConfiguration.axisLabelFontSize));
          } else {
            final adjustedX = data.hasAttackerData && data.hasDefenderData ? x - separatorIndex - 1 : x;
            if (adjustedX < 0 || adjustedX >= data.defenderDistribution.length) {
              return const SizedBox.shrink();
            }
            final lossValue = data.defenderDistribution[adjustedX].losses;
            if (lossValue % interval.toInt() != 0) {
              return const SizedBox.shrink();
            }
            return Text(lossValue.toString(), style: const TextStyle(fontSize: ChartConfiguration.axisLabelFontSize));
          }
        },
      ),
      axisNameWidget: _buildBottomAxisLabel(data),
    );
  }

  static Widget _buildBottomAxisLabel(ChartDataModel data) {
    if (data.hasAttackerData && !data.hasDefenderData) {
      return const Text(
        'Verluste des Angreifers',
        style: TextStyle(fontSize: ChartConfiguration.mergedAxisNameFontSize),
        textAlign: TextAlign.center,
      );
    } else if (!data.hasAttackerData && data.hasDefenderData) {
      return const Text(
        'Verluste des Verteidigers',
        style: TextStyle(fontSize: ChartConfiguration.mergedAxisNameFontSize),
        textAlign: TextAlign.center,
      );
    } else {
      return Row(
        children: const [
          Expanded(
            child: Text(
              'Verluste des Angreifers',
              style: TextStyle(fontSize: ChartConfiguration.mergedAxisNameFontSize),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: Text(
              'Verluste des Verteidigers',
              style: TextStyle(fontSize: ChartConfiguration.mergedAxisNameFontSize),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      );
    }
  }

  static AxisTitles _buildLeftTitles(double maxY) {
    return AxisTitles(
      axisNameSize: ChartConfiguration.leftAxisNameSize,
      sideTitles: SideTitles(
        showTitles: true,
        reservedSize: ChartConfiguration.leftTitleReservedSize,
        getTitlesWidget: (value, meta) {
          if (value >= maxY * ChartConfiguration.topLabelHideThreshold) {
            return const SizedBox.shrink();
          }
          return Text(value.toStringAsFixed(1), style: const TextStyle(fontSize: 11));
        },
      ),
      axisNameWidget: const Text(
        'Wahrscheinlichkeit in %',
        style: TextStyle(fontSize: ChartConfiguration.axisNameFontSize),
      ),
    );
  }

  static Widget buildTitleWidget(ChartDataModel data) {
    final attackerPercentage = (data.totalAttackerWinProbability * 100).toStringAsFixed(1);
    final defenderPercentage = (data.totalDefenderWinProbability * 100).toStringAsFixed(1);

    if (data.hasAttackerData && !data.hasDefenderData) {
      return Text(
        'Angreifer gewinnt ($attackerPercentage%)',
        style: const TextStyle(
          fontSize: ChartConfiguration.titleFontSize,
          fontWeight: FontWeight.bold,
          color: ChartConfiguration.attackerColor,
        ),
        textAlign: TextAlign.center,
      );
    } else if (!data.hasAttackerData && data.hasDefenderData) {
      return Text(
        'Verteidiger gewinnt ($defenderPercentage%)',
        style: const TextStyle(
          fontSize: ChartConfiguration.titleFontSize,
          fontWeight: FontWeight.bold,
          color: ChartConfiguration.defenderColor,
        ),
        textAlign: TextAlign.center,
      );
    }

    return Row(
      children: [
        Expanded(
          child: Text(
            'Angreifer gewinnt ($attackerPercentage%)',
            style: const TextStyle(
              fontSize: ChartConfiguration.titleFontSize,
              fontWeight: FontWeight.bold,
              color: ChartConfiguration.attackerColor,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        Expanded(
          child: Text(
            'Verteidiger gewinnt ($defenderPercentage%)',
            style: const TextStyle(
              fontSize: ChartConfiguration.titleFontSize,
              fontWeight: FontWeight.bold,
              color: ChartConfiguration.defenderColor,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
