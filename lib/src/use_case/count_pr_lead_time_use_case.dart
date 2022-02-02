import 'package:github/github.dart';

class CountPrLeadTimeUseCase {
  String call(List<PullRequest> prList) {
    int size = prList.length;
    Duration duration = const Duration();
    for (PullRequest pr in prList) {
      duration += pr.createdAt!.difference(pr.closedAt!);
    }
    final double minutes = duration.inMinutes / size;
    return _durationToString(Duration(minutes: minutes.toInt()).abs());
  }

  String _durationToString(Duration duration) {
    String result = "";
    if (duration.inDays > 0) result += "${duration.inDays}D";
    result += " ${duration.inHours % 24}H";
    return result;
  }
}
