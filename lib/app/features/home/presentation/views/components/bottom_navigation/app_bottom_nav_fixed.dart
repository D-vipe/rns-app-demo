import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rns_app/app/features/home/presentation/controllers/bottomnav_controller.dart';

class AppBottomNavFixed extends GetView<BottomNavController> {
  const AppBottomNavFixed({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: GetPlatform.isAndroid ? 55.0 : 65.0,
      decoration: BoxDecoration(color: Theme.of(context).colorScheme.background),
      child: Padding(
        padding: EdgeInsets.fromLTRB(50.0, 0.0, 50.0, GetPlatform.isAndroid ? 0.0 : 15.0),
        child: Obx(
          () => AnimatedSwitcher(
            duration: const Duration(milliseconds: 400),
            child: controller.navItemsList.value,
          ),
        ),
      ),
    );
  }
}
