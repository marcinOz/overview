// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

import '../data/shared_preferences.dart' as _i3;
import '../features/dashboard/avg/pr_list_data_cubit.dart' as _i7;
import '../features/dashboard/avg/time_to_first_review/avg_time_to_first_review_cubit.dart'
    as _i10;
import '../features/dashboard/repo_name/repository_name_cubit.dart' as _i5;
import '../features/dashboard/repos_list/repositories_list_cubit.dart' as _i6;
import '../features/login/login_cubit.dart' as _i9;
import '../features/splash/splash_cubit.dart' as _i8;
import '../github/github_service.dart' as _i4;

// initializes the registration of main-scope dependencies inside of GetIt
_i1.GetIt $initGetIt(
  _i1.GetIt getIt, {
  String? environment,
  _i2.EnvironmentFilter? environmentFilter,
}) {
  final gh = _i2.GetItHelper(
    getIt,
    environment,
    environmentFilter,
  );
  gh.singleton<_i3.SharedPreferences>(() => _i3.SharedPreferences());
  gh.lazySingleton<_i4.GithubService>(
      () => _i4.GithubService(gh<_i3.SharedPreferences>()));
  gh.singleton<_i5.RepositoryNameCubit>(
      () => _i5.RepositoryNameCubit(gh<_i4.GithubService>()));
  gh.factory<_i6.RepositoriesListCubit>(
      () => _i6.RepositoriesListCubit(gh<_i4.GithubService>()));
  gh.lazySingleton<_i7.PRListDataCubit>(
      () => _i7.PRListDataCubit(gh<_i4.GithubService>()));
  gh.factory<_i8.SplashCubit>(() => _i8.SplashCubit(gh<_i4.GithubService>()));
  gh.factory<_i9.LoginCubit>(() => _i9.LoginCubit(gh<_i4.GithubService>()));
  gh.factory<_i10.AvgTimeToFirstReviewCubit>(
      () => _i10.AvgTimeToFirstReviewCubit(
            gh<_i7.PRListDataCubit>(),
            gh<_i4.GithubService>(),
          ));
  return getIt;
}
