import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:overview/src/injectable/injectable.dart';
import 'package:overview/src/localization/localizations.dart';
import 'package:overview/src/use_case/count_time_to_first_cr_use_case.dart';
import 'package:styleguide/styleguide.dart';

import 'avg_time_to_first_review_chart.dart';
import 'avg_time_to_first_review_cubit.dart';

class AvgTimeToFirstReviewCard extends StatefulWidget {
  const AvgTimeToFirstReviewCard({Key? key}) : super(key: key);

  @override
  _AvgTimeToFirstReviewCardState createState() =>
      _AvgTimeToFirstReviewCardState();
}

class _AvgTimeToFirstReviewCardState extends State<AvgTimeToFirstReviewCard> {
  final AvgTimeToFirstReviewCubit _cubit = getIt.get();
  final int countHistoryThreshold = 20;

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AppCard(
        child: Padding(
          padding: const EdgeInsets.all(Dimensions.paddingM),
          child:
              BlocBuilder<AvgTimeToFirstReviewCubit, AvgTimeToFirstReviewState>(
            bloc: _cubit,
            builder: (context, state) => Column(
              children: [
                if (state.map != null) _prLeadTimeText(context, state),
                const SizedBox(height: Dimensions.paddingM),
                _chartDescription(context),
                const SizedBox(height: Dimensions.paddingM),
                if (state.map?.isNotEmpty != true)
                  const CircularProgressIndicator(),
                if (state.map?.isNotEmpty == true)
                  Padding(
                    padding: const EdgeInsets.all(Dimensions.paddingL),
                    child: SizedBox(
                      height: 400,
                      width: MediaQuery.of(context).size.width - 400,
                      child: AvgTimeToFirstReviewChart(
                        map: state.map!,
                        countHistoryThreshold: countHistoryThreshold,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      );

  Text _chartDescription(BuildContext context) => Text(
        context.loc().belowTimeToFirstCR(countHistoryThreshold),
        style: context.bodyMediumTextStyle(),
      );

  Text _prLeadTimeText(BuildContext context, AvgTimeToFirstReviewState state) =>
      Text(
        Loc.of(context).timeToFirstCR(CountTimeToFirstCrUseCase()(
          state.map!,
        ).pretty()),
        style: context.titleSmallTextStyle(),
      );
}
