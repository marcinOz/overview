import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:github/github.dart';
import 'package:injectable/injectable.dart';
import 'package:overview/src/github/github_service.dart';

@LazySingleton()
class AvgCubit extends Cubit<AvgState> {
  AvgCubit(this._service) : super(const AvgState()) {
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
    _subscription = _service.currentRepoStream.stream.listen((event) {
      emit(AvgState(repoName: event.name));
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

class AvgState {
  const AvgState({
    this.prList,
    this.repoName = "",
  });

  final String repoName;
  final List<PullRequest>? prList;

  AvgState copyWith({List<PullRequest>? prList}) => AvgState(
        repoName: repoName,
        prList: prList ?? this.prList,
      );
}
