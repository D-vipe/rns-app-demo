import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rns_app/app/features/timesheets/presentation/controllers/ts_filter_controller.dart';
import 'package:rns_app/app/uikit/app_button.dart';
import 'package:rns_app/app/uikit/form_widgets/date_block_widget.dart';
import 'package:rns_app/app/uikit/form_widgets/select/extended_select_button.dart';
import 'package:rns_app/app/utils/extensions.dart';
import 'package:rns_app/configs/theme/miscellaneous.dart';

class TimesheetsFilterView extends GetView<TSFilterController> {
  const TimesheetsFilterView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      // без этого цвета page transition выглядит немного коряво
      color: context.colors.backgroundPrimary,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstraints.screenPadding,
        ),
        child: Obx(
          () => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24.0),
              DateBlockWidget(
                label: 'timeSheets_labelDate'.tr,
                placeholder: 'timeSheets_hintDate'.tr,
                datePick: controller.pickDate,
                dateController: controller.dateController,
                date: controller.date.value,
                error: controller.dateError.value,
              ),
              ExtendedSelectButton(
                label: 'timeSheets_projectEmployer'.tr,
                placeholder: 'timeSheets_chooseEmployer'.tr,
                textController: controller.employerController,
                onTap: controller.openExtendedSelectModal,
                error: controller.executorError.value,
              ),
              const Spacer(),
              AppButton(
                label: 'timeSheets_show'.tr,
                onTap: controller.applyFilters,
                processing: controller.applyingFilters.value,
              ),
              const SizedBox(height: 25.0),
            ],
          ),
        ),
      ),
    );
  }
}
