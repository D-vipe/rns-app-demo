import 'package:get/get.dart';
import 'package:rns_app/app/features/email/presentation/controllers/email_controller.dart';
import 'package:rns_app/app/features/email/presentation/controllers/email_list_controller.dart';
import 'package:rns_app/app/features/employee/presentation/controllers/employee_controller.dart';
import 'package:rns_app/app/features/home/presentation/controllers/home_controller.dart';
import 'package:rns_app/app/features/tasks/presentation/controllers/tasks_controller.dart';
import 'package:rns_app/app/features/timesheets/presentation/controllers/timesheets_controller.dart';
import 'package:rns_app/configs/routes/app_pages.dart';
import 'package:rns_app/resources/resources.dart';

class AppBarController extends GetxController {
  static AppBarController get to => Get.find();

  final RxString title = 'appbarTitle_home'.tr.obs;
  final RxBool showFlexibleSpace = true.obs;

  // Иконка и функция слева
  final RxString leadingAsset = AppIcons.appbarBurger.obs;
  void Function()? leadingFun;
  // Иконка и функция слева конец

  // Иконка и функция справа
  final Rxn<String> actionAsset = Rxn<String>(null);
  final RxBool actionActive = false.obs;
  // Добавим второй action в apppbar
  final Rxn<String> actionAsset2 = Rxn<String>(null);
  final RxBool actionActive2 = false.obs;
  final Rxn<String> actionName = Rxn<String>(null);
  void Function()? actionFun;
  void Function()? actionFun2;
  // Иконка и функция справа конец

  @override
  void onInit() {
    ever(HomeController.to.currentRoot, (currentRoute) => _handleAppBarWidget(currentRoute));

    super.onInit();
  }

  void _handleAppBarWidget(String currentRoute) {
    switch (currentRoute) {
      case Routes.HOME:
        title.value = 'appbarTitle_home'.tr;
        showFlexibleSpace.value = true;

        leadingAsset.value = AppIcons.appbarBurger;
        leadingFun = null;
        actionAsset.value = null;
        actionAsset2.value = null;
        actionName.value = null;
        actionFun = null;
        actionFun2 = null;
        break;
      case Routes.TS:
        showFlexibleSpace.value = false;
        title.value = 'appbarTitle_timesheets'.tr;

        leadingAsset.value = AppIcons.appbarBurger;
        leadingFun = null;

        actionAsset.value = AppIcons.tune;
        actionFun = () {
          TimeSheetController.to.currentRoute.value = Routes.TSFILTER;
        };

        actionAsset2.value = null;
        actionFun2 = null;
        break;
      case Routes.NEWS:
        showFlexibleSpace.value = false;
        title.value = 'appbarTitle_news'.tr;

        leadingAsset.value = AppIcons.appbarBurger;
        leadingFun = null;

        actionAsset.value = null;
        break;
      case Routes.NEWS_DETAILED:
        showFlexibleSpace.value = false;
        title.value = 'appbarTitle_news'.tr;

        leadingAsset.value = AppIcons.chevronLeft;
        leadingFun = () => HomeController.to.navigateTo(Routes.NEWS);

        actionAsset.value = null;
        break;

      case Routes.TASKS:
        showFlexibleSpace.value = false;
        title.value = 'appbarTitle_tasks'.tr;

        leadingAsset.value = AppIcons.appbarBurger;
        leadingFun = null;

        actionAsset.value = AppIcons.tune;
        actionFun = () {
          TasksController.to.currentRoute.value = Routes.TASKSFILTER;
        };

        actionAsset2.value = null;
        actionFun2 = null;
        break;

      case Routes.EMAIL:
        showFlexibleSpace.value = false;
        title.value = 'appbarTitle_email'.tr;

        leadingAsset.value = AppIcons.appbarBurger;
        leadingFun = null;

        actionAsset.value = AppIcons.tune;
        actionAsset2.value = AppIcons.moreVert;
        actionFun = () {
          EmailController.to.currentRoute.value = Routes.EMAILFILTER;
        };
        actionFun2 = () => EmailListController.to.toggleBatchMode();
        break;

      case Routes.EMPLOYEE:
        showFlexibleSpace.value = false;
        title.value = 'appbarTitle_employees'.tr;

        leadingAsset.value = AppIcons.appbarBurger;
        leadingFun = null;
        actionAsset.value = AppIcons.tune;
        actionFun = () {
          EmployeeController.to.currentRoute.value = Routes.EMPLOYEEFILTER;
        };

        actionAsset2.value = null;
        actionFun2 = null;
        break;

      default:
        title.value = '';
        showFlexibleSpace.value = false;
        actionAsset2.value = null;
        actionFun2 = null;
        break;
    }
  }
}
