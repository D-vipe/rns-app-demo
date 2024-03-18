import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rns_app/app/features/home/presentation/controllers/home_controller.dart';
import 'package:rns_app/app/features/home/presentation/views/components/appbar/app_sliver_appbar.dart';
import 'package:rns_app/app/features/home/presentation/views/components/bottom_navigation/app_bottom_nav_fixed.dart';
import 'package:rns_app/app/features/home/presentation/views/components/drawer/app_drawer.dart';
import 'package:rns_app/app/uikit/app_scaffold.dart';

class HomeRoutingPage extends GetView<HomeController> {
  const HomeRoutingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => PopScope(
        onPopInvoked: (bool didPop) async => controller.onWillPop(didPop),
        canPop: controller.rootCanPop.value,
        child: AppScaffold(
          sliverAppBar: AppSliverAppBar(
            topPinnedWidget: controller.topPinnedWidget.value,
          ),
          drawer: const AppDrawer(),
          navigationBar: const AppBottomNavFixed(),
          floatingActionButton: controller.floatingActionBtn.value,
          child: GetRouterOutlet.builder(
            builder: (_, delegate, __) {
              controller.initDelegate(delegate);
              return GetRouterOutlet(
                initialRoute: controller.currentRoot.value,
                key: Get.nestedKey(controller.anchorRoute),
                anchorRoute: controller.anchorRoute,
                filterPages: (afterAnchor) {
                  return afterAnchor.take(1);
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
