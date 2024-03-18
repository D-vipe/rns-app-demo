import 'package:flutter/material.dart';
import 'package:flutter_html_v3/flutter_html.dart';
import 'package:get/get.dart';
import 'package:rns_app/app/features/tasks/presentation/controllers/detail_tabs/general_tab_controller.dart';
import 'package:rns_app/app/features/tasks/presentation/controllers/tasks_detail_controller.dart';
import 'package:rns_app/app/uikit/app_loader.dart';
import 'package:rns_app/app/uikit/general_models/select_types.dart';
import 'package:rns_app/app/utils/extensions.dart';
import 'package:rns_app/app/utils/helper_utils.dart';
import 'package:rns_app/configs/theme/miscellaneous.dart';

class TaskTab extends GetView<GeneralTabController> {
  const TaskTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: context.colors.backgroundPrimary,
      width: double.infinity,
      height: Get.height,
      child: SingleChildScrollView(
        controller: controller.scrollController,
        physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        padding: GetPlatform.isAndroid
            ? EdgeInsets.only(bottom: 125.0 + Get.bottomBarHeight + Get.statusBarHeight)
            : EdgeInsets.only(bottom: 75.0 + Get.bottomBarHeight + Get.statusBarHeight),
        child: SelectionArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(AppConstraints.screenPadding, 16.0, AppConstraints.screenPadding, 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
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
                Text(
                  controller.data.value?.taskName ?? ' - ',
                  style: context.textStyles.subtitle,
                ),
                Text(
                  controller.data.value?.projectTitle ?? ' - ',
                  style: context.textStyles.header1,
                ),
                const SizedBox(
                  height: 20.0,
                ),
                Text(
                  controller.data.value?.brief.replaceAll('<br>', '') ?? '',
                  style: context.textStyles.header2,
                ),
                SelectableHtml(
                  data: controller.data.value?.description ?? '',
                  onLinkTap: (url, context, attributes, element) => HelperUtils.openUrlLink(url),
                  style: {
                    '*': Style(
                      fontSize: FontSize(14.0),
                      padding: EdgeInsets.zero,
                      margin: Margins.zero,
                    ),
                  },
                ),
                _TitleBlock(
                  label: 'tasks_label_taskInfo'.tr,
                ),
                Obx(
                  () => _TaskInfoActionBlock(
                    label: 'tasks_label_status'.tr,
                    value: controller.data.value?.status ?? '',
                    action: () => controller.openExtendedSelectModal(SelectType.status),
                  ),
                ),
                _TaskInfoBlock(
                  label: 'tasks_label_type'.tr,
                  info: controller.data.value?.type ?? '',
                ),
                _TaskInfoBlock(
                  label: 'tasks_label_urgency'.tr,
                  info: controller.data.value?.urgency ?? '',
                ),
                if (controller.data.value?.planDate != null)
                  _TaskInfoBlock(
                    label: 'tasks_label_planDate'.tr,
                    info: controller.data.value?.planDate ?? '',
                  ),
                if (controller.data.value?.deadline != null)
                  _TaskInfoBlock(
                    label: 'tasks_label_deadline'.tr,
                    info: controller.data.value?.deadline ?? '',
                  ),
                _TaskInfoBlock(
                  label: 'tasks_label_responsible'.tr,
                  info: controller.data.value?.curator ?? '',
                ),
                Obx(
                  () => _TaskInfoActionBlock(
                    label: 'tasks_label_executor'.tr,
                    value: controller.data.value?.executor ?? '',
                    action: () => controller.openExtendedSelectModal(SelectType.user),
                  ),
                ),
                if (controller.data.value?.executorOthers != null && controller.data.value!.executorOthers.isNotEmpty)
                  _TaskInfoBlock(
                    label: 'tasks_label_coExecutors'.tr,
                    info: controller.data.value?.executorOthers ?? '',
                  ),
                _TaskInfoBlock(
                  label: 'tasks_label_creator'.tr,
                  info: controller.data.value?.creator ?? '',
                ),
                if (controller.data.value?.appointedBy != '')
                  _TaskInfoBlock(
                    label: 'tasks_label_appointedBy'.tr,
                    info: controller.data.value?.appointedBy ?? '',
                  ),
                if (controller.data.value?.module != null ||
                    controller.data.value?.version != null ||
                    controller.data.value?.initReason != null)
                  _TitleBlock(
                    label: 'tasks_label_additionalInfo'.tr,
                  ),
                if (controller.data.value?.module != null && controller.data.value!.module!.isNotEmpty)
                  _TaskInfoBlock(
                    label: 'tasks_label_module'.tr,
                    info: controller.data.value?.module ?? '',
                  ),
                if (controller.data.value?.version != null && controller.data.value!.version!.isNotEmpty)
                  _TaskInfoBlock(
                    label: 'tasks_label_version'.tr,
                    info: controller.data.value?.version ?? '',
                  ),
                if (controller.data.value?.initReason != null && controller.data.value!.initReason!.isNotEmpty)
                  _TaskInfoBlock(
                    label: 'tasks_label_reason'.tr,
                    info: controller.data.value?.initReason ?? '',
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TitleBlock extends StatelessWidget {
  const _TitleBlock({
    required this.label,
  });

  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 46.0,
        ),
        Text(
          label,
          style: context.textStyles.header2,
        ),
      ],
    );
  }
}

class _TaskInfoActionBlock extends StatelessWidget {
  const _TaskInfoActionBlock({
    required this.label,
    required this.value,
    required this.action,
  });

  final String label;
  final String value;
  final void Function() action;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 16.0,
        ),
        Text(
          label,
          style: context.textStyles.subtitleSmall,
        ),
        GestureDetector(
          onTap: action,
          child: Text(
            value,
            style: context.textStyles.header3.copyWith(color: context.colors.buttonActive),
          ),
        ),
      ],
    );
  }
}

class _TaskInfoBlock extends StatelessWidget {
  const _TaskInfoBlock({
    required this.label,
    required this.info,
  });

  final String label;
  final String info;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const SizedBox(
          height: 16.0,
        ),
        Text(
          label,
          style: context.textStyles.subtitleSmall,
        ),
        Text(
          info,
          style: context.textStyles.header3,
        ),
      ],
    );
  }
}
