import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:overview/src/features/dashboard/dashboard_view.dart';
import 'package:overview/src/features/login/login_cubit.dart';
import 'package:overview/src/injectable/injectable.dart';
import 'package:overview/src/localization/localizations.dart';
import 'package:styleguide/styleguide.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  static const routeName = '/login';

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late LoginCubit _cubit;

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
  Widget build(BuildContext context) => Scaffold(
        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 300),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _tokenTextField(context),
                const SizedBox(height: Dimensions.paddingM),
                BlocConsumer<LoginCubit, LoginState>(
                  bloc: _cubit,
                  listener: (context, state) {
                    if (state.success) {
                      Navigator.pushReplacementNamed(
                        context,
                        DashboardView.routeName,
                      );
                    }
                    if (state.error != null) {
                      showErrorDialog(context, state.error!);
                    }
                  },
                  builder: (context, state) => _signInButton(context),
                ),
              ],
            ),
          ),
        ),
      );

  TextField _tokenTextField(BuildContext context) {
    return TextField(
      obscureText: true,
      enableSuggestions: false,
      autocorrect: false,
      decoration: InputDecoration(
        label: Text(context.loc().token),
      ),
      onChanged: (value) {
        _cubit.tokenChanged(value);
      },
    );
  }

  Widget _signInButton(BuildContext context) => LoadingButton(
        isLoading: _cubit.state.isLoading,
        onClick: _cubit.login,
        text: context.loc().signIn,
      );
}
