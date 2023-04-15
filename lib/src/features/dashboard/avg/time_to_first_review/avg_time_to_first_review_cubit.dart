import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:github/github.dart';
import 'package:injectable/injectable.dart';
import 'package:overview/src/features/dashboard/avg/pr_list_data_cubit.dart';
import 'package:overview/src/github/github_service.dart';

import '../chart_card.dart';

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
  }

  Future<void> _getReview(PullRequest pr) async {
    (await _githubService.getReviewsFor(pr)).fold(
      (l) => emit(AvgTimeToFirstReviewState(map)),
      (allReviews) {
        if (allReviews.isNotEmpty) {
          map[pr] = allReviews.reduce(
            (a, b) => a.submittedAt!.isBefore(b.submittedAt!) ? a : b,
          );
        }
        emit(AvgTimeToFirstReviewState(map));
      },
    );
  }
}

class AvgTimeToFirstReviewState extends ChartCardState {
  const AvgTimeToFirstReviewState([
    this.map,
    isLoading = false,
  ]) : super(isLoading);

  final Map<PullRequest, PullRequestReview?>? map;

  @override
  bool isPopulated() => !isLoading && map?.isNotEmpty == true;
}
