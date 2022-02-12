import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:github/github.dart';
import 'package:overview/src/use_case/count_time_to_first_cr_use_case.dart';

import '../avg_chart.dart';

class AvgTimeToFirstReviewChart extends StatelessWidget {
  const AvgTimeToFirstReviewChart({Key? key, required this.map})
      : super(key: key);

  final Map<PullRequest, PullRequestReview?> map;

  @override
  Widget build(BuildContext context) => AvgChart(
        prList: map.keys.toList(),
        mapPrsToSpots: getSpotsFromPRs,
      );

  List<FlSpot> getSpotsFromPRs(List<PullRequest> prList) {
    return prList.map((pr) {
      final FlSpot spot = FlSpot(
        pr.closedAt!.millisecondsSinceEpoch.toDouble(),
        _getTimeToFirstReviewInDays(prList, pr),
      );
      return spot;
    }).toList();
  }

  double _getTimeToFirstReviewInDays(List<PullRequest> list, PullRequest pr) {
    final index = list.indexOf(pr);
    Map<PullRequest, PullRequestReview?> result = {};
    for (int i = max(0, index - 20); i < index + 1; i++){
      result[map.keys.toList()[i]] = map.values.toList()[i];
    }
    Duration duration = CountTimeToFirstCrUseCase()(result);
    if (duration.inMinutes == 0) return 0;
    return duration.inMinutes / 1440;
  }
}
