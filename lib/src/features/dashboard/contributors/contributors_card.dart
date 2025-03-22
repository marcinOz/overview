import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:overview/src/features/dashboard/contributors/contributor_profile_card.dart';
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.loc().contributors,
                  style: context.titleSmallTextStyle(),
                ),
                const SizedBox(height: Dimensions.paddingM),
                BlocBuilder<ContributorsCubit, ContributorsState>(
                  bloc: _contributorsCubit,
                  builder: (BuildContext context, ContributorsState state) {
                    if (state.isLoading) {
                      return const CircularProgressIndicator();
                    } else if (state.contributors != null) {
                      return _contributorsGrid(state);
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

  Widget _contributorsGrid(ContributorsState state) =>
      BlocBuilder<CurrentContributorDataCubit, String>(
        bloc: _currentContributorsCubit,
        builder: (context, currentContributor) {
          // Calculate number of columns based on available width
          final width = MediaQuery.of(context).size.width -
              220; // Adjust for margins and padding
          final cardWidth =
              100; // Approximate width of each card including spacing
          final crossAxisCount =
              (width / cardWidth).floor().clamp(3, 10); // Min 3, max 10 columns

          // Add the "All" option first
          final allWidgets = [
            AllContributorsCard(
              isSelected: currentContributor ==
                  CurrentContributorDataCubit.initialContributors,
              onTap: () => _currentContributorsCubit
                  .set(CurrentContributorDataCubit.initialContributors),
              width: 80,
            ),

            // Add individual contributor cards
            ...state.contributors!.map((contributor) {
              return ContributorProfileCard(
                contributor: contributor,
                isSelected: currentContributor == contributor.login,
                onTap: () => _currentContributorsCubit.set(contributor.login!),
                width: 80,
              );
            }).toList(),
          ];

          return Container(
            padding: const EdgeInsets.all(Dimensions.paddingS),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: BorderRadius.circular(Dimensions.cornerRadiusM),
            ),
            height:
                200, // Slightly increased to accommodate the new aspect ratio
            child: GridView.builder(
              padding: const EdgeInsets.all(8),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 0.75, // Reduced to allow more space for names
              ),
              itemCount: allWidgets.length,
              itemBuilder: (context, index) => allWidgets[index],
            ),
          );
        },
      );
}
