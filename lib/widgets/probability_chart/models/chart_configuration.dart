import 'package:flutter/material.dart';

class ChartConfiguration {
  static const Color attackerColor = Colors.green;
  static const Color defenderColor = Colors.red;
  static const Color attackerPressedColor = Color(0xFF2E7D32);
  static const Color defenderPressedColor = Color(0xFFB71C1C);
  static const Color separatorColor = Colors.black;

  static const double separatorWidth = 2.0;
  static const double borderWidth = 2.0;

  static const double smallBarWidth = 2.0;
  static const double mediumBarWidth = 4.0;
  static const double largeBarWidth = 8.0;
  static const double extraLargeBarWidth = 16.0;

  static const int smallLabelInterval = 1;
  static const int mediumLabelInterval = 5;
  static const int largeLabelInterval = 10;

  static const double maxYPaddingFactor = 1.1;
  static const double topLabelHideThreshold = 0.95;

  static const double leftTitleReservedSize = 30.0;
  static const double leftAxisNameSize = 40.0;

  static const double titleFontSize = 12.0;
  static const double axisLabelFontSize = 12.0;
  static const double axisNameFontSize = 13.0;
  static const double mergedAxisNameFontSize = 14.0;
  static const double tooltipFontSize = 12.0;

  static double calculateBarWidth(int dataLength) {
    if (dataLength <= 20) return extraLargeBarWidth;
    if (dataLength <= 50) return largeBarWidth;
    if (dataLength <= 100) return mediumBarWidth;
    return smallBarWidth;
  }

  static int calculateLabelInterval(int dataLength) {
    if (dataLength <= 20) return smallLabelInterval;
    if (dataLength <= 80) return mediumLabelInterval;
    return largeLabelInterval;
  }
}
