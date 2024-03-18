import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rns_app/app/features/tasks/presentation/controllers/form_tabs/form_general_tab_controller.dart';
import 'package:rns_app/app/uikit/form_widgets/select/select_block_widget.dart';
import 'package:rns_app/app/uikit/general_models/select_types.dart';
import 'package:rns_app/app/utils/extensions.dart';

class CoexecutorWidget extends GetView<GeneralFormTabController> {
  final int index;
  const CoexecutorWidget({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Obx(
                () => SelectBlockWidget(
                  label: index == 0 ? 'tasks_label_coExecutors'.tr : '',
                  placeholder: 'tasks_placeholder_coExecutor'.tr,
                  items: controller.executorsList,
                  selectedVal: controller.selectedCoexecutors[index].value.data,
                  selectType: SelectType.coexecutor,
                  onChange: (value, _) => controller.onCoexecutorSelect(value, index),
                  error: controller.projectError.value,
                  processing: controller.loadingDependentData.value,
                  reset: () => controller.coexecutorDrop(index),
                  searchController: null,
                ),
              ),
            ),
            const SizedBox(
              width: 10.0,
            ),
            Container(
              margin: const EdgeInsets.only(top: 5.0),
              child: Material(
                child: Obx(
                  () => Ink(
                    decoration: ShapeDecoration(
                      color: controller.executorsList.isEmpty
                          ? context.colors.inputBackground
                          : context.colors.buttonActive,
                      shape: const CircleBorder(),
                    ),
                    child: IconButton(
                      onPressed: index == 0 ? controller.addNewCoexecutor : () => controller.removeCoexecutor(index),
                      icon: Icon(
                        index == 0 ? Icons.add : Icons.remove,
                        color: context.colors.white,
                        size: 14.0,
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ],
    );
  }
}
