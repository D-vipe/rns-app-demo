import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rns_app/app/features/home/presentation/controllers/home_logic_controller.dart';
import 'package:rns_app/app/features/home/presentation/views/widgets/current_plan_table_row.dart';
import 'package:rns_app/app/utils/extensions.dart';

class CurrentPlanTable extends GetView<HomeLogicController> {
  const CurrentPlanTable({super.key});

  String _twoDigits(int n) => n >= 10 ? '$n' : '0$n';

  String _durationFormat(Duration value) {
    return '${value.inHours}:${_twoDigits(value.inMinutes.remainder(60).abs())}';
  }

  @override
  Widget build(BuildContext context) {
    final tableBorderSide = BorderSide(color: context.colors.tableDividerColor);
    return Column(
      children: [
        Obx(
          () {
            return Table(
              columnWidths: const {
                0: FlexColumnWidth(4),
                2: FlexColumnWidth(1),
                4: FlexColumnWidth(1),
              },
              border: TableBorder(
                top: tableBorderSide,
                bottom: tableBorderSide,
                horizontalInside: tableBorderSide,
                verticalInside: tableBorderSide,
              ),
              children: List.generate((controller.plan.value?.projects.length ?? 0) + 1, (index) {
                if (index == 0) {
                  return CurrentPlanTableRow(
                    context: context,
                    color: context.colors.main,
                    style: context.textStyles.bodyBoldOnSurface,
                    title: 'home_project'.tr,
                    plan: 'home_plan'.tr,
                    fact: 'home_fact'.tr,
                  );
                }
                return CurrentPlanTableRow(
                  context: context,
                  color: index % 2 == 0 ? context.colors.inputBackground : context.colors.backgroundPrimary,
                  style: context.textStyles.bodyBold,
                  title: controller.plan.value!.projects[index - 1].title,
                  plan: _durationFormat(controller.plan.value!.projects[index - 1].planTime),
                  fact: _durationFormat(controller.plan.value!.projects[index - 1].factTime),
                );
              }),
            );
          },
        ),
      ],
    );
  }
}
