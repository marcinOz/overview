import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:overview/src/features/dashboard/avg/pr_lead_time/avg_pr_lead_time_card.dart';
import 'package:overview/src/features/dashboard/avg/pr_number/avg_pr_number_card.dart';
import 'package:overview/src/features/dashboard/avg/time_to_first_review/avg_time_to_first_review_card.dart';
import 'package:overview/src/features/dashboard/chart_period/chart_period_cubit.dart';
import 'package:overview/src/features/dashboard/repo_name/repository_name_card.dart';
import 'package:overview/src/features/dashboard/repos_list/repositories_list.dart';
import 'package:overview/src/features/dashboard/widgets/profile_card.dart';
import 'package:overview/src/localization/localizations.dart';
import 'package:overview/src/use_case/logout_use_case.dart';
import 'package:styleguide/styleguide.dart';

import '../../injectable/injectable.dart';
import 'contributors/contributors_card.dart';
import 'contributors/current_contributor_data_cubit.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({Key? key}) : super(key: key);

  static const routeName = '/dashboard';

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  @override
  void dispose() {
    getIt.get<CurrentContributorDataCubit>().close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(Loc.of(context).dashboard),
          actions: [
            IconButton(
              onPressed: () => LogoutUseCase()(context),
              icon: const Icon(Icons.logout),
              tooltip: context.loc().signOut,
            ),
          ],
        ),
        body: BlocProvider(
          create: (_) => getIt<ChartPeriodCubit>(),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(Dimensions.paddingM),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      ProfileCard(),
                      const SizedBox(height: Dimensions.paddingM),
                      const RepositoriesList(),
                    ],
                  ),
                  const SizedBox(width: Dimensions.paddingM),
                  const Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RepositoryNameCard(),
                      SizedBox(height: Dimensions.paddingM),
                      ContributorsCard(),
                      SizedBox(height: Dimensions.paddingM),
                      AvgPrLeadTimeCard(),
                      SizedBox(height: Dimensions.paddingM),
                      AvgTimeToFirstReviewCard(),
                      SizedBox(height: Dimensions.paddingM),
                      AvgPrNumberCard(),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );
}
