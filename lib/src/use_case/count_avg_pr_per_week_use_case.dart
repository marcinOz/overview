import 'package:flutter/foundation.dart';
import 'package:github/github.dart';
import 'package:overview/src/extensions/week_of_year.dart';

class CountAvgPrPerWeekUseCase {
  double call(List<PullRequest> prList) {
    if (prList.isEmpty) return 0;
    Map<int, Map<String, int>> map = {};

    for (var element in prList) {
      final weekOfYear = element.createdAt!.weekOfYear;
      final login = element.user!.login!;
      if (!map.keys.contains(weekOfYear)) {
        map[weekOfYear] = {login: 1};
      } else if (map[weekOfYear]!.keys.contains(login)) {
        final int prev = map[weekOfYear]![login]!;
        map[weekOfYear]![login] = prev + 1;
      } else {
        map[weekOfYear]![login] = 1;
      }
    }

    double sum = 0;
    for (var week in map.keys) {
      int prsSumInWeek = 0;
      for (var user in map[week]!.keys) {
        prsSumInWeek += map[week]![user]!;
      }
      double weekAvg = prsSumInWeek / map[week]!.keys.length;
      debugPrint('Week: $week, Avg: $weekAvg');
      sum += weekAvg;
    }

    double result = sum / map.keys.length;
    debugPrint('Whole Avg: $result');
    return result;
  }
}
