import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:github/github.dart';
import 'package:intl/intl.dart';

const List<Color> _gradientColors = [
  Color(0xff23b6e6),
  Color(0xff02d39a),
];

class AvgChart extends StatelessWidget {
  const AvgChart({
    Key? key,
    required this.prList,
    required this.mapPrsToSpots,
  }) : super(key: key);

  final List<PullRequest> prList;
  final List<FlSpot> Function(List<PullRequest>) mapPrsToSpots;

  @override
  Widget build(BuildContext context) => LineChart(data(prList));

  LineChartData data(List<PullRequest> prList) {
    return LineChartData(
      gridData: flGridData(),
      titlesData: flTitlesData(),
      borderData: flBorderData(),
      minY: 0,
      maxY: 10,
      lineTouchData: _tooltipsData(),
      lineBarsData: [
        lineChartBarData(prList),
      ],
    );
  }

  LineTouchData _tooltipsData() {
    return LineTouchData(
      touchTooltipData: LineTouchTooltipData(
        tooltipBgColor: Colors.white,
        getTooltipItems: (spots) => spots
            .map((e) => LineTooltipItem(
                  '${e.y} days',
                  const TextStyle(color: Colors.black),
                ))
            .toList(),
      ),
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
      rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
      topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
      bottomTitles: bottomTitles(),
      leftTitles: leftTitles(),
    );
  }

  AxisTitles bottomTitles() {
    return AxisTitles(
      sideTitles: SideTitles(
        showTitles: true,
        reservedSize: 22,
        interval: 5259600000,
        getTitlesWidget: (value, titleMeta) => Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text(
            DateFormat('MMM')
                .format(DateTime.fromMillisecondsSinceEpoch(value.toInt())),
            style: const TextStyle(
              color: Color(0xff68737d),
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }

  AxisTitles leftTitles() {
    return AxisTitles(
      sideTitles: SideTitles(
        reservedSize: 30,
        showTitles: true,
        interval: 1,
        getTitlesWidget: (value, titleMeta) => Text(
          '${value.toInt()}D',
          style: const TextStyle(
            color: Color(0xff67727d),
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
      ),
    );
  }

  FlBorderData flBorderData() {
    return FlBorderData(
        show: true,
        border: Border.all(color: const Color(0xff37434d), width: 1));
  }

  LineChartBarData lineChartBarData(List<PullRequest> prList) {
    return LineChartBarData(
      spots: mapPrsToSpots(prList),
      isCurved: false,
      gradient: const LinearGradient(colors: _gradientColors),
      barWidth: 5,
      isStrokeCapRound: true,
      dotData: FlDotData(show: false),
      belowBarData: BarAreaData(
        show: true,
        gradient: LinearGradient(
          colors:
              _gradientColors.map((color) => color.withOpacity(0.3)).toList(),
        ),
      ),
    );
  }
}
