import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rns_app/app/dependency/repository_module.dart';
import 'package:rns_app/app/utils/extensions.dart';
import 'package:rns_app/app/utils/snackbar_service.dart';
import 'package:rns_app/configs/routes/app_pages.dart';

enum LoginInput { login, password }

class AuthController extends GetxController {
  final _repository = RepositoryModule.authRepository();

  final RxBool isLoading = true.obs;
  final RxBool processingForm = false.obs;
  final RxBool isAuthenticated = false.obs;
  final RxBool isError = false.obs;
  final RxString generalError = ''.obs;
  String errorMessage = '';
  RxString loginError = ''.obs;
  RxString passwordError = ''.obs;

  late TextEditingController login;
  late TextEditingController password;
  late FocusNode loginFN;
  late FocusNode passwordFN;

  @override
  void onInit() {
    login = TextEditingController()
      ..addListener(
        () => _resetInputError(LoginInput.login),
      );
    password = TextEditingController()
      ..addListener(
        () => _resetInputError(LoginInput.password),
      );
    loginFN = FocusNode();
    passwordFN = FocusNode();
    super.onInit();
  }

  @override
  void onReady() {
    _checkAuth();
  }

  @override
  void onClose() {
    login.dispose();
    password.dispose();
    loginFN.dispose();
    passwordFN.dispose();
    super.onClose();
  }

  Future<void> _checkAuth() async {
    // Подержим немного, чтобы не было скачка
    await Future.delayed(const Duration(milliseconds: 1000));
    final bool isAuthenticated = await _repository.isUserAuthenticated();

    if (isAuthenticated) {
      Get.offNamed(Routes.DASHBOARD);
    }

    isLoading.value = false;
  }

  Future<void> processAuth() async {
    processingForm.value = true;
    if (loginFN.hasFocus) loginFN.unfocus();
    if (passwordFN.hasFocus) passwordFN.unfocus();
    if (_validateFormFields()) {
      try {
        final bool result = await _repository.auth(login: login.text, password: password.text);

        if (result) {
          Get.offNamed(Routes.DASHBOARD);
        } else {
          generalError.value = 'error_auth'.tr;
        }
      } catch (e) {
        final String exceptionError = e.toString().cleanException();
        SnackbarService.error(exceptionError, modifyPosition: false, duration: 15);
      }
    }
    processingForm.value = false;
  }

  bool _validateFormFields() {
    bool isValid = true;
    if (login.text.isEmpty) {
      loginError.value = 'error_fillLogin'.tr;
      isValid = false;
    }
    if (password.text.isEmpty) {
      passwordError.value = 'error_fillPassword'.tr;
      isValid = false;
    }

    if (isValid) {
      loginError.value = '';
      passwordError.value = '';
    }

    return isValid;
  }

  void _resetInputError(LoginInput type) {
    switch (type) {
      case LoginInput.login:
        if (loginError.value != '') {
          loginError.value = '';
        }
        break;
      case LoginInput.password:
        if (passwordError.value != '') {
          passwordError.value = '';
        }
        break;
    }

    if (generalError.value != '') {
      generalError.value = '';
    }
  }
}
