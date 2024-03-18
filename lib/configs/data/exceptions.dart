import 'package:get/get.dart';

class ConnectionException implements Exception {
  final String? message;
  ConnectionException([this.message]);

  @override
  String toString() {
    String? message = this.message;
    if (message == null) return 'error_network'.tr;
    return message;
  }
}

class ParseException implements Exception {
  final String? message;
  ParseException([this.message]);

  @override
  String toString() {
    String? message = this.message;
    if (message == null) return 'error_dataParse'.tr;
    return message;
  }
}

class NotFoundException implements Exception {
  final String? message;
  NotFoundException([this.message]);

  @override
  String toString() {
    String? message = this.message;
    if (message == null) return 'error_resourceNotFound'.tr;
    return message;
  }
}

class AuthorizationException implements Exception {
  final String? message;

  AuthorizationException([this.message]);

  @override
  String toString() {
    String? message = this.message;
    if (message == null) return 'error_unAuthorized'.tr;
    return message;
  }
}

class WrongCredentialsException implements Exception {}
