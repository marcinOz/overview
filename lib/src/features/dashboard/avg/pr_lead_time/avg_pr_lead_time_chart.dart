import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:github/github.dart';
import 'package:overview/src/use_case/count_pr_lead_time_use_case.dart';

import '../avg_chart.dart';

class AvgPrLeadTimeChart extends StatelessWidget {
  const AvgPrLeadTimeChart({Key? key, required this.prList}) : super(key: key);

  final List<PullRequest> prList;

  @override
  Widget build(BuildContext context) => AvgChart(
        prList: prList,
        mapPrsToSpots: getSpotsFromPRs,
      );

  List<FlSpot> getSpotsFromPRs(List<PullRequest> prList) {
    final result = prList.map((pr) {
      final FlSpot spot = FlSpot(
        pr.closedAt!.millisecondsSinceEpoch.toDouble(),
        _getPRLeadTimeInDays(prList, pr),
      );
      return spot;
    }).toList();
    return result;
  }

  double _getPRLeadTimeInDays(List<PullRequest> list, PullRequest pr) {
    final index = list.indexOf(pr);
    final List<PullRequest> prList =
        list.sublist(max(0, index - 20), index + 1);
    Duration duration = CountPrLeadTimeUseCase()(prList);
    if (duration.inMinutes == 0) return 0;
    return duration.inMinutes / 1440;
  }
}
