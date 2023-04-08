import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:github/github.dart';
import 'package:injectable/injectable.dart';
import 'package:overview/src/features/dashboard/avg/pr_list_data_cubit.dart';
import 'package:overview/src/github/github_service.dart';

@Injectable()
class AvgTimeToFirstReviewCubit extends Cubit<AvgTimeToFirstReviewState> {
  AvgTimeToFirstReviewCubit(
    this._prListDataCubit,
    this._githubService,
  ) : super(const AvgTimeToFirstReviewState()) {
    _subscription = _prListDataCubit.stream.listen(_onPrListDataCubitEvent);
  }

  final PRListDataCubit _prListDataCubit;
  final GithubService _githubService;
  late final StreamSubscription _subscription;
  Map<PullRequest, PullRequestReview?> map = {};
  int prListSize = 0;

  @override
  Future<void> close() async {
    _subscription.cancel();
    super.close();
  }

  void _onPrListDataCubitEvent(PRListState event) {
    emit(AvgTimeToFirstReviewState(
      null,
      event.isLoading || event.prList != null,
    ));
    if (event.prList == null) return;
    map = event.prList!.asMap().map((key, value) => MapEntry(value, null));
    prListSize = event.prList!.length;
    for (var element in event.prList!) {
      _getReview(element);
    }
    // There was no reviews or error occurred
    if (state.isLoading) {
      emit(AvgTimeToFirstReviewState(map));
    }
  }

  Future<void> _getReview(PullRequest pr) async {
    (await _githubService.getReviewsFor(pr)).fold(
      (l) => null,
      (allReviews) {
        if (allReviews.isEmpty) {
          map[pr] = null;
          return;
        }
        map[pr] = allReviews.reduce(
          (a, b) => a.submittedAt!.isBefore(b.submittedAt!) ? a : b,
        );
        if (map.length == prListSize) {
          emit(AvgTimeToFirstReviewState(map));
        }
      },
    );
  }
}

class AvgTimeToFirstReviewState {
  const AvgTimeToFirstReviewState([
    this.map,
    this.isLoading = false,
  ]);

  final bool isLoading;
  final Map<PullRequest, PullRequestReview?>? map;

  @override
  String toString() {
    return '''AvgTimeToFirstReviewState{
    map: $map, 
    isLoading: $isLoading
    }''';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AvgTimeToFirstReviewState &&
        mapEquals(other.map, map) &&
        other.isLoading == isLoading;
  }

  @override
  int get hashCode => map.hashCode ^ isLoading.hashCode;
}
