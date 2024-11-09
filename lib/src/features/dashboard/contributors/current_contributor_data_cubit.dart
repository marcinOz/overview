import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@LazySingleton()
class CurrentContributorDataCubit extends Cubit<String> {
  CurrentContributorDataCubit() : super(initialContributors);

  static const String initialContributors = "all";
  set(String contributor) {
    emit(contributor);
  }
}