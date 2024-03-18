import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rns_app/app/features/tasks/presentation/controllers/detail_tabs/files_tab_controller.dart';
import 'package:rns_app/app/uikit/app_button.dart';
import 'package:rns_app/app/uikit/form_widgets/app_textfield.dart';
import 'package:rns_app/app/uikit/form_widgets/select/custom_select_bottom_modal.dart';
import 'package:rns_app/app/uikit/form_widgets/select/single_select_widget.dart';
import 'package:rns_app/app/utils/extensions.dart';

class NewFileFormWidget extends GetView<FilesTabController> {
  const NewFileFormWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => CustomSelectBottomWidget(
        title: 'tasks_title_file'.tr,
        clearHandler: () => controller.clearSelectFilter(),
        closeHandler: () => Get.back(),
        saveHandler: controller.saveFile,
        processing: controller.savingForm.value,
        buttonLabel: 'tasks_button_saveFile'.tr,
        hideActionButton: controller.hideActionBtn.value,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: AppButton(
                  label: 'tasks_button_choosePhoto'.tr,
                  onTap: controller.pickPhoto,
                  processing: false,
                ),
              ),
              const SizedBox(
                width: 10.0,
              ),
              Expanded(
                child: AppButton(
                  label: 'tasks_button_chooseFile'.tr,
                  onTap: controller.pickFiles,
                  processing: false,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12.0),
          Obx(
            () => AnimatedSwitcher(
              duration: const Duration(milliseconds: 400),
              child: controller.pickedFiles.isNotEmpty
                  ? TextButton(
                      style: ButtonStyle(
                        padding: MaterialStateProperty.resolveWith(
                          (states) => EdgeInsets.zero,
                        ),
                      ),
                      onPressed: controller.showSelectedFilesDialog,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'tasks_title_filesCounter'.trParams({'value': controller.pickedFiles.length.toString()}),
                          ),
                          Icon(
                            Icons.chevron_right,
                            color: context.colors.background,
                          ),
                        ],
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.symmetric(vertical: 17.0),
                      child: Obx(
                        () => Text(
                          'tasks_error_fileNotSelected'.tr,
                          style: context.textStyles.subtitleSmall
                              .copyWith(color: controller.emptyFile.value ? context.colors.error : null),
                        ),
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 12.0),
          Text(
            'tasks_label_fileDescription'.tr,
            style: context.textStyles.header2,
          ),
          const SizedBox(height: 6.0),
          AppTextField(
            hintText: 'tasks_placeholder_file'.tr,
            labelText: 'tasks_label_fileDescription'.tr,
            textEditingController: controller.descriptionController,
            errorMessage: controller.descriptionError.value,
            fieldError: controller.descriptionError.value.isNotEmpty,
            focusNode: controller.descriptionFocus,
            maxLines: 2,
          ),
          Obx(
            () => SingleSelectWidget(
              items: controller.availableFileTypes,
              refresher: () => controller.getFileTypes(),
              onChange: controller.onFileTypeSelect,
              searchController: TextEditingController(),
              selectedVal: controller.selectedFileType.value,
              loadingData: controller.loadingTypes.value,
              error: controller.fileTypeError.value,
              animationController: controller.animationController,
              searching: false,
              searchLabel: '',
              searchTitle: '',
              listTitle: 'label_chooseOption'.tr,
              enableSearch: false,
              disabled: false,
              removeTopMargin: true,
            ),
          )
        ],
      ),
    );
  }
}
