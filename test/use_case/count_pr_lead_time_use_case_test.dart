import 'package:flutter_test/flutter_test.dart';
import 'package:github/github.dart';
import 'package:mockito/mockito.dart';
import 'package:overview/src/use_case/count_pr_lead_time_use_case.dart';

import '../mocks/nice_mocks.mocks.dart';

void main() {
  late CountPrLeadTimeUseCase useCase;
  late List<PullRequest> mockPrList;

  setUp(() {
    useCase = CountPrLeadTimeUseCase();
    mockPrList = [];
  });

  test('should return zero duration when input list is empty', () {
    final result = useCase.call([]);

    expect(result, equals(Duration.zero));
  });

  test('should calculate lead time for PRs', () {
    mockPrList = [
      MockPullRequest(),
      MockPullRequest(),
      MockPullRequest(),
    ];
    when(mockPrList[0].createdAt).thenReturn(DateTime(2023, 1, 1));
    when(mockPrList[0].closedAt).thenReturn(DateTime(2023, 1, 2));
    when(mockPrList[1].createdAt).thenReturn(DateTime(2023, 1, 2));
    when(mockPrList[1].closedAt).thenReturn(DateTime(2023, 1, 4));
    when(mockPrList[2].createdAt).thenReturn(DateTime(2023, 1, 3));
    when(mockPrList[2].closedAt).thenReturn(DateTime(2023, 1, 6));

    final result = useCase.call(mockPrList);

    expect(result, equals(const Duration(days: 2)));
  });

  test('should calculate lead time for PRs: case 2', () {
  for (int i = 0; i < 100; i++) {
    mockPrList.add(MockPullRequest());
    when(mockPrList[i].createdAt).thenReturn(DateTime(2023, 1, 1 + i));
    when(mockPrList[i].closedAt).thenReturn(DateTime(2023, 1, 2 + i));
  }

  final result = useCase.call(mockPrList);

  expect(result, equals(const Duration(minutes: 1439)));
});

  test('should format duration string', () {
    const duration = Duration(days: 2, hours: 8);

    final result = duration.pretty();

    expect(result, equals("2 D 8H"));
  });
}
