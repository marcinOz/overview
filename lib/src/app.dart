import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:overview/src/features/dashboard/dashboard_view.dart';
import 'package:overview/src/features/login/login_view.dart';
import 'package:overview/src/features/splash/splash_view.dart';
import 'package:overview/src/github/github_service.dart';
import 'package:styleguide/styleguide.dart';

import 'features/settings/settings_controller.dart';
import 'features/settings/settings_view.dart';
import 'injectable/injectable.dart';

/// The Widget that configures your application.
class MyApp extends StatefulWidget {
  const MyApp({
    Key? key,
    required this.settingsController,
  }) : super(key: key);

  final SettingsController settingsController;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    // Glue the SettingsController to the MaterialApp.
    //
    // The AnimatedBuilder Widget listens to the SettingsController for changes.
    // Whenever the user updates their settings, the MaterialApp is rebuilt.
    return AnimatedBuilder(
      animation: widget.settingsController,
      builder: (BuildContext context, Widget? child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          // Providing a restorationScopeId allows the Navigator built by the
          // MaterialApp to restore the navigation stack when a user leaves and
          // returns to the app after it has been killed while running in the
          // background.
          restorationScopeId: 'app',

          // Provide the generated AppLocalizations to the MaterialApp. This
          // allows descendant Widgets to display the correct translations
          // depending on the user's locale.
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en', ''), // English, no country code
          ],
          onGenerateTitle: (BuildContext context) =>
              AppLocalizations.of(context)!.appTitle,
          theme: AppThemeData.light().get(),
          darkTheme: AppThemeData.dark().get(),
          themeMode: widget.settingsController.themeMode,

          // Define a function to handle named routes in order to support
          // Flutter web url navigation and deep linking.
          onGenerateRoute: (RouteSettings routeSettings) {
            return MaterialPageRoute<void>(
              settings: routeSettings,
              builder: (BuildContext context) {
                switch (routeSettings.name) {
                  case SplashView.routeName:
                    return const SplashView();
                  case LoginView.routeName:
                    return const LoginView();
                  case SettingsView.routeName:
                    return SettingsView(controller: widget.settingsController);
                  case DashboardView.routeName:
                    return const DashboardView();
                  default:
                    return const SplashView();
                }
              },
            );
          },
        );
      },
    );
  }

  @override
  void dispose() {
    getIt.get<GithubService>().dispose();
    super.dispose();
  }
}
