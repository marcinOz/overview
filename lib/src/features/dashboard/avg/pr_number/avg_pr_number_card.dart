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
  Widget build(BuildContext context) => ChartCard<PRListDataCubit, PRListState>(
        chart: (state) => AvgPrNumberChart(prList: state.prList!),
        header: (state) => Text(
          Loc.of(context).prNumber(
              CountAvgPrPerWeekUseCase()(state.prList!).toPrecision(1)),
          style: context.titleSmallTextStyle(),
        ),
      );
}
