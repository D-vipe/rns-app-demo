import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rns_app/app/features/employee/presentation/controllers/employee_controller.dart';

class EmployeeRoutingPage extends GetView<EmployeeController> {
  const EmployeeRoutingPage({super.key});

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
