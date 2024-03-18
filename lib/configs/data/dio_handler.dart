import 'package:dio/dio.dart';
import 'package:get/get_utils/get_utils.dart';

import 'package:rns_app/configs/data/exceptions.dart';

class DioHandler {
  static bool checkResponse(
    Response response,
  ) {
    switch (response.statusCode) {
      case 200:
      case 201:
      case 202:
      case 204:
        return true;
      case 302:
        throw AuthorizationException();
      case 400:
        if (response.data is Map) {
          if (response.data['error'] != null &&
              response.data['error'].toLowerCase() ==
                  'invalid username or password.') {
            throw WrongCredentialsException();
          } else {
            throw Exception('error_status400'.tr);
          }
        } else {
          throw Exception('error_status400'.tr);
        }
      case 401:
        throw AuthorizationException();
      case 404:
        throw NotFoundException();
      default:
        throw Exception(response.data is Map
            ? (response.data['error'] ?? 'error_network'.tr)
            : 'error_general'.tr);
    }
  }
}
