import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rns_app/app/uikit/dialogs/snack_message.dart';
import 'package:rns_app/app/utils/extensions.dart';
import 'package:rns_app/configs/theme/app_colors.dart';
import 'package:rns_app/resources/resources.dart';

class SnackbarService {
  static const _appDarkColors = AppDarkColors();

  static void success(
    String message, {
    int? duration,
    bool modifyPosition = true,
    RxBool? snackDebounce,
  }) {
    Get.closeCurrentSnackbar();
    Get.snackbar(
      '',
      '',
      titleText: const SizedBox.shrink(),
      messageText: SnackBarMessage(
        message: message,
        iconAsset: AppIcons.successIcon,
      ),
      snackPosition: SnackPosition.TOP,
      backgroundColor: Get.context!.colors.success,
      colorText: _appDarkColors.white,
      margin: modifyPosition ? const EdgeInsets.only(top: 56.0) : EdgeInsets.zero,
      padding: EdgeInsets.zero,
      duration: Duration(seconds: duration ?? 5),
      borderRadius: 4.0,
      snackStyle: SnackStyle.FLOATING,
      snackbarStatus: (status) {
        if (status == SnackbarStatus.CLOSED && snackDebounce != null) {
          snackDebounce.value = false;
        }
      },
    );
  }

  static void error(
    String message, {
    int? duration,
    bool modifyPosition = true,
    RxBool? snackDebounce,
  }) {
    Get.closeCurrentSnackbar();
    Get.snackbar(
      '',
      '',
      titleText: const SizedBox.shrink(),
      messageText: SnackBarMessage(
        message: message,
        iconAsset: AppIcons.infoIcon,
      ),
      snackPosition: SnackPosition.TOP,
      backgroundColor: Get.context!.colors.error,
      colorText: _appDarkColors.white,
      margin: modifyPosition ? const EdgeInsets.only(top: 56.0) : EdgeInsets.zero,
      padding: EdgeInsets.zero,
      duration: Duration(seconds: duration ?? 5),
      borderRadius: 4.0,
      snackStyle: SnackStyle.FLOATING,
      snackbarStatus: (status) {
        if (status == SnackbarStatus.CLOSED && snackDebounce != null) {
          snackDebounce.value = false;
        }
      },
    );
  }

  static void info(
    String message, {
    int? duration,
    bool modifyPosition = true,
    RxBool? snackDebounce,
  }) {
    Get.closeCurrentSnackbar();
    Get.snackbar(
      '',
      '',
      titleText: const SizedBox.shrink(),
      messageText: SnackBarMessage(
        message: message,
        iconAsset: AppIcons.infoIcon,
      ),
      snackPosition: SnackPosition.TOP,
      backgroundColor: Get.context!.colors.info,
      colorText: _appDarkColors.white,
      margin: modifyPosition ? const EdgeInsets.only(top: 56.0) : EdgeInsets.zero,
      padding: EdgeInsets.zero,
      duration: Duration(seconds: duration ?? 5),
      borderRadius: 4.0,
      snackStyle: SnackStyle.FLOATING,
      snackbarStatus: (status) {
        if (status == SnackbarStatus.CLOSED && snackDebounce != null) {
          snackDebounce.value = false;
        }
      },
    );
  }

  static void warning(String message, {int? duration, bool modifyPosition = true, RxBool? snackDebounce}) {
    Get.closeCurrentSnackbar();
    Get.snackbar(
      '',
      '',
      titleText: const SizedBox.shrink(),
      messageText: SnackBarMessage(
        message: message,
        iconAsset: AppIcons.warninigIcon,
      ),
      snackPosition: SnackPosition.TOP,
      backgroundColor: Get.context!.colors.warning,
      colorText: _appDarkColors.white,
      margin: modifyPosition ? const EdgeInsets.only(top: 56.0) : EdgeInsets.zero,
      padding: EdgeInsets.zero,
      duration: Duration(seconds: duration ?? 5),
      borderRadius: 4.0,
      snackStyle: SnackStyle.FLOATING,
      snackbarStatus: (status) {
        if (status == SnackbarStatus.CLOSED && snackDebounce != null) {
          snackDebounce.value = false;
        }
      },
    );
  }

  static void uploadProgress(Widget body, {bool modifyPosition = true, RxBool? snackDebounce}) {
    Get.closeCurrentSnackbar();
    Get.snackbar(
      '',
      '',
      titleText: const SizedBox.shrink(),
      messageText: body,
      snackPosition: SnackPosition.TOP,
      backgroundColor: Get.context!.colors.inputBackground,
      colorText: _appDarkColors.white,
      margin: modifyPosition ? const EdgeInsets.only(top: 56.0) : EdgeInsets.zero,
      padding: EdgeInsets.zero,
      duration: const Duration(minutes: 10),
      borderRadius: 4.0,
      // isDismissible: false,
      snackStyle: SnackStyle.FLOATING,
      snackbarStatus: (status) {
        if (status == SnackbarStatus.CLOSED && snackDebounce != null) {
          snackDebounce.value = false;
        }
      },
    );
  }
}
