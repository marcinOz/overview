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
        chart: (state) => _chart(state as AvgTimeToFirstReviewState),
        title: (state) => _text(context, state as AvgTimeToFirstReviewState),
        subtitle: context.loc().belowTimeToFirstCR(countHistoryThreshold),
      );

  Widget _chart(AvgTimeToFirstReviewState state) => AvgTimeToFirstReviewChart(
    map: state.map!,
    countHistoryThreshold: countHistoryThreshold,
  );

  Widget _text(BuildContext context, AvgTimeToFirstReviewState state) => Text(
    Loc.of(context).timeToFirstCR(CountTimeToFirstCrUseCase()(
      state.map!,
    ).pretty()),
    style: context.titleSmallTextStyle(),
  );
}
