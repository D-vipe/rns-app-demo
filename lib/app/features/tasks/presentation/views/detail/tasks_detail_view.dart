import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rns_app/app/features/tasks/presentation/controllers/tasks_detail_controller.dart';
import 'package:rns_app/app/uikit/app_loader.dart';
import 'package:rns_app/app/utils/extensions.dart';

class TasksDetailView extends GetView<TasksDetailController> {
  const TasksDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      // без этого цвета page transition выглядит немного коряво
      color: context.colors.backgroundPrimary,
      child: Column(
        children: [
          Container(
            alignment: Alignment.center,
            color: Get.context!.colors.inputBackground,
            width: double.infinity,
            height: 48.0,
            child: Obx(
              () => TabBar(
                padding: EdgeInsets.zero,
                isScrollable: true,
                tabs: List.generate(
                  controller.tabController.length,
                  (index) => Tab(
                    text: controller.getTabCounter(index),
                  ),
                ),
                controller: controller.tabController,
                // labelPadding: EdgeInsets.zero,
              ),
            ),
          ),
          Obx(
            () => controller.loadingData.value
                ? const Expanded(child: Loader())
                : controller.loadingError.value
                    ? Expanded(
                        child: Center(
                          child: Text(
                            controller.errorMessage,
                            style: context.textStyles.bodyBold,
                          ),
                        ),
                      )
                    : AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        child: controller.detailTabs[controller.currentTabIndex.value],
                      ),
          ),
        ],
      ),
    );
  }
}
