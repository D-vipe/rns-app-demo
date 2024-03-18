import 'dart:convert';

import 'package:rns_app/app/dependency/api_module.dart';
import 'package:rns_app/app/features/authentication/data/converters/bearer_token_converter.dart';
import 'package:rns_app/app/features/authentication/data/dto/bearer_token_dto.dart';
import 'package:rns_app/app/features/authentication/data/requests/login_body.dart';
import 'package:rns_app/app/features/authentication/domain/models/bearer_token_model.dart';
import 'package:rns_app/app/utils/hive_service.dart';
import 'package:rns_app/app/utils/shared_preferences.dart';
import 'package:rns_app/configs/data/exceptions.dart';

class AuthRepository {
  final _service = ApiModule.authService();

  Future<bool> auth({required String login, required String password}) async {
    bool result = false;
    try {
      final BearerTokenDTO? tokenDTO = await _service.auth(
        LoginBody(login: login, password: password),
      );
      if (tokenDTO != null) {
        final BearerToken token = BearerTokenConverter.convertDTO(tokenDTO);

        // Конвертируем данные и сохраним в SharedStorage
        await SharedStorageService.setString(PreferenceKey.bearerToken, jsonEncode(token.toJson()));

        result = true;
      }
    } on WrongCredentialsException catch (_) {
      result = false;
    } catch (_) {
      rethrow;
    }

    return result;
  }

  Future<bool> isUserAuthenticated() async {
    bool isAuthed = false;
    final String tokenData = SharedStorageService.getString(PreferenceKey.bearerToken);

    if (tokenData.isNotEmpty) {
      try {
        final BearerToken token = BearerToken.fromJson(json.decode(tokenData));

        final DateTime _now = DateTime.now();
        isAuthed = _now.isBefore(token.expDate);
        if (!isAuthed) {
          // очистим данные о пользователе
          await HiveService.clearUser();

          // Очистим storage
          await SharedStorageService.clear();
        }
      } catch (_) {
        print('ERROR PARSING SAVED TOKEN DATA');
      }
    }

    return isAuthed;
  }
}
