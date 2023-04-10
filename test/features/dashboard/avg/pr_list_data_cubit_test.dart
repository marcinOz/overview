import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:github/github.dart';
import 'package:mockito/mockito.dart';
import 'package:overview/src/error/app_error.dart';
import 'package:overview/src/features/dashboard/avg/pr_list_data_cubit.dart';
import 'package:overview/src/github/github_service.dart';

import '../../../mocks/nice_mocks.mocks.dart';

void main() {
  late GithubService mockService;
  late PRListDataCubit prListDataCubit;
  late StreamController<Repository> currentRepoStreamController;
  PullRequest pr = PullRequest();
  List<PullRequest> prList = [pr];

  setUp(() {
    mockService = MockGithubService();
    currentRepoStreamController = StreamController<Repository>();
    when(mockService.currentRepoStream)
        .thenAnswer((_) => currentRepoStreamController.stream);
    prListDataCubit = PRListDataCubit(mockService);
  });

  tearDown(() {
    prListDataCubit.close();
  });

  group('PRListDataCubit', () {
    test('initial state is PRListState', () {
      expect(prListDataCubit.state, const PRListState());
    });

    blocTest<PRListDataCubit, PRListState>(
      'emits PRListState with prList when getClosedPRs returns a list of PullRequests',
      build: () {
        when(mockService.getClosedPRs())
            .thenAnswer((_) async => Right(prList));
        return prListDataCubit;
      },
      act: (cubit) => currentRepoStreamController.add(Repository()),
      expect: () => [
        const PRListState(isLoading: true),
        PRListState(
          isLoading: false,
          prList: prList,
        ),
      ],
    );

    blocTest<PRListDataCubit, PRListState>(
      'does not emit any state when getClosedPRs returns a failure',
      build: () {
        when(mockService.getClosedPRs())
            .thenAnswer((_) async => const Left(AppError(message: 'error')));
        return prListDataCubit;
      },
      expect: () => [],
    );
  });
}
