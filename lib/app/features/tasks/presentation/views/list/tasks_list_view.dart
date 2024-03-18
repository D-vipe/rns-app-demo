import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rns_app/app/features/tasks/presentation/controllers/tasks_list_controller.dart';
import 'package:rns_app/app/features/tasks/presentation/views/list/components/list_body.dart';
import 'package:rns_app/app/uikit/app_loader.dart';
import 'package:rns_app/app/utils/extensions.dart';

class TasksListView extends GetView<TasksListController> {
  const TasksListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      // без этого цвета page transition выглядит немного коряво
      color: context.colors.backgroundPrimary,
      child: Obx(
        () => controller.loadingData.value
            ? const Loader()
            : controller.loadingError.value
                ? Center(
                    child: Text(
                      controller.errorMessage,
                      style: context.textStyles.bodyBold,
                    ),
                  )
                : const TasksListBody(),
      ),
    );
  }
}
