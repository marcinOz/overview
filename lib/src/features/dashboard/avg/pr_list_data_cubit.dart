import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:github/github.dart';
import 'package:injectable/injectable.dart';
import 'package:overview/src/features/dashboard/avg/chart_card.dart';
import 'package:overview/src/features/dashboard/contributors/current_contributor_data_cubit.dart';
import 'package:overview/src/github/github_service.dart';
import 'package:overview/src/injectable/injectable.dart';

@LazySingleton()
class PRListDataCubit extends Cubit<PRListState> {
  PRListDataCubit(
    this._service,
  ) : super(const PRListState()) {
    _onInit();
  }

  final GithubService _service;
  late final StreamSubscription _repoSelectionSubscription;
  late final StreamSubscription _contributorSubscription;
  List<PullRequest> _allPRs = [];
  String _currentContributor = CurrentContributorDataCubit.initialContributors;

  @override
  Future<void> close() {
    _repoSelectionSubscription.cancel();
    _contributorSubscription.cancel();
    return super.close();
  }

  void _onInit() {
    _repoSelectionSubscription = _service.currentRepoStream.listen((event) {
      emit(PRListState(repoName: event.name, isLoading: true));
      _getPRs();
    });

    // Listen to contributor changes
    final contributorCubit = getIt.get<CurrentContributorDataCubit>();
    _contributorSubscription = contributorCubit.stream.listen((contributor) {
      _currentContributor = contributor;
      _filterPRsByContributor();
    });
  }

  Future<void> _getPRs() async {
    (await _service.getClosedPRs()).fold(
      (l) => null,
      (prList) {
        prList.sort((a, b) => a.createdAt!.isBefore(b.createdAt!) ? 1 : -1);
        _allPRs = prList;
        _filterPRsByContributor();
      },
    );
  }

  void _filterPRsByContributor() {
    if (_allPRs.isEmpty) return;

    if (_currentContributor ==
        CurrentContributorDataCubit.initialContributors) {
      // Show all PRs
      emit(state.copyWith(prList: _allPRs));
    } else {
      // Filter PRs by contributor
      final filteredPRs =
          _allPRs.where((pr) => pr.user?.login == _currentContributor).toList();

      emit(state.copyWith(prList: filteredPRs));
    }
  }
}

class PRListState extends ChartCardState {
  const PRListState({
    this.prList,
    this.repoName = "",
    isLoading = false,
  }) : super(isLoading);

  final String repoName;
  final List<PullRequest>? prList;

  @override
  String toString() {
    return '''PRListState{
    repoName: $repoName, 
    prList: $prList, 
    isLoading: $isLoading
    }''';
  }

  @override
  bool operator ==(Object other) {
    return other is PRListState &&
        repoName == other.repoName &&
        prList == other.prList &&
        isLoading == other.isLoading;
  }

  @override
  int get hashCode => repoName.hashCode ^ prList.hashCode ^ isLoading.hashCode;

  PRListState copyWith({
    List<PullRequest>? prList,
    bool? isLoading,
  }) =>
      PRListState(
        repoName: repoName,
        prList: prList ?? this.prList,
        isLoading: isLoading ?? false,
      );

  @override
  bool isPopulated() => prList?.isNotEmpty == true;
}
