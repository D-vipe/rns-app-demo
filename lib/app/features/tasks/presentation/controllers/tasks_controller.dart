import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rns_app/app/features/home/domain/models/user_model.dart';
import 'package:rns_app/app/features/home/presentation/controllers/appbar_controller.dart';
import 'package:rns_app/app/features/home/presentation/controllers/home_controller.dart';
import 'package:rns_app/app/features/tasks/domain/models/task_model.dart';
import 'package:rns_app/app/features/tasks/domain/models/tasks_filter_model.dart';
import 'package:rns_app/app/features/tasks/presentation/controllers/tasks_create_controller.dart';
import 'package:rns_app/app/features/tasks/presentation/controllers/tasks_detail_controller.dart';
import 'package:rns_app/app/features/tasks/presentation/controllers/tasks_filter_controller.dart';
import 'package:rns_app/app/features/tasks/presentation/views/list/components/floating_action_button.dart';
import 'package:rns_app/app/uikit/dialogs/app_confirm_dialog.dart';
import 'package:rns_app/app/uikit/general_models/select_object_model.dart';
import 'package:rns_app/app/utils/hive_service.dart';
import 'package:rns_app/configs/routes/app_pages.dart';
import 'package:rns_app/resources/resources.dart';

class TasksController extends GetxController {
  static TasksController get to => Get.find();

  final User? user = HiveService.getUser();

  final String anchorRoute = Routes.TASKS;

  GetDelegate? _delegate;
  GetDelegate get delegate => _delegate!;

  final RxString currentRoute = Routes.TASKSLIST.obs;

  final Rx<TasksFilterModel> filters = TasksFilterModel.initial().obs;

  // Сюда будем помещать данные для редактирования / копирования
  Task? formItem;
  int? detailTaskId;

  bool closeOverlays = false;
  bool taskWasCreated = false;

  void initDelegate(GetDelegate delegate) {
    _delegate ??= delegate;
  }

  @override
  void onInit() {
    ever(currentRoute, (route) => _rootChanges(route));
    if (user != null) {
      filters.value = filters.value.copyWith(
        executor: SelectObject(id: user!.id, title: user!.fio),
        status: filters.value.status,
        project: filters.value.project,
        isNewTask: filters.value.isNewTask,
      );
    }

    super.onInit();
  }

  @override
  void onReady() {
    HomeController.to.floatingActionBtn.value = const CreateTaskButton();
    super.onReady();
  }

  void _rootChanges(String route) {
    _delegate!.toNamed(route);
    AppBarController appBar = AppBarController.to;

    switch (route) {
      case Routes.TASKS:
      case Routes.TASKSLIST:
        appBar.title.value = 'appbarTitle_tasks'.tr;

        appBar.leadingAsset.value = AppIcons.appbarBurger;
        appBar.leadingFun = null;

        appBar.actionAsset.value = AppIcons.tune;
        appBar.actionFun = () {
          currentRoute.value = Routes.TASKSFILTER;
        };
        checkFiltersActive();
        HomeController.to.floatingActionBtn.value = const CreateTaskButton();
        break;
      case Routes.TASKSFILTER:
        appBar.title.value = 'appbarTitle_filters'.tr;

        appBar.leadingAsset.value = AppIcons.clear;
        appBar.actionAsset.value = null;
        appBar.actionName.value = 'button_reset'.tr;
        appBar.leadingFun = () => currentRoute.value = Routes.TASKSLIST;
        appBar.actionFun = () => TasksFilterController.to.clearFilters();
        HomeController.to.floatingActionBtn.value = null;
        break;

      case Routes.TASKSCREATE:
        appBar.title.value = 'appbarTitle_createTask'.tr;

        appBar.leadingAsset.value = AppIcons.clear;
        appBar.actionAsset.value = null;
        appBar.actionName.value = 'button_reset'.tr;
        appBar.leadingFun = () async {
          final bool closeForm = await TasksCreateController.to.quitTsCreateDialog();
          if (closeForm) {
            currentRoute.value = Routes.TASKSLIST;
          }
        };
        appBar.actionFun = () => TasksCreateController.to.resetForm();
        HomeController.to.floatingActionBtn.value = null;
        break;

      case Routes.TASKSDETAIL:
        appBar.title.value = 'appbarTitle_tasks'.tr;
        appBar.leadingAsset.value = AppIcons.chevronLeft;
        appBar.leadingFun = () => currentRoute.value = Routes.TASKSLIST;

        appBar.actionAsset.value = null;
        appBar.actionName.value = null;
        appBar.actionFun = null;

        HomeController.to.floatingActionBtn.value = null;
        break;

      default:
        appBar.title.value = 'appbarTitle_tasks'.tr;
    }
  }

  void checkFiltersActive() {
    // Изменим активность виджета в appbar
    if (filters.value != TasksFilterModel.initial()) {
      AppBarController.to.actionActive.value = true;
    } else {
      AppBarController.to.actionActive.value = false;
    }
  }

  Future<void> onWillPop(bool didPop) async {
    if (didPop) return;
    try {
      switch (currentRoute.value) {
        case Routes.TASKS:
        case Routes.TASKSLIST:
          await HomeController.to.quitDialog().then((value) {
            if (value) {
              HomeController.to.rootCanPop.value = true;
            }
          });
          break;
        case Routes.TASKSFILTER:
          currentRoute.value = Routes.TASKSLIST;
          _delegate?.toNamed(Routes.TASKSLIST);
          break;
        case Routes.TASKSCREATE:
          final bool closeForm = await TasksCreateController.to.quitTsCreateDialog();
          if (closeForm) {
            currentRoute.value = Routes.TASKSLIST;
          }
          break;
        case Routes.TASKSDETAIL:
          switch (TasksDetailController.to.currentTabIndex.value) {
            case 2:
              if (Get.isBottomSheetOpen == true) {
                await closeFileFormDialog().then((value) {
                  if (value) {
                    Get.back();
                  }
                });
              } else {
                currentRoute.value = Routes.TASKSLIST;
                _delegate?.toNamed(Routes.TASKSLIST);
              }
              break;
            default:
              currentRoute.value = Routes.TASKSLIST;
              _delegate?.toNamed(Routes.TASKSLIST);
              break;
          }
          break;
      }
    } catch (e) {
      Get.log(e.toString(), isError: true);
    }
  }

  void showListScreen() {
    currentRoute.value = Routes.TASKSLIST;
    _delegate?.toNamed(Routes.TASKSLIST);
  }

  Future<bool> closeFileFormDialog() async {
    final bool? res = await Get.dialog(
      AppConfirmDialog(
        height: 250.0,
        message: 'tasks_message_closeFileForm'.tr,
        confirmLabel: 'button_yes'.tr,
        cancelLabel: 'button_cancel'.tr,
      ),
      barrierColor: Colors.black.withOpacity(.6),
    );

    return res ?? false;
  }
}
