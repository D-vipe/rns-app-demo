import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:rns_app/app/uikit/form_widgets/app_textfield.dart';
import 'package:rns_app/app/utils/extensions.dart';
import 'package:rns_app/app/utils/input_formatters/input_formatters.dart';
import 'package:rns_app/resources/resources.dart';

class PlannedTimeWidget extends StatelessWidget {
  final TextEditingController inputController;
  final String label;
  final FocusNode focusNode;
  const PlannedTimeWidget({
    super.key,
    required this.inputController,
    required this.label,
    required this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          label,
          style: context.textStyles.header2,
        ),
        const SizedBox(
          height: 6.0,
        ),
        AppTextField(
          hintText: 'messages_placeholder_timeDelayed'.tr,
          labelText: 'messages_placeholder_timeDelayed'.tr,
          textEditingController: inputController,
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
            TimeTextInputFormatter(hourMaxValue: 999, minuteMaxValue: 59),
          ],
        ),
      ],
    );
  }
}
