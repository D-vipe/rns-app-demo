import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rns_app/app/features/home/presentation/controllers/root_controller.dart';
import 'package:rns_app/app/uikit/app_scalebox.dart';
import 'package:rns_app/configs/routes/app_pages.dart';

class RootView extends GetView<RootController> {
  const RootView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaleBox(
      child: RouterOutlet<RouterDelegate<Object>, Object>.builder(
        delegate: GetDelegate(
          notFoundRoute: GetPage(
            name: '/404',
            page: () => Container(),
          ),
        ),
        builder: (context, delegate, object) {
          return GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Obx(
              () => PopScope(
                onPopInvoked: (bool didPop) => controller.onWillPop(didPop),
                canPop: controller.rootCanPop.value,
                child: GetRouterOutlet(
                  initialRoute: controller.initialRoute.value,
                  key: Get.nestedKey(Routes.AUTH),
                  anchorRoute: AppPages.INITIAL,
                  filterPages: (afterAnchor) {
                    return afterAnchor.take(1);
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
