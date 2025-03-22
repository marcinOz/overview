// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import '../data/shared_preferences.dart' as _i722;
import '../features/dashboard/avg/pr_list_data_cubit.dart' as _i447;
import '../features/dashboard/avg/time_to_first_review/avg_time_to_first_review_cubit.dart'
    as _i640;
import '../features/dashboard/chart_period/chart_period_cubit.dart' as _i903;
import '../features/dashboard/contributors/contributors_cubit.dart' as _i518;
import '../features/dashboard/contributors/current_contributor_data_cubit.dart'
    as _i76;
import '../features/dashboard/repo_name/repository_name_cubit.dart' as _i989;
import '../features/dashboard/repos_list/repositories_list_cubit.dart' as _i995;
import '../features/login/login_cubit.dart' as _i538;
import '../features/splash/splash_cubit.dart' as _i302;
import '../github/github_service.dart' as _i583;

// initializes the registration of main-scope dependencies inside of GetIt
_i174.GetIt $initGetIt(
  _i174.GetIt getIt, {
  String? environment,
  _i526.EnvironmentFilter? environmentFilter,
}) {
  final gh = _i526.GetItHelper(
    getIt,
    environment,
    environmentFilter,
  );
  gh.singleton<_i722.SharedPreferences>(() => _i722.SharedPreferences());
  gh.lazySingleton<_i903.ChartPeriodCubit>(() => _i903.ChartPeriodCubit());
  gh.lazySingleton<_i76.CurrentContributorDataCubit>(
      () => _i76.CurrentContributorDataCubit());
  gh.lazySingleton<_i583.GithubService>(
      () => _i583.GithubService(gh<_i722.SharedPreferences>()));
  gh.singleton<_i989.RepositoryNameCubit>(
      () => _i989.RepositoryNameCubit(gh<_i583.GithubService>()));
  gh.factory<_i995.RepositoriesListCubit>(
      () => _i995.RepositoriesListCubit(gh<_i583.GithubService>()));
  gh.lazySingleton<_i447.PRListDataCubit>(
      () => _i447.PRListDataCubit(gh<_i583.GithubService>()));
  gh.lazySingleton<_i518.ContributorsCubit>(
      () => _i518.ContributorsCubit(gh<_i583.GithubService>()));
  gh.factory<_i302.SplashCubit>(
      () => _i302.SplashCubit(gh<_i583.GithubService>()));
  gh.factory<_i538.LoginCubit>(
      () => _i538.LoginCubit(gh<_i583.GithubService>()));
  gh.factory<_i640.AvgTimeToFirstReviewCubit>(
      () => _i640.AvgTimeToFirstReviewCubit(
            gh<_i447.PRListDataCubit>(),
            gh<_i583.GithubService>(),
          ));
  return getIt;
}
