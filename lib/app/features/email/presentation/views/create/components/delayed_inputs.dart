import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:rns_app/app/features/email/presentation/controllers/email_create_controller.dart';
import 'package:rns_app/app/uikit/form_widgets/app_textfield.dart';
import 'package:rns_app/app/uikit/form_widgets/date_block_widget.dart';
import 'package:rns_app/app/utils/extensions.dart';
import 'package:rns_app/app/utils/input_formatters/input_formatters.dart';
import 'package:rns_app/resources/resources.dart';

class DelayedInputs extends StatelessWidget {
  const DelayedInputs({
    super.key,
    required this.controller,
  });

  final EmailCreateController controller;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: Get.width / 2 - 22,
          child: Offstage(
            offstage: !controller.delayedSend.value,
            child: SizeTransition(
              sizeFactor: CurvedAnimation(
                parent: controller.dateAnimation,
                curve: Curves.fastLinearToSlowEaseIn,
              ),
              child: Obx(
                () => DateBlockWidget(
                  label: 'messages_label_delayedDate'.tr,
                  placeholder: 'messages_placeholder_delayedDate'.tr,
                  datePick: controller.pickDate,
                  dateController: controller.dateController,
                  date: controller.date.value,
                  error: controller.dateError.value,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(
          width: 12.0,
        ),
        SizedBox(
          width: Get.width / 2 - 22,
          child: Offstage(
            offstage: !controller.delayedSend.value,
            child: SizeTransition(
              sizeFactor: CurvedAnimation(
                parent: controller.dateAnimation,
                curve: Curves.fastLinearToSlowEaseIn,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'messages_label_delayedTime'.tr,
                    style: context.textStyles.header2,
                  ),
                  const SizedBox(
                    height: 6.0,
                  ),
                  Obx(
                    () => AppTextField(
                      hintText: 'messages_placeholder_timeDelayed'.tr,
                      labelText: 'messages_placeholder_timeDelayed'.tr,
                      textEditingController: controller.timeController,
                      focusNode: null,
                      fieldError: controller.timeDelayedError.value != null,
                      errorMessage: controller.timeDelayedError.value,
                      actionButton: SvgPicture.asset(
                        AppIcons.queryBuilder,
                        width: 24.0,
                        height: 24.0,
                        colorFilter: ColorFilter.mode(
                          context.colors.background,
                          BlendMode.srcIn,
                        ),
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        TimeTextInputFormatter(hourMaxValue: 23, minuteMaxValue: 59),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}
