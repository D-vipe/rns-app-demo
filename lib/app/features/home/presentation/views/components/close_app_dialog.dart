import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rns_app/app/uikit/app_button.dart';
import 'package:rns_app/app/uikit/dialogs/custom_dialog.dart';
import 'package:rns_app/app/utils/extensions.dart';

class CloseAppDialog extends StatelessWidget {
  const CloseAppDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      height: 200,
      title: Text(
        'title_attention'.tr.toUpperCase(),
        style: context.textStyles.header1,
      ),
      body: Text(
        'message_confirmQuit'.tr,
        style: context.textStyles.body,
      ),
      actions: [
        AppButton(
          label: 'button_yes'.tr,
          onTap: () {
            Get.back(result: true);
          },
          processing: false,
        ),
        const SizedBox(
          width: 10.0,
        ),
        AppButton(
          label: 'button_cancel'.tr,
          processing: false,
          onTap: () {
            Get.back(result: false);
          },
        ),
      ],
      dismissable: false,
    );
  }
}
