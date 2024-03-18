import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rns_app/app/features/email/presentation/controllers/email_create_controller.dart';
import 'package:rns_app/app/uikit/app_animated_list_item.dart';
import 'package:rns_app/app/utils/extensions.dart';
import 'package:rns_app/app/utils/helper_utils.dart';
import 'package:rns_app/configs/theme/app_decorations.dart';
import 'package:rns_app/resources/resources.dart';

class AttachmentsList extends GetView<EmailCreateController> {
  const AttachmentsList({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Column(
        children: List.generate(
          controller.pickedFiles.length,
          (index) => AppAnimatedListItem(
            index: index,
            alreadyRendered: false,
            child: Container(
              padding: const EdgeInsets.all(8.0),
              margin: const EdgeInsets.only(bottom: 8.0),
              decoration: AppDecorations.attachmentItem(context),
              child: Row(
                children: [
                  Image.asset(
                    HelperUtils.getFileIconFromNameExtension(controller.pickedFiles[index].fileName) ?? AppIcons.doc,
                    width: 28.0,
                    height: 28.0,
                  ),
                  const SizedBox(
                    width: 8.0,
                  ),
                  Text(
                    HelperUtils.shortenFileName(controller.pickedFiles[index].fileName),
                    style: context.textStyles.header3,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(
                    width: 8.0,
                  ),
                  if (controller.pickedFiles[index].fileSize != null)
                    Text(
                      controller.pickedFiles[index].fileSize!,
                      style: context.textStyles.body.copyWith(color: context.colors.background),
                    ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () => controller.removePickedFile(index),
                        child: Icon(
                          Icons.delete,
                          color: context.colors.background,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
