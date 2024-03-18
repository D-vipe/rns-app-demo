import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:rns_app/app/features/general/domain/entities/app_file_model.dart';
import 'package:rns_app/app/features/tasks/presentation/controllers/detail_tabs/files_tab_controller.dart';
import 'package:rns_app/app/features/tasks/presentation/controllers/tasks_detail_controller.dart';
import 'package:rns_app/app/uikit/app_animated_list_item.dart';
import 'package:rns_app/app/uikit/app_loader.dart';
import 'package:rns_app/app/uikit/empty_data_widget.dart';
import 'package:rns_app/app/utils/extensions.dart';
import 'package:rns_app/configs/theme/app_decorations.dart';
import 'package:rns_app/configs/theme/miscellaneous.dart';
import 'package:rns_app/resources/resources.dart';

class FilesTab extends GetView<FilesTabController> {
  const FilesTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SelectionArea(
      child: Container(
        color: context.colors.backgroundPrimary,
        width: double.infinity,
        height: Get.height,
        child: SingleChildScrollView(
          controller: controller.scrollController,
          physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          padding: GetPlatform.isAndroid
              ? EdgeInsets.only(bottom: 125.0 + Get.bottomBarHeight + Get.statusBarHeight)
              : EdgeInsets.only(bottom: 75.0 + Get.bottomBarHeight + Get.statusBarHeight),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(AppConstraints.screenPadding, 16.0, AppConstraints.screenPadding, 16.0),
            child: Obx(
              () => (controller.data.isNotEmpty)
                  ? Column(children: [
                      Obx(
                        () => TasksDetailController.to.refreshing.value
                            ? Padding(
                                padding: const EdgeInsets.only(bottom: 12.0),
                                child: Loader(
                                  size: 15,
                                  btn: true,
                                  color: context.colors.main,
                                ),
                              )
                            : const SizedBox.shrink(),
                      ),
                      ...List.generate(
                        controller.data.length,
                        (index) => AppAnimatedListItem(
                          index: index,
                          alreadyRendered: false,
                          child: _FileWidget(
                            file: controller.data[index],
                          ),
                        ),
                      ),
                    ])
                  : EmptyDataWidget(
                      message: 'tasks_error_emptyFileTab'.tr,
                      refresh: TasksDetailController.to.getData,
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

class _FileWidget extends StatelessWidget {
  const _FileWidget({
    required this.file,
  });

  final Rx<AppFile> file;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8.0),
      padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
      decoration: AppDecorations.fileBoxDecoration(context),
      child: Obx(() => Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                file.value.title,
                style: context.textStyles.header2,
              ),
              const SizedBox(
                height: 20.0,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Image.asset(AppIcons.userSampleIcon),
                  const SizedBox(
                    width: 16.0,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        file.value.author,
                        style: context.textStyles.body,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(
                        height: 8.0,
                      ),
                      Text(
                        file.value.dateCreate,
                        style: context.textStyles.subtitleSmall,
                      ),
                    ],
                  ),
                ],
              ),
              Divider(
                color: context.colors.background,
                height: 40.0,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      file.value.fileType,
                    ),
                    Text(
                      file.value.description,
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Obx(
                () => AnimatedSwitcher(
                  duration: const Duration(milliseconds: 400),
                  child: (file.value.saving)
                      ? SizedBox(
                          height: 46,
                          child: Center(
                            child: LinearProgressIndicator(
                              value: double.parse(file.value.downloadProgress) / 100,
                              backgroundColor: context.colors.background,
                              color: context.colors.buttonActive,
                            ),
                          ),
                        )
                      : TextButton(
                          onPressed: () => file.value.downloaded
                              ? FilesTabController.to.openFile(file.value)
                              : FilesTabController.to.downloadFile(file),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              if (!file.value.downloaded) SvgPicture.asset(AppIcons.saveAlt),
                              if (!file.value.downloaded)
                                const SizedBox(
                                  width: 8.0,
                                ),
                              Text(
                                file.value.downloaded
                                    ? 'tasks_label_openFile'.tr.toUpperCase()
                                    : 'tasks_label_downloadFile'.tr.toUpperCase(),
                                style: context.textStyles.bodyBold.copyWith(color: context.colors.buttonActive),
                              )
                            ],
                          ),
                        ),
                ),
              ),
            ],
          )),
    );
  }
}
