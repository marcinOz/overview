import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

enum ChartPeriod {
  all,
  lastMonth,
  lastWeek,
  custom,
}

class PeriodSelectorData {
  final ChartPeriod period;
  final DateTime? startDate;
  final DateTime? endDate;

  const PeriodSelectorData({
    required this.period,
    this.startDate,
    this.endDate,
  });

  factory PeriodSelectorData.all() =>
      const PeriodSelectorData(period: ChartPeriod.all);

  factory PeriodSelectorData.lastMonth() => PeriodSelectorData(
        period: ChartPeriod.lastMonth,
        endDate: DateTime.now(),
        startDate: DateTime.now().subtract(const Duration(days: 30)),
      );

  factory PeriodSelectorData.lastWeek() => PeriodSelectorData(
        period: ChartPeriod.lastWeek,
        endDate: DateTime.now(),
        startDate: DateTime.now().subtract(const Duration(days: 7)),
      );

  factory PeriodSelectorData.custom({
    required DateTime startDate,
    required DateTime endDate,
  }) =>
      PeriodSelectorData(
        period: ChartPeriod.custom,
        startDate: startDate,
        endDate: endDate,
      );

  String get displayText {
    switch (period) {
      case ChartPeriod.all:
        return 'All Time';
      case ChartPeriod.lastMonth:
        return 'Last Month';
      case ChartPeriod.lastWeek:
        return 'Last Week';
      case ChartPeriod.custom:
        final formatter = DateFormat('dd MMM yyyy');
        return '${formatter.format(startDate!)} - ${formatter.format(endDate!)}';
    }
  }

  bool isInPeriod(DateTime date) {
    if (period == ChartPeriod.all) return true;

    return date.isAfter(startDate!) &&
        date.isBefore(endDate!.add(const Duration(days: 1)));
  }
}

class PeriodSelector extends StatelessWidget {
  final PeriodSelectorData currentPeriod;
  final Function(PeriodSelectorData) onPeriodChanged;

  const PeriodSelector({
    Key? key,
    required this.currentPeriod,
    required this.onPeriodChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => _showPeriodSelector(context),
      style: TextButton.styleFrom(
        backgroundColor: Colors.grey.withOpacity(0.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.date_range, size: 16),
          const SizedBox(width: 4),
          Text(currentPeriod.displayText),
          const SizedBox(width: 4),
          const Icon(Icons.arrow_drop_down, size: 16),
        ],
      ),
    );
  }

  void _showPeriodSelector(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Period'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildPeriodOption(context, PeriodSelectorData.all()),
            _buildPeriodOption(context, PeriodSelectorData.lastMonth()),
            _buildPeriodOption(context, PeriodSelectorData.lastWeek()),
            _buildCustomPeriodOption(context),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  Widget _buildPeriodOption(BuildContext context, PeriodSelectorData period) {
    final isSelected = currentPeriod.period == period.period;

    return ListTile(
      title: Text(period.displayText),
      selected: isSelected,
      leading: isSelected
          ? const Icon(Icons.check_circle, color: Colors.green)
          : const Icon(Icons.circle_outlined),
      onTap: () {
        Navigator.of(context).pop();
        onPeriodChanged(period);
      },
    );
  }

  Widget _buildCustomPeriodOption(BuildContext context) {
    final isSelected = currentPeriod.period == ChartPeriod.custom;

    return ListTile(
      title: const Text('Custom Range'),
      subtitle: isSelected ? Text(currentPeriod.displayText) : null,
      selected: isSelected,
      leading: isSelected
          ? const Icon(Icons.check_circle, color: Colors.green)
          : const Icon(Icons.circle_outlined),
      onTap: () async {
        final initialDateRange = DateTimeRange(
          start: currentPeriod.period == ChartPeriod.custom
              ? currentPeriod.startDate!
              : DateTime.now().subtract(const Duration(days: 30)),
          end: currentPeriod.period == ChartPeriod.custom
              ? currentPeriod.endDate!
              : DateTime.now(),
        );

        final isDarkMode = Theme.of(context).brightness == Brightness.dark;
        final primaryColor = Theme.of(context).primaryColor;
        final textColor = isDarkMode ? Colors.white : Colors.black87;
        final backgroundColor = isDarkMode
            ? Theme.of(context).colorScheme.surface
            : Theme.of(context).colorScheme.surface;

        final dateRange = await showDateRangePicker(
          context: context,
          initialDateRange: initialDateRange,
          firstDate: DateTime(2000),
          lastDate: DateTime.now(),
          builder: (context, child) {
            return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: Theme.of(context).colorScheme.copyWith(
                      primary: primaryColor,
                      onPrimary: Colors.white,
                      onSurface: textColor,
                      surface: backgroundColor,
                    ),
                dialogBackgroundColor: backgroundColor,
                textButtonTheme: TextButtonThemeData(
                  style: TextButton.styleFrom(
                    foregroundColor: primaryColor,
                  ),
                ),
                appBarTheme: AppBarTheme(
                  backgroundColor: isDarkMode
                      ? Theme.of(context).primaryColor.withOpacity(0.2)
                      : Theme.of(context).primaryColor.withOpacity(0.1),
                  iconTheme: IconThemeData(
                    color: textColor,
                  ),
                  titleTextStyle: TextStyle(
                    color: textColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              child: child!,
            );
          },
        );

        if (dateRange != null) {
          Navigator.of(context).pop();
          onPeriodChanged(PeriodSelectorData.custom(
            startDate: dateRange.start,
            endDate: dateRange.end,
          ));
        }
      },
    );
  }
}
