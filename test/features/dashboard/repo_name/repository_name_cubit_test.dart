import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:overview/src/error/app_error.dart';
import 'package:overview/src/features/dashboard/repo_name/repository_name_cubit.dart';
import 'package:overview/src/github/github_service.dart';

import '../../../mocks/nice_mocks.mocks.dart';

void main() {
  group('RepositoryNameCubit', () {
    late RepositoryNameCubit repositoryNameCubit;
    late GithubService mockGithubService;

    setUp(() {
      mockGithubService = MockGithubService();
      repositoryNameCubit = RepositoryNameCubit(mockGithubService);
    });

    test('initial state is correct', () {
      expect(
        repositoryNameCubit.state,
        const RepositoryNameState(),
      );
    });

    test('fillUpFromClick sets owner and name', () {
      const owner = 'owner';
      const name = 'name';
      repositoryNameCubit.fillUpFromClick(owner, name);
      expect(repositoryNameCubit.state.owner, owner);
      expect(repositoryNameCubit.state.name, name);
    });

    test('onOwnerChanged sets owner', () {
      const owner = 'owner';
      repositoryNameCubit.onOwnerChanged(owner);
      expect(repositoryNameCubit.state.owner, owner);
    });

    test('onNameChanged sets name', () {
      const name = 'name';
      repositoryNameCubit.onNameChanged(name);
      expect(repositoryNameCubit.state.name, name);
    });

    test('onSubmitClicked with empty fields emits error', () async {
      repositoryNameCubit.onSubmitClicked();
      verifyNever(mockGithubService.getRepository('', ''));
      expect(repositoryNameCubit.state.error?.message, 'Empty Fields!');
    });

    test(
        'onSubmitClicked with valid fields emits isLoading and gets repository',
        () async {
      const owner = 'owner';
      const name = 'name';
      when(mockGithubService.getRepository(owner, name)).thenAnswer(
        (_) => Future.value(const Right(unit)),
      );
      repositoryNameCubit.fillUpFromClick(owner, name);
      repositoryNameCubit.onSubmitClicked();
      expect(repositoryNameCubit.state.isLoading, true);
      await untilCalled(mockGithubService.getRepository(owner, name));
      verify(mockGithubService.getRepository(owner, name)).called(1);
      expect(repositoryNameCubit.state.isLoading, false);
    });

    test('onSubmitClicked with invalid fields emits error', () async {
      const owner = 'owner';
      const name = 'name';
      when(mockGithubService.getRepository(owner, name)).thenAnswer(
        (_) => Future.value(const Left(AppError(message: 'Error'))),
      );
      repositoryNameCubit.fillUpFromClick(owner, name);
      repositoryNameCubit.onSubmitClicked();
      expect(repositoryNameCubit.state.isLoading, true);
      await untilCalled(mockGithubService.getRepository(owner, name));
      verify(mockGithubService.getRepository(owner, name)).called(1);
      expect(repositoryNameCubit.state.isLoading, false);
      expect(repositoryNameCubit.state.error?.message, 'Error');
    });
  });
}
