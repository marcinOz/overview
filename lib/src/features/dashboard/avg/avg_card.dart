import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:overview/src/features/dashboard/avg/avg_chart.dart';
import 'package:overview/src/injectable/injectable.dart';
import 'package:overview/src/localization/localizations.dart';
import 'package:styleguide/styleguide.dart';

import 'avg_cubit.dart';

class AvgCard extends StatefulWidget {
  const AvgCard({Key? key}) : super(key: key);

  @override
  _AvgCardState createState() => _AvgCardState();
}

class _AvgCardState extends State<AvgCard> {
  final AvgCubit _cubit = getIt.get();

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AppCard(
        child: Padding(
          padding: const EdgeInsets.all(Dimensions.paddingM),
          child: BlocBuilder<AvgCubit, AvgState>(
            bloc: _cubit,
            builder: (context, state) => Column(
              children: [
                Row(
                  children: [
                    Text(Loc.of(context).avgPrLeadTime + state.avgPrLeadTime),
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
                      child: AvgChart(prList: state.prList!),
                    ),
                  ),
              ],
            ),
          ),
        ),
      );
}
