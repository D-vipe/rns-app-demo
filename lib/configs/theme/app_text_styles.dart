import 'package:flutter/material.dart';
import 'package:rns_app/configs/theme/app_colors.dart';

class AppTextStyles extends BaseAppTextStyles {
  AppTextStyles(AppColors colors)
      : super(
          header1: TextStyle(
            color: colors.text.main,
            fontSize: 20.0,
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w500,
            height: 24.0 / 20.0,
            letterSpacing: 0.15,
          ),
          header2: TextStyle(
            color: colors.text.main,
            fontSize: 16.0,
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w500,
            height: 18.75 / 16.0,
            letterSpacing: 0.15,
          ),
          header3: TextStyle(
            color: colors.text.main,
            fontSize: 16.0,
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w400,
            height: 18.75 / 16.0,
            letterSpacing: 0.15,
          ),
          subtitleSmall: TextStyle(
            color: colors.text.subtitle,
            fontSize: 12.0,
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w400,
            height: 11.72 / 10.0,
            letterSpacing: 0.015,
          ),
          subtitle: TextStyle(
            color: colors.text.subtitle,
            fontSize: 14.0,
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w400,
            height: 20.0 / 14.0,
            letterSpacing: 0.25,
          ),
          error: TextStyle(
            color: colors.error,
            fontSize: 14.0,
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w400,
            height: 20.0 / 14.0,
            letterSpacing: 0.25,
          ),
          bodyBoldOnSurface: TextStyle(
            color: colors.text.subtitle,
            fontSize: 14.0,
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w500,
            height: 24.0 / 14.0,
            letterSpacing: 0.1,
          ),
          bodyBold: TextStyle(
            color: colors.text.main,
            fontSize: 14.0,
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w500,
            height: 24.0 / 14.0,
            letterSpacing: 0.1,
          ),
          body: TextStyle(
            color: colors.text.main,
            fontSize: 14.0,
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w400,
            height: 19.0 / 14.0,
            letterSpacing: 0.0025,
          ),
          button: TextStyle(
            color: colors.text.onPrimary,
            fontSize: 14.0,
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w500,
            letterSpacing: 0.1,
          ),
          labelContrast: TextStyle(
            color: colors.contrast,
            fontSize: 12.0,
            fontFamily: 'Roboto Mono',
            fontWeight: FontWeight.w500,
            height: 14.4 / 12.0,
            letterSpacing: 0.16,
          ),
        );
}

class BaseAppTextStyles extends ThemeExtension<BaseAppTextStyles> {
  const BaseAppTextStyles({
    required this.header1,
    required this.header2,
    required this.header3,
    required this.subtitleSmall,
    required this.subtitle,
    required this.error,
    required this.bodyBold,
    required this.body,
    required this.button,
    required this.labelContrast,
    required this.bodyBoldOnSurface,
  });

  final TextStyle header1;
  final TextStyle header2;
  final TextStyle header3;
  final TextStyle subtitleSmall;
  final TextStyle subtitle;
  final TextStyle error;
  final TextStyle bodyBold;
  final TextStyle body;
  final TextStyle button;
  final TextStyle labelContrast;
  final TextStyle bodyBoldOnSurface;

  @override
  ThemeExtension<BaseAppTextStyles> copyWith({
    final TextStyle? header1,
    final TextStyle? header2,
    final TextStyle? header3,
    final TextStyle? subtitleSmall,
    final TextStyle? subtitle,
    final TextStyle? error,
    final TextStyle? bodyBold,
    final TextStyle? body,
    final TextStyle? button,
    final TextStyle? labelContrast,
    final TextStyle? bodyBoldOnSurface,
  }) {
    return BaseAppTextStyles(
      header1: header1 ?? this.header1,
      header2: header2 ?? this.header2,
      header3: header3 ?? this.header3,
      subtitleSmall: subtitleSmall ?? this.subtitleSmall,
      subtitle: subtitle ?? this.subtitle,
      error: error ?? this.error,
      bodyBold: bodyBold ?? this.bodyBold,
      body: body ?? this.body,
      button: button ?? this.button,
      labelContrast: labelContrast ?? this.labelContrast,
      bodyBoldOnSurface: bodyBoldOnSurface ?? this.bodyBoldOnSurface,
    );
  }

  @override
  BaseAppTextStyles lerp(ThemeExtension<BaseAppTextStyles>? other, double t) {
    if (other is! AppTextStyles) {
      return this;
    }
    return BaseAppTextStyles(
      header1: TextStyle.lerp(header1, other.header1, t)!,
      header2: TextStyle.lerp(header2, other.header2, t)!,
      header3: TextStyle.lerp(header3, other.header3, t)!,
      subtitleSmall: TextStyle.lerp(subtitleSmall, other.subtitleSmall, t)!,
      subtitle: TextStyle.lerp(subtitle, other.subtitle, t)!,
      error: TextStyle.lerp(error, other.error, t)!,
      bodyBold: TextStyle.lerp(bodyBold, other.bodyBold, t)!,
      body: TextStyle.lerp(body, other.body, t)!,
      button: TextStyle.lerp(button, other.button, t)!,
      labelContrast: TextStyle.lerp(labelContrast, other.labelContrast, t)!,
      bodyBoldOnSurface: TextStyle.lerp(bodyBoldOnSurface, other.bodyBoldOnSurface, t)!,
    );
  }
}
