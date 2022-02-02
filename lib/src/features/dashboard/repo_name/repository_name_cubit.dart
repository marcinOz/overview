import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:overview/src/error/app_error.dart';
import 'package:overview/src/github/github_service.dart';

@Injectable()
class RepositoryNameCubit extends Cubit<RepositoryNameState> {
  RepositoryNameCubit(this._githubService) : super(const RepositoryNameState());

  final GithubService _githubService;

  void onOwnerChanged(String owner) {
    emit(state.copyWith(owner: owner));
  }

  void onNameChanged(String name) {
    emit(state.copyWith(name: name));
  }

  Future<void> onSubmitClicked() async {
    if (state.owner == null || state.name == null) {
      emit(state.copyWith(error: const AppError(message: "Empty Fields!")));
      return;
    }
    emit(state.copyWith(isLoading: true));
    (await _githubService.getRepo(state.owner!, state.name!)).fold(
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
