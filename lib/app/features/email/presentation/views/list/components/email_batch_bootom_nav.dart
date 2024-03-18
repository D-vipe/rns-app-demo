import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rns_app/app/features/email/presentation/controllers/email_list_controller.dart';
import 'package:rns_app/app/features/home/presentation/views/components/bottom_navigation/default_botom_nav.dart';
import 'package:rns_app/app/utils/extensions.dart';

class EmailBatchBottomNav extends DefaultBottomNav {
  const EmailBatchBottomNav({super.key});

  @override
  Widget build(BuildContext context) {
    final EmailListController controller = EmailListController.to;

    return Obx(
      () => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: controller.selectedEmails.isEmpty ? null : () => controller.batchRead(),
            child: Text(
              controller.readActionName(),
              style: context.textStyles.bodyBold.copyWith(
                color: context.colors.backgroundPrimary.withOpacity(controller.selectedEmails.isEmpty ? 0.5 : 1.0),
              ),
            ),
          ),
          GestureDetector(
            onTap: controller.selectedEmails.isEmpty ? null : () => controller.batchDelete(),
            child: Text(
              'messages_button_delete'.tr.toUpperCase(),
              style: context.textStyles.bodyBold.copyWith(
                color: context.colors.backgroundPrimary.withOpacity(controller.selectedEmails.isEmpty ? 0.5 : 1.0),
              ),
            ),
          ),
          GestureDetector(
            onTap: () => controller.toggleBatchMode(),
            child: Text(
              'button_cancelBatch'.tr.toUpperCase(),
              style: context.textStyles.bodyBold.copyWith(
                color: context.colors.backgroundPrimary,
              ),
            ),
          )
        ],
      ),
    );
  }
}
