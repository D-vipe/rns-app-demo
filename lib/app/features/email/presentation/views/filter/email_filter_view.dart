import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rns_app/app/features/email/presentation/controllers/email_controller.dart';
import 'package:rns_app/app/features/email/presentation/controllers/email_filter_controller.dart';
import 'package:rns_app/app/features/email/presentation/views/filter/components/email_importance_chip.dart';
import 'package:rns_app/app/uikit/app_button.dart';
import 'package:rns_app/app/uikit/form_widgets/app_textfield.dart';
import 'package:rns_app/app/uikit/form_widgets/date_block_widget.dart';
import 'package:rns_app/app/uikit/form_widgets/select/extended_select_button.dart';
import 'package:rns_app/app/utils/extensions.dart';
import 'package:rns_app/configs/theme/miscellaneous.dart';

class EmailFilterView extends GetView<EmailFilterController> {
  const EmailFilterView({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(Get.context!).unfocus(),
      child: Container(
        color: context.colors.backgroundPrimary,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstraints.screenPadding,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24.0),
              Text(
                'messages_label_searchTitle'.tr,
                style: context.textStyles.header2,
              ),
              const SizedBox(
                height: 6.0,
              ),
              AppTextField(
                textEditingController: controller.searchTermController,
                labelText: 'messages_placeholder_seachTitle'.tr,
                actionButton: null,
              ),
              const SizedBox(
                height: 24.0,
              ),
              Text(
                'messages_label_searchDate'.tr,
                style: context.textStyles.header2,
              ),
              Row(
                children: [
                  SizedBox(
                    width: Get.width / 2 - 22,
                    child: Obx(
                      () => DateBlockWidget(
                        label: '',
                        placeholder: 'placeHolder_dateFrom'.tr,
                        datePick: () => controller.pickDate(),
                        dateController: controller.startDateController,
                        date: controller.selectedStartDate.value,
                        error: controller.startDateError.value,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12.0),
                  SizedBox(
                    width: Get.width / 2 - 22,
                    child: Obx(
                      () => DateBlockWidget(
                        label: '',
                        placeholder: 'placeHolder_dateTo'.tr,
                        datePick: () => controller.pickDate(beginPeriod: false),
                        dateController: controller.endDateController,
                        date: controller.selectedEndDate.value,
                        error: controller.endDateError.value,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 24.0,
              ),
              ExtendedSelectButton(
                label: 'messages_label_searchRecepient'.tr,
                placeholder: 'messages_placeholder_searchRecepient'.tr,
                textController: controller.selectedUserController,
                onTap: controller.openExtendedSelectModal,
                error: null,
              ),
              if (EmailController.to.incoming) const EmailImportanceChip(),
              const SizedBox(
                height: 24.0,
              ),
              Obx(
                () => Row(
                  children: [
                    Switch(
                        value: controller.onlyUnread.value,
                        onChanged: (bool value) => controller.onlyUnread.value = value),
                    const SizedBox(
                      width: 12.0,
                    ),
                    Text(
                      'messages_label_onlyUnread'.tr,
                      style: Get.context!.textStyles.body,
                    )
                  ],
                ),
              ),
              const Spacer(),
              Obx(
                () => AnimatedOpacity(
                  duration: const Duration(milliseconds: 800),
                  opacity: controller.animationsFinished.value ? 1 : 0,
                  child: AppButton(
                    label: 'messages_button_applyFilters'.tr,
                    onTap: controller.applyFilters,
                    processing: controller.applyingFilters.value,
                  ),
                ),
              ),
              const SizedBox(height: 25.0),
            ],
          ),
        ),
      ),
    );
  }
}
