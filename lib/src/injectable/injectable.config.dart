// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

import '../data/shared_preferences.dart' as _i3;
import '../features/dashboard/avg/avg_cubit.dart' as _i8;
import '../features/dashboard/avg/pr_lead_time/avg_pr_lead_time_cubit.dart'
    as _i9;
import '../features/dashboard/avg/time_to_first_review/avg_time_to_first_review_cubit.dart'
    as _i10;
import '../features/dashboard/repo_name/repository_name_cubit.dart' as _i6;
import '../features/login/login_cubit.dart' as _i5;
import '../features/splash/splash_cubit.dart' as _i7;
import '../github/github_service.dart'
    as _i4; // ignore_for_file: unnecessary_lambdas

// ignore_for_file: lines_longer_than_80_chars
/// initializes the registration of provided dependencies inside of [GetIt]
_i1.GetIt $initGetIt(_i1.GetIt get,
    {String? environment, _i2.EnvironmentFilter? environmentFilter}) {
  final gh = _i2.GetItHelper(get, environment, environmentFilter);
  gh.singleton<_i3.SharedPreferences>(_i3.SharedPreferences());
  gh.lazySingleton<_i4.GithubService>(
      () => _i4.GithubService(get<_i3.SharedPreferences>()));
  gh.factory<_i5.LoginCubit>(() => _i5.LoginCubit(get<_i4.GithubService>()));
  gh.factory<_i6.RepositoryNameCubit>(
      () => _i6.RepositoryNameCubit(get<_i4.GithubService>()));
  gh.factory<_i7.SplashCubit>(() => _i7.SplashCubit(get<_i4.GithubService>()));
  gh.lazySingleton<_i8.AvgCubit>(() => _i8.AvgCubit(get<_i4.GithubService>()));
  gh.factory<_i9.AvgPrLeadTimeCubit>(
      () => _i9.AvgPrLeadTimeCubit(get<_i8.AvgCubit>()));
  gh.factory<_i10.AvgTimeToFirstReviewCubit>(() =>
      _i10.AvgTimeToFirstReviewCubit(
          get<_i8.AvgCubit>(), get<_i4.GithubService>()));
  return get;
}
