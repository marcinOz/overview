import 'package:github/github.dart';

class CountTimeToFirstCrUseCase {
  Duration call(Map<PullRequest, PullRequestReview?> map) {
    if (map.isEmpty) return const Duration();
    int size = map.length;
    Duration duration = const Duration();
    for (MapEntry entry in map.entries) {
      if (entry.value == null || entry.value!.submittedAt == null) continue;
      duration += entry.key.createdAt!.difference(entry.value!.submittedAt!);
    }
    final double minutes = duration.inMinutes / size;
    return Duration(minutes: minutes.toInt()).abs();
  }
}

extension FirstCrDurationExt on Duration {
  String pretty() {
    String result = "";
    if (inDays > 0) result += "$inDays D";
    result += " ${inHours % 24}H";
    return result;
  }
}
