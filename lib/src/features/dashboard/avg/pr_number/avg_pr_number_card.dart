import 'package:flutter/material.dart';
import 'package:overview/src/extensions/double_ext.dart';
import 'package:overview/src/features/dashboard/avg/chart_card.dart';
import 'package:overview/src/localization/localizations.dart';
import 'package:overview/src/use_case/count_avg_pr_per_week_use_case.dart';
import 'package:styleguide/styleguide.dart';

import '../pr_list_data_cubit.dart';
import 'avg_pr_number_chart.dart';

class AvgPrNumberCard extends StatelessWidget {
  const AvgPrNumberCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) =>
      ChartCard<PRListDataCubit, ChartCardState>(
        chart: (state, _) => _chart(state as PRListState),
        title: (state) => _text(context, state as PRListState),
        subtitle: context.loc().belowAvgPrNumber,
      );

  Widget _chart(PRListState state) {
    return AvgPrNumberChart(prList: state.prList!);
  }

  Widget _text(BuildContext context, PRListState state) {
    final count = CountAvgPrPerWeekUseCase()(state.prList!).toPrecision(1);
    return Text(
      Loc.of(context).prNumber(count),
      style: context.titleSmallTextStyle(),
    );
  }
}
