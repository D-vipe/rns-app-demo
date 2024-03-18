import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rns_app/app/features/tasks/presentation/controllers/form_tabs/form_general_tab_controller.dart';
import 'package:rns_app/app/features/tasks/presentation/views/create/components/coexecutor_widget.dart';
import 'package:rns_app/app/uikit/app_animated_list_item.dart';
import 'package:rns_app/app/uikit/form_widgets/select/select_block_widget.dart';
import 'package:rns_app/app/uikit/general_models/select_types.dart';
import 'package:rns_app/app/utils/extensions.dart';
import 'package:rns_app/configs/theme/miscellaneous.dart';

class GeneralFormTab extends GetView<GeneralFormTabController> {
  const GeneralFormTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      controller: controller.scrollController,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 24.0,
          ),
          Obx(
            () => Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppConstraints.screenPadding),
              child: SelectBlockWidget(
                label: 'tasks_label_project'.tr,
                placeholder: 'timeSheets_hintProject'.tr,
                items: controller.projects,
                selectedVal: controller.selectedProject.value,
                selectType: SelectType.project,
                onChange: controller.onChange,
                error: controller.projectError.value,
                processing: controller.fetchingProjects.value,
                reset: controller.dropSelectedProject,
                searchController: null,
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Obx(
            () => Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppConstraints.screenPadding),
              child: SelectBlockWidget(
                label: 'tasks_label_lifeCycle'.tr,
                placeholder: 'tasks_placeholder_selectLifeCycle'.tr,
                items: controller.taskLifeCycles,
                selectedVal: controller.selectedLifeCycle.value,
                selectType: SelectType.lifeCycle,
                onChange: controller.onChange,
                error: controller.lifeCycleError.value,
                processing: controller.loadingDependentData.value,
                reset: () => controller.selectedLifeCycle.value = null,
                searchController: null,
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Obx(
            () => Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppConstraints.screenPadding),
              child: SelectBlockWidget(
                label: 'tasks_label_taskType'.tr,
                placeholder: 'tasks_placeholder_selectType'.tr,
                items: controller.taskType,
                selectedVal: controller.selectedTaskType.value,
                selectType: SelectType.taskType,
                onChange: controller.onChange,
                error: controller.taskTypeError.value,
                processing: controller.loadingDependentData.value,
                reset: () => controller.selectedTaskType.value = null,
                searchController: null,
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Obx(
            () => Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppConstraints.screenPadding),
                    child: Row(
                      children: [
                        Switch(
                            value: controller.isTaskError.value,
                            onChanged: (bool value) => controller.isTaskError.value = value),
                        const SizedBox(
                          width: 12.0,
                        ),
                        Text(
                          'tasks_label_errorToggle'.tr,
                          style: Get.context!.textStyles.body,
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10.0,
                ),
                Expanded(
                  child: Row(
                    children: [
                      Switch(
                          value: controller.isTaskPrioritet.value,
                          onChanged: (bool value) => controller.isTaskPrioritet.value = value),
                      const SizedBox(
                        width: 12.0,
                      ),
                      Expanded(
                        child: Text(
                          'tasks_label_prioritetToggle'.tr,
                          style: Get.context!.textStyles.body,
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 20.0,
          ),
          Obx(
            () => Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppConstraints.screenPadding),
              child: SelectBlockWidget(
                label: 'tasks_label_urgency'.tr,
                placeholder: 'tasks_placeholder_selectUrgency'.tr,
                items: controller.urgencyList,
                selectedVal: controller.selectedUrgency.value,
                selectType: SelectType.urgency,
                onChange: controller.onChange,
                error: controller.urgencyError.value,
                processing: controller.loadingDependentData.value,
                reset: null,
                searchController: null,
              ),
            ),
          ),
          const SizedBox(
            height: 20.0,
          ),
          Obx(
            () => Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppConstraints.screenPadding),
              child: SelectBlockWidget(
                label: 'tasks_label_responsible'.tr,
                placeholder: 'tasks_placeholder_selectResponsible'.tr,
                items: controller.curatorsList,
                selectedVal: controller.selectedResponsible.value,
                selectType: SelectType.responsible,
                onChange: controller.onChange,
                error: controller.responsibleError.value,
                processing: controller.loadingDependentData.value,
                reset: () => controller.selectedResponsible.value = null,
                searchController: null,
              ),
            ),
          ),
          const SizedBox(
            height: 20.0,
          ),
          Obx(
            () => Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppConstraints.screenPadding),
              child: SelectBlockWidget(
                label: 'tasks_label_executor'.tr,
                placeholder: 'tasks_placeholder_selectExecutor'.tr,
                items: controller.executorsList,
                selectedVal: controller.selectedExecutor.value,
                selectType: SelectType.executor,
                onChange: controller.onChange,
                error: controller.executorError.value,
                processing: controller.loadingDependentData.value,
                reset: () => controller.selectedExecutor.value = null,
                searchController: null,
              ),
            ),
          ),
          const SizedBox(
            height: 20.0,
          ),
          Obx(
            () => Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppConstraints.screenPadding),
              child: SelectBlockWidget(
                label: 'tasks_label_initiator'.tr,
                placeholder: 'tasks_placeholder_selectInitiator'.tr,
                items: controller.curatorsList,
                selectedVal: controller.selectedInitiator.value,
                selectType: SelectType.initiator,
                onChange: controller.onChange,
                error: controller.initiatorError.value,
                processing: controller.loadingDependentData.value,
                reset: () => controller.selectedInitiator.value = null,
                searchController: null,
              ),
            ),
          ),
          const SizedBox(
            height: 20.0,
          ),
          Obx(
            () => Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppConstraints.screenPadding),
              child: SelectBlockWidget(
                label: 'tasks_label_sp'.tr,
                placeholder: 'tasks_placeholder_sp'.tr,
                items: controller.spList,
                selectedVal: controller.selectedSp.value,
                selectType: SelectType.sp,
                onChange: controller.onChange,
                error: controller.spError.value,
                processing: controller.loadingDependentData.value,
                reset: () => controller.selectedSp.value = null,
                searchController: null,
              ),
            ),
          ),
          const SizedBox(
            height: 20.0,
          ),
          Obx(
            () => Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppConstraints.screenPadding),
              child: SelectBlockWidget(
                label: 'tasks_label_stage'.tr,
                placeholder: 'tasks_placeholder_stage'.tr,
                items: controller.stageList,
                selectedVal: controller.selectedStage.value,
                selectType: SelectType.stage,
                onChange: controller.onChange,
                error: controller.stageError.value,
                processing: controller.loadingDependentData.value,
                reset: () => controller.selectedStage.value = null,
                searchController: null,
              ),
            ),
          ),
          const SizedBox(
            height: 20.0,
          ),
          Obx(
            () => Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppConstraints.screenPadding),
              child: SelectBlockWidget(
                label: 'tasks_label_module'.tr,
                placeholder: 'tasks_placeholder_module'.tr,
                items: controller.moduleList,
                selectedVal: controller.selectedModule.value,
                selectType: SelectType.module,
                onChange: controller.onChange,
                error: controller.moduleError.value,
                processing: controller.loadingDependentData.value,
                reset: () => controller.selectedModule.value = null,
                searchController: null,
              ),
            ),
          ),
          const SizedBox(
            height: 20.0,
          ),
          Obx(
            () => Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppConstraints.screenPadding),
              child: SelectBlockWidget(
                label: 'tasks_label_version'.tr,
                placeholder: 'tasks_placeholder_version'.tr,
                items: controller.versionList,
                selectedVal: controller.selectedVersion.value,
                selectType: SelectType.version,
                onChange: controller.onChange,
                error: controller.versionError.value,
                processing: controller.loadingDependentData.value,
                reset: () => controller.selectedVersion.value = null,
                searchController: null,
              ),
            ),
          ),
          const SizedBox(
            height: 20.0,
          ),
          Obx(
            () => Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppConstraints.screenPadding),
              child: SelectBlockWidget(
                label: 'tasks_label_initType'.tr,
                placeholder: 'tasks_placeholder_initType'.tr,
                items: controller.initTypeList,
                selectedVal: controller.selectedInitType.value,
                selectType: SelectType.initType,
                onChange: controller.onChange,
                error: null,
                processing: controller.loadingDependentData.value,
                reset: () => controller.selectedInitType.value = null,
                searchController: null,
              ),
            ),
          ),
          const SizedBox(
            height: 20.0,
          ),
          Obx(
            () => Column(
              children: List.generate(
                controller.selectedCoexecutors.length,
                (index) => Offstage(
                  offstage: index == 0 ? false : !controller.selectedCoexecutors[index].value.showed,
                  child: SizeTransition(
                    sizeFactor: CurvedAnimation(
                      parent: controller.selectedCoexecutors[index].value.animationController,
                      curve: Curves.fastLinearToSlowEaseIn,
                    ),
                    child: AppAnimatedListItem(
                      index: index,
                      alreadyRendered: false,
                      animationController: controller.selectedCoexecutors[index].value.animationController,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: AppConstraints.screenPadding),
                        child: CoexecutorWidget(
                          index: index,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 65.0),
        ],
      ),
    );
  }
}
