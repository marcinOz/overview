import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:github/github.dart';
import 'package:overview/src/features/dashboard/avg/chart_parts/chart_date_formatter.dart';
import 'package:overview/src/features/dashboard/avg/chart_parts/chart_value_formatter.dart';
import 'package:overview/src/features/dashboard/avg/chart_parts/pr_tooltip.dart';
import 'package:styleguide/src/app_colors.dart';
import 'package:styleguide/styleguide.dart';

// Use colors from our AppColors class
const List<Color> _gradientColors = [
  AppColors.chartGradientStart,
  AppColors.chartGradientEnd,
];

class AvgChart extends StatefulWidget {
  const AvgChart({
    Key? key,
    required this.prList,
    required this.mapPrsToSpots,
  }) : super(key: key);

  final List<PullRequest> prList;
  final List<FlSpot> Function(List<PullRequest>) mapPrsToSpots;

  @override
  State<AvgChart> createState() => _AvgChartState();
}

class _AvgChartState extends State<AvgChart> {
  // Get the appropriate interval based on project duration
  double get _dateInterval =>
      ChartDateFormatter.getDateInterval(_projectDuration);

  // Get the data points that will be displayed on the chart
  List<FlSpot> get _dataSpots => widget.mapPrsToSpots(widget.prList);

  int get _projectDuration {
    if (widget.prList.isEmpty || widget.prList.length == 1) {
      // Return a default value if there are no PRs or only one PR
      return Duration.millisecondsPerDay * 30; // Default to 30 days
    }

    return widget.prList.first.createdAt!
        .difference(widget.prList.last.createdAt!)
        .abs() // Ensure positive value
        .inMilliseconds;
  }

  @override
  Widget build(BuildContext context) {
    // If there are no PRs, show a message instead of the chart
    if (widget.prList.isEmpty) {
      return Center(
        child: Text(
          'No pull requests to display for the selected period',
          style: TextStyle(
            fontSize: 16,
            color: context.isDarkMode
                ? AppColors.darkTextPrimary
                : AppColors.lightTextPrimary,
          ),
        ),
      );
    }

    return LineChart(
      LineChartData(
        gridData: _flGridData(),
        titlesData: _flTitlesData(),
        borderData: _flBorderData(),
        minY: 0,
        lineTouchData: _tooltipsData(),
        lineBarsData: [
          _lineChartBarData(widget.prList),
        ],
      ),
    );
  }

  LineTouchData _tooltipsData() => PRTooltip(
        context: context,
        prList: widget.prList,
      );

  FlGridData _flGridData() => FlGridData(
        show: true,
        drawVerticalLine: true,
        verticalInterval: Duration.millisecondsPerDay / 2,
        getDrawingHorizontalLine: (value) {
          final gridColor = context.isDarkMode
              ? AppColors.darkTextSecondary.withOpacity(0.2)
              : AppColors.lightTextSecondary.withOpacity(0.2);
          return FlLine(color: gridColor, strokeWidth: 1);
        },
        getDrawingVerticalLine: (value) {
          final date = DateTime.fromMillisecondsSinceEpoch(value.toInt());
          final isWeekend = date.weekday == DateTime.saturday ||
              date.weekday == DateTime.sunday;

          final gridColor = context.isDarkMode
              ? AppColors.darkTextSecondary.withOpacity(0.1)
              : AppColors.lightTextSecondary.withOpacity(0.1);

          return FlLine(
            color: isWeekend
                ? AppColors.weekendHighlight.withOpacity(0.3)
                : gridColor,
            strokeWidth: 2,
          );
        },
      );

  FlTitlesData _flTitlesData() => FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        bottomTitles: _bottomTitles(),
        leftTitles: ChartValueFormatter.getDurationAxisTitles(_dataSpots),
      );

  AxisTitles _bottomTitles() {
    final interval = _dateInterval;

    return AxisTitles(
      sideTitles: SideTitles(
        showTitles: true,
        reservedSize:
            40, // Increased from 30 to allow more vertical space for labels
        interval: interval,
        getTitlesWidget: (value, titleMeta) =>
            ChartDateFormatter.getDateLabel(value, interval),
      ),
    );
  }

  FlBorderData _flBorderData() {
    final borderColor = context.isDarkMode
        ? AppColors.darkTextSecondary.withOpacity(0.3)
        : AppColors.lightTextSecondary.withOpacity(0.3);

    return FlBorderData(
      show: true,
      border: Border.all(color: borderColor, width: 1),
    );
  }

  LineChartBarData _lineChartBarData(List<PullRequest> prList) =>
      LineChartBarData(
        spots: _dataSpots,
        isCurved: false,
        gradient: const LinearGradient(colors: _gradientColors),
        barWidth: 5,
        isStrokeCapRound: true,
        dotData: const FlDotData(show: false),
        belowBarData: BarAreaData(
          show: true,
          spotsLine: _highlightDataSpots(),
          gradient: LinearGradient(
            colors:
                _gradientColors.map((color) => color.withOpacity(0.3)).toList(),
          ),
        ),
      );

  BarAreaSpotsLine _highlightDataSpots() {
    return BarAreaSpotsLine(
      show: true,
      flLineStyle: FlLine(
        color: Theme.of(context).highlightColor.withOpacity(0.5),
        strokeWidth: 2,
      ),
    );
  }
}
