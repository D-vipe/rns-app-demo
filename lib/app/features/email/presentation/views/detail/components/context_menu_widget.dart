import 'package:flutter/material.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:rns_app/app/features/email/presentation/controllers/email_detail_controller.dart';
import 'package:rns_app/app/utils/extensions.dart';

class ContextMenuWidget extends StatelessWidget {
  const ContextMenuWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          margin: const EdgeInsets.only(top: 42.0, right: 8.0),
          decoration: BoxDecoration(
            color: context.colors.background,
            borderRadius: BorderRadius.circular(4.0),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextButton(
                onPressed: () => EmailDetailController.to.replyTo(false),
                child: Text(
                  'messages_contextMenu_reply'.tr,
                  style: context.textStyles.header3.copyWith(color: context.colors.backgroundPrimary),
                ),
              ),
              TextButton(
                onPressed: () => EmailDetailController.to.replyTo(true),
                child: Text(
                  'messages_contextMenu_replyAll'.tr,
                  style: context.textStyles.header3.copyWith(color: context.colors.backgroundPrimary),
                ),
              ),
              TextButton(
                onPressed: EmailDetailController.to.forwardMail,
                child: Text(
                  'messages_contextMenu_forward'.tr,
                  style: context.textStyles.header3.copyWith(color: context.colors.backgroundPrimary),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
