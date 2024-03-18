import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rns_app/app/features/tasks/presentation/controllers/form_tabs/form_general_tab_controller.dart';
import 'package:rns_app/app/features/tasks/presentation/controllers/tasks_create_controller.dart';
import 'package:rns_app/app/uikit/app_button.dart';
import 'package:rns_app/app/uikit/app_loader.dart';
import 'package:rns_app/app/utils/extensions.dart';
import 'package:rns_app/configs/theme/miscellaneous.dart';

class TasksCreateView extends GetView<TasksCreateController> {
  const TasksCreateView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => IgnorePointer(
        ignoring: controller.processingForm.value,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Stack(
            children: [
              Container(
                // без этого цвета page transition выглядит немного коряво
                color: context.colors.backgroundPrimary,
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.center,
                      color: Get.context!.colors.inputBackground,
                      width: double.infinity,
                      height: 48.0,
                      child: TabBar(
                        padding: EdgeInsets.zero,
                        isScrollable: false,
                        tabs: List.generate(
                          controller.tabController.length,
                          (index) => Tab(
                            text: controller.tabTitles[index],
                            // child: controller.formTabs[index],
                          ),
                        ),
                        controller: controller.tabController,
                        // labelPadding: EdgeInsets.zero,
                      ),
                    ),
                    GeneralFormTabController.to.loadingData.value
                        ? const Expanded(child: Loader())
                        : Expanded(
                            flex: 1,
                            child: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 300),
                              child: controller.formTabs[controller.currentTabIndex.value],
                            ),
                          ),
                  ],
                ),
              ),
              Positioned(
                bottom: 25.0,
                left: AppConstraints.screenPadding,
                right: AppConstraints.screenPadding,
                child: Obx(
                  () => AnimatedOpacity(
                    opacity: controller.hideActionButton.value ? 0 : 1,
                    duration: const Duration(milliseconds: 400),
                    child: IgnorePointer(
                      ignoring: controller.hideActionButton.value,
                      child: AppButton(
                        label: 'button_save'.tr,
                        onTap: controller.saveTask,
                        processing: controller.processingForm.value,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
