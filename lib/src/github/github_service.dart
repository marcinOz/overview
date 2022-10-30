import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:github/github.dart';
import 'package:injectable/injectable.dart';
import 'package:overview/src/data/shared_preferences.dart';
import 'package:overview/src/error/app_error.dart';

@LazySingleton()
class GithubService {
  GithubService(this.prefs) {
    gitHub = GitHub(auth: findAuthenticationFromEnvironment());
    currentRepoStream = StreamController();
  }

  final SharedPreferences prefs;
  late GitHub gitHub;
  User? user;
  late Repository currentRepo;
  late final StreamController<Repository> currentRepoStream;

  void dispose() {
    currentRepoStream.close();
  }

  Future<bool> isAuthenticated() async {
    String? token = prefs.getToken();
    if (token == null) return false;
    return (await login(token)).fold(
      (l) => false,
      (r) => true,
    );
  }

  Future<Either<GitHubError, User>> login(
    String token,
  ) async {
    try {
      gitHub = GitHub(auth: Authentication.withToken(token));
      user = await gitHub.users.getCurrentUser();
      prefs.saveToken(token);
      return right(user!);
    } on AccessForbidden catch (e) {
      return left(e);
    }
  }

  void logout() {
    gitHub.dispose();
    prefs.removeToken();
  }

  Future<Either<AppError, Unit>> getRepository(
    String owner,
    String name,
  ) async {
    try {
      currentRepo =
          await gitHub.repositories.getRepository(RepositorySlug(owner, name));
      currentRepoStream.add(currentRepo);
      return right(unit);
    } on GitHubError catch (e) {
      return left(AppError(message: e.message!));
    }
  }

  Future<Either<AppError, List<Repository>>> getAllRepositories() async {
    try {
      List<Repository> list =
          await gitHub.repositories.listRepositories(type: 'all').toList();
      return right(list);
    } on GitHubError catch (e) {
      return left(AppError(message: e.message!));
    }
  }

  Future<Either<AppError, List<PullRequest>>> getClosedPRs() async {
    try {
      final prList = (await gitHub.pullRequests
          .list(
            RepositorySlug(
              currentRepo.owner!.login,
              currentRepo.name,
            ),
            state: "closed",
          )
          .toList());
      return right(prList);
    } on AccessForbidden catch (e) {
      return left(AppError(message: e.message!));
    }
  }

  Future<Either<AppError, List<PullRequestReview>>> getReviewsFor(
    PullRequest pr,
  ) async {
    try {
      final prList = (await gitHub.pullRequests
          .listReviews(
            RepositorySlug(
              currentRepo.owner!.login,
              currentRepo.name,
            ),
            pr.number!,
          )
          .toList());
      return right(prList);
    } on AccessForbidden catch (e) {
      return left(AppError(message: e.message!));
    }
  }
}
