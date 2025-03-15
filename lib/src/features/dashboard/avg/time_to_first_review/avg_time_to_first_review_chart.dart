import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:github/github.dart';
import 'package:overview/src/extensions/double_ext.dart';
import 'package:overview/src/features/dashboard/avg/chart_parts/period_selector.dart';
import 'package:overview/src/features/dashboard/chart_period/chart_period_cubit.dart';
import 'package:overview/src/use_case/count_time_to_first_cr_use_case.dart';

import '../avg_chart.dart';

class AvgTimeToFirstReviewChart extends StatelessWidget {
  const AvgTimeToFirstReviewChart({
    Key? key,
    required this.map,
    required this.countHistoryThreshold,
  }) : super(key: key);

  final Map<PullRequest, PullRequestReview?> map;
  final int countHistoryThreshold;

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<ChartPeriodCubit, PeriodSelectorData>(
        builder: (context, periodData) => AvgChart(
          prList: _filterPRsByPeriod(map.keys.toList(), periodData),
          mapPrsToSpots: getSpotsFromPRs,
        ),
      );

  List<PullRequest> _filterPRsByPeriod(
      List<PullRequest> prList, PeriodSelectorData periodData) {
    if (periodData.period == ChartPeriod.all) return prList;

    return prList
        .where((pr) =>
            pr.createdAt != null && periodData.isInPeriod(pr.createdAt!))
        .toList();
  }

  List<FlSpot> getSpotsFromPRs(List<PullRequest> prList) {
    return prList.map((pr) {
      final FlSpot spot = FlSpot(
        pr.createdAt!.millisecondsSinceEpoch.toDouble(),
        _getTimeToFirstReviewInDays(prList, pr),
      );
      return spot;
    }).toList();
  }

  double _getTimeToFirstReviewInDays(List<PullRequest> list, PullRequest pr) {
    final index = list.indexOf(pr);
    Map<PullRequest, PullRequestReview?> result = {};
    for (int i = max(0, index - countHistoryThreshold); i < index + 1; i++) {
      result[map.keys.toList()[i]] = map.values.toList()[i];
    }
    Duration duration = CountTimeToFirstCrUseCase()(result);
    if (duration.inMinutes == 0) return 0;
    return (duration.inMinutes / 1440).toPrecision(3);
  }
}
