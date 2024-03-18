import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:rns_app/app/features/home/domain/models/navigation_item_model.dart';
import 'package:rns_app/app/features/home/presentation/controllers/home_controller.dart';
import 'package:rns_app/app/features/home/utils/navigation_lists.dart';
import 'package:rns_app/app/uikit/app_loader.dart';
import 'package:rns_app/app/utils/extensions.dart';
import 'package:rns_app/configs/theme/miscellaneous.dart';
import 'package:rns_app/resources/resources.dart';

class AppDrawer extends GetView<HomeController> {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: () => Get.back(),
                child: SvgPicture.asset(
                  AppIcons.clear,
                  width: 24.0,
                  height: 24.0,
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            const _UserBlock(),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(
                  vertical: 12.0,
                ),
                itemCount: AppNavigationList.sideBarList.length,
                itemBuilder: ((context, index) {
                  final NavItem item = AppNavigationList.sideBarList[index];

                  return ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: AppConstraints.screenPadding, vertical: 0.0),
                    onTap: () {
                      Scaffold.of(context).closeDrawer();
                      controller.navigateTo(item.path);
                    },
                    title: Obx(
                      () => Row(
                        children: [
                          AnimatedSwitcher(
                            duration:
                                Duration(milliseconds: HomeController.to.currentRoot.value == item.path ? 0 : 200),
                            transitionBuilder: (Widget child, Animation<double> animation) {
                              return SlideTransition(
                                position: Tween<Offset>(
                                  begin: const Offset(-1.0, -0.0),
                                  end: const Offset(0.0, 0.0),
                                ).animate(animation),
                                child: child,
                              );
                            },
                            child: SvgPicture.asset(
                              HomeController.to.currentRoot.value == item.path ? item.altAsset : item.asset,
                              width: 24.0,
                              height: 24.0,
                              key: ValueKey<String>(
                                  HomeController.to.currentRoot.value == item.path ? item.altAsset : item.asset),
                            ),
                          ),
                          const SizedBox(width: 16.0),
                          Text(
                            item.title ?? '',
                            style: context.textStyles.body,
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _UserBlock extends GetView<HomeController> {
  const _UserBlock();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppConstraints.screenPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Obx(
            () => CircleAvatar(
              radius: 45,
              backgroundColor: context.colors.white,
              child: (controller.userData.value != null && (controller.userData.value?.avatarUrl != null))
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(56.0),
                      child: CachedNetworkImage(
                        fit: BoxFit.contain,
                        imageUrl: controller.userData.value!.avatarUrl!,
                        placeholder: (_, __) => Loader(
                          btn: true,
                          size: 15.0,
                          color: context.colors.inputBackground,
                        ),
                        errorWidget: (context, url, error) => const Icon(Icons.error_outline),
                      ),
                    )
                  : null,
            ),
          ),
          const SizedBox(height: 16.0),
          Obx(
            () => Text(
              controller.userData.value != null ? controller.userData.value?.fio ?? ' - ' : ' - ',
              style: context.textStyles.header1,
            ),
          ),
          const SizedBox(
            height: 8.0,
          ),
          if (controller.userData.value?.position != null)
            Text(
              controller.userData.value?.position ?? ' - ',
              style: context.textStyles.body.copyWith(
                color: context.colors.text.subtitle,
              ),
            ),
        ],
      ),
    );
  }
}
