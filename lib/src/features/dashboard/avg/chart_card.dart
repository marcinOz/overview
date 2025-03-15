import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:overview/src/features/dashboard/avg/chart_parts/period_selector.dart';
import 'package:overview/src/features/dashboard/chart_period/chart_period_cubit.dart';
import 'package:overview/src/injectable/injectable.dart';
import 'package:styleguide/styleguide.dart';

abstract class ChartCardState {
  const ChartCardState(this.isLoading);

  final bool isLoading;

  bool isPopulated();
}

class ChartCard<C extends Cubit<S>, S extends ChartCardState>
    extends StatefulWidget {
  const ChartCard({
    Key? key,
    required this.chart,
    required this.title,
    required this.subtitle,
  }) : super(key: key);

  final Widget Function(S, PeriodSelectorData?) chart;
  final Widget Function(S) title;
  final String subtitle;

  @override
  State<ChartCard> createState() => _ChartCardState<C, S>();
}

class _ChartCardState<C extends Cubit<S>, S extends ChartCardState>
    extends State<ChartCard> {
  final C _cubit = getIt.get();

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AppCard(
        child: Padding(
          padding: const EdgeInsets.all(Dimensions.paddingM),
          child: BlocBuilder<C, S>(
            bloc: _cubit,
            builder: (context, state) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (state.isPopulated()) _buildHeader(state),
                const SizedBox(height: Dimensions.paddingM),
                _chartDescription(context),
                const SizedBox(height: Dimensions.paddingM),
                if (state.isLoading) const CircularProgressIndicator(),
                if (state.isPopulated()) _chart(context, state),
              ],
            ),
          ),
        ),
      );

  Widget _buildHeader(S state) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        widget.title(state),
      ],
    );
  }

  Padding _chart(BuildContext context, S state) => Padding(
        padding: const EdgeInsets.all(Dimensions.paddingL),
        child: SizedBox(
          height: 400,
          width: MediaQuery.of(context).size.width - 264,
          child: BlocBuilder<ChartPeriodCubit, PeriodSelectorData>(
            builder: (context, periodData) {
              return widget.chart(state, periodData);
            },
          ),
        ),
      );

  Text _chartDescription(BuildContext context) => Text(
        widget.subtitle,
        style: context.bodyMediumTextStyle(),
      );
}
