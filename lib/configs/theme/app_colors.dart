import 'package:flutter/material.dart';

class AppDarkColors extends AppColors {
  const AppDarkColors()
      : super(
          main: const Color.fromRGBO(146, 169, 184, 1),
          background: const Color.fromRGBO(73, 96, 111, 1),
          inputBackground: const Color.fromRGBO(37, 52, 62, 1),
          backgroundPrimary: const Color.fromRGBO(13, 30, 41, 1),
          white: const Color.fromRGBO(255, 255, 255, 1),
          black: const Color.fromRGBO(0, 0, 0, 1),
          buttonActive: const Color.fromRGBO(24, 90, 164, 1),
          contrast: const Color.fromRGBO(255, 168, 0, 1),
          error: const Color.fromRGBO(244, 67, 54, 1),
          tableDividerColor: const Color.fromRGBO(13, 30, 41, 1),
          warning: const Color.fromRGBO(255, 193, 7, 1),
          info: const Color.fromRGBO(33, 150, 243, 1),
          success: const Color.fromRGBO(76, 175, 80, 1),
          purple: const Color.fromRGBO(219, 0, 255, 0.87),
          text: const TextColors(
            main: Color.fromRGBO(146, 169, 184, 1),
            subtitle: Color.fromRGBO(73, 96, 111, 1),
            onPrimary: Color.fromRGBO(255, 255, 255, 1),
          ),
          importance: const ImportanceColors(
            low: Color.fromRGBO(0, 205, 8, .6),
            lowBg: Color.fromRGBO(0, 205, 8, .08),
            normal: Color.fromRGBO(5, 0, 255, .6),
            normalBg: Color.fromRGBO(5, 0, 255, .08),
            high: Color.fromRGBO(255, 0, 0, .6),
            highBg: Color.fromRGBO(255, 0, 0, .2),
          ),
        );
}

class AppColors extends ThemeExtension<AppColors> {
  const AppColors({
    required this.main,
    required this.background,
    required this.inputBackground,
    required this.backgroundPrimary,
    required this.white,
    required this.black,
    required this.buttonActive,
    required this.contrast,
    required this.error,
    required this.tableDividerColor,
    required this.warning,
    required this.success,
    required this.purple,
    required this.info,
    required this.text,
    required this.importance,
  });

  final Color main;
  final Color background;
  final Color inputBackground;
  final Color backgroundPrimary;
  final Color white;
  final Color black;
  final Color buttonActive;
  final Color contrast;
  final Color error;
  final Color tableDividerColor;
  final Color warning;
  final Color success;
  final Color purple;
  final Color info;
  final TextColors text;
  final ImportanceColors importance;

  @override
  ThemeExtension<AppColors> copyWith({
    final Color? main,
    final Color? background,
    final Color? inputBackground,
    final Color? backgroundPrimary,
    final Color? white,
    final Color? black,
    final Color? buttonActive,
    final Color? contrast,
    final Color? error,
    final Color? tableDividerColor,
    final Color? warning,
    final Color? success,
    final Color? purple,
    final Color? info,
    final TextColors? text,
    final ImportanceColors? importance,
  }) {
    return AppColors(
      main: main ?? this.main,
      background: background ?? this.background,
      inputBackground: inputBackground ?? this.inputBackground,
      backgroundPrimary: backgroundPrimary ?? this.backgroundPrimary,
      white: white ?? this.white,
      black: black ?? this.black,
      buttonActive: buttonActive ?? this.buttonActive,
      contrast: contrast ?? this.contrast,
      warning: warning ?? this.warning,
      success: success ?? this.success,
      purple: purple ?? this.purple,
      info: info ?? this.info,
      error: error ?? this.error,
      tableDividerColor: tableDividerColor ?? this.tableDividerColor,
      text: text ?? this.text,
      importance: importance ?? this.importance,
    );
  }

  @override
  AppColors lerp(ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) {
      return this;
    }
    return AppColors(
      main: Color.lerp(main, other.main, t)!,
      background: Color.lerp(background, other.background, t)!,
      inputBackground: Color.lerp(inputBackground, other.inputBackground, t)!,
      backgroundPrimary: Color.lerp(backgroundPrimary, other.backgroundPrimary, t)!,
      white: Color.lerp(white, other.white, t)!,
      black: Color.lerp(white, other.black, t)!,
      buttonActive: Color.lerp(buttonActive, other.buttonActive, t)!,
      contrast: Color.lerp(contrast, other.contrast, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      success: Color.lerp(success, other.success, t)!,
      purple: Color.lerp(purple, other.purple, t)!,
      info: Color.lerp(info, other.contrast, t)!,
      error: Color.lerp(error, other.error, t)!,
      tableDividerColor: Color.lerp(tableDividerColor, other.tableDividerColor, t)!,
      text: TextColors(
        main: Color.lerp(text.main, other.text.main, t)!,
        subtitle: Color.lerp(text.subtitle, other.text.subtitle, t)!,
        onPrimary: Color.lerp(text.onPrimary, other.text.onPrimary, t)!,
      ),
      importance: ImportanceColors(
        low: Color.lerp(importance.low, other.importance.low, t)!,
        lowBg: Color.lerp(importance.lowBg, other.importance.lowBg, t)!,
        normal: Color.lerp(importance.normal, other.importance.normal, t)!,
        normalBg: Color.lerp(importance.normalBg, other.importance.normalBg, t)!,
        high: Color.lerp(importance.high, other.importance.high, t)!,
        highBg: Color.lerp(importance.highBg, other.importance.highBg, t)!,
      ),
    );
  }
}

class TextColors {
  const TextColors({
    required this.main,
    required this.subtitle,
    required this.onPrimary,
  });

  final Color main;
  final Color subtitle;
  final Color onPrimary;
}

class ImportanceColors {
  const ImportanceColors({
    required this.low,
    required this.lowBg,
    required this.normal,
    required this.normalBg,
    required this.high,
    required this.highBg,
  });

  final Color low;
  final Color lowBg;
  final Color normal;
  final Color normalBg;
  final Color high;
  final Color highBg;
}
