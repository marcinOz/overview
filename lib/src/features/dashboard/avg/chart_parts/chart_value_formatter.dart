import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

/// A utility class for formatting and configuring the y-axis (left axis) of charts
class ChartValueFormatter {
  /// Calculate appropriate interval for left axis labels based on max value
  /// to prevent overlapping
  static double getYAxisInterval(List<FlSpot> spots,
      {bool isDurationValue = true}) {
    // Get the max value from the chart data
    double maxValue = 0;
    for (final spot in spots) {
      if (spot.y > maxValue) {
        maxValue = spot.y;
      }
    }

    // Different interval scales for duration charts vs count charts
    if (isDurationValue) {
      // For duration charts (showing days/hours)
      if (maxValue > 50) return 10.0;
      if (maxValue > 30) return 5.0;
      if (maxValue > 15) return 5.0;
      if (maxValue > 5) return 2.5;
      return 1.0;
    } else {
      // For count charts (showing PR numbers)
      if (maxValue > 15) return 5.0;
      if (maxValue > 10) return 2.0;
      if (maxValue > 5) return 1.0;
      return 0.5; // Smaller increment for small values
    }
  }

  /// Format duration value for y-axis
  /// Converts to days/hours with appropriate formatting
  static String formatDurationValue(double value) {
    if (value > 1) {
      // For larger values (days), trim decimal places for large numbers
      if (value >= 10) {
        return '${value.toInt()} D';
      } else {
        return '${value.toStringAsFixed(1)} D';
      }
    } else {
      // For hours
      return '${(value * 24).toInt()} H';
    }
  }

  /// Format count value for y-axis
  /// Shows clean integers or fixed decimals as appropriate
  static String formatCountValue(double value) {
    // For PR numbers, always use integers for whole numbers
    if (value == value.toInt()) {
      return value.toInt().toString();
    }
    // For fractional values, use a single decimal place
    return value.toStringAsFixed(1);
  }

  /// Get a properly configured AxisTitles for duration values (days/hours)
  static AxisTitles getDurationAxisTitles(List<FlSpot> spots) {
    final interval = getYAxisInterval(spots, isDurationValue: true);

    return AxisTitles(
      sideTitles: SideTitles(
        reservedSize: 60,
        showTitles: true,
        interval: interval,
        getTitlesWidget: (value, titleMeta) => Text(
          formatDurationValue(value),
          style: const TextStyle(
            color: Color(0xff67727d),
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  /// Get a properly configured AxisTitles for count values (PR numbers)
  static AxisTitles getCountAxisTitles(List<FlSpot> spots) {
    final interval = getYAxisInterval(spots, isDurationValue: false);

    return AxisTitles(
      sideTitles: SideTitles(
        reservedSize: 40, // Less space needed for count values
        showTitles: true,
        interval: interval,
        getTitlesWidget: (value, titleMeta) => Text(
          formatCountValue(value),
          style: const TextStyle(
            color: Color(0xff67727d),
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}
