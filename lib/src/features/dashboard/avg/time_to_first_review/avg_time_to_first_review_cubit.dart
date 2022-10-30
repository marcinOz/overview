import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:github/github.dart';
import 'package:injectable/injectable.dart';
import 'package:overview/src/features/dashboard/avg/avg_cubit.dart';
import 'package:overview/src/github/github_service.dart';

@Injectable()
class AvgTimeToFirstReviewCubit extends Cubit<AvgTimeToFirstReviewState> {
  AvgTimeToFirstReviewCubit(
    this._avgCubit,
    this._githubService,
  ) : super(const AvgTimeToFirstReviewState()) {
    _subscription = _avgCubit.stream.listen(_onAvgCubitEvent);
  }

  final AvgCubit _avgCubit;
  final GithubService _githubService;
  late final StreamSubscription _subscription;
  Map<PullRequest, PullRequestReview?> map = {};
  int prListSize = 0;

  @override
  Future<void> close() async {
    _subscription.cancel();
    super.close();
  }

  void _onAvgCubitEvent(AvgState event) {
    if (event.prList == null) return;
    map = event.prList!.asMap().map((key, value) => MapEntry(value, null));
    prListSize = event.prList!.length;
    for (var element in event.prList!) {
      _getReview(element);
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
  ]);

  final Map<PullRequest, PullRequestReview?>? map;
}
