import 'package:github/github.dart';
import 'package:mockito/annotations.dart';
import 'package:overview/src/github/github_service.dart';

@GenerateNiceMocks([
  MockSpec<GithubService>(),
  MockSpec<PullRequest>(),
  MockSpec<PullRequestReview>(),
])
class NiceMocks {
  const NiceMocks();
}
