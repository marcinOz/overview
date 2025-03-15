import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:overview/src/features/dashboard/avg/chart_parts/period_selector.dart';

@LazySingleton()
class ChartPeriodCubit extends Cubit<PeriodSelectorData> {
  ChartPeriodCubit() : super(PeriodSelectorData.all());

  void setPeriod(PeriodSelectorData period) {
    emit(period);
  }
}
