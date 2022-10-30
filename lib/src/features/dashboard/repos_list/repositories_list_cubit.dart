import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:github/github.dart';
import 'package:injectable/injectable.dart';
import 'package:overview/src/error/app_error.dart';
import 'package:overview/src/github/github_service.dart';

@Injectable()
class RepositoriesListCubit extends Cubit<RepositoriesListState> {
  RepositoriesListCubit(this._githubService)
      : super(const RepositoriesListLoadingState()) {
    onInit();
  }

  final GithubService _githubService;

  void onInit() async {
    (await _githubService.getAllRepositories()).fold(
      (error) => emit(RepositoriesListErrorState(error)),
      (list) => emit(RepositoriesListPopulatedState(list)),
    );
  }
}

abstract class RepositoriesListState {
  const RepositoriesListState();
}

class RepositoriesListLoadingState extends RepositoriesListState {
  const RepositoriesListLoadingState();
}

class RepositoriesListPopulatedState extends RepositoriesListState {
  const RepositoriesListPopulatedState(this.list);

  final List<Repository> list;
}

class RepositoriesListErrorState extends RepositoriesListState {
  const RepositoriesListErrorState(this.error);

  final AppError error;
}
