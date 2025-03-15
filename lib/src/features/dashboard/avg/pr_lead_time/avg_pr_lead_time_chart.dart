import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:github/github.dart';
import 'package:overview/src/extensions/double_ext.dart';
import 'package:overview/src/features/dashboard/avg/chart_parts/period_selector.dart';
import 'package:overview/src/features/dashboard/chart_period/chart_period_cubit.dart';
import 'package:overview/src/use_case/count_pr_lead_time_use_case.dart';

import '../avg_chart.dart';

class AvgPrLeadTimeChart extends StatelessWidget {
  const AvgPrLeadTimeChart({
    Key? key,
    required this.prList,
    required this.countHistoryThreshold,
  }) : super(key: key);

  final List<PullRequest> prList;
  final int countHistoryThreshold;

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<ChartPeriodCubit, PeriodSelectorData>(
        builder: (context, periodData) => AvgChart(
          prList: _filterPRsByPeriod(prList, periodData),
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
    final index = list.indexOf(pr);
    final List<PullRequest> prList =
        list.sublist(max(0, index - countHistoryThreshold), index + 1);
    Duration duration = CountPrLeadTimeUseCase()(prList);
    if (duration.inMinutes == 0) return 0;
    return (duration.inMinutes / 1440).toPrecision(3);
  }
}
