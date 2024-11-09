import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:overview/src/features/dashboard/contributors/contributors_cubit.dart';
import 'package:overview/src/features/dashboard/contributors/current_contributor_data_cubit.dart';
import 'package:overview/src/injectable/injectable.dart';
import 'package:overview/src/localization/localizations.dart';
import 'package:styleguide/styleguide.dart';

class ContributorsCard extends StatefulWidget {
  const ContributorsCard({Key? key}) : super(key: key);

  @override
  State<ContributorsCard> createState() => _ContributorsCardState();
}

class _ContributorsCardState extends State<ContributorsCard> {
  final ContributorsCubit _contributorsCubit = getIt.get();
  final CurrentContributorDataCubit _currentContributorsCubit = getIt.get();

  @override
  void dispose() {
    _contributorsCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => SizedBox(
        width: MediaQuery.of(context).size.width - 178,
        child: AppCard(
          child: Padding(
            padding: const EdgeInsets.all(Dimensions.paddingM),
            child: Column(
              children: [
                Text(
                  context.loc().contributors,
                  style: context.titleSmallTextStyle(),
                ),
                const SizedBox(height: Dimensions.paddingS),
                BlocBuilder<ContributorsCubit, ContributorsState>(
                  bloc: _contributorsCubit,
                  builder: (BuildContext context, ContributorsState state) {
                    if (state.isLoading) {
                      return const CircularProgressIndicator();
                    } else if (state.contributors != null) {
                      return Row(
                        children: [
                          _contributorsDropDown(state),
                        ],
                      );
                    } else {
                      return Text(Loc.of(context).noContributorsFound);
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      );

  Widget _contributorsDropDown(ContributorsState state) =>
      BlocBuilder<CurrentContributorDataCubit, String>(
        bloc: _currentContributorsCubit,
        builder: (context, currentContributor) => DropdownButton<String>(
          value: currentContributor,
          items: [
            DropdownMenuItem(
              value: CurrentContributorDataCubit.initialContributors,
              child: Text(Loc.of(context).all),
            ),
            ...state.contributors!.map((contributor) {
              return DropdownMenuItem(
                value: contributor.login,
                child: Text(contributor.login!),
              );
            }),
          ],
          onChanged: (value) => _currentContributorsCubit.set(value!),
        ),
      );
}
