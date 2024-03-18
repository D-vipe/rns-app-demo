import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rns_app/app/uikit/dialogs/app_confirm_dialog.dart';
import 'package:rns_app/configs/routes/app_pages.dart';

class RootController extends GetxController {
  static RootController get to => Get.find();

  // Небольшой костыль. Используем это, чтобы обновлять WillPopScope у Dashboard
  final RxString initialRoute = Routes.AUTH.obs;
  final RxBool rootCanPop = false.obs;

  Future<void> onWillPop(bool didPop) async {
    if (didPop) return;
    Get.log('ROOT CONTROLLER CURRENT ROUTE: ${Get.currentRoute}');

    await _quitDialog().then((value) {
      if (value) {
        rootCanPop.value = true;
      }
    });
  }

  Future<bool> _quitDialog() async {
    final bool res = await Get.dialog(
      AppConfirmDialog(
        height: 250,
        message: 'message_confirmQuit'.tr,
        confirmLabel: 'button_yes'.tr,
        cancelLabel: 'button_cancel'.tr,
      ),
      barrierColor: Colors.black.withOpacity(.6),
    );

    return res;
  }
}
