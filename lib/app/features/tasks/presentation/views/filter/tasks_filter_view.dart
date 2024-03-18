import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rns_app/app/features/tasks/presentation/controllers/tasks_filter_controller.dart';
import 'package:rns_app/app/uikit/form_widgets/select/chip_select_block.dart';
import 'package:rns_app/app/uikit/form_widgets/select/extended_select_button.dart';
import 'package:rns_app/app/uikit/general_models/select_types.dart';
import 'package:rns_app/app/utils/extensions.dart';
import 'package:rns_app/configs/theme/miscellaneous.dart';

class TasksFilterView extends GetView<TasksFilterController> {
  const TasksFilterView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      // без этого цвета page transition выглядит немного коряво
      color: context.colors.backgroundPrimary,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstraints.screenPadding,
        ),
        child: Obx(
          () => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24.0),
              ExtendedSelectButton(
                label: 'tasks_label_executor'.tr,
                placeholder: 'tasks_placeholder_executor'.tr,
                textController: controller.executorController,
                onTap: () => controller.openExtendedSelectModal(SelectType.user),
                error: controller.executorError.value,
              ),
              ExtendedSelectButton(
                label: 'tasks_label_project'.tr,
                placeholder: 'tasks_placeholder_project'.tr,
                textController: controller.projectController,
                onTap: () => controller.openExtendedSelectModal(SelectType.project),
                error: controller.executorError.value,
              ),
              Obx(
                () => Row(
                  children: [
                    Switch(
                        value: controller.onlyNew.value, onChanged: (bool value) => controller.onlyNew.value = value),
                    const SizedBox(
                      width: 12.0,
                    ),
                    Text(
                      'tasks_label_onlyNew'.tr,
                      style: Get.context!.textStyles.body,
                    )
                  ],
                ),
              ),
              const SizedBox(height: 24.0),
              Obx(
                () => AnimatedOpacity(
                  opacity: controller.statuses.isEmpty ? 0 : 1,
                  duration: const Duration(milliseconds: 400),
                  child: ChipSelectBlock(
                    label: 'tasks_label_status'.tr,
                    list: controller.statuses,
                    multipleSelect: false,
                    selectedValue: controller.selectedStatus.value,
                    onTap: controller.selectStatus,
                  ),
                ),
              ),
              const SizedBox(height: 55.0),
            ],
          ),
        ),
      ),
    );
  }
}
