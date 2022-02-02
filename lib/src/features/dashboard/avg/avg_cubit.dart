import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:github/github.dart';
import 'package:injectable/injectable.dart';
import 'package:overview/src/github/github_service.dart';
import 'package:overview/src/use_case/count_pr_lead_time_use_case.dart';

@Injectable()
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
    (await _service.getPRs()).fold(
      (l) => null,
      (prList) => emit(state.copyWith(
        prList: prList,
        avgPrLeadTime: CountPrLeadTimeUseCase()(prList),
      )),
    );
  }
}

class AvgState {
  const AvgState({
    this.prList,
    this.repoName = "",
    this.avgPrLeadTime = "None",
  });

  final String repoName;
  final String avgPrLeadTime;
  final List<PullRequest>? prList;

  AvgState copyWith({
    String? avgPrLeadTime,
    List<PullRequest>? prList,
  }) =>
      AvgState(
        repoName: repoName,
        prList: prList ?? this.prList,
        avgPrLeadTime: avgPrLeadTime ?? this.avgPrLeadTime,
      );
}
