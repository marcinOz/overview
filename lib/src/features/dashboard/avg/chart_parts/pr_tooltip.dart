import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:github/github.dart';
import 'package:intl/intl.dart';
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
      DateFormat('dd.MM.yyyy').format(pr.createdAt!);

  static String _getDuration(BuildContext context, double days) {
    final totalMinutes = (days * 24 * 60).toInt();
    final d = totalMinutes ~/ (24 * 60);
    final h = (totalMinutes % (24 * 60)) ~/ 60;
    final m = totalMinutes % 60;

    if (d > 0) {
      return '${Loc.of(context).days(d)} ${Loc.of(context).hours(h)}';
    } else if (h > 0) {
      return Loc.of(context).hours(h);
    } else {
      return Loc.of(context).minutes(m);
    }
  }
}
