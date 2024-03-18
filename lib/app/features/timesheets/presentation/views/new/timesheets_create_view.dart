import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rns_app/app/features/timesheets/presentation/controllers/ts_create_controller.dart';
import 'package:rns_app/app/features/timesheets/presentation/views/new/components/time_gap_widget.dart';
import 'package:rns_app/app/uikit/app_button.dart';
import 'package:rns_app/app/uikit/app_loader.dart';
import 'package:rns_app/app/uikit/form_widgets/app_textfield.dart';
import 'package:rns_app/app/uikit/form_widgets/date_block_widget.dart';
import 'package:rns_app/app/uikit/general_models/select_types.dart';
import 'package:rns_app/app/uikit/form_widgets/select/select_block_widget.dart';
import 'package:rns_app/app/utils/extensions.dart';
import 'package:rns_app/configs/theme/miscellaneous.dart';

class TimesheetsCreateView extends GetView<TsCreateController> {
  const TimesheetsCreateView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => IgnorePointer(
        ignoring: controller.processingForm.value || controller.preparingFromCopiedTsItem.value,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Stack(
            children: [
              Container(
                // без этого цвета page transition выглядит немного коряво
                color: context.colors.backgroundPrimary,
                padding: const EdgeInsets.only(
                  left: AppConstraints.screenPadding,
                  right: AppConstraints.screenPadding,
                ),
                child: SingleChildScrollView(
                  controller: controller.scrollController,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 16.0,
                      ),
                      Obx(
                        () => SelectBlockWidget(
                          label: 'timeSheets_labelProject'.tr,
                          placeholder: 'timeSheets_hintProject'.tr,
                          items: controller.projects,
                          selectedVal: controller.selectedProject.value,
                          selectType: SelectType.project,
                          onChange: controller.onChange,
                          searchController: controller.searchController,
                          error: controller.projectError.value,
                          processing: controller.fetchingProjects.value,
                          reset: controller.dropSelectedProject,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      GestureDetector(
                        onTap: () => controller.disabledSelectWarning(SelectType.task),
                        child: Obx(
                          () => SelectBlockWidget(
                            label: 'timeSheets_labelTask'.tr,
                            placeholder: 'timeSheets_hintTask'.tr,
                            items: controller.tasks,
                            selectedVal: controller.selectedTask.value,
                            selectType: SelectType.task,
                            onChange: controller.onChange,
                            searchController: controller.searchController,
                            error: controller.taskError.value,
                            processing: controller.fetchingTasks.value,
                            reset: () => controller.selectedTask.value = null,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      GestureDetector(
                        onTap: () => controller.disabledSelectWarning(SelectType.activity),
                        child: Obx(
                          () => SelectBlockWidget(
                            label: 'timeSheets_labelActivity'.tr,
                            placeholder: 'timeSheets_hintActivity'.tr,
                            items: controller.activities,
                            selectedVal: controller.selectedActivity.value,
                            selectType: SelectType.activity,
                            onChange: controller.onChange,
                            searchController: controller.searchController,
                            error: controller.activityError.value,
                            processing: controller.fetchingActivities.value,
                            reset: () => controller.selectedActivity.value = null,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 26,
                      ),
                      Obx(
                        () => DateBlockWidget(
                          label: 'timeSheets_labelDate'.tr,
                          placeholder: 'timeSheets_hintDate'.tr,
                          datePick: controller.pickDate,
                          dateController: controller.dateController,
                          date: controller.date.value,
                          error: controller.dateError.value,
                        ),
                      ),
                      const SizedBox(
                        height: 26,
                      ),
                      Obx(
                        () => TimeGapWidget(
                          label: 'timeSheets_labelTimeGap'.tr,
                          controller1: controller.timeStartController,
                          controller2: controller.timeEndController,
                          placeholder1: 'placeHolder_dateFrom'.tr,
                          placeholder2: 'placeHolder_dateTo'.tr,
                          error1: controller.timeGapError1.value,
                          error2: controller.timeGapError2.value,
                          focusNode1: controller.timeStartFN,
                          focusNode2: controller.timeEndFN,
                        ),
                      ),
                      const SizedBox(
                        height: 26,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'timeSheets_labelDescription'.tr,
                            style: context.textStyles.header2,
                          ),
                          const SizedBox(
                            height: 6.0,
                          ),
                          AppTextField(
                            focusNode: controller.descriptionFN,
                            hintText: 'timeSheets_hintDescription'.tr,
                            labelText: 'timeSheets_hintDescription'.tr,
                            textEditingController: controller.descriptionController,
                            maxLines: 3,
                          ),
                          const SizedBox(
                            height: 65.0,
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: 15.0,
                right: 16.0,
                left: 16.0,
                child: Obx(
                  () => AppButton(
                    label: 'button_save'.tr,
                    onTap: controller.createNewTS,
                    processing: controller.processingForm.value,
                  ),
                ),
              ),
              if (controller.preparingFromCopiedTsItem.value)
                Positioned(
                  child: Container(
                    color: context.colors.backgroundPrimary.withOpacity(.5),
                    child: const Loader(
                      size: 15,
                      btn: true,
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
