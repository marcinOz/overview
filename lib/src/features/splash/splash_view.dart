import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:overview/src/features/dashboard/dashboard_view.dart';
import 'package:overview/src/features/login/login_view.dart';
import 'package:overview/src/features/splash/splash_cubit.dart';
import 'package:overview/src/injectable/injectable.dart';
import 'package:styleguide/styleguide.dart';

class SplashView extends StatefulWidget {
  const SplashView({Key? key}) : super(key: key);

  static const routeName = '/';

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  late SplashCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = getIt.get();
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => BlocListener<SplashCubit, SplashState>(
        bloc: _cubit,
        listener: (context, state) {
          Navigator.pushReplacementNamed(
            context,
            state is SplashAuthenticatedState
                ? DashboardView.routeName
                : LoginView.routeName,
          );
        },
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset('assets/images/flutter_logo.png'),
              const SizedBox(height: Dimensions.paddingM),
              const CircularProgressIndicator(),
            ],
          ),
        ),
      );
}
