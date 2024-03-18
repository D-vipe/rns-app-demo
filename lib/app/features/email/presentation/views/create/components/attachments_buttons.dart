import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rns_app/app/features/email/presentation/controllers/email_create_controller.dart';
import 'package:rns_app/app/uikit/app_button.dart';

class AttachmentsButtons extends StatelessWidget {
  const AttachmentsButtons({
    super.key,
    required this.controller,
  });

  final EmailCreateController controller;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: Get.width / 2 - 22,
          child: AppButton(
            label: 'messages_label_chooseAttachment'.tr,
            onTap: controller.pickFiles,
            processing: false,
          ),
        ),
        const SizedBox(
          width: 12.0,
        ),
        SizedBox(
          width: Get.width / 2 - 22,
          child: AppButton(
            label: 'messages_label_choosePhoto'.tr,
            onTap: controller.pickPhoto,
            processing: false,
          ),
        ),
      ],
    );
  }
}
