import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:overview/src/github/github_service.dart';

@Injectable()
class LoginCubit extends Cubit<LoginState> {
  LoginCubit(this._service) : super(const LoginState());

  final GithubService _service;

  void tokenChanged(String token) {
    emit(state.copyWith(token: token));
  }

  Future<void> login() async {
    emit(state.copyWith(isLoading: true));
    (await _service.login(state.token)).fold(
      (error) => emit(state.copyWith(isLoading: false, error: error.message)),
      (user) => emit(const LoginState(success: true)),
    );
  }
}

class LoginState {
  const LoginState({
    this.token = "",
    this.isLoading = false,
    this.success = false,
    this.error,
  });

  final String token;
  final String? error;
  final bool isLoading;
  final bool success;

  LoginState copyWith({
    String? username,
    String? token,
    bool? isLoading,
    String? error,
  }) =>
      LoginState(
        token: token ?? this.token,
        isLoading: isLoading ?? this.isLoading,
        error: error,
      );
}
