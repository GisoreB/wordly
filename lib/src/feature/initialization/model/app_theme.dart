import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:wordly/src/core/assets/generated/fonts.gen.dart';
import 'package:wordly/src/core/resources/resources.dart';
import 'package:wordly/src/core/utils/extensions/extensions.dart';
import 'package:wordly/src/feature/settings/model/change_color_result.dart';

/// {@template app_theme}
/// An immutable class that holds properties needed
/// to build a [ThemeData] for the app.
/// {@endtemplate}
@immutable
final class AppTheme with Diagnosticable {
  /// {@macro app_theme}
  AppTheme({
    required this.themeMode,
    required this.colorMode,
    this.otherColors,
  })  : lightTheme = ThemeData(
          brightness: Brightness.light,
          extensions: const [BackgroundCustomColors(background: Colors.white)],
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.white,
          ),
          colorSchemeSeed: colorMode == ColorMode.other ? otherColors?.$1 ?? AppColors.green : AppColors.green,
          fontFamily: FontFamily.nunito,
        ),
        darkTheme = ThemeData(
          brightness: Brightness.dark,
          extensions: const [BackgroundCustomColors(background: AppColors.darkBackground)],
          appBarTheme: const AppBarTheme(
            backgroundColor: AppColors.darkBackground,
            surfaceTintColor: AppColors.darkBackground,
          ),
          colorSchemeSeed: colorMode == ColorMode.other ? otherColors?.$1 ?? AppColors.green : AppColors.green,
          fontFamily: FontFamily.nunito,
        );

  /// The type of theme to use.
  final ThemeMode themeMode;

  /// The type of color mode to use.
  final ColorMode colorMode;

  /// Other colors for cells
  final (Color, Color, Color)? otherColors;

  /// The dark [ThemeData] for this [AppTheme].
  final ThemeData darkTheme;

  /// The light [ThemeData] for this [AppTheme].
  final ThemeData lightTheme;

  /// The default [AppTheme].
  static final defaultTheme = AppTheme(
    themeMode: ThemeMode.system,
    colorMode: ColorMode.casual,
  );

  /// The [ThemeData] for this [AppTheme].
  /// This is computed based on the [themeMode].
  ThemeData computeTheme() {
    switch (themeMode) {
      case ThemeMode.light:
        return lightTheme;
      case ThemeMode.dark:
        return darkTheme;
      case ThemeMode.system:
        return PlatformDispatcher.instance.platformBrightness == Brightness.dark ? darkTheme : lightTheme;
    }
  }

  bool isDarkTheme(BuildContext context) => context.theme.brightness == Brightness.dark;

  Color get correctColor => switch (colorMode) {
        ColorMode.casual => AppColors.green,
        ColorMode.highContrast => AppColors.orange,
        ColorMode.other => otherColors?.$1 ?? AppColors.green
      };

  Color get wrongSpotColor => switch (colorMode) {
        ColorMode.casual => AppColors.yellow,
        ColorMode.highContrast => AppColors.blue,
        ColorMode.other => otherColors?.$2 ?? AppColors.yellow
      };

  Color notInWordColor(BuildContext context) {
    final isDark = isDarkTheme(context);
    if (colorMode case ColorMode.casual || ColorMode.highContrast) {
      return isDark ? AppColors.tertiary : AppColors.grey;
    }
    return otherColors?.$3 ?? (isDark ? AppColors.tertiary : AppColors.grey);
  }

  Color unknownColor(BuildContext context) => isDarkTheme(context) ? AppColors.grey : AppColors.tertiary;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(EnumProperty<ThemeMode>('mode', themeMode))
      ..add(EnumProperty<ColorMode>('colorMode', colorMode))
      ..add(DiagnosticsProperty<ThemeData>('lightTheme', lightTheme))
      ..add(DiagnosticsProperty<ThemeData>('darkTheme', darkTheme));
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppTheme &&
          runtimeType == other.runtimeType &&
          themeMode == other.themeMode &&
          colorMode == other.colorMode &&
          otherColors == other.otherColors;

  @override
  int get hashCode => Object.hash(themeMode, colorMode, otherColors);

  AppTheme copyWith({
    ThemeMode? themeMode,
    ColorMode? colorMode,
    (Color, Color, Color)? otherColors,
  }) =>
      AppTheme(
        themeMode: themeMode ?? this.themeMode,
        colorMode: colorMode ?? this.colorMode,
        otherColors: otherColors ?? this.otherColors,
      );
}
