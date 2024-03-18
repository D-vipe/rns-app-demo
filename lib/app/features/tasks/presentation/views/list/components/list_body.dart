import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rns_app/app/features/tasks/presentation/controllers/tasks_list_controller.dart';
import 'package:rns_app/app/features/tasks/presentation/views/list/components/tasks_list_item.dart';
import 'package:rns_app/app/uikit/app_animated_list_item.dart';
import 'package:rns_app/app/uikit/app_loader.dart';
import 'package:rns_app/app/uikit/empty_data_widget.dart';
import 'package:rns_app/app/uikit/slide_lists/slide_list_item.dart';
import 'package:rns_app/app/utils/extensions.dart';
import 'package:rns_app/app/utils/snackbar_service.dart';

class TasksListBody extends GetView<TasksListController> {
  const TasksListBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => controller.tasks.isEmpty
          ? EmptyDataWidget(
              message: 'tasks_error_emptyTasks'.tr,
              refresh: () => controller.refreshPage(),
            )
          : SingleChildScrollView(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  Obx(
                    () => controller.refreshing.value
                        ? Padding(
                            padding: const EdgeInsets.only(bottom: 12.0),
                            child: Loader(
                              size: 15,
                              btn: true,
                              color: context.colors.main,
                            ),
                          )
                        : const SizedBox.shrink(),
                  ),
                  IgnorePointer(
                    ignoring: controller.refreshing.value,
                    child: Obx(
                      () => Column(
                        children: List.generate(
                          controller.tasks.length,
                          (index) => GestureDetector(
                            onTap: () => controller.openDetailView(index),
                            child: SlideListItem(
                              index: index,
                              deleteAction: null, //controller.deleteTimeSheet(controller.tasks[index]),
                              // editAction: (int index) => controller.processEdit(controller.tasks[index]),
                              editAction: (int index) => Future.delayed(
                                  Duration.zero, () => SnackbarService.info('Данное действие находится в разработке.')),
                              // copyAction: (int index) => controller.processCopy(controller.tasks[index]),
                              copyAction: (int index) => Future.delayed(
                                  Duration.zero, () => SnackbarService.info('Данное действие находится в разработке.')),
                              child: AppAnimatedListItem(
                                index: index,
                                alreadyRendered: false,
                                child: TasksListItem(
                                  item: controller.tasks[index],
                                  last: controller.tasks.length - 1 == index,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Obx(
                    () => controller.isLoadingMore.value
                        ? Padding(
                            padding: const EdgeInsets.only(top: 12.0),
                            child: Loader(
                              size: 15,
                              btn: true,
                              color: context.colors.main,
                            ),
                          )
                        : const SizedBox.shrink(),
                  ),
                  const SizedBox(
                    height: 62.0,
                  ),
                ],
              ),
            ),
    );
  }
}
