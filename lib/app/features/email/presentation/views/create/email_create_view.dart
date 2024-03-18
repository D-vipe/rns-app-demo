import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rns_app/app/features/email/domain/models/receiver_type_enum.dart';
import 'package:rns_app/app/features/email/presentation/controllers/email_create_controller.dart';
import 'package:rns_app/app/features/email/presentation/views/create/components/attachments_buttons.dart';
import 'package:rns_app/app/features/email/presentation/views/create/components/attachments_list.dart';
import 'package:rns_app/app/features/email/presentation/views/create/components/delayed_inputs.dart';
import 'package:rns_app/app/features/email/presentation/views/create/components/receiver_widget.dart';
import 'package:rns_app/app/uikit/app_animated_list_item.dart';
import 'package:rns_app/app/uikit/app_button.dart';
import 'package:rns_app/app/uikit/app_loader.dart';
import 'package:rns_app/app/uikit/form_widgets/app_textfield.dart';
import 'package:rns_app/app/utils/extensions.dart';
import 'package:rns_app/configs/theme/miscellaneous.dart';

class EmailCreateView extends GetView<EmailCreateController> {
  const EmailCreateView({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(Get.context!).unfocus(),
      child: Container(
        // без этого цвета page transition выглядит немного коряво
        color: context.colors.backgroundPrimary,
        // width: double.infinity,
        child: Obx(
          () => controller.loadingData.value
              ? const Loader()
              : controller.errorMessage.value != null
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: AppConstraints.screenPadding),
                      child: Center(
                        child: Text(
                          controller.errorMessage.value ?? '',
                          style: context.textStyles.bodyBold,
                        ),
                      ),
                    )
                  : IgnorePointer(
                      ignoring: controller.sendingForm.value,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 24.0),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: AppConstraints.screenPadding),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'messages_label_sendFrom'.tr,
                                  style: context.textStyles.header2,
                                ),
                                const SizedBox(
                                  height: 6.0,
                                ),
                                AppTextField(
                                  hintText: '',
                                  labelText: 'messages_label_sendFrom'.tr,
                                  textEditingController: controller.sendFrom,
                                  errorMessage: '',
                                  fieldError: false,
                                  maxLines: 1,
                                  readOnly: true,
                                  actionButton: Icon(
                                    Icons.list,
                                    color: context.colors.main,
                                  ),
                                  actionFun: controller.openPersonalMailboxList,
                                ),
                                const SizedBox(height: 24.12),
                                const ReceiverWidget(
                                  type: ReceiverType.to,
                                ),
                              ],
                            ),
                          ),
                          Column(
                            children: List.generate(
                              controller.additionalFields.length,
                              (index) => Offstage(
                                offstage: !controller.additionalFields[index].value.showed,
                                child: SizeTransition(
                                  sizeFactor: CurvedAnimation(
                                    parent: controller.additionalFields[index].value.animationController,
                                    curve: Curves.fastLinearToSlowEaseIn,
                                  ),
                                  child: AppAnimatedListItem(
                                    index: index,
                                    alreadyRendered: false,
                                    animationController: controller.additionalFields[index].value.animationController,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: AppConstraints.screenPadding),
                                      child: ReceiverWidget(
                                        type: controller.additionalFields[index].value.type,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: AppConstraints.screenPadding),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  height: 12.0,
                                ),
                                Text(
                                  'messages_label_theme'.tr,
                                  style: context.textStyles.header2,
                                ),
                                const SizedBox(
                                  height: 6.0,
                                ),
                                AppTextField(
                                  hintText: 'messages_placeholder_theme'.tr,
                                  labelText: 'messages_label_theme'.tr,
                                  textEditingController: controller.themeController,
                                  errorMessage: '',
                                  fieldError: false,
                                  maxLines: 1,
                                ),
                                CheckboxListTile(
                                  value: controller.highImportance.value,
                                  onChanged: controller.changeImportance,
                                  title: Text(
                                    'messages_label_highImportance'.tr,
                                    style: context.textStyles.header3,
                                  ),
                                  controlAffinity: ListTileControlAffinity.leading,
                                  contentPadding: EdgeInsets.zero,
                                ),
                                Text(
                                  'messages_label_message'.tr,
                                  style: context.textStyles.header2,
                                ),
                                const SizedBox(
                                  height: 6.0,
                                ),
                                AppTextField(
                                  hintText: 'messages_placeholder_message'.tr,
                                  labelText: 'messages_label_message'.tr,
                                  textEditingController: controller.messageController,
                                  errorMessage: '',
                                  fieldError: controller.messageError.value,
                                  maxLines: 4,
                                ),
                                CheckboxListTile(
                                  value: controller.delayedSend.value,
                                  onChanged: controller.toggleDelayed,
                                  title: Text(
                                    'messages_label_delayed'.tr,
                                    style: context.textStyles.header3,
                                  ),
                                  controlAffinity: ListTileControlAffinity.leading,
                                  contentPadding: EdgeInsets.zero,
                                ),
                                DelayedInputs(controller: controller),
                                const SizedBox(
                                  height: 12.0,
                                ),
                                AttachmentsButtons(
                                  controller: controller,
                                ),
                                const SizedBox(height: 24.0),
                                const AttachmentsList(),
                                const SizedBox(height: 24.0),
                                AppButton(
                                    label: 'messages_label_send'.tr,
                                    onTap: () => controller.sendEmail(),
                                    processing: controller.sendingForm.value)
                              ],
                            ),
                          ),
                          const SizedBox(height: 24.0),
                        ],
                      ),
                    ),
        ),
      ),
    );
  }
}
