import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:rns_app/app/features/authentication/domain/models/bearer_token_model.dart';
import 'package:rns_app/app/utils/shared_preferences.dart';

class DioSettings {
  static const String baseUrl = 'http://05.runetsoft.ru/RnsWebMobileApiNew_develop';
  // static const String baseUrl = 'https://office.runetsoft.ru/RNSWebApiNew20240222';

  final BaseOptions _dioBaseOptions = BaseOptions(
    baseUrl: baseUrl,
    connectTimeout: const Duration(seconds: 60),
    followRedirects: true,
    maxRedirects: 10,
    validateStatus: (status) {
      return status != null && status <= 500;
    },
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    },
  );

  static Dio createDio({Duration connectTimeout = const Duration(seconds: 60), bool useBaseUrl = true}) {
    Dio dio = Dio(
      DioSettings()._getDioBaseOptions(connectTimeout: connectTimeout, useBaseUrl: useBaseUrl),
    );

    dio.interceptors.add(
      QueuedInterceptorsWrapper(
        onRequest: (options, handler) async {
          String token = SharedStorageService.getString(PreferenceKey.bearerToken);
          if (token.isNotEmpty) {
            final Map<String, dynamic> tokenJson = json.decode(token);
            final BearerToken bearerToken = BearerToken.fromJson(tokenJson);
            options.headers['Authorization'] = 'Bearer ${bearerToken.data}';
          }

          handler.next(options);
        },
      ),
    );

    // if (kDebugMode) {
    //   dio.interceptors.add(
    //     PrettyDioLogger(requestHeader: true, requestBody: true),
    //   );
    // }

    return dio;
  }

  BaseOptions _getDioBaseOptions({Duration connectTimeout = const Duration(seconds: 60), required bool useBaseUrl}) {
    var options = _dioBaseOptions;

    if (useBaseUrl == false) {
      options.copyWith(baseUrl: '');
    }

    options.connectTimeout = connectTimeout;
    options.receiveTimeout = connectTimeout;
    return options;
  }
}
