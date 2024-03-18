import 'package:get/get.dart';
import 'package:rns_app/app/features/home/domain/models/user_model.dart';
import 'package:rns_app/app/features/home/presentation/controllers/appbar_controller.dart';
import 'package:rns_app/app/features/home/presentation/controllers/home_controller.dart';
import 'package:rns_app/app/features/timesheets/domain/enums/form_action.dart';
import 'package:rns_app/app/features/timesheets/domain/models/timesheet_filter_model.dart';
import 'package:rns_app/app/features/timesheets/domain/models/ts_item_model.dart';
import 'package:rns_app/app/features/timesheets/presentation/controllers/ts_create_controller.dart';
import 'package:rns_app/app/features/timesheets/presentation/controllers/ts_filter_controller.dart';
import 'package:rns_app/app/uikit/general_models/select_object_model.dart';
import 'package:rns_app/app/utils/hive_service.dart';
import 'package:rns_app/configs/routes/app_pages.dart';
import 'package:rns_app/resources/resources.dart';

class TimeSheetController extends GetxController {
  static TimeSheetController get to => Get.find();

  final User? user = HiveService.getUser();

  final String anchorRoute = Routes.TS;

  GetDelegate? _delegate;
  GetDelegate get delegate => _delegate!;

  final RxString currentRoute = Routes.TSLIST.obs;

  final Rx<TimeSheetFilterModel> filters = TimeSheetFilterModel(date: DateTime.now(), executor: null).obs;

  // Сюда будем помещать данные для редактирования / копирования
  TsItem? formItem;
  FormActionType formType = FormActionType.create;

  void initDelegate(GetDelegate delegate) {
    _delegate ??= delegate;
  }

  @override
  void onInit() {
    ever(currentRoute, (route) => _rootChanges(route));
    if (user != null) {
      filters.value = filters.value.copyWith(
        executor: SelectObject(id: user!.id, title: user!.fio),
      );
    }

    super.onInit();
  }

  void _rootChanges(String route) {
    _delegate!.toNamed(route);

    AppBarController appBar = AppBarController.to;

    switch (route) {
      case Routes.TS:
      case Routes.TSLIST:
        appBar.title.value = 'appbarTitle_timesheets'.tr;

        appBar.leadingAsset.value = AppIcons.appbarBurger;
        appBar.leadingFun = null;

        appBar.actionAsset.value = AppIcons.tune;
        appBar.actionFun = () {
          currentRoute.value = Routes.TSFILTER;
        };
        break;
      case Routes.TSFILTER:
        // showFlexibleSpace.value = false;
        appBar.title.value = 'appbarTitle_filters'.tr;

        appBar.leadingAsset.value = AppIcons.clear;
        appBar.actionAsset.value = null;
        appBar.actionName.value = 'button_reset'.tr;
        appBar.leadingFun = () => TimeSheetController.to.currentRoute.value = Routes.TSLIST;
        appBar.actionFun = () => TSFilterController.to.clearFilters();
        HomeController.to.floatingActionBtn.value = null;
        break;

      case Routes.TSCREATE:
        appBar.title.value = formType == FormActionType.edit ? 'appbarTitle_editTS'.tr : 'appbarTitle_createTS'.tr;

        appBar.leadingAsset.value = AppIcons.clear;
        appBar.actionAsset.value = null;
        appBar.actionName.value = 'button_reset'.tr;
        appBar.leadingFun = () => currentRoute.value = Routes.TSLIST;
        appBar.actionFun = () => TsCreateController.to.resetForm();
        HomeController.to.floatingActionBtn.value = null;
        break;

      default:
        appBar.title.value = 'appbarTitle_timesheets'.tr;
    }
  }

  Future<void> onWillPop(bool didPop) async {
    if (didPop) return;
    try {
      switch (currentRoute.value) {
        case Routes.TS:
        case Routes.TSLIST:
          await HomeController.to.quitDialog().then((value) {
            if (value) {
              HomeController.to.rootCanPop.value = true;
            }
          });
          break;
        case Routes.TSFILTER:
          currentRoute.value = Routes.TSLIST;
          _delegate?.toNamed(Routes.TSLIST);
          break;
        case Routes.TSCREATE:
          final bool closeForm = await TsCreateController.to.quitTsCreateDialog();
          if (closeForm) {
            currentRoute.value = Routes.TSLIST;
            _delegate?.toNamed(Routes.TSLIST);
          }
          break;
      }
    } catch (e) {
      Get.log(e.toString(), isError: true);
    }
  }
}
