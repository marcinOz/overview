import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:overview/src/features/dashboard/avg/avg_cubit.dart';

@Injectable()
class AvgPrLeadTimeCubit extends Cubit<AvgState> {
  AvgPrLeadTimeCubit(this._avgCubit) : super(const AvgState()) {
    _subscription = _avgCubit.stream.listen((event) {
      emit(event);
    });
  }

  final AvgCubit _avgCubit;
  late final StreamSubscription _subscription;

  @override
  Future<void> close() async => _subscription.cancel();
}
