// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

import '../data/shared_preferences.dart' as _i3;
import '../features/dashboard/avg/avg_cubit.dart' as _i9;
import '../features/dashboard/avg/pr_lead_time/avg_pr_lead_time_cubit.dart'
    as _i10;
import '../features/dashboard/avg/pr_number/avg_pr_number_cubit.dart' as _i11;
import '../features/dashboard/avg/time_to_first_review/avg_time_to_first_review_cubit.dart'
    as _i12;
import '../features/dashboard/repo_name/repository_name_cubit.dart' as _i7;
import '../features/dashboard/repos_list/repositories_list_cubit.dart' as _i6;
import '../features/login/login_cubit.dart' as _i5;
import '../features/splash/splash_cubit.dart' as _i8;
import '../github/github_service.dart'
    as _i4; // ignore_for_file: unnecessary_lambdas

// ignore_for_file: lines_longer_than_80_chars
/// initializes the registration of provided dependencies inside of [GetIt]
_i1.GetIt $initGetIt(
  _i1.GetIt get, {
  String? environment,
  _i2.EnvironmentFilter? environmentFilter,
}) {
  final gh = _i2.GetItHelper(
    get,
    environment,
    environmentFilter,
  );
  gh.singleton<_i3.SharedPreferences>(_i3.SharedPreferences());
  gh.lazySingleton<_i4.GithubService>(
      () => _i4.GithubService(get<_i3.SharedPreferences>()));
  gh.factory<_i5.LoginCubit>(() => _i5.LoginCubit(get<_i4.GithubService>()));
  gh.factory<_i6.RepositoriesListCubit>(
      () => _i6.RepositoriesListCubit(get<_i4.GithubService>()));
  gh.singleton<_i7.RepositoryNameCubit>(
      _i7.RepositoryNameCubit(get<_i4.GithubService>()));
  gh.factory<_i8.SplashCubit>(() => _i8.SplashCubit(get<_i4.GithubService>()));
  gh.lazySingleton<_i9.AvgCubit>(() => _i9.AvgCubit(get<_i4.GithubService>()));
  gh.factory<_i10.AvgPrLeadTimeCubit>(
      () => _i10.AvgPrLeadTimeCubit(get<_i9.AvgCubit>()));
  gh.factory<_i11.AvgPrNumberCubit>(
      () => _i11.AvgPrNumberCubit(get<_i9.AvgCubit>()));
  gh.factory<_i12.AvgTimeToFirstReviewCubit>(
      () => _i12.AvgTimeToFirstReviewCubit(
            get<_i9.AvgCubit>(),
            get<_i4.GithubService>(),
          ));
  return get;
}
