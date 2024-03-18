import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rns_app/app/uikit/form_widgets/app_textfield.dart';
// import 'package:rns_app/app/uikit/form_widgets/under_field_error.dart';
import 'package:rns_app/app/utils/extensions.dart';
import 'package:rns_app/resources/resources.dart';

class DateBlockWidget extends StatelessWidget {
  final String label;
  final String placeholder;
  final String? error;
  final TextEditingController dateController;
  final DateTime? date;
  final void Function() datePick;

  const DateBlockWidget({
    super.key,
    required this.label,
    required this.placeholder,
    this.error,
    required this.datePick,
    required this.dateController,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label.isNotEmpty)
          Text(
            label,
            style: context.textStyles.header2,
          ),

        const SizedBox(
          height: 6.0,
        ),
        GestureDetector(
          onTap: datePick,
          child: AppTextField(
            textEditingController: dateController,
            labelText: placeholder,
            enabled: false,
            fieldError: error != null,
            errorMessage: error,
            actionButton: SvgPicture.asset(AppIcons.dateSingle),
          ),
        ),
        // UnderFiledError(error: error),
      ],
    );
  }
}
