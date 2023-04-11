import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:github/github.dart';
import 'package:intl/intl.dart';

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

  LineTouchData _tooltipsData() => LineTouchData(
        touchTooltipData: LineTouchTooltipData(
          tooltipBgColor: Colors.white,
          getTooltipItems: (spots) => spots
              .map((s) => LineTooltipItem(
                    'PR #${widget.prList[s.spotIndex].number} \n${s.y} days',
                    const TextStyle(color: Colors.black),
                  ))
              .toList(),
        ),
      );

  FlGridData _flGridData() => FlGridData(
        show: true,
        drawVerticalLine: true,
        getDrawingHorizontalLine: (value) =>
            FlLine(color: const Color(0xff37434d), strokeWidth: 1),
        getDrawingVerticalLine: (value) =>
            FlLine(color: const Color(0xff37434d), strokeWidth: 1),
      );

  FlTitlesData _flTitlesData() => FlTitlesData(
        show: true,
        rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        bottomTitles: _bottomTitles(),
        leftTitles: _leftTitles(),
      );

  AxisTitles _bottomTitles() => AxisTitles(
        sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 22,
            interval: 5259600000,
            getTitlesWidget: (value, titleMeta) {
              final title = DateFormat('MMM')
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

  AxisTitles _leftTitles() => AxisTitles(
        drawBehindEverything: true,
        sideTitles: SideTitles(
          reservedSize: 30,
          showTitles: true,
          interval: 1,
          getTitlesWidget: (value, titleMeta) => _isNotCompleteNumber(value)
              ? const SizedBox()
              : Text(
                  '${value.toInt()}D',
                  style: const TextStyle(
                    color: Color(0xff67727d),
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
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
        dotData: FlDotData(show: false),
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
