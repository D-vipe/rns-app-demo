import 'package:flutter/material.dart';
import 'package:rns_app/configs/theme/app_colors.dart';
import 'package:rns_app/configs/theme/app_text_styles.dart';

class AppTheme {
  static const _appDarkColors = AppDarkColors();

  static ThemeData lightTheme() => ThemeData(
        useMaterial3: true,
      );

  static ThemeData darkTheme() => ThemeData(
        useMaterial3: true,
        canvasColor: _appDarkColors.backgroundPrimary,
        colorScheme: ColorScheme(
          brightness: Brightness.dark,
          primary: _appDarkColors.main,
          onPrimary: _appDarkColors.backgroundPrimary,
          secondary: _appDarkColors.contrast,
          onSecondary: _appDarkColors.backgroundPrimary,
          error: _appDarkColors.error,
          onError: _appDarkColors.white,
          background: _appDarkColors.background,
          onBackground: _appDarkColors.main,
          surface: _appDarkColors.background,
          onSurface: _appDarkColors.white,
        ),
        dividerTheme: const DividerThemeData(color: Colors.transparent),
        scaffoldBackgroundColor: _appDarkColors.backgroundPrimary,
        textTheme: TextTheme(
          bodySmall: TextStyle(
            color: _appDarkColors.text.subtitle,
            fontSize: 12.0,
            fontFamily: 'Roboto',
          ),
          bodyMedium: TextStyle(
            color: _appDarkColors.text.main,
            fontSize: 14.0,
            fontFamily: 'Roboto',
          ),
          bodyLarge: TextStyle(
            color: _appDarkColors.text.main,
            fontSize: 20.0,
            fontFamily: 'Roboto',
          ),
          titleMedium: TextStyle(
            color: _appDarkColors.text.main,
            fontSize: 24.0,
            fontFamily: 'Roboto',
          ),
        ),
        datePickerTheme: DatePickerThemeData(
          surfaceTintColor: Colors.transparent,
          headerBackgroundColor: _appDarkColors.inputBackground,
          headerForegroundColor: _appDarkColors.text.main,
          backgroundColor: _appDarkColors.backgroundPrimary,

          dayForegroundColor: MaterialStateProperty.resolveWith(
            (states) => states.contains(MaterialState.selected)
                ? _appDarkColors.backgroundPrimary
                : states.contains(MaterialState.disabled)
                    ? _appDarkColors.inputBackground
                    : _appDarkColors.text.main,
          ),
          // rangePickerHeaderBackgroundColor: _appDarkColors.error,
          dayStyle: const TextStyle(
            fontFamily: 'Roboto',
            fontSize: 16,
          ),
          weekdayStyle: TextStyle(
            fontFamily: 'Roboto',
            fontSize: 16,
            color: _appDarkColors.text.subtitle,
          ),
        ),
        checkboxTheme: CheckboxThemeData(
            checkColor: MaterialStateProperty.resolveWith(
              (states) => _appDarkColors.black,
            ),
            side: BorderSide(width: 1.5, color: _appDarkColors.buttonActive),
            fillColor: MaterialStateProperty.resolveWith(
              (states) => states.contains(MaterialState.selected) ? _appDarkColors.buttonActive : Colors.transparent,
            ),
            visualDensity: VisualDensity.compact),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: _appDarkColors.inputBackground,
          labelStyle: TextStyle(
            fontSize: 14.0,
            color: _appDarkColors.text.subtitle,
            // height: 10.0,
          ),
          hintStyle: TextStyle(
            fontSize: 14.0,
            color: _appDarkColors.text.subtitle,
          ),
          floatingLabelStyle: TextStyle(
            fontSize: 14.0,
            height: 1,
            color: _appDarkColors.text.subtitle,
          ),
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          border: UnderlineInputBorder(
            borderSide: BorderSide(width: 1, color: _appDarkColors.background),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(4.0),
              topRight: Radius.circular(4.0),
            ),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(width: 1, color: _appDarkColors.background),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(4.0),
              topRight: Radius.circular(4.0),
            ),
          ),
          disabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(width: 1, color: _appDarkColors.background),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(4.0),
              topRight: Radius.circular(4.0),
            ),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(width: 1, color: _appDarkColors.main),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(4.0),
              topRight: Radius.circular(4.0),
            ),
          ),
        ),
        radioTheme: RadioThemeData(
          fillColor: MaterialStateProperty.resolveWith(
              (states) => states.contains(MaterialState.selected) ? _appDarkColors.buttonActive : null),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            minimumSize: const Size(
              double.infinity,
              36.0,
            ),
            visualDensity: VisualDensity.compact,
            surfaceTintColor: _appDarkColors.buttonActive,
            // maximumSize: const Size(double.infinity, 36.0),
            backgroundColor: _appDarkColors.buttonActive,
            side: const BorderSide(color: Colors.transparent, width: 1),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(4),
              ),
            ),
          ),
        ),
        drawerTheme: DrawerThemeData(
          backgroundColor: _appDarkColors.backgroundPrimary,
          surfaceTintColor: _appDarkColors.backgroundPrimary,
          scrimColor: Colors.black.withOpacity(.6),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(0),
              bottomRight: Radius.circular(0),
            ),
          ),
        ),
        scrollbarTheme: ScrollbarThemeData(
          thickness: MaterialStateProperty.resolveWith(
            (states) => 4.0,
          ),
          thumbColor: MaterialStateProperty.resolveWith(
            (states) => _appDarkColors.main,
          ),
          radius: const Radius.circular(2.0),
        ),
        switchTheme: SwitchThemeData(
          thumbColor: MaterialStateProperty.resolveWith(
            (states) => states.contains(MaterialState.selected) ? _appDarkColors.buttonActive : _appDarkColors.main,
          ),
          trackColor: MaterialStateProperty.resolveWith(
            (states) => states.contains(MaterialState.selected)
                ? _appDarkColors.buttonActive.withOpacity(.6)
                : _appDarkColors.inputBackground,
          ),
          trackOutlineColor: MaterialStateProperty.resolveWith(
            (states) => states.contains(MaterialState.selected) ? null : _appDarkColors.inputBackground,
          ),
        ),
        tabBarTheme: TabBarTheme(
          dividerColor: Colors.transparent,
          labelColor: _appDarkColors.main,
          unselectedLabelColor: _appDarkColors.background,
          indicatorSize: TabBarIndicatorSize.tab,
          labelStyle: const TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500),
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(backgroundColor: _appDarkColors.buttonActive),
        extensions: [
          AppTextStyles(_appDarkColors),
          _appDarkColors,
        ],
      );
}
