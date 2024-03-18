import 'package:flutter/material.dart';
import 'package:rns_app/configs/data/exceptions.dart';
import 'package:rns_app/configs/theme/app_colors.dart';
import 'package:rns_app/configs/theme/app_text_styles.dart';

extension CustomHelpers on String {
  String cleanException() {
    return replaceAll('Exception:', '').trim();
  }

  String convertStringDate() {
    final List<String> digits = split('.');
    if (digits.length < 3) {
      throw ParseException();
    } else {
      return '${digits[2]}-${digits[1]}-${digits[0]}';
    }
  }
}

extension ThemePicker on BuildContext {
  AppColors get colors => Theme.of(this).extension<AppColors>()!;
  BaseAppTextStyles get textStyles => Theme.of(this).extension<BaseAppTextStyles>()!;
}
