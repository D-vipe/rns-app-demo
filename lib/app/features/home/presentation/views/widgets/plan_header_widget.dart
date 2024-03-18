import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rns_app/app/features/home/presentation/controllers/home_logic_controller.dart';
import 'package:rns_app/app/features/home/presentation/views/widgets/info_item.dart';
import 'package:rns_app/app/utils/extensions.dart';

class PlanHeaderWidget extends GetView<HomeLogicController> {
  const PlanHeaderWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16.0),
          Text(
            'home_currentPlan'.tr,
            style: context.textStyles.header1,
          ),
          if (controller.plan.value != null) const SizedBox(height: 16),
          controller.plan.value != null
              ? Column(
                  children: [
                    InfoItem(
                      keyText: '${'home_plan'.tr}:',
                      valueText: controller.plan.value == null ? ' - ' : controller.plan.value?.period ?? ' - ',
                    ),
                    InfoItem(
                      keyText: '${'home_timeCount'.tr}:',
                      valueText: controller.plan.value == null ? '' : '${controller.plan.value!.timeCount}',
                    ),
                    InfoItem(
                      keyText: '${'home_matching'.tr}:',
                      valueText: controller.plan.value == null
                          ? ''
                          : controller.plan.value!.matching
                              ? 'home_matching_yes'.tr
                              : 'home_matching_no'.tr,
                    ),
                  ],
                )
              : const Text('Нет данных'),
        ],
      ),
    );
  }
}
