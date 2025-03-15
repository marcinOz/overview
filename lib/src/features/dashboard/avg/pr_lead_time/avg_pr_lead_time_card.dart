import 'package:flutter/material.dart';
import 'package:overview/src/localization/localizations.dart';
import 'package:overview/src/use_case/count_pr_lead_time_use_case.dart';
import 'package:styleguide/styleguide.dart';

import '../chart_card.dart';
import '../pr_list_data_cubit.dart';
import 'avg_pr_lead_time_chart.dart';

class AvgPrLeadTimeCard extends StatelessWidget {
  const AvgPrLeadTimeCard({Key? key}) : super(key: key);

  final int countHistoryThreshold = 20;

  @override
  Widget build(BuildContext context) =>
      ChartCard<PRListDataCubit, ChartCardState>(
        chart: (state, _) => _chart(state as PRListState),
        title: (state) => _text(context, state as PRListState),
        subtitle: context.loc().belowPrLeadTime(countHistoryThreshold),
      );

  Widget _chart(PRListState state) {
    return AvgPrLeadTimeChart(
      prList: state.prList!,
      countHistoryThreshold: countHistoryThreshold,
    );
  }

  Widget _text(BuildContext context, PRListState state) {
    final leadTime = CountPrLeadTimeUseCase()(state.prList!).pretty();
    return Text(
      Loc.of(context).avgPrLeadTime(leadTime),
      style: context.titleSmallTextStyle(),
    );
  }
}
