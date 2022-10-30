import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:overview/src/extensions/double_ext.dart';
import 'package:overview/src/injectable/injectable.dart';
import 'package:overview/src/localization/localizations.dart';
import 'package:overview/src/use_case/count_avg_pr_per_week_use_case.dart';
import 'package:styleguide/styleguide.dart';

import '../avg_cubit.dart';
import 'avg_pr_number_chart.dart';
import 'avg_pr_number_cubit.dart';

class AvgPrNumberCard extends StatefulWidget {
  const AvgPrNumberCard({Key? key}) : super(key: key);

  @override
  State<AvgPrNumberCard> createState() => _AvgPrNumberCardState();
}

class _AvgPrNumberCardState extends State<AvgPrNumberCard> {
  final AvgPrNumberCubit _cubit = getIt.get();

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AppCard(
        child: Padding(
          padding: const EdgeInsets.all(Dimensions.paddingM),
          child: BlocBuilder<AvgPrNumberCubit, AvgState>(
            bloc: _cubit,
            builder: (context, state) => Column(
              children: [
                if (state.prList != null) _avgPrNumberText(context, state),
                const SizedBox(height: Dimensions.paddingM),
                _chartDescription(context),
                const SizedBox(height: Dimensions.paddingM),
                if (state.repoName.isNotEmpty &&
                    state.prList?.isNotEmpty != true)
                  const CircularProgressIndicator(),
                if (state.prList?.isNotEmpty == true) _chart(context, state),
              ],
            ),
          ),
        ),
      );

  Padding _chart(BuildContext context, AvgState state) => Padding(
        padding: const EdgeInsets.all(Dimensions.paddingL),
        child: SizedBox(
          height: 400,
          width: MediaQuery.of(context).size.width - 264,
          child: AvgPrNumberChart(
            prList: state.prList!,
          ),
        ),
      );

  Text _chartDescription(BuildContext context) => Text(
        context.loc().belowAvgPrNumber,
        style: context.bodyMediumTextStyle(),
      );

  Text _avgPrNumberText(BuildContext context, AvgState state) => Text(
        Loc.of(context)
            .prNumber(CountAvgPrPerWeekUseCase()(state.prList!).toPrecision(1)),
        style: context.titleSmallTextStyle(),
      );
}
