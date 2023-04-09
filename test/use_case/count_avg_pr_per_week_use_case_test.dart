import 'package:flutter_test/flutter_test.dart';
import 'package:github/github.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:overview/src/use_case/count_avg_pr_per_week_use_case.dart';

import 'count_avg_pr_per_week_use_case_test.mocks.dart';

@GenerateNiceMocks([MockSpec<PullRequest>()])
void main() {
  late CountAvgPrPerWeekUseCase useCase;
  late List<PullRequest> mockPrList;

  setUp(() {
    useCase = CountAvgPrPerWeekUseCase();
  });

  test('should return 0 when input list is empty', () {
    final result = useCase.call([]);

    expect(result, equals(0));
  });

  test('should calculate average number of PRs per week [one week]', () {
    mockPrList = [
      MockPullRequest(),
      MockPullRequest(),
      MockPullRequest(),
      MockPullRequest(),
    ];
    final user1 = User(login: 'user1');
    when(mockPrList[0].createdAt).thenReturn(DateTime(2023, 1, 2));
    when(mockPrList[0].user).thenReturn(user1);
    when(mockPrList[1].createdAt).thenReturn(DateTime(2023, 1, 3));
    when(mockPrList[1].user).thenReturn(user1);
    when(mockPrList[2].createdAt).thenReturn(DateTime(2023, 1, 4));
    when(mockPrList[2].user).thenReturn(user1);

    when(mockPrList[3].createdAt).thenReturn(DateTime(2023, 1, 3));
    when(mockPrList[3].user).thenReturn(User(login: 'user2'));

    final result = useCase.call(mockPrList);

    expect(result, equals(2));
  });

  test('should calculate average number of PRs per week [two weeks]', () {
    mockPrList = [
      MockPullRequest(),
      MockPullRequest(),
      MockPullRequest(),
      MockPullRequest(),
      MockPullRequest(),
      MockPullRequest(),
      MockPullRequest(),
    ];
    final user1 = User(login: 'user1');
    final user2 = User(login: 'user2');
    // Week 1
    when(mockPrList[0].createdAt).thenReturn(DateTime(2023, 1, 2));
    when(mockPrList[0].user).thenReturn(user1);
    when(mockPrList[1].createdAt).thenReturn(DateTime(2023, 1, 3));
    when(mockPrList[1].user).thenReturn(user1);
    when(mockPrList[2].createdAt).thenReturn(DateTime(2023, 1, 4));
    when(mockPrList[2].user).thenReturn(user1);

    when(mockPrList[3].createdAt).thenReturn(DateTime(2023, 1, 3));
    when(mockPrList[3].user).thenReturn(user2);

    // Week 2
    when(mockPrList[4].createdAt).thenReturn(DateTime(2023, 1, 9));
    when(mockPrList[4].user).thenReturn(user1);
    when(mockPrList[5].createdAt).thenReturn(DateTime(2023, 1, 9));
    when(mockPrList[5].user).thenReturn(user2);
    when(mockPrList[6].createdAt).thenReturn(DateTime(2023, 1, 10));
    when(mockPrList[6].user).thenReturn(user2);

    final result = useCase.call(mockPrList);

    expect(result, equals(1.75));
  });
}
