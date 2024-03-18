import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:rns_app/app/features/tasks/presentation/controllers/form_tabs/form_date_tab_controller.dart';
import 'package:rns_app/app/uikit/form_widgets/app_textfield.dart';
import 'package:rns_app/app/uikit/form_widgets/date_block_widget.dart';
import 'package:rns_app/app/utils/extensions.dart';
import 'package:rns_app/app/utils/input_formatters/input_formatters.dart';
import 'package:rns_app/resources/resources.dart';

class DateTimeInputs extends GetView<DateFormTabController> {
  final String dateLabel;
  final TextEditingController dateTextController;
  final TextEditingController timeTextController;
  final Rxn<DateTime> dateTime;
  final Rxn<String> error;
  final FocusNode? focusNode;
  const DateTimeInputs({
    super.key,
    required this.dateLabel,
    required this.dateTime,
    required this.dateTextController,
    required this.timeTextController,
    required this.error,
    required this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: Get.width / 2 - 22,
          child: Obx(
            () => DateBlockWidget(
              label: dateLabel,
              placeholder: 'placeHolder_chooseDate'.tr,
              datePick: () => controller.pickDate(dateTime, dateTextController),
              dateController: dateTextController,
              date: dateTime.value,
              error: error.value,
            ),
          ),
        ),
        const SizedBox(
          width: 12.0,
        ),
        SizedBox(
          width: Get.width / 2 - 22,
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
              AppTextField(
                hintText: 'messages_placeholder_timeDelayed'.tr,
                labelText: 'messages_placeholder_timeDelayed'.tr,
                textEditingController: timeTextController,
                focusNode: focusNode,
                fieldError: false,
                errorMessage: '',
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
            ],
          ),
        )
      ],
    );
  }
}
