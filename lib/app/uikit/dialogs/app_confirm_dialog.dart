import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rns_app/app/uikit/dialogs/custom_dialog.dart';
import 'package:rns_app/app/utils/extensions.dart';

class AppConfirmDialog extends StatelessWidget {
  const AppConfirmDialog({
    super.key,
    required this.message,
    required this.confirmLabel,
    required this.cancelLabel,
    this.title,
    this.dismissible,
    this.height,
  });

  final String? title;
  final String message;
  // confirm button label
  final String confirmLabel;
  // cancel button label
  final String cancelLabel;
  final bool? dismissible;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      height: height,
      title: Text(
        title ?? 'title_attention'.tr,
        style: context.textStyles.header1,
      ),
      body: Text(
        message,
        style: context.textStyles.body,
      ),
      actions: [
        TextButton(
          onPressed: () => Get.back(result: false),
          child: Text(cancelLabel.toUpperCase(), style: context.textStyles.bodyBold,),
        ),
        const SizedBox(
          width: 10.0,
        ),
        TextButton(
          onPressed: () => Get.back(result: true),
          child: Text(confirmLabel.toUpperCase(), style: context.textStyles.bodyBold,),
        ),
      ],
      dismissable: dismissible ?? true,
    );
  }
}
