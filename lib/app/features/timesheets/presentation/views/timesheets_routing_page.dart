import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rns_app/app/features/timesheets/presentation/controllers/timesheets_controller.dart';

class TimesheetsRoutingPage extends GetView<TimeSheetController> {
  const TimesheetsRoutingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetRouterOutlet.builder(
      builder: (_, delegate, __) {
        controller.initDelegate(delegate);
        return GetRouterOutlet(
          initialRoute: controller.currentRoute.value,
          key: Get.nestedKey(controller.anchorRoute),
          anchorRoute: controller.anchorRoute,
          filterPages: (afterAnchor) {
            return afterAnchor.take(1);
          },
        );
      },
    );
  }
}
