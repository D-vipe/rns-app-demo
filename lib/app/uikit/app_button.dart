import 'package:flutter/material.dart';
import 'package:rns_app/app/uikit/app_loader.dart';
import 'package:rns_app/app/utils/extensions.dart';

class AppButton extends StatelessWidget {
  final String label;
  final Function? onTap;
  final bool processing;
  final bool? disabled;

  const AppButton({
    super.key,
    required this.label,
    required this.onTap,
    required this.processing,
    this.disabled,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36.0,
      child: OutlinedButton(
        onPressed: (processing || disabled == true) ? null : (() => onTap != null ? onTap!() : null),
        child: processing
            ? const Loader(
                size: 18,
                btn: true,
              )
            : Text(
                label,
                style: context.textStyles.button,
              ),
      ),
    );
  }
}
