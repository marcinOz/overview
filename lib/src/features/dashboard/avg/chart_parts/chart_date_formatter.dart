import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// A utility class for handling date formatting and intervals in charts
class ChartDateFormatter {
  /// Calculate appropriate date intervals based on total project duration
  static double getDateInterval(int durationInMillis) {
    // For short time periods (< 1 month), show fewer labels
    if (durationInMillis < Duration.millisecondsPerDay * 30) {
      return (durationInMillis / 4).toDouble();
    }
    // For periods < 3 months, show weekly labels
    else if (durationInMillis < Duration.millisecondsPerDay * 90) {
      return Duration.millisecondsPerDay * 7.0; // Weekly intervals
    }
    // For periods < 6 months, show biweekly labels
    else if (durationInMillis < Duration.millisecondsPerDay * 180) {
      return Duration.millisecondsPerDay * 14.0; // Biweekly intervals
    }
    // For periods < 1 year, show monthly labels
    else if (durationInMillis < Duration.millisecondsPerDay * 365) {
      return Duration.millisecondsPerDay * 30.0; // Monthly intervals
    }
    // For periods > 1 year, show quarterly labels
    else {
      return Duration.millisecondsPerDay * 90.0; // Quarterly intervals
    }
  }

  /// Get a date format string based on the current interval
  static String getDateFormatForInterval(double interval) {
    if (interval >= Duration.millisecondsPerDay * 90) {
      // For quarterly or longer intervals, just show month and year
      return 'MM.yyyy';
    } else if (interval >= Duration.millisecondsPerDay * 30) {
      // For monthly intervals
      return 'MM.yyyy';
    } else if (interval >= Duration.millisecondsPerDay * 14) {
      // For biweekly intervals
      return 'dd.MM';
    } else {
      // For very short intervals (weekly or less)
      return 'dd.MM';
    }
  }

  /// Get a widget that displays a date label for chart axis
  static Widget getDateLabel(double value, double interval) {
    final date = DateTime.fromMillisecondsSinceEpoch(value.toInt());
    final dateFormat = getDateFormatForInterval(interval);
    final title = DateFormat(dateFormat).format(date);

    // For very dense time periods, use smaller horizontal labels without rotation
    if (interval <= Duration.millisecondsPerDay * 7.0) {
      return Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.only(top: 5.0),
        child: Text(
          title,
          style: const TextStyle(
            color: Color(0xff68737d),
            fontWeight: FontWeight.bold,
            fontSize: 10, // Smaller font size for dense data
          ),
          textAlign: TextAlign.center,
        ),
      );
    }

    // For medium density periods, use horizontal labels with standard font
    if (interval <= Duration.millisecondsPerDay * 21.0) {
      return Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.only(top: 5.0),
        child: Text(
          title,
          style: const TextStyle(
            color: Color(0xff68737d),
            fontWeight: FontWeight.bold,
            fontSize: 11,
          ),
          textAlign: TextAlign.center,
        ),
      );
    }

    // For less dense data, use angled text
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.only(top: 5.0),
      child: Transform.rotate(
        angle: -0.5, // ~30 degree angle for better readability
        alignment: Alignment.center, // Ensure consistent alignment
        child: SizedBox(
          width: 60, // Ensure width is constrained for rotated text
          child: Text(
            title,
            style: const TextStyle(
              color: Color(0xff68737d),
              fontWeight: FontWeight.bold,
              fontSize: 11,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
