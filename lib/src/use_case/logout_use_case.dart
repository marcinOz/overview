import 'package:flutter/cupertino.dart';
import 'package:overview/src/github/github_service.dart';
import 'package:overview/src/injectable/injectable.dart';

import '../features/login/login_view.dart';

class LogoutUseCase {
  void call(BuildContext context) {
    getIt.get<GithubService>().logout();
    Navigator.pushReplacementNamed(
      context,
      LoginView.routeName,
    );
  }
}
