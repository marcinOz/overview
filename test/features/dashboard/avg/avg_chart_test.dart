import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:github/github.dart';
import 'package:overview/src/features/dashboard/avg/avg_chart.dart';

import '../../../mocks/nice_mocks.mocks.dart';

void main() {
  group('AvgChart Widget', () {
    late List<PullRequest> prList;
    late List<FlSpot> Function(List<PullRequest>) mapPrsToSpots;
    late AvgChart avgChart;

    setUp(() {
      prList = [MockPullRequest(), MockPullRequest(), MockPullRequest()];
      mapPrsToSpots = (List<PullRequest> prList) => [
            FlSpot(DateTime(2023, 1).millisecondsSinceEpoch.toDouble(), 2),
            FlSpot(DateTime(2023, 2).millisecondsSinceEpoch.toDouble(), 4),
            FlSpot(DateTime(2023, 3).millisecondsSinceEpoch.toDouble(), 6),
          ];
      avgChart = AvgChart(prList: prList, mapPrsToSpots: mapPrsToSpots);
    });

    testWidgets('should display a LineChart widget',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: avgChart));

      expect(find.byType(LineChart), findsOneWidget);
    });

    testWidgets('should display bottom axis titles with month names',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: avgChart));

      expect(find.text('Jan'), findsOneWidget);
      expect(find.text('Mar'), findsOneWidget);
    });

    testWidgets('should display left axis titles with day numbers',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: avgChart));

      expect(find.text('0D'), findsOneWidget);
      expect(find.text('1D'), findsOneWidget);
      expect(find.text('2D'), findsOneWidget);
      expect(find.text('3D'), findsOneWidget);
      expect(find.text('4D'), findsOneWidget);
      expect(find.text('5D'), findsOneWidget);
      expect(find.text('6D'), findsOneWidget);
    });
  });
}
