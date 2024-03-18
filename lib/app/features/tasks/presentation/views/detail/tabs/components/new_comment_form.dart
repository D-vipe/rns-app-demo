import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rns_app/app/features/tasks/presentation/controllers/detail_tabs/comment_tab_controller.dart';
import 'package:rns_app/app/uikit/app_button.dart';
import 'package:rns_app/app/uikit/form_widgets/app_textfield.dart';
import 'package:rns_app/app/utils/extensions.dart';
import 'package:rns_app/configs/theme/miscellaneous.dart';

class NewCommentFormWidget extends GetView<CommentTabController> {
  const NewCommentFormWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Container(
          height: 250.0,
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstraints.screenPadding,
            vertical: 25.0,
          ),
          decoration: BoxDecoration(
            color: Get.context!.colors.backgroundPrimary,
            // backgroundBlendMode: BlendMode.color,
          ),
          child: Obx(
            () => Column(
              children: [
                AppTextField(
                  hintText: 'tasks_placeholder_comment'.tr,
                  labelText: 'tasks_label_comment'.tr,
                  textEditingController: controller.commentController,
                  errorMessage: controller.commentError.value,
                  fieldError: controller.commentError.value.isNotEmpty,
                  maxLines: 3,
                ),
                const Spacer(),
                AppButton(
                  label: 'button_add'.tr,
                  onTap: controller.addNewComment,
                  processing: controller.addingComment.value,
                ),
              ],
            ),
          ),
        ),
      );
  }
}
