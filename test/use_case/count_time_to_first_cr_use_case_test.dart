import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:overview/src/use_case/count_time_to_first_cr_use_case.dart';

import '../mocks/nice_mocks.mocks.dart';

void main() {
  late CountTimeToFirstCrUseCase useCase;

  setUp(() {
    useCase = CountTimeToFirstCrUseCase();
  });

  group('CountTimeToFirstCrUseCase', () {
    test('should return zero when given an empty map', () {
      final result = useCase.call({});
      expect(result.inMinutes, equals(0));
    });

    test('should return the average time to first CR', () {
      final pr1 = MockPullRequest();
      final review1 = MockPullRequestReview();
      when(pr1.createdAt).thenReturn(DateTime.now().subtract(Duration(days: 1)));
      when(review1.submittedAt).thenReturn(DateTime.now());
      final pr2 = MockPullRequest();
      final review2 = MockPullRequestReview();
      when(pr2.createdAt).thenReturn(DateTime.now().subtract(Duration(days: 2)));
      when(review2.submittedAt).thenReturn(DateTime.now().subtract(Duration(hours: 1)));
      final result = useCase.call({
        pr1: review1,
        pr2: review2,
      });
      expect(result.pretty(), equals('1 D 11H'));
    });
  });

  group('FirstCrDurationExt', () {
    test('should return a string representation of the duration', () {
      const duration = Duration(days: 1, hours: 1, minutes: 30);
      expect(duration.pretty(), equals('1 D 1H'));
    });
  });
}
