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
    _currentRepoStream = StreamController();
  }

  final SharedPreferences prefs;
  late GitHub gitHub;
  User? user;
  late Repository currentRepo;
  late final StreamController<Repository> _currentRepoStream;
  Stream<Repository>? _stream;

  Stream<Repository> get currentRepoStream {
    if (_stream != null) return _stream!;
    _stream = _currentRepoStream.stream.asBroadcastStream();
    return _stream!;
  }

  void dispose() {
    _currentRepoStream.close();
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
      _currentRepoStream.add(currentRepo);
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
    } catch (e) {
      return left(AppError(message: e.toString()));
    }
  }

  Future<Either<AppError, Map<int, List<PullRequestReview>>>>
      getBatchReviewsForPRs(
    List<PullRequest> prs,
  ) async {
    try {
      final Map<int, List<PullRequestReview>> reviewsMap = {};

      final futures = prs.map((pr) => gitHub.pullRequests
              .listReviews(
                RepositorySlug(
                  currentRepo.owner!.login,
                  currentRepo.name,
                ),
                pr.number!,
              )
              .toList()
              .then((reviews) {
            reviewsMap[pr.number!] = reviews;
          }).catchError((e) {
            print('Error fetching reviews for PR #${pr.number}: $e');
            reviewsMap[pr.number!] = [];
          }));

      await Future.wait(futures);

      return right(reviewsMap);
    } on AccessForbidden catch (e) {
      return left(AppError(message: e.message!));
    } catch (e) {
      return left(AppError(message: e.toString()));
    }
  }

  Future<Either<AppError, List<Repository>>> searchRepositories(
    String query,
  ) async {
    try {
      final repoList = (await gitHub.search.repositories(query).toList());
      return right(repoList);
    } on AccessForbidden catch (e) {
      return left(AppError(message: e.message!));
    } catch (e) {
      return left(AppError(message: e.toString()));
    }
  }

  Future<Either<AppError, List<Contributor>>>
      getCurrentRepoContributors() async => getContributors(
            currentRepo.owner!.login,
            currentRepo.name,
          );

  Future<Either<AppError, List<Contributor>>> getContributors(
    String owner,
    String name,
  ) async {
    try {
      final contributors = await gitHub.repositories
          .listContributors(RepositorySlug(owner, name))
          .toList();
      return right(contributors);
    } on GitHubError catch (e) {
      return left(AppError(message: e.message!));
    } catch (e) {
      return left(AppError(message: e.toString()));
    }
  }
}
