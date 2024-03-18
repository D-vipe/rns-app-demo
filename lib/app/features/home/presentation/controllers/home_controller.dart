import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:rns_app/app/dependency/repository_module.dart';
import 'package:rns_app/app/features/email/presentation/controllers/email_controller.dart';
import 'package:rns_app/app/features/home/domain/models/user_model.dart';
import 'package:rns_app/app/features/tasks/presentation/controllers/tasks_controller.dart';
import 'package:rns_app/app/features/timesheets/presentation/controllers/timesheets_controller.dart';
import 'package:rns_app/app/uikit/dialogs/app_confirm_dialog.dart';
import 'package:rns_app/app/utils/extensions.dart';
import 'package:rns_app/app/utils/hive_service.dart';
import 'package:rns_app/app/utils/shared_preferences.dart';
import 'package:rns_app/app/utils/snackbar_service.dart';
import 'package:rns_app/configs/data/exceptions.dart';
import 'package:rns_app/configs/routes/app_pages.dart';

class HomeController extends GetxController {
  static HomeController get to => Get.find();
  final RxBool rootCanPop = false.obs;

  final _repository = RepositoryModule.homeRepository();

  final String anchorRoute = Routes.DASHBOARD;

  final RxBool firstLoadUserData = false.obs;
  final RxBool refreshUserData = false.obs;

  final RxBool disableScroll = false.obs;
  bool loggingOutProcess = false;

  // Timer? debouncerScrollBody;
  final RxBool enableScrollBody = false.obs;

  final Rxn<Widget> topPinnedWidget = Rxn(null);
  final Rxn<Widget> floatingActionBtn = Rxn(null);

  double? widgetTop;
  double? widgetBottom;
  double? widgetLeft;
  double? widgetRight;

  final Rxn<User> userData = Rxn<User>(null);

  GetDelegate? _delegate;

  GetDelegate get delegate => _delegate!;

  final RxString currentRoot = Routes.HOME.obs;

  late ScrollController scrollController;

  @override
  void onInit() {
    scrollController = ScrollController();
    super.onInit();
  }

  @override
  void onReady() {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    _getUserInfo();
    super.onReady();
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }

  Future<void> _getUserInfo() async {
    if (userData.value != null) {
      refreshUserData.value = true;
      firstLoadUserData.value = false;
    } else {
      refreshUserData.value = false;
      firstLoadUserData.value = true;
    }

    try {
      userData.value = await _repository.getPersonalInfo();
      refreshUserData.value = false;
      firstLoadUserData.value = false;
    } on AuthorizationException catch (_) {
      await SharedStorageService.clear();
      userData.value = null;
      Get.offNamed(Routes.AUTH);
      if (!loggingOutProcess) {
        SnackbarService.error('error_unAuthorized'.tr, modifyPosition: false);
      }
    } catch (e) {
      final String errorMessage = e.toString().cleanException();
      Get.log(errorMessage, isError: true);
    }
  }

  void initDelegate(GetDelegate delegate) {
    _delegate ??= delegate;
  }

  void navigateTo(String route) {
    // ! Временное решение, пока не все разделы из нижнего меню доступны
    if (route == '') {
      SnackbarService.warning('Данный раздел временно недоступен');
      return;
    }

    if (route != currentRoot.value) {
      dropTopPinnedWidget();
      floatingActionBtn.value = null;
    }
    if (route.isNotEmpty && route != Routes.AUTH) {
      Get.back();
      // if (route == Routes.HOME) {
      //   enableScrollBody.value = false;
      // }

      enableScrollBody.value = false;
      currentRoot.value = route;
      _delegate?.toNamed(route);
    }

    if (route == Routes.AUTH) {
      _logout();
    }
  }

  Future<void> onWillPop(bool didPop) async {
    if (didPop) return;
    try {
      switch (currentRoot.value) {
        case Routes.HOME:
          await quitDialog().then((value) {
            if (value) {
              rootCanPop.value = true;
            }
          });
        case Routes.TS:
          TimeSheetController.to.onWillPop(didPop);
          break;
        case Routes.TASKS:
          TasksController.to.onWillPop(didPop);
          break;
        case Routes.EMAIL:
          EmailController.to.onWillPop(didPop);
          break;
      }
    } catch (e) {
      Get.log(e.toString(), isError: true);
    }

    // return res;
  }

  Future<bool> quitDialog() async {
    final bool? res = await Get.dialog(
      AppConfirmDialog(
        height: 250.0,
        message: 'message_confirmQuit'.tr,
        confirmLabel: 'button_yes'.tr,
        cancelLabel: 'button_cancel'.tr,
      ),
      barrierColor: Colors.black.withOpacity(.6),
    );

    return res ?? false;
  }

  Future<void> _logout() async {
    final bool? res = await Get.dialog(
      AppConfirmDialog(
        height: 230.0,
        message: 'message_confirmLogout'.tr,
        confirmLabel: 'button_yes'.tr,
        cancelLabel: 'button_cancel'.tr,
      ),
      barrierColor: Colors.black.withOpacity(.6),
    );

    if (res == true) {
      Get.back();
      loggingOutProcess = true;
      await HiveService.clearUser();
      await SharedStorageService.clear();

      // Без этих действий. При перелогинивании есть вероятность, что откроется главный экран с фрагментом, с которого был выполнен логаут
      currentRoot.value = Routes.HOME;
      _delegate!.toNamed(currentRoot.value);

      Get.offNamed(Routes.AUTH);
    }
  }

  void setTopPinnedWidget(
      {required Widget widget,
      required double? topPosition,
      required double? bottomPosition,
      required double? leftPosition,
      required double? rightPosition}) {
    topPinnedWidget.value = widget;
    widgetTop = topPosition;
    widgetBottom = bottomPosition;
    widgetLeft = leftPosition;
    widgetRight = rightPosition;
  }

  void dropTopPinnedWidget() {
    topPinnedWidget.value = null;
    widgetTop = null;
    widgetBottom = null;
    widgetLeft = null;
    widgetRight = null;
  }
}
