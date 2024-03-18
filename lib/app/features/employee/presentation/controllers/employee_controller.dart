import 'package:get/get.dart';
import 'package:rns_app/app/features/employee/presentation/controllers/employee_filter_controller.dart';
import 'package:rns_app/app/features/home/presentation/controllers/appbar_controller.dart';
import 'package:rns_app/app/features/home/presentation/controllers/home_controller.dart';
import 'package:rns_app/configs/routes/app_pages.dart';
import 'package:rns_app/resources/resources.dart';

class EmployeeController extends GetxController {
  static EmployeeController get to => Get.find();

  final String anchorRoute = Routes.EMPLOYEELIST;

  GetDelegate? _delegate;
  GetDelegate get delegate => _delegate!;

  final RxString currentRoute = Routes.EMPLOYEELIST.obs;

  // final Rx<TimeSheetFilterModel> filters = TimeSheetFilterModel(date: DateTime.now(), executor: null).obs;

  void initDelegate(GetDelegate delegate) {
    _delegate ??= delegate;
  }

  @override
  void onInit() {
    ever(currentRoute, (route) => _rootChanges(route));
    // if (user != null) {
    //   filters.value = filters.value.copyWith(
    //     executor: SelectObject(id: user!.id, title: user!.fio),
    //   );
    // }

    super.onInit();
  }

  void _rootChanges(String route) {
    _delegate!.toNamed(route);

    AppBarController appBar = AppBarController.to;

    switch (route) {
      case Routes.EMPLOYEE:
      case Routes.EMPLOYEELIST:
        appBar.title.value = 'appbarTitle_employees'.tr;

        appBar.leadingAsset.value = AppIcons.appbarBurger;
        appBar.leadingFun = null;

        appBar.actionAsset.value = AppIcons.tune;
        appBar.actionFun = () {
          currentRoute.value = Routes.EMPLOYEEFILTER;
        };
        break;
      case Routes.EMPLOYEEFILTER:
        appBar.title.value = 'appbarTitle_filters'.tr;

        appBar.leadingAsset.value = AppIcons.clear;
        appBar.actionAsset.value = null;
        appBar.actionName.value = 'button_reset'.tr;
        appBar.leadingFun = () => currentRoute.value = Routes.EMPLOYEELIST;
        appBar.actionFun = () => EmployeeFilterController.to.clearFilters();
        break;

      case Routes.EMPLOYEEDETAIL:
        // appBar.title.value = formType == FormActionType.edit ? 'appbarTitle_editTS'.tr : 'appbarTitle_createTS'.tr;

        // appBar.leadingAsset.value = AppIcons.clear;
        // appBar.actionAsset.value = null;
        // appBar.actionName.value = 'button_reset'.tr;
        // appBar.leadingFun = () => currentRoute.value = Routes.TSLIST;
        // appBar.actionFun = () => TsCreateController.to.resetForm();
        // HomeController.to.floatingActionBtn.value = null;
        break;

      default:
        appBar.title.value = 'appbarTitle_employees'.tr;
    }
  }

  Future<void> onWillPop(bool didPop) async {
    if (didPop) return;
    try {
      switch (currentRoute.value) {
        case Routes.EMPLOYEE:
        case Routes.EMPLOYEELIST:
          await HomeController.to.quitDialog().then((value) {
            if (value) {
              HomeController.to.rootCanPop.value = true;
            }
          });
          break;
        case Routes.EMAILFILTER:
          currentRoute.value = Routes.EMPLOYEELIST;
          _delegate?.toNamed(Routes.EMPLOYEELIST);
          break;
      }
    } catch (e) {
      Get.log(e.toString(), isError: true);
    }
  }
}
