import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:github/github.dart';
import 'package:intl/intl.dart';

const List<Color> _gradientColors = [
  Color(0xff23b6e6),
  Color(0xff02d39a),
];

class AvgChart extends StatelessWidget {
  const AvgChart({Key? key, required this.prList}) : super(key: key);

  final List<PullRequest> prList;

  @override
  Widget build(BuildContext context) => LineChart(data(prList));

  LineChartData data(List<PullRequest> prList) {
    return LineChartData(
      gridData: flGridData(),
      titlesData: flTitlesData(),
      borderData: flBorderData(),
      minY: 0,
      maxY: 10,
      lineBarsData: [
        lineChartBarData(prList),
      ],
    );
  }

  FlGridData flGridData() {
    return FlGridData(
      show: true,
      drawVerticalLine: true,
      getDrawingHorizontalLine: (value) =>
          FlLine(color: const Color(0xff37434d), strokeWidth: 1),
      getDrawingVerticalLine: (value) =>
          FlLine(color: const Color(0xff37434d), strokeWidth: 1),
    );
  }

  FlTitlesData flTitlesData() {
    return FlTitlesData(
      show: true,
      rightTitles: SideTitles(showTitles: false),
      topTitles: SideTitles(showTitles: false),
      bottomTitles: bottomTitles(),
      leftTitles: leftTitles(),
    );
  }

  SideTitles bottomTitles() {
    return SideTitles(
      showTitles: true,
      reservedSize: 22,
      interval: 5259600000,
      getTextStyles: (context, value) => const TextStyle(
        color: Color(0xff68737d),
        fontWeight: FontWeight.bold,
        fontSize: 16,
      ),
      getTitles: (value) => DateFormat('MMM')
          .format(DateTime.fromMillisecondsSinceEpoch(value.toInt())),
      margin: 8,
    );
  }

  SideTitles leftTitles() {
    return SideTitles(
      showTitles: true,
      interval: 1,
      getTextStyles: (context, value) => const TextStyle(
        color: Color(0xff67727d),
        fontWeight: FontWeight.bold,
        fontSize: 15,
      ),
      getTitles: (value) {
        return '$value D';
      },
      margin: 12,
    );
  }

  FlBorderData flBorderData() {
    return FlBorderData(
        show: true,
        border: Border.all(color: const Color(0xff37434d), width: 1));
  }

  LineChartBarData lineChartBarData(List<PullRequest> prList) {
    return LineChartBarData(
      spots: getSpotsFromPRs(prList),
      isCurved: true,
      colors: _gradientColors,
      barWidth: 5,
      isStrokeCapRound: true,
      dotData: FlDotData(
        show: false,
      ),
      belowBarData: BarAreaData(
        show: true,
        colors: _gradientColors.map((color) => color.withOpacity(0.3)).toList(),
      ),
    );
  }

  List<FlSpot> getSpotsFromPRs(List<PullRequest> prList) {
    final result = prList.map((pr) {
      final FlSpot spot = FlSpot(
        pr.closedAt!.millisecondsSinceEpoch.toDouble(),
        _getPRLeadTime(prList, pr),
      );
      debugPrint(
          "#ELO month:${DateFormat('yMMMd').format(DateTime.fromMillisecondsSinceEpoch(spot.x.toInt()))} days:${spot.y}");
      return spot;
    }).toList();
    result.sort((a, b) => a.x >= b.x ? 1 : -1);
    return result;
  }

  double _getPRLeadTime(List<PullRequest> list, PullRequest pr) {
    final index = list.indexOf(pr);
    final List<PullRequest> prList = list.sublist(max(0, index-20), index + 1);
    int size = prList.length;
    Duration duration = const Duration();
    for (PullRequest pr in prList) {
      duration += pr.createdAt!.difference(pr.closedAt!).abs();
    }
    if (duration.inMinutes == 0) return 0;
    final double minutes = duration.inMinutes / size / 1440;
    return minutes;
  }
}
