import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rns_app/app/features/email/domain/models/receiver_type_enum.dart';
import 'package:rns_app/app/features/email/presentation/controllers/email_create_controller.dart';
import 'package:rns_app/app/uikit/form_widgets/app_textfield.dart';
import 'package:rns_app/app/utils/extensions.dart';

class ReceiverWidget extends GetView<EmailCreateController> {
  final ReceiverType type;
  const ReceiverWidget({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          type.displayTitle,
          style: context.textStyles.header3,
        ),
        const SizedBox(
          height: 6.0,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: type == ReceiverType.to
                  ? Obx(() => AppTextField(
                        hintText: '',
                        labelText: 'messages_label_selectReceiver'.tr,
                        textEditingController: controller.sendTo,
                        errorMessage: controller.sendToError.value ? 'error_needInput'.tr : '',
                        fieldError: controller.sendToError.value,
                        maxLines: 1,
                        readOnly: false,
                        actionButton: Icon(
                          Icons.list,
                          color: context.colors.main,
                        ),
                        actionFun: () => controller.openEmployeeMailboxList(type),
                      ))
                  : AppTextField(
                      hintText: '',
                      labelText: 'messages_label_selectReceiver'.tr,
                      textEditingController: type == ReceiverType.copy ? controller.copyTo : controller.secretCopyTo,
                      errorMessage: '',
                      fieldError: false,
                      maxLines: 1,
                      readOnly: false,
                      actionButton: Icon(
                        Icons.list,
                        color: context.colors.main,
                      ),
                      actionFun: () => controller.openEmployeeMailboxList(type),
                    ),
            ),
            const SizedBox(
              width: 10.0,
            ),
            Material(
              child: Ink(
                decoration: ShapeDecoration(
                  color: context.colors.buttonActive,
                  shape: const CircleBorder(),
                ),
                child: IconButton(
                  onPressed: type == ReceiverType.to
                      ? controller.addAdditionalFields
                      : () => controller.removeAdditionalField(type),
                  icon: Icon(
                    type == ReceiverType.to ? Icons.add : Icons.remove,
                    color: context.colors.white,
                    size: 14.0,
                  ),
                ),
              ),
            )
          ],
        ),
      ],
    );
  }
}
