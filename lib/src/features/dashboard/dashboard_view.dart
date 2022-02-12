import 'package:flutter/material.dart';
import 'package:overview/src/features/dashboard/avg/pr_lead_time/avg_pr_lead_time_card.dart';
import 'package:overview/src/features/dashboard/avg/time_to_first_review/avg_time_to_first_review_card.dart';
import 'package:overview/src/features/dashboard/repo_name/repository_name_card.dart';
import 'package:overview/src/features/dashboard/widgets/profile_card.dart';
import 'package:overview/src/localization/localizations.dart';
import 'package:styleguide/styleguide.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({Key? key}) : super(key: key);

  static const routeName = '/dashboard';

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: Text(Loc.of(context).dashboard)),
        body: Padding(
          padding: const EdgeInsets.all(Dimensions.paddingL),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ProfileCard(),
              const SizedBox(width: Dimensions.paddingL),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  RepositoryNameCard(),
                  SizedBox(width: Dimensions.paddingL),
                  AvgPrLeadTimeCard(),
                  SizedBox(width: Dimensions.paddingL),
                  AvgTimeToFirstReviewCard(),
                ],
              ),
            ],
          ),
        ),
      );
}
