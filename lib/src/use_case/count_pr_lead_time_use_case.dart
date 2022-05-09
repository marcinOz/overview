import 'package:github/github.dart';

class CountPrLeadTimeUseCase {
  Duration call(List<PullRequest> prList) {
    if (prList.isEmpty) return Duration.zero;

    int size = prList.length;
    Duration duration = const Duration();
    for (PullRequest pr in prList) {
      duration += pr.createdAt!.difference(pr.closedAt!);
    }
    final double minutes = duration.inMinutes / size;
    return Duration(minutes: minutes.toInt()).abs();
  }
}

extension PrDurationExt on Duration {
  String pretty() {
    String result = "";
    if (inDays > 0) result += "$inDays D";
    result += " ${inHours % 24}H";
    return result;
  }
}
