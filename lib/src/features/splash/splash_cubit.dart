import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:overview/src/github/github_service.dart';

@Injectable()
class SplashCubit extends Cubit<SplashState> {
  SplashCubit(this._service) : super(const SplashIdleState()) {
    _onInit();
  }

  final GithubService _service;

  Future<void> _onInit() async {
    await Future.delayed(const Duration(seconds: 1));
    emit((await _service.isAuthenticated())
        ? const SplashAuthenticatedState()
        : const SplashLogoutState());
  }
}

abstract class SplashState {
  const SplashState();
}

class SplashIdleState extends SplashState {
  const SplashIdleState();
}

class SplashAuthenticatedState extends SplashState {
  const SplashAuthenticatedState();
}

class SplashLogoutState extends SplashState {
  const SplashLogoutState();
}
