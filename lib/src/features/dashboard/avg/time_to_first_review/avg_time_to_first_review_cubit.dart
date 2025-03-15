import 'dart:async';

import 'package:flutter/foundation.dart';
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

    // Handle null or empty PR list
    if (event.prList == null || event.prList!.isEmpty) {
      map = {};
      prListSize = 0;
      emit(AvgTimeToFirstReviewState(map));
      return;
    }

    // Initialize empty map and set PR list size
    map = {};
    prListSize = event.prList!.length;

    // Fetch all reviews in a single batch
    _getReviewsBatch(event.prList!);
  }

  Future<void> _getReviewsBatch(List<PullRequest> prs) async {
    // Show loading state
    emit(AvgTimeToFirstReviewState(null, true));

    // Fetch all reviews in a batch
    (await _githubService.getBatchReviewsForPRs(prs)).fold(
      (error) {
        // Handle error
        print('Error fetching reviews: ${error.message}');
        emit(AvgTimeToFirstReviewState({}));
      },
      (reviewsMap) async {
        // Process the data in a background thread using compute
        _processReviewsInBackground(prs, reviewsMap);
      },
    );
  }

  Future<void> _processReviewsInBackground(List<PullRequest> prs,
      Map<int, List<PullRequestReview>> reviewsMap) async {
    try {
      // Create a map of PR numbers to PRs for lookup
      final prMap = {for (var pr in prs) pr.number!: pr};

      // Process the data in a background thread using compute
      // This is more efficient than spawning a separate isolate manually
      final processedMap = await compute(_findEarliestReviews, {
        'reviewsMap': reviewsMap,
        'prMap': prMap,
      });

      // Convert the result back to the expected format
      map = {
        for (var entry in processedMap.entries) prMap[entry.key]!: entry.value
      };

      emit(AvgTimeToFirstReviewState(map));
    } catch (e) {
      print('Error processing reviews in background: $e');

      // Fallback to processing in main thread if compute fails
      _processReviewsInMainThread(prs, reviewsMap);
    }
  }

  void _processReviewsInMainThread(
      List<PullRequest> prs, Map<int, List<PullRequestReview>> reviewsMap) {
    final processedMap = <PullRequest, PullRequestReview?>{};

    for (final pr in prs) {
      final reviews = reviewsMap[pr.number!] ?? [];

      if (reviews.isNotEmpty) {
        // Find the earliest review
        processedMap[pr] = reviews.reduce((a, b) {
          if (a.submittedAt == null) return b;
          if (b.submittedAt == null) return a;
          return a.submittedAt!.isBefore(b.submittedAt!) ? a : b;
        });
      } else {
        processedMap[pr] = null;
      }
    }

    map = processedMap;
    emit(AvgTimeToFirstReviewState(map));
  }
}

// Static function to run in a separate isolate via compute
Map<int, PullRequestReview?> _findEarliestReviews(Map<String, dynamic> args) {
  final reviewsMap = args['reviewsMap'] as Map<int, List<PullRequestReview>>;
  final prMap = args['prMap'] as Map<int, PullRequest>;

  final result = <int, PullRequestReview?>{};

  for (final prNumber in prMap.keys) {
    final reviews = reviewsMap[prNumber] ?? [];

    if (reviews.isNotEmpty) {
      // Find the earliest review
      result[prNumber] = reviews.reduce((a, b) {
        if (a.submittedAt == null) return b;
        if (b.submittedAt == null) return a;
        return a.submittedAt!.isBefore(b.submittedAt!) ? a : b;
      });
    } else {
      result[prNumber] = null;
    }
  }

  return result;
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
