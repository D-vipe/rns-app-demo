import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rns_app/app/uikit/form_widgets/app_textfield.dart';
import 'package:rns_app/app/uikit/form_widgets/under_field_error.dart';
import 'package:rns_app/app/utils/extensions.dart';
import 'package:rns_app/resources/resources.dart';

class ExtendedSelectButton extends StatelessWidget {
  final String label;
  final String placeholder;
  final String? error;
  final TextEditingController textController;
  final void Function() onTap;
  const ExtendedSelectButton({
    super.key,
    required this.label,
    required this.placeholder,
    this.error,
    required this.textController,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: context.textStyles.header2,
        ),
        const SizedBox(
          height: 6.0,
        ),
        GestureDetector(
          onTap: onTap,
          child: AppTextField(
            textEditingController: textController,
            labelText: placeholder,
            enabled: false,
            actionButton: SvgPicture.asset(AppIcons.expandMore),
          ),
        ),
        UnderFiledError(error: error),
      ],
    );
  }
}
