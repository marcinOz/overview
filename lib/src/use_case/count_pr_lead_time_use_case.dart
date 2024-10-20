import 'package:github/github.dart';

class CountPrLeadTimeUseCase {
  Duration call(List<PullRequest> prList) {
    if (prList.isEmpty) return Duration.zero;

    Duration duration = const Duration();
    for (PullRequest pr in prList) {
      duration += pr.closedAt!.difference(pr.createdAt!);
    }
    final double minutes = duration.inMinutes / prList.length;
    return Duration(minutes: minutes.toInt());
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
