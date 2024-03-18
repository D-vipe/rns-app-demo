import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rns_app/app/features/tasks/presentation/controllers/form_tabs/form_files_tab_controller.dart';
import 'package:rns_app/app/features/tasks/presentation/views/create/components/added_task_file_widget.dart';
import 'package:rns_app/app/uikit/app_animated_list_item.dart';
import 'package:rns_app/app/uikit/app_button.dart';
import 'package:rns_app/configs/theme/miscellaneous.dart';

class FileFormTab extends GetView<FormFilesTabController> {
  const FileFormTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Get.height,
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
              controller: controller.scrollController,
              child: Column(
                // mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 24.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppConstraints.screenPadding),
                    child: Row(
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
                  ),
                  const SizedBox(
                    height: 24.0,
                  ),
                  Obx(
                    () => Column(
                      children: List.generate(
                        controller.pickedFiles.length,
                        (index) => Offstage(
                          offstage: index == 0 ? false : !controller.pickedFiles[index].value.showed,
                          child: SizeTransition(
                            sizeFactor: CurvedAnimation(
                              parent: controller.pickedFiles[index].value.animationController,
                              curve: Curves.fastLinearToSlowEaseIn,
                            ),
                            child: AppAnimatedListItem(
                              index: index,
                              alreadyRendered: false,
                              animationController: controller.pickedFiles[index].value.animationController,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: AppConstraints.screenPadding),
                                child: Obx(
                                  () => AddedTaskFileWidget(
                                    index: index,
                                    viewModel: controller.pickedFiles[index].value,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 65.0),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
