import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:github/github.dart';
import 'package:injectable/injectable.dart';
import 'package:overview/src/github/github_service.dart';

@LazySingleton()
class ContributorsCubit extends Cubit<ContributorsState> {
  ContributorsCubit(this._service) : super(const ContributorsState()) {
    _onInit();
  }

  final GithubService _service;

  late final StreamSubscription _subscription;

  @override
  Future<void> close() {
    _subscription.cancel();
    return super.close();
  }

  void _onInit() {
    _subscription = _service.currentRepoStream.listen((event) {
      emit(ContributorsState(isLoading: true));
      _getContributors();
    });
  }

  Future<void> _getContributors() async {
    (await _service.getCurrentRepoContributors()).fold(
      (l) => null,
      (contributors) {
        emit(state.copyWith(contributors: contributors));
      },
    );
  }
}

class ContributorsState {
  const ContributorsState({
    this.contributors,
    this.isLoading = false,
  });

  final List<Contributor>? contributors;
  final bool isLoading;

  @override
  String toString() {
    return '''ContributorsState{
    contributors: $contributors, 
    isLoading: $isLoading
    }''';
  }

  @override
  bool operator ==(Object other) {
    return other is ContributorsState &&
        contributors == other.contributors &&
        isLoading == other.isLoading;
  }

  @override
  int get hashCode => contributors.hashCode ^ isLoading.hashCode;

  ContributorsState copyWith({
    List<Contributor>? contributors,
    bool? isLoading,
  }) =>
      ContributorsState(
        contributors: contributors ?? this.contributors,
        isLoading: isLoading ?? false,
      );
}
