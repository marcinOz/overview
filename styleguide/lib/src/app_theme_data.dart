import 'package:flutter/material.dart';
import 'package:styleguide/src/app_colors.dart';

@immutable
class AppThemeData {
  const AppThemeData(this._isDark);

  factory AppThemeData.light() => const AppThemeData(false);

  factory AppThemeData.dark() => const AppThemeData(true);

  final bool _isDark;

  ThemeData get() {
    final isLight = !_isDark;

    return ThemeData(
      useMaterial3: true,
      brightness: _isDark ? Brightness.dark : Brightness.light,
      primaryColor: AppColors.primary,
      colorScheme: ColorScheme(
        brightness: _isDark ? Brightness.dark : Brightness.light,
        primary: AppColors.primary,
        onPrimary: Colors.white,
        secondary: AppColors.secondary,
        onSecondary: Colors.white,
        error: AppColors.error,
        onError: Colors.white,
        background:
            isLight ? AppColors.lightBackground : AppColors.darkBackground,
        onBackground:
            isLight ? AppColors.lightTextPrimary : AppColors.darkTextPrimary,
        surface: isLight ? AppColors.lightSurface : AppColors.darkSurface,
        onSurface:
            isLight ? AppColors.lightTextPrimary : AppColors.darkTextPrimary,
      ),
      scaffoldBackgroundColor:
          isLight ? AppColors.lightBackground : AppColors.darkBackground,
      cardColor: isLight ? AppColors.lightSurface : AppColors.darkSurface,
      dividerColor: isLight
          ? AppColors.lightTextSecondary.withOpacity(0.2)
          : AppColors.darkTextSecondary.withOpacity(0.2),

      // Date Picker Theme
      datePickerTheme: DatePickerThemeData(
        backgroundColor:
            isLight ? AppColors.lightSurface : AppColors.darkSurface,
        headerBackgroundColor: isLight
            ? AppColors.primary.withOpacity(0.08)
            : AppColors.primary.withOpacity(0.2),
        headerForegroundColor: isLight ? AppColors.primary : Colors.white,
        dayBackgroundColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return AppColors.primary;
          } else if (states.contains(MaterialState.disabled)) {
            return isLight ? Colors.grey.shade200 : Colors.grey.shade800;
          }
          return null;
        }),
        dayForegroundColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return Colors.white;
          } else if (states.contains(MaterialState.disabled)) {
            return isLight ? Colors.grey.shade400 : Colors.grey.shade600;
          }
          return isLight
              ? AppColors.lightTextPrimary
              : AppColors.darkTextPrimary;
        }),
        todayBackgroundColor: MaterialStateProperty.resolveWith((_) => isLight
            ? AppColors.primary.withOpacity(0.1)
            : AppColors.primary.withOpacity(0.3)),
        todayForegroundColor: MaterialStateProperty.resolveWith(
            (_) => isLight ? AppColors.primary : Colors.white),
        yearBackgroundColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return AppColors.primary;
          }
          return null;
        }),
        yearForegroundColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return Colors.white;
          }
          return isLight
              ? AppColors.lightTextPrimary
              : AppColors.darkTextPrimary;
        }),
        surfaceTintColor: Colors.transparent,
        dayStyle: const TextStyle(fontWeight: FontWeight.normal),
        yearStyle: const TextStyle(fontWeight: FontWeight.normal),
      ),

      // Icon Theme for Date Picker
      iconTheme: IconThemeData(
        color: isLight ? AppColors.lightTextPrimary : AppColors.darkTextPrimary,
      ),

      // Calendar specific icons and text
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: isLight ? AppColors.primary : Colors.white,
        ),
      ),

      // Dialog Theme (affects date picker dialog)
      dialogTheme: DialogTheme(
        backgroundColor:
            isLight ? AppColors.lightSurface : AppColors.darkSurface,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color:
              isLight ? AppColors.lightTextPrimary : AppColors.darkTextPrimary,
        ),
        contentTextStyle: TextStyle(
          fontSize: 16,
          color:
              isLight ? AppColors.lightTextPrimary : AppColors.darkTextPrimary,
        ),
      ),

      // For date range selector actions
      buttonTheme: ButtonThemeData(
        colorScheme: ColorScheme(
          brightness: _isDark ? Brightness.dark : Brightness.light,
          primary: AppColors.primary,
          onPrimary: Colors.white,
          secondary: AppColors.secondary,
          onSecondary: Colors.white,
          error: AppColors.error,
          onError: Colors.white,
          background:
              isLight ? AppColors.lightBackground : AppColors.darkBackground,
          onBackground:
              isLight ? AppColors.lightTextPrimary : AppColors.darkTextPrimary,
          surface: isLight ? AppColors.lightSurface : AppColors.darkSurface,
          onSurface:
              isLight ? AppColors.lightTextPrimary : AppColors.darkTextPrimary,
        ),
        textTheme: ButtonTextTheme.primary,
      ),

      textTheme: TextTheme(
        headlineLarge: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 24,
          color:
              isLight ? AppColors.lightTextPrimary : AppColors.darkTextPrimary,
        ),
        headlineMedium: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,
          color:
              isLight ? AppColors.lightTextPrimary : AppColors.darkTextPrimary,
        ),
        headlineSmall: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18,
          color:
              isLight ? AppColors.lightTextPrimary : AppColors.darkTextPrimary,
        ),
        titleLarge: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 16,
          color:
              isLight ? AppColors.lightTextPrimary : AppColors.darkTextPrimary,
        ),
        titleMedium: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 14,
          color:
              isLight ? AppColors.lightTextPrimary : AppColors.darkTextPrimary,
        ),
        bodyLarge: TextStyle(
          fontWeight: FontWeight.normal,
          fontSize: 16,
          color:
              isLight ? AppColors.lightTextPrimary : AppColors.darkTextPrimary,
        ),
        bodyMedium: TextStyle(
          fontWeight: FontWeight.normal,
          fontSize: 14,
          color:
              isLight ? AppColors.lightTextPrimary : AppColors.darkTextPrimary,
        ),
        bodySmall: TextStyle(
          fontWeight: FontWeight.normal,
          fontSize: 12,
          color: isLight
              ? AppColors.lightTextSecondary
              : AppColors.darkTextSecondary,
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor:
            isLight ? AppColors.lightSurface : AppColors.darkSurface,
        foregroundColor:
            isLight ? AppColors.lightTextPrimary : AppColors.darkTextPrimary,
        elevation: 0,
      ),
      chipTheme: ChipThemeData(
        backgroundColor:
            isLight ? AppColors.lightBackground : AppColors.darkSurface,
        labelStyle: TextStyle(
          color:
              isLight ? AppColors.lightTextPrimary : AppColors.darkTextPrimary,
        ),
      ),
      cardTheme: CardTheme(
        color: isLight ? AppColors.lightSurface : AppColors.darkSurface,
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        fillColor:
            isLight ? AppColors.lightBackground : AppColors.darkBackground,
        filled: true,
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: isLight
                ? AppColors.lightTextSecondary.withOpacity(0.5)
                : AppColors.darkTextSecondary.withOpacity(0.5),
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: isLight
                ? AppColors.lightTextSecondary.withOpacity(0.5)
                : AppColors.darkTextSecondary.withOpacity(0.5),
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: AppColors.primary,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }
}

extension ThemeExt on BuildContext {
  Color primaryColor() => Theme.of(this).primaryColor;

  Color bgColor() => Theme.of(this).scaffoldBackgroundColor;

  TextStyle titleSmallTextStyle() => Theme.of(this).textTheme.titleSmall!;

  TextStyle bodyMediumTextStyle() => Theme.of(this).textTheme.bodyMedium!;
}

extension ThemeExtension on BuildContext {
  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => Theme.of(this).textTheme;
  ColorScheme get colorScheme => Theme.of(this).colorScheme;
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;
}
