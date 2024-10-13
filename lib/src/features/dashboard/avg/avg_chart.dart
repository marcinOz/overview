import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:github/github.dart';
import 'package:intl/intl.dart';
import 'package:overview/src/features/dashboard/avg/chart_parts/pr_tooltip.dart';
import 'package:overview/src/localization/localizations.dart';

const List<Color> _gradientColors = [
  Color(0xff23b6e6),
  Color(0xff02d39a),
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
  String _bottomCurrentVal = "";

  Duration get period =>
      widget.prList.last.createdAt!.difference(widget.prList.first.createdAt!);

  @override
  Widget build(BuildContext context) => LineChart(
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

  LineTouchData _tooltipsData() => PRTooltip(
        context: context,
        prList: widget.prList,
      );

  FlGridData _flGridData() => FlGridData(
        show: true,
        drawVerticalLine: true,
        getDrawingHorizontalLine: (value) =>
            const FlLine(color: Color(0xff37434d), strokeWidth: 1),
        getDrawingVerticalLine: (value) =>
            const FlLine(color: Color(0xff37434d), strokeWidth: 1),
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
    final interval = widget.prList.first.createdAt!.difference(widget.prList.last.createdAt!).inMilliseconds / 8;
    return AxisTitles(
      sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 22,
          interval: interval,
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

  AxisTitles _leftTitles() => AxisTitles(
        sideTitles: SideTitles(
          reservedSize: 60,
          showTitles: true,
          getTitlesWidget: (value, titleMeta) => _isNotCompleteNumber(value)
              ? const SizedBox()
              : Text(
                  Loc.of(context).days(value.toInt()),
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
        gradient: const LinearGradient(colors: _gradientColors),
        barWidth: 5,
        isStrokeCapRound: true,
        dotData: const FlDotData(show: false),
        belowBarData: BarAreaData(
          show: true,
          gradient: LinearGradient(
            colors:
                _gradientColors.map((color) => color.withOpacity(0.3)).toList(),
          ),
        ),
      );

  bool _isNotCompleteNumber(double value) => value - value.toInt() > 0;
}
