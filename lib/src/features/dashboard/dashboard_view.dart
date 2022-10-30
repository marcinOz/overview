import 'package:flutter/material.dart';
import 'package:overview/src/features/dashboard/avg/pr_lead_time/avg_pr_lead_time_card.dart';
import 'package:overview/src/features/dashboard/avg/pr_number/avg_pr_number_card.dart';
import 'package:overview/src/features/dashboard/avg/time_to_first_review/avg_time_to_first_review_card.dart';
import 'package:overview/src/features/dashboard/repo_name/repository_name_card.dart';
import 'package:overview/src/features/dashboard/repos_list/repositories_list.dart';
import 'package:overview/src/features/dashboard/widgets/profile_card.dart';
import 'package:overview/src/localization/localizations.dart';
import 'package:overview/src/use_case/logout_use_case.dart';
import 'package:styleguide/styleguide.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({Key? key}) : super(key: key);

  static const routeName = '/dashboard';

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
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(Dimensions.paddingM),
            child: Row(
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
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    RepositoryNameCard(),
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
      );
}
