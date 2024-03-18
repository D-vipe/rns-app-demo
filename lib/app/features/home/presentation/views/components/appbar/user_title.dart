import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rns_app/app/features/home/presentation/controllers/home_controller.dart';
import 'package:rns_app/app/utils/extensions.dart';

class AppBarExpansionTitle extends GetView<HomeController> {
  const AppBarExpansionTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 2,
      child: Obx(() => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                controller.userData.value?.fio ?? ' - ',
                style: context.textStyles.header1,
              ),
              const SizedBox(
                height: 8.0,
              ),
              if (controller.userData.value?.position != null)
                Text(
                  controller.userData.value!.position!,
                  style: context.textStyles.body,
                ),
            ],
          )),
    );
  }
}
