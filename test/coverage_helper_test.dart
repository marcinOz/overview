// Helper file to make coverage work for all dart files

// ignore_for_file: unused_import
import 'package:overview/main.dart';
import 'package:overview/src/app.dart';
import 'package:overview/src/data/shared_preferences.dart';
import 'package:overview/src/error/app_error.dart';
import 'package:overview/src/extensions/double_ext.dart';
import 'package:overview/src/extensions/week_of_year.dart';
import 'package:overview/src/features/dashboard/avg/avg_chart.dart';
import 'package:overview/src/features/dashboard/avg/chart_card.dart';
import 'package:overview/src/features/dashboard/avg/pr_lead_time/avg_pr_lead_time_card.dart';
import 'package:overview/src/features/dashboard/avg/pr_lead_time/avg_pr_lead_time_chart.dart';
import 'package:overview/src/features/dashboard/avg/pr_list_data_cubit.dart';
import 'package:overview/src/features/dashboard/avg/pr_number/avg_pr_number_card.dart';
import 'package:overview/src/features/dashboard/avg/pr_number/avg_pr_number_chart.dart';
import 'package:overview/src/features/dashboard/avg/time_to_first_review/avg_time_to_first_review_card.dart';
import 'package:overview/src/features/dashboard/avg/time_to_first_review/avg_time_to_first_review_chart.dart';
import 'package:overview/src/features/dashboard/avg/time_to_first_review/avg_time_to_first_review_cubit.dart';
import 'package:overview/src/features/dashboard/dashboard_view.dart';
import 'package:overview/src/features/dashboard/repo_name/repository_name_card.dart';
import 'package:overview/src/features/dashboard/repo_name/repository_name_cubit.dart';
import 'package:overview/src/features/dashboard/repos_list/repositories_list.dart';
import 'package:overview/src/features/dashboard/repos_list/repositories_list_cubit.dart';
import 'package:overview/src/features/dashboard/widgets/profile_card.dart';
import 'package:overview/src/features/login/login_cubit.dart';
import 'package:overview/src/features/login/login_view.dart';
import 'package:overview/src/features/settings/settings_controller.dart';
import 'package:overview/src/features/settings/settings_service.dart';
import 'package:overview/src/features/settings/settings_view.dart';
import 'package:overview/src/features/splash/splash_cubit.dart';
import 'package:overview/src/features/splash/splash_view.dart';
import 'package:overview/src/github/github_service.dart';
import 'package:overview/src/injectable/injectable.config.dart';
import 'package:overview/src/injectable/injectable.dart';
import 'package:overview/src/localization/localizations.dart';
import 'package:overview/src/use_case/count_avg_pr_per_week_use_case.dart';
import 'package:overview/src/use_case/count_pr_lead_time_use_case.dart';
import 'package:overview/src/use_case/count_time_to_first_cr_use_case.dart';
import 'package:overview/src/use_case/logout_use_case.dart';
void main(){}