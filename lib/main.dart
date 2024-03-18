import 'dart:isolate';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:rns_app/app/application.dart';
import 'package:rns_app/app/features/general/domain/utils/fcm_util.dart';
import 'package:rns_app/app/utils/hive_service.dart';
import 'package:rns_app/app/utils/shared_preferences.dart';
import 'package:rns_app/firebase_options.dart';

void main() async {
  final binding = WidgetsFlutterBinding.ensureInitialized();

// Необходимо для отображения splash_screen до тех пор, пока это необходимо
  binding.deferFirstFrame();

// Загрузим заранее все необходимые картинки, чтобы избежать лишних "скачков"
  binding.addPostFrameCallback((_) async {

    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    FlutterError.onError = (errorDetails) {
      FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
    };
    // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };

    // Отлов ошибок вне среды Flutter
    Isolate.current.addErrorListener(
      RawReceivePort((pair) async {
        final List<dynamic> errorAndStacktrace = pair;
        await FirebaseCrashlytics.instance.recordError(
          errorAndStacktrace.first,
          errorAndStacktrace.last,
          fatal: true,
        );
      }).sendPort,
    );

    binding.allowFirstFrame();
  });

  await FCMUtil.init();
  await SharedStorageService.init();
  await HiveService.init();

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  // Необходимо для форматирования дат
  initializeDateFormatting('ru_RU');

  runApp(const Application());
}
