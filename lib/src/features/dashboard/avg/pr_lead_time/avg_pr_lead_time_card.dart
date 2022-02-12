import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:overview/src/injectable/injectable.dart';
import 'package:overview/src/localization/localizations.dart';
import 'package:overview/src/use_case/count_pr_lead_time_use_case.dart';
import 'package:styleguide/styleguide.dart';

import '../avg_cubit.dart';
import 'avg_pr_lead_time_chart.dart';
import 'avg_pr_lead_time_cubit.dart';

class AvgPrLeadTimeCard extends StatefulWidget {
  const AvgPrLeadTimeCard({Key? key}) : super(key: key);

  @override
  _AvgPrLeadTimeCardState createState() => _AvgPrLeadTimeCardState();
}

class _AvgPrLeadTimeCardState extends State<AvgPrLeadTimeCard> {
  final AvgPrLeadTimeCubit _cubit = getIt.get();

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AppCard(
        child: Padding(
          padding: const EdgeInsets.all(Dimensions.paddingM),
          child: BlocBuilder<AvgPrLeadTimeCubit, AvgState>(
            bloc: _cubit,
            builder: (context, state) => Column(
              children: [
                Row(
                  children: [
                    if (state.prList != null) _prLeadTimeText(context, state),
                    const SizedBox(width: Dimensions.paddingM),
                    const Text('Below is AVG PR Lead Time for last 20 PRs'),
                  ],
                ),
                const SizedBox(height: Dimensions.paddingM),
                if (state.repoName.isNotEmpty &&
                    state.prList?.isNotEmpty != true)
                  const CircularProgressIndicator(),
                if (state.prList?.isNotEmpty == true)
                  Padding(
                    padding: const EdgeInsets.all(Dimensions.paddingL),
                    child: SizedBox(
                      height: 400,
                      width: MediaQuery.of(context).size.width - 400,
                      child: AvgPrLeadTimeChart(prList: state.prList!),
                    ),
                  ),
              ],
            ),
          ),
        ),
      );

  Text _prLeadTimeText(BuildContext context, AvgState state) => Text(
        Loc.of(context)
            .avgPrLeadTime(CountPrLeadTimeUseCase()(state.prList!).pretty()),
      );
}
