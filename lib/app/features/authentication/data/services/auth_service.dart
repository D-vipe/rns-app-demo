import 'package:dio/dio.dart';
import 'package:rns_app/app/features/authentication/data/dto/bearer_token_dto.dart';
import 'package:rns_app/app/features/authentication/data/requests/login_body.dart';
import 'package:rns_app/configs/data/dio_handler.dart';
import 'package:rns_app/configs/data/endpoints/api_endpoints.dart';
import 'package:rns_app/configs/data/exceptions.dart';

class AuthService {
  final Dio _dio;

  AuthService(this._dio);

  Future<BearerTokenDTO?> auth(LoginBody body) async {
    BearerTokenDTO? result;
    try {
      final Response response = await _dio.post(
        AuthEndpoints.login,
        options: Options(
          headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
          },
        ),
        data: body.toJson(),
      );
      if (DioHandler.checkResponse(response)) {
        if (response.data != null && response.data['error'] == null) {
          try {
            result = BearerTokenDTO.fromJson(response.data);
          } catch (_) {
            throw ParseException();
          }
        } else {
          throw Exception(response.data['error']);
        }
      }
    } catch (e) {
      if (e is DioException) {
        throw ConnectionException();
      } else {
        rethrow;
      }
    }

    return result;
  }
}
