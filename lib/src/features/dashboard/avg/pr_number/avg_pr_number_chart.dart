import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:github/github.dart';
import 'package:intl/intl.dart';
import 'package:overview/src/extensions/double_ext.dart';
import 'package:overview/src/extensions/week_of_year.dart';
import 'package:overview/src/features/dashboard/avg/chart_parts/period_selector.dart';
import 'package:overview/src/features/dashboard/avg/chart_parts/pr_tooltip.dart';
import 'package:overview/src/features/dashboard/chart_period/chart_period_cubit.dart';
import 'package:overview/src/use_case/count_avg_pr_per_week_use_case.dart';

class AvgPrNumberChart extends StatelessWidget {
  const AvgPrNumberChart({
    Key? key,
    required this.prList,
  }) : super(key: key);

  final List<PullRequest> prList;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChartPeriodCubit, PeriodSelectorData>(
      builder: (context, periodData) {
        final filteredPrList = _filterPRsByPeriod(prList, periodData);

        // Handle empty list case
        if (filteredPrList.isEmpty) {
          return const Center(
            child: Text(
              'No pull requests to display for the selected period',
              style: TextStyle(fontSize: 16),
            ),
          );
        }

        return PrNumberCustomChart(
          prList: filteredPrList,
          mapPrsToSpots: getSpotsFromPRs,
        );
      },
    );
  }

  List<PullRequest> _filterPRsByPeriod(
      List<PullRequest> prList, PeriodSelectorData periodData) {
    if (periodData.period == ChartPeriod.all) return prList;

    return prList
        .where((pr) =>
            pr.createdAt != null && periodData.isInPeriod(pr.createdAt!))
        .toList();
  }

  List<FlSpot> getSpotsFromPRs(List<PullRequest> prList) {
    if (prList.isEmpty) {
      return [];
    }

    final result = prList.map((pr) {
      final FlSpot spot = FlSpot(
        pr.createdAt!.millisecondsSinceEpoch.toDouble(),
        _getPRLeadTimeInDays(prList, pr),
      );
      return spot;
    }).toList();
    return result;
  }

  double _getPRLeadTimeInDays(List<PullRequest> list, PullRequest pr) {
    if (list.isEmpty) {
      return 0;
    }

    int week = pr.createdAt!.weekOfYear;
    List<PullRequest> subList =
        list.where((element) => element.createdAt!.weekOfYear == week).toList();
    double avg = CountAvgPrPerWeekUseCase()(subList);
    return avg.toPrecision(1);
  }
}

// Custom chart implementation for PR number chart that shows just numbers on the left axis
class PrNumberCustomChart extends StatefulWidget {
  const PrNumberCustomChart({
    Key? key,
    required this.prList,
    required this.mapPrsToSpots,
  }) : super(key: key);

  final List<PullRequest> prList;
  final List<FlSpot> Function(List<PullRequest>) mapPrsToSpots;

  @override
  State<PrNumberCustomChart> createState() => _PrNumberCustomChartState();
}

class _PrNumberCustomChartState extends State<PrNumberCustomChart> {
  String _bottomCurrentVal = "";

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

  LineTouchData _tooltipsData() => LineTouchData(
        enabled: true,
        touchTooltipData: LineTouchTooltipData(
          getTooltipItems: (spots) => spots.map((s) {
            final pr = widget.prList[s.spotIndex];
            return LineTooltipItem(
              'PR #${pr.number}: ${s.y} PRs',
              const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            );
          }).toList(),
        ),
      );

  FlGridData _flGridData() => FlGridData(
        show: true,
        drawVerticalLine: true,
        verticalInterval: Duration.millisecondsPerDay / 2,
        getDrawingHorizontalLine: (value) =>
            const FlLine(color: Color(0xff37434d), strokeWidth: 1),
        getDrawingVerticalLine: (value) {
          final date = DateTime.fromMillisecondsSinceEpoch(value.toInt());
          final isWeekend = date.weekday == DateTime.saturday ||
              date.weekday == DateTime.sunday;
          return FlLine(
            color: isWeekend
                ? const Color(0xff9C27B0).withOpacity(0.3)
                : const Color(0x2037434d),
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
        leftTitles: _leftTitles(),
      );

  AxisTitles _bottomTitles() {
    // Ensure interval is never zero or negative
    final interval = _projectDuration / 8;
    final safeInterval = interval <= 0
        ? Duration.millisecondsPerDay.toDouble()
        : interval.toDouble();

    return AxisTitles(
      sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 22,
          interval: safeInterval,
          getTitlesWidget: (value, titleMeta) {
            final title = DateFormat('dd.MM.yyyy')
                .format(DateTime.fromMillisecondsSinceEpoch(value.toInt()));

            if (_bottomCurrentVal == title) return const SizedBox();

            _bottomCurrentVal = title;
            return Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(
                title,
                style: const TextStyle(
                  color: Color(0xff68737d),
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            );
          }),
    );
  }

  // Custom left titles implementation that shows just numbers without the 'D' suffix
  AxisTitles _leftTitles() => AxisTitles(
        sideTitles: SideTitles(
          reservedSize: 40, // Reduced size since we don't have the 'D' suffix
          showTitles: true,
          getTitlesWidget: (value, titleMeta) => Text(
            // Just show the number without any suffix
            value.toStringAsFixed(1),
            style: const TextStyle(
              color: Color(0xff67727d),
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
      );

  FlBorderData _flBorderData() => FlBorderData(
        show: true,
        border: Border.all(color: const Color(0xff37434d), width: 1),
      );

  LineChartBarData _lineChartBarData(List<PullRequest> prList) =>
      LineChartBarData(
        spots: widget.mapPrsToSpots(prList),
        isCurved: false,
        gradient: const LinearGradient(colors: [
          Color(0xff23b6e6),
          Color(0xff02d39a),
        ]),
        barWidth: 5,
        isStrokeCapRound: true,
        dotData: const FlDotData(show: false),
        belowBarData: BarAreaData(
          show: true,
          gradient: LinearGradient(
            colors: [
              const Color(0xff23b6e6).withOpacity(0.3),
              const Color(0xff02d39a).withOpacity(0.3),
            ],
          ),
        ),
      );
}
