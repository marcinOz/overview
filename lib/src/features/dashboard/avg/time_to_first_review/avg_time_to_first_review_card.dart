import 'package:flutter/material.dart';
import 'package:overview/src/localization/localizations.dart';
import 'package:overview/src/use_case/count_time_to_first_cr_use_case.dart';
import 'package:styleguide/styleguide.dart';

import '../chart_card.dart';
import 'avg_time_to_first_review_chart.dart';
import 'avg_time_to_first_review_cubit.dart';

class AvgTimeToFirstReviewCard extends StatelessWidget {
  const AvgTimeToFirstReviewCard({Key? key}) : super(key: key);

  final int countHistoryThreshold = 20;

  @override
  Widget build(BuildContext context) =>
      ChartCard<AvgTimeToFirstReviewCubit, ChartCardState>(
        chart: (state, _) => _chart(state as AvgTimeToFirstReviewState),
        title: (state) => _text(context, state as AvgTimeToFirstReviewState),
        subtitle: context.loc().belowTimeToFirstCR(countHistoryThreshold),
      );

  Widget _chart(AvgTimeToFirstReviewState state) {
    if (state.map == null || state.map!.isEmpty) {
      return const Center(
        child: Text('No data available'),
      );
    }

    return AvgTimeToFirstReviewChart(
      map: state.map!,
      countHistoryThreshold: countHistoryThreshold,
    );
  }

  Widget _text(BuildContext context, AvgTimeToFirstReviewState state) {
    if (state.map == null || state.map!.isEmpty) {
      return Text(
        Loc.of(context).timeToFirstCR("N/A"),
        style: context.titleSmallTextStyle(),
      );
    }

    final timeToFirstCR = CountTimeToFirstCrUseCase()(state.map!).pretty();
    return Text(
      Loc.of(context).timeToFirstCR(timeToFirstCR),
      style: context.titleSmallTextStyle(),
    );
  }
}
