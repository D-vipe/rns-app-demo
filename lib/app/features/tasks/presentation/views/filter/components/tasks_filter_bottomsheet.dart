import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rns_app/app/features/tasks/presentation/controllers/tasks_filter_controller.dart';
import 'package:rns_app/app/uikit/form_widgets/select/custom_select_bottom_modal.dart';
import 'package:rns_app/app/uikit/form_widgets/select/single_select_widget.dart';
import 'package:rns_app/app/uikit/general_models/select_types.dart';
import 'package:rns_app/app/utils/extensions.dart';

class TasksFilterBottomSheet extends GetView<TasksFilterController> {
  const TasksFilterBottomSheet({super.key, required this.type});

  final SelectType type;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(Get.context!).unfocus(),
      child: Obx(
        () => CustomSelectBottomWidget(
          title: type == SelectType.user ? 'tasks_title_executor'.tr : 'tasks_title_project'.tr,
          hideActionButton: controller.hideFiltersActionBtn.value,
          clearHandler: () => controller.clearSelectFilter(type),
          closeHandler: () {
            Get.back();
            controller.noExecutor.value = false;
          },
          saveHandler: () {
            controller.applySelectedValue(type);
            Get.back();
          },
          children: [
            if (type == SelectType.user && controller.noExecutorData != null)
              Row(
                children: [
                  Switch(
                      value: controller.noExecutor.value,
                      onChanged: (bool value) => controller.noExecutor.value = value),
                  const SizedBox(
                    width: 12.0,
                  ),
                  Text(
                    'tasks_label_noExecutor'.tr,
                    style: Get.context!.textStyles.body,
                  )
                ],
              ),
            SingleSelectWidget(
              items: type == SelectType.user ? controller.executors : controller.projects,
              refresher: () =>
                  type == SelectType.user ? controller.getAvailableExecutors() : controller.getAvailableProjects(),
              onChange: type == SelectType.user ? controller.onExecutorChange : controller.onProjectChange,
              searchController: type == SelectType.user ? controller.searchExecutor : controller.searchProject,
              searchFocus: controller.searchFocus,
              selectedVal: type == SelectType.user ? controller.radioExecutor.value : controller.radioProject.value,
              loadingData: controller.loadingData.value,
              error: controller.executorError.value,
              animationController: controller.animationController,
              searching: controller.searching.value,
              searchLabel: 'tasks_placeholder_search'.tr,
              searchTitle: type == SelectType.user ? 'tasks_label_fioSearch'.tr : 'tasks_label_projectSearch'.tr,
              listTitle: 'label_chooseOption'.tr,
              disabled: type == SelectType.user ? controller.noExecutor.value : false,
            )
          ],
        ),
      ),
    );
  }
}
