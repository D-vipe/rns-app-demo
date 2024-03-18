import 'package:get/get.dart';
import 'package:rns_app/app/features/email/domain/models/email_filter_model.dart';
import 'package:rns_app/app/features/email/presentation/controllers/email_create_controller.dart';
import 'package:rns_app/app/features/email/presentation/controllers/email_detail_controller.dart';
import 'package:rns_app/app/features/email/presentation/controllers/email_filter_controller.dart';
import 'package:rns_app/app/features/email/presentation/controllers/email_list_controller.dart';
import 'package:rns_app/app/features/email/presentation/views/list/components/floating_create_email.dart';
import 'package:rns_app/app/features/home/presentation/controllers/appbar_controller.dart';
import 'package:rns_app/app/features/home/presentation/controllers/home_controller.dart';
import 'package:rns_app/configs/routes/app_pages.dart';
import 'package:rns_app/resources/resources.dart';

class EmailController extends GetxController {
  static EmailController get to => Get.find();
  final String anchorRoute = Routes.EMAIL;

  GetDelegate? _delegate;
  GetDelegate get delegate => _delegate!;

  final RxString currentRoute = Routes.EMAILIST.obs;

  final Rx<EmailFilterModel> incomingFilters = EmailFilterModel.initial().obs;
  final Rx<EmailFilterModel> outGoingFilters = EmailFilterModel.initial().obs;

  // Id выбранного для просмотра письма
  int? readEmailId;
  String? emailFrom;
  bool incoming = true;
  String? replyTo;
  int? parentIncomingId;
  int? parentOutgoingId;
  String? replyTopic;

  void initDelegate(GetDelegate delegate) {
    _delegate ??= delegate;
  }

  @override
  void onInit() {
    ever(currentRoute, (route) => _rootChanges(route));
    super.onInit();
  }

  @override
  void onReady() {
    HomeController.to.floatingActionBtn.value = const CreateEmailButton();
    super.onReady();
  }

  @override
  void onClose() {
    Get.delete<EmailListController>(force: true);
    super.onClose();
  }

  void _rootChanges(String route) {
    _delegate!.toNamed(route);

    AppBarController appBar = AppBarController.to;

    switch (route) {
      case Routes.EMAIL:
      case Routes.EMAILIST:
        appBar.title.value = 'appbarTitle_email'.tr;
        enableEmailListUi(appBar);
        checkFiltersActive();
        break;
      case Routes.EMAILFILTER:
        appBar.title.value = 'appbarTitle_filters'.tr;

        appBar.leadingAsset.value = AppIcons.clear;
        appBar.actionAsset.value = null;
        appBar.actionName.value = 'button_reset'.tr;
        appBar.leadingFun = () => currentRoute.value = Routes.EMAILIST;
        appBar.actionFun = () => EmailFilterController.to.clearFilters();
        appBar.actionAsset2.value = null;
        appBar.actionFun2 = null;
        HomeController.to.floatingActionBtn.value = null;

        appBar.actionActive.value = false;
        appBar.actionActive2.value = false;
        break;

      case Routes.EMAILCREATE:
        appBar.title.value = 'appbarTitle_createEmail'.tr;

        appBar.leadingAsset.value = AppIcons.clear;
        appBar.actionAsset.value = null;
        appBar.actionName.value = 'button_reset'.tr;
        appBar.leadingFun = () => currentRoute.value = Routes.EMAILIST;
        appBar.actionFun = () => EmailCreateController.to.resetCreateForm();
        appBar.actionAsset2.value = null;
        appBar.actionFun2 = null;
        appBar.actionActive.value = false;
        appBar.actionActive2.value = false;
        HomeController.to.floatingActionBtn.value = null;
        break;

      case Routes.EMAILDETAIL:
        appBar.title.value = 'appbarTitle_emailDetail'.trParams({'author': emailFrom ?? ''});
        appBar.leadingAsset.value = AppIcons.chevronLeft;
        appBar.leadingFun = () => currentRoute.value = Routes.EMAILIST;

        appBar.actionAsset.value = AppIcons.moreVert;
        appBar.actionName.value = null;
        appBar.actionFun = () => EmailDetailController.to.openActionsMenu();

        appBar.actionAsset2.value = null;
        appBar.actionFun2 = null;

        appBar.actionActive.value = false;
        appBar.actionActive2.value = false;
        HomeController.to.floatingActionBtn.value = null;
        break;

      default:
        appBar.title.value = 'appbarTitle_email'.tr;
    }
  }

  void showListScreen() {
    checkFiltersActive();
    EmailListController.to.getData(applyFilter: true);
    currentRoute.value = Routes.EMAILIST;
    _delegate?.toNamed(Routes.EMAILIST);
  }

  void checkFiltersActive() {
    // Изменим активность виджета в appbar
    if (incoming) {
      if (incomingFilters.value != EmailFilterModel.initial()) {
        AppBarController.to.actionActive.value = true;
      } else {
        AppBarController.to.actionActive.value = false;
      }
    } else {
      if (outGoingFilters.value != EmailFilterModel.initial()) {
        AppBarController.to.actionActive.value = true;
      } else {
        AppBarController.to.actionActive.value = false;
      }
    }
  }

  void enableEmailListUi(AppBarController appBar) {
    appBar.leadingAsset.value = AppIcons.appbarBurger;
    appBar.leadingFun = null;

    appBar.actionAsset.value = AppIcons.tune;
    appBar.actionAsset2.value = AppIcons.moreVert;
    appBar.actionFun = () {
      currentRoute.value = Routes.EMAILFILTER;
    };
    appBar.actionFun2 = EmailListController.to.toggleBatchMode;

    HomeController.to.floatingActionBtn.value = const CreateEmailButton();
  }

  Future<void> onWillPop(bool didPop) async {
    if (didPop) return;
    try {
      switch (currentRoute.value) {
        case Routes.EMAIL:
        case Routes.EMAILIST:
          await HomeController.to.quitDialog().then((value) {
            if (value) {
              HomeController.to.rootCanPop.value = true;
            }
          });
          break;
        case Routes.EMAILFILTER:
          currentRoute.value = Routes.EMAILIST;
          _delegate?.toNamed(Routes.EMAILIST);
          break;
        case Routes.EMAILCREATE:
          final bool closeForm = await EmailCreateController.to.quitCreateDialog();
          if (closeForm) {
            currentRoute.value = Routes.EMAILIST;
          }
          break;
        case Routes.EMAILDETAIL:
          currentRoute.value = Routes.EMAILIST;
          _delegate?.toNamed(Routes.EMAILIST);
          break;
      }
    } catch (e) {
      Get.log(e.toString(), isError: true);
    }
  }
}
