import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rns_app/app/features/tasks/presentation/controllers/form_tabs/form_date_tab_controller.dart';
import 'package:rns_app/app/features/tasks/presentation/views/create/components/date_time_input.dart';
import 'package:rns_app/app/features/tasks/presentation/views/create/components/planned_time_widget.dart';
import 'package:rns_app/configs/theme/miscellaneous.dart';

class DateFormTab extends GetView<DateFormTabController> {
  const DateFormTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.height,
      padding: const EdgeInsets.symmetric(horizontal: AppConstraints.screenPadding),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        controller: controller.scrollController,
        child: Column(
          // mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 24.0,
            ),
            DateTimeInputs(
              dateLabel: 'tasks_label_deadlineCreate'.tr,
              dateTime: controller.deadlineDate,
              dateTextController: controller.deadlineDateController,
              timeTextController: controller.deadlineTimeController,
              error: controller.deadlineDateError,
              focusNode: controller.deadlineDateFocus,
            ),
            const SizedBox(height: 12.0),
            DateTimeInputs(
              dateLabel: 'tasks_label_plannedDateStart'.tr,
              dateTime: controller.plannedStartDate,
              dateTextController: controller.plannedStartDateController,
              timeTextController: controller.plannedStartimeController,
              error: Rxn(null),
              focusNode: controller.plannedstartDateFocus,
            ),
            const SizedBox(height: 12.0),
            PlannedTimeWidget(
              label: 'tasks_label_plannedTine'.tr,
              inputController: controller.totalTimeController,
              focusNode: controller.plannedTimeFocus,
            ),
            const SizedBox(height: 12.0),
            PlannedTimeWidget(
              label: 'tasks_label_developmentTime'.tr,
              inputController: controller.totalDevelopmentTimeController,
              focusNode: controller.developmentTimeFocus,
            ),
            const SizedBox(height: 12.0),
            PlannedTimeWidget(
              label: 'tasks_label_testingTime'.tr,
              inputController: controller.totalTestTimeController,
              focusNode: controller.testingTimeFocus,
            ),
            const SizedBox(height: 65.0),
          ],
        ),
      ),
    );
  }
}
