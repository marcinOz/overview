import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:github/github.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:overview/src/error/app_error.dart';
import 'package:overview/src/features/dashboard/avg/pr_list_data_cubit.dart';
import 'package:overview/src/features/dashboard/avg/time_to_first_review/avg_time_to_first_review_cubit.dart';
import 'package:overview/src/github/github_service.dart';

import '../../../../mocks/nice_mocks.mocks.dart';
import 'avg_time_to_first_review_cubit_test.mocks.dart';

@GenerateNiceMocks([MockSpec<PRListDataCubit>()])
void main() {
  late PRListDataCubit mockPRListDataCubit;
  late GithubService mockGithubService;
  late AvgTimeToFirstReviewCubit avgTimeToFirstReviewCubit;
  late StreamController<PRListState> streamController;
  PullRequestReview prReview = PullRequestReview(id: 1, user: User());
  PullRequest pr = PullRequest();
  List<PullRequest> prList = [pr];

  setUp(() {
    mockPRListDataCubit = MockPRListDataCubit();
    mockGithubService = MockGithubService();
    streamController = StreamController<PRListState>();
    when(mockPRListDataCubit.stream).thenAnswer((_) => streamController.stream);
    avgTimeToFirstReviewCubit = AvgTimeToFirstReviewCubit(
      mockPRListDataCubit,
      mockGithubService,
    );
  });

  tearDown(() {
    avgTimeToFirstReviewCubit.close();
  });

  group('AvgTimeToFirstReviewCubit', () {
    test('initial state is AvgTimeToFirstReviewState', () {
      expect(
          avgTimeToFirstReviewCubit.state, const AvgTimeToFirstReviewState());
    });

    blocTest<AvgTimeToFirstReviewCubit, AvgTimeToFirstReviewState>(
      'emits AvgTimeToFirstReviewState with map when PRListDataCubit emits PRListState',
      build: () {
        when(mockGithubService.getReviewsFor(pr))
            .thenAnswer((_) async => Right([prReview]));
        return avgTimeToFirstReviewCubit;
      },
      act: (cubit) => streamController
        ..add(const PRListState(isLoading: true))
        ..add(PRListState(prList: prList)),
      expect: () => [
        isA<AvgTimeToFirstReviewState>()
            .having((state) => state.isLoading, 'isLoading', equals(true))
            .having((state) => state.map, 'map', equals(null)),
        isA<AvgTimeToFirstReviewState>()
            .having((state) => state.isLoading, 'isLoading', equals(true))
            .having((state) => state.map, 'map', equals(null)),
        isA<AvgTimeToFirstReviewState>()
            .having((state) => state.map, 'map', equals({pr: prReview})),
      ],
    );

    blocTest<AvgTimeToFirstReviewCubit, AvgTimeToFirstReviewState>(
      'emit null map when PRListDataCubit emits PRListState with null prList',
      build: () {
        return avgTimeToFirstReviewCubit;
      },
      act: (cubit) => streamController
        ..add(const PRListState(isLoading: true))
        ..add(const PRListState(prList: null)),
      expect: () => [
        isA<AvgTimeToFirstReviewState>()
            .having((state) => state.isLoading, 'isLoading', equals(true))
            .having((state) => state.map, 'map', equals(null)),
        isA<AvgTimeToFirstReviewState>()
            .having((state) => state.isLoading, 'isLoading', equals(false))
            .having((state) => state.map, 'map', equals(null)),
      ],
    );

    blocTest<AvgTimeToFirstReviewCubit, AvgTimeToFirstReviewState>(
      'emit state with null reviews when GithubService returns a failure',
      build: () {
        when(mockGithubService.getReviewsFor(pr))
            .thenAnswer((_) async => const Left(AppError(message: 'error')));
        return avgTimeToFirstReviewCubit;
      },
      act: (cubit) => streamController
        ..add(const PRListState(isLoading: true))
        ..add(PRListState(prList: prList)),
      expect: () => [
        isA<AvgTimeToFirstReviewState>()
            .having((state) => state.isLoading, 'isLoading', equals(true))
            .having((state) => state.map, 'map', equals(null)),
        isA<AvgTimeToFirstReviewState>()
            .having((state) => state.isLoading, 'isLoading', equals(true))
            .having((state) => state.map, 'map', equals(null)),
        isA<AvgTimeToFirstReviewState>()
            .having((state) => state.map, 'map', equals({pr: null})),
      ],
    );
  });
}
