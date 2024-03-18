import 'package:get/get.dart';
import 'package:rns_app/app/features/home/domain/models/navigation_item_model.dart';
import 'package:rns_app/configs/routes/app_pages.dart';
import 'package:rns_app/resources/resources.dart';

class AppNavigationList {
  static final List<NavItem> bottomList = [
    NavItem(
      path: Routes.HOME,
      asset: AppIcons.home,
      altAsset: AltAppIcons.homeAlt,
    ),
    NavItem(
      path: Routes.TASKS,
      asset: AppIcons.bookmarks,
      altAsset: AltAppIcons.bookmarksAlt,
    ),
    NavItem(
      path: Routes.TS,
      asset: AppIcons.queryBuilder,
      altAsset: AltAppIcons.queryBuilderAlt,
    ),
    NavItem(
      path: Routes.EMAIL,
      asset: AppIcons.email,
      altAsset: AltAppIcons.emailAlt,
    ),
  ];
  static final List<NavItem> sideBarList = [
    NavItem(
      path: Routes.TASKS,
      asset: AppIcons.moveToInbox,
      altAsset: AltAppIcons.moveToInbox,
      title: 'drawer_tasks'.tr,
    ),
    NavItem(
      path: '',
      asset: AppIcons.insertDriveFile,
      altAsset: AltAppIcons.insertDriveFile,
      title: 'drawer_projects'.tr,
    ),
    NavItem(
      path: Routes.TS,
      asset: AppIcons.dateRange,
      altAsset: AltAppIcons.dateRange,
      title: 'drawer_timesheets'.tr,
    ),
    NavItem(
      path: '',
      asset: AppIcons.questionAnswer,
      altAsset: AltAppIcons.questionAnswer,
      title: 'drawer_messages'.tr,
    ),
    NavItem(
      path: Routes.EMAIL,
      asset: AppIcons.emailSide,
      altAsset: AltAppIcons.emailAlt,
      title: 'drawer_emails'.tr,
    ),
    NavItem(
      path: Routes.EMPLOYEE,
      asset: AppIcons.supervisedUserCircle,
      altAsset: AltAppIcons.supervisedUserCircle,
      title: 'drawer_employees'.tr,
    ),
    NavItem(
      path: Routes.NEWS,
      asset: AppIcons.flashOn,
      altAsset: AltAppIcons.flashOn,
      title: 'drawer_news'.tr,
    ),
    NavItem(
      path: '',
      asset: AppIcons.layers,
      altAsset: AltAppIcons.layers,
      title: 'drawer_stickers'.tr,
    ),
    NavItem(
      path: '',
      asset: AppIcons.settings,
      altAsset: AltAppIcons.settings,
      title: 'drawer_settings'.tr,
    ),
    NavItem(
      path: Routes.AUTH,
      asset: AppIcons.exitToApp,
      altAsset: AppIcons.exitToApp,
      title: 'drawer_logout'.tr,
    ),
  ];
}
