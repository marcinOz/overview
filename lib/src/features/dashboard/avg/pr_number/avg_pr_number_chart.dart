import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:github/github.dart';
import 'package:overview/src/extensions/double_ext.dart';
import 'package:overview/src/extensions/week_of_year.dart';
import 'package:overview/src/use_case/count_avg_pr_per_week_use_case.dart';

import '../avg_chart.dart';

class AvgPrNumberChart extends StatelessWidget {
  const AvgPrNumberChart({
    Key? key,
    required this.prList,
  }) : super(key: key);

  final List<PullRequest> prList;

  @override
  Widget build(BuildContext context) => AvgChart(
        prList: prList,
        mapPrsToSpots: getSpotsFromPRs,
      );

  List<FlSpot> getSpotsFromPRs(List<PullRequest> prList) {
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
    int week = pr.createdAt!.weekOfYear;
    List<PullRequest> subList = prList
        .where((element) => element.createdAt!.weekOfYear == week)
        .toList();
    double avg = CountAvgPrPerWeekUseCase()(subList);
    return avg.toPrecision(1);
  }
}
