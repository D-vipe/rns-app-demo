import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rns_app/app/features/tasks/presentation/controllers/detail_tabs/general_tab_controller.dart';
import 'package:rns_app/app/features/tasks/presentation/controllers/tasks_detail_controller.dart';
import 'package:rns_app/app/uikit/form_widgets/app_textfield.dart';
import 'package:rns_app/app/uikit/form_widgets/select/chip_select_block.dart';
import 'package:rns_app/app/utils/extensions.dart';

class StatusBlockWidget extends GetView<GeneralTabController> {
  const StatusBlockWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 24.0,
          ),
          Text(
            'tasks_label_searchStatus'.tr,
            style: Get.context!.textStyles.header2,
          ),
          const SizedBox(height: 6.0),
          AppTextField(
            hintText: 'tasks_placeholder_search'.tr,
            labelText: 'tasks_placeholder_search'.tr,
            enabled: true,
            textEditingController: controller.searchController,
          ),
          const SizedBox(height: 32.0),
          AnimatedOpacity(
            opacity: TasksDetailController.to.editStatusList.isEmpty ? 0 : 1,
            duration: const Duration(milliseconds: 400),
            child: ChipSelectBlock(
              label: 'tasks_label_status'.tr,
              list: TasksDetailController.to.editStatusList,
              multipleSelect: false,
              selectedValue: controller.selectedNewStatus.value,
              onTap: controller.selectStatus,
              loading: controller.searching.value,
              animationController: controller.animationController,
            ),
          ),
        ],
      ),
    );
  }
}
