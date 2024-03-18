import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rns_app/app/features/tasks/presentation/controllers/form_tabs/form_files_tab_controller.dart';
import 'package:rns_app/app/features/tasks/presentation/view_models/added_file_view_model.dart';
import 'package:rns_app/app/uikit/form_widgets/app_textfield.dart';
import 'package:rns_app/app/uikit/form_widgets/select/select_block_widget.dart';
import 'package:rns_app/app/uikit/general_models/select_types.dart';
import 'package:rns_app/app/utils/extensions.dart';
import 'package:rns_app/app/utils/helper_utils.dart';
import 'package:rns_app/configs/theme/app_decorations.dart';
import 'package:rns_app/resources/resources.dart';

class AddedTaskFileWidget extends GetView<FormFilesTabController> {
  final AddedFileViewModel viewModel;
  final int index;
  const AddedTaskFileWidget({
    super.key,
    required this.viewModel,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8.0),
          margin: const EdgeInsets.only(bottom: 8.0),
          decoration: AppDecorations.attachmentItem(context),
          child: Row(
            children: [
              Image.asset(
                HelperUtils.getFileIconFromNameExtension(viewModel.item.fileName) ?? AppIcons.doc,
                width: 28.0,
                height: 28.0,
              ),
              const SizedBox(
                width: 8.0,
              ),
              Text(
                HelperUtils.shortenFileName(viewModel.item.fileName),
                style: context.textStyles.header3,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(
                width: 8.0,
              ),
              if (viewModel.item.fileSize != null)
                Text(
                  viewModel.item.fileSize!,
                  style: context.textStyles.body.copyWith(color: context.colors.background),
                ),
              Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () => controller.removeAddedFileWidget(index),
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
        const SizedBox(
          height: 12.0,
        ),
        Obx(
          () => SelectBlockWidget(
            label: 'tasks_label_type'.tr,
            placeholder: 'tasks_placeholder_select'.tr,
            items: controller.availableFileTypes,
            selectedVal: controller.pickedFiles[index].value.fileType,
            selectType: SelectType.fileType,
            onChange: (value, _) => controller.onFileTypeChange(index, newValue: value),
            error: controller.pickedFiles[index].value.error,
            processing: controller.loadingTypes.value,
            reset: () => controller.resetFileTypeValue(index),
            searchController: null,
          ),
        ),
        const SizedBox(
          height: 8.0,
        ),
        AppTextField(
          hintText: 'placeHolder_comment'.tr,
          labelText: 'label_comment'.tr,
          textEditingController: viewModel.commentController,
          focusNode: viewModel.focusNode,
          errorMessage: null,
          fieldError: false,
          maxLines: 2,
        ),
        const SizedBox(
          height: 24.0,
        ),
      ],
    );
  }
}
