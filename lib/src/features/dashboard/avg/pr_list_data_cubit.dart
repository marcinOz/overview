import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:github/github.dart';
import 'package:injectable/injectable.dart';
import 'package:overview/src/features/dashboard/avg/chart_card.dart';
import 'package:overview/src/github/github_service.dart';

@LazySingleton()
class PRListDataCubit extends Cubit<PRListState> {
  PRListDataCubit(
    this._service,
  ) : super(const PRListState()) {
    _onInit();
  }

  final GithubService _service;
  late final StreamSubscription _repoSelectionSubscription;

  @override
  Future<void> close() {
    _repoSelectionSubscription.cancel();
    return super.close();
  }

  void _onInit() {
    _repoSelectionSubscription = _service.currentRepoStream.listen((event) {
      emit(PRListState(repoName: event.name, isLoading: true));
      _getPRs();
    });
  }

  Future<void> _getPRs() async {
    (await _service.getClosedPRs()).fold(
      (l) => null,
      (prList) {
        prList.sort((a, b) => a.createdAt!.isBefore(b.createdAt!) ? 1 : -1);
        emit(state.copyWith(prList: prList));
      },
    );
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
