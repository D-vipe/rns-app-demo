import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:rns_app/app/features/home/domain/models/navigation_item_model.dart';
import 'package:rns_app/app/features/home/presentation/controllers/home_controller.dart';

class BottomItem extends GetView<HomeController> {
  final NavItem item;
  const BottomItem({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => AnimatedScale(
        scale: (controller.currentRoot.value == item.path) ? 1.4 : 1,
        curve: Curves.bounceInOut,
        duration: const Duration(milliseconds: 400),
        child: GestureDetector(
          onTap: () => controller.navigateTo(item.path),
          child: Container(
            alignment: Alignment.center,
            // color: context.colors.error,
            padding: const EdgeInsets.symmetric(horizontal: 7.5),
            child: Obx(
              () => AnimatedSwitcher(
                duration: const Duration(milliseconds: 400),
                reverseDuration: const Duration(milliseconds: 400),
                switchInCurve: Curves.bounceIn,
                switchOutCurve: Curves.bounceOut,
                child: (controller.currentRoot.value == item.path)
                    ? SvgPicture.asset(
                        item.altAsset,
                        width: 24.0,
                        height: 24.0,
                      )
                    : SvgPicture.asset(
                        item.asset,
                        width: 24.0,
                        height: 24.0,
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
