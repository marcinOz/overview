import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:github/github.dart';
import 'package:overview/src/localization/localizations.dart';

class PRTooltip extends LineTouchData {
  final BuildContext context;
  final List<PullRequest> prList;

  PRTooltip({
    required this.context,
    required this.prList,
  }) : super(
          touchTooltipData: LineTouchTooltipData(
            getTooltipItems: (spots) => spots.map((s) {
              final pr = prList[s.spotIndex];
              return LineTooltipItem(
                'PR #${pr.number}\n${_date(pr)}\n${_getDuration(context, s.y)}',
                const TextStyle(color: Colors.white),
              );
            }).toList(),
          ),
        );

  static String _date(PullRequest pr) =>
      '${pr.createdAt!.day}.${pr.createdAt!.month}.${pr.createdAt!.year}';

  static String _getDuration(BuildContext context, double days) {
    final d = days.toInt();
    final h = ((days - d) * 24);
    if (h < 1) {
      return Loc.of(context).minutes((h * 60).toInt());
    }
    if (d < 1) {
      return Loc.of(context).hours((days * 24).toInt());
    }
    return '${Loc.of(context).days(d)} ${Loc.of(context).hours(h.toInt())}';
  }
}
