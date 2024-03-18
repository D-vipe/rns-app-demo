import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:rns_app/app/features/tasks/presentation/controllers/detail_tabs/files_tab_controller.dart';
import 'package:rns_app/app/uikit/app_button.dart';
import 'package:rns_app/app/uikit/app_scalebox.dart';
import 'package:rns_app/app/utils/extensions.dart';
import 'package:rns_app/configs/theme/miscellaneous.dart';
import 'package:rns_app/resources/resources.dart';

class SelectedFilesDialog extends GetView<FilesTabController> {
  const SelectedFilesDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaleBox(
      child: Material(
        color: Colors.transparent,
        child: Container(
          height: 300,
          padding: const EdgeInsets.all(15.0),
          margin: const EdgeInsets.symmetric(horizontal: AppConstraints.screenPadding / 2),
          decoration: BoxDecoration(color: context.colors.backgroundPrimary, borderRadius: BorderRadius.circular(18.0)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'tasks_title_pickedFilesDialog'.tr.toUpperCase(),
                style: context.textStyles.header2,
              ),
              const SizedBox(
                height: 15.0,
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Obx(
                    () => AnimatedSwitcher(
                      duration: const Duration(milliseconds: 400),
                      child: controller.pickedFiles.isNotEmpty
                          ? Wrap(
                              children: List.generate(
                                controller.pickedFiles.length,
                                (index) => Container(
                                  margin: const EdgeInsets.only(right: 8.0),
                                  child: Chip(
                                    backgroundColor: context.colors.inputBackground,
                                    padding: const EdgeInsets.all(6.0),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(28.0),
                                    ),
                                    side: BorderSide.none,
                                    label: Obx(
                                      () => Text(
                                        controller.pickedFiles[index].fileName,
                                        style: context.textStyles.bodyBold,
                                      ),
                                    ),
                                    deleteIcon: SvgPicture.asset(AppIcons.clear),
                                    onDeleted: () => controller.removePickedFile(index),
                                  ),
                                ),
                              ),
                            )
                          : Center(
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
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Container(
                  margin: const EdgeInsets.only(top: 5.0),
                  width: 120.0,
                  child: AppButton(
                    label: 'button_close'.tr,
                    onTap: () => Get.back(),
                    processing: false,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
