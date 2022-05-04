import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:styleguide/src/app_colors.dart';
import 'package:styleguide/src/dimensions.dart';

@immutable
class AppThemeData {
  const AppThemeData(this._isDark);

  factory AppThemeData.light() => const AppThemeData(false);

  factory AppThemeData.dark() => const AppThemeData(true);

  final bool _isDark;

  ThemeData get() => ThemeData(
        brightness: _isDark ? Brightness.dark : Brightness.light,
        primaryColor: AppColors.primary,
        textTheme: textTheme(),
      );

  TextTheme textTheme() => const TextTheme(
        titleSmall: TextStyle(fontSize: Dimensions.textSizeM),
        bodyMedium: TextStyle(fontSize: Dimensions.textSizeS),
      );
}

extension ThemeExt on BuildContext {
  Color primaryColor() => Theme.of(this).primaryColor;

  TextStyle titleSmallTextStyle() => Theme.of(this).textTheme.titleSmall!;

  TextStyle bodyMediumTextStyle() => Theme.of(this).textTheme.bodyMedium!;
}
