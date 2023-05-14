import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:github/github.dart';
import 'package:injectable/injectable.dart';
import 'package:overview/src/error/app_error.dart';
import 'package:overview/src/github/github_service.dart';

@Singleton()
class RepositoryNameCubit extends Cubit<RepositoryNameState> {
  RepositoryNameCubit(this._githubService) : super(const RepositoryNameState());

  final GithubService _githubService;

  void fillUpFromClick(String owner, String name) {
    emit(state.copyWith(owner: owner, name: name));
  }

  void onOwnerChanged(String owner) {
    emit(state.copyWith(owner: owner));
  }

  void onNameChanged(String name) {
    emit(state.copyWith(name: name));
  }

  Future<List<Repository>> searchRepository(String name) async {
    if (name.isEmpty) return [];
    return (await _githubService.searchRepositories(name)).fold(
      (error) => [],
      (suggestions) => suggestions,
    );
  }

  Future<void> onSubmitClicked() async {
    if (state.owner == null || state.name == null) {
      emit(state.copyWith(error: const AppError(message: "Empty Fields!")));
      return;
    }
    emit(state.copyWith(isLoading: true));
    (await _githubService.getRepository(state.owner!, state.name!)).fold(
      (error) => emit(state.copyWith(error: error)),
      (r) => emit(state.copyWith()),
    );
  }
}

class RepositoryNameState {
  const RepositoryNameState({
    this.error,
    this.owner,
    this.name,
    this.isLoading = false,
  });

  final String? owner;
  final String? name;
  final bool isLoading;
  final AppError? error;

  RepositoryNameState copyWith({
    AppError? error,
    String? owner,
    String? name,
    bool isLoading = false,
  }) =>
      RepositoryNameState(
        owner: owner ?? this.owner,
        name: name ?? this.name,
        isLoading: isLoading,
        error: error,
      );
}
