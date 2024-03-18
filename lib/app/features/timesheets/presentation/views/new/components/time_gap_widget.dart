import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rns_app/app/uikit/form_widgets/app_textfield.dart';
import 'package:rns_app/app/utils/extensions.dart';
import 'package:rns_app/app/utils/input_formatters/input_formatters.dart';
import 'package:rns_app/resources/resources.dart';

class TimeGapWidget extends StatelessWidget {
  final String label;
  final String placeholder1;
  final String placeholder2;
  final TextEditingController controller1;
  final TextEditingController controller2;
  final String? error1;
  final String? error2;
  final FocusNode focusNode1;
  final FocusNode focusNode2;

  const TimeGapWidget({
    super.key,
    required this.label,
    required this.placeholder1,
    required this.placeholder2,
    required this.controller1,
    required this.controller2,
    required this.error1,
    required this.error2,
    required this.focusNode1,
    required this.focusNode2,
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
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: AppTextField(
                hintText: placeholder1,
                labelText: placeholder1,
                textEditingController: controller1,
                focusNode: focusNode1,
                fieldError: error1 != null,
                errorMessage: error1,
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
            const SizedBox(
              width: 16.0,
            ),
            Expanded(
              child: AppTextField(
                hintText: placeholder2,
                labelText: placeholder2,
                textEditingController: controller2,
                focusNode: focusNode2,
                fieldError: error2 != null,
                errorMessage: error2,
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
      ],
    );
  }
}
