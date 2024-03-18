import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:rns_app/configs/routes/app_pages.dart';
import 'package:rns_app/configs/theme/app_theme.dart';
import 'package:rns_app/generated/locales.g.dart';

class Application extends StatefulWidget {
  const Application({Key? key}) : super(key: key);

  @override
  State<Application> createState() => _ApplicationState();
}

class _ApplicationState extends State<Application> {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'RNS WEB',
      theme: AppTheme.darkTheme(),
      locale: const Locale('ru', 'RU'),
      localizationsDelegates: const [GlobalMaterialLocalizations.delegate],
      translationsKeys: AppTranslation.translations,
      fallbackLocale: const Locale('ru', 'RU'),
      initialRoute: Routes.ROOT,
      getPages: AppPages.routes,
      builder: (BuildContext context, Widget? child) =>
          ResponsiveBreakpoints.builder(
        child: child!,
        breakpoints: const [
          Breakpoint(start: 0, end: 400, name: MOBILE),
          Breakpoint(start: 401, end: 480, name: PHONE),
          Breakpoint(start: 481, end: 720, name: TABLET),
          Breakpoint(start: 721, end: 1920, name: DESKTOP),
        ],
      ),
    );
  }
}
