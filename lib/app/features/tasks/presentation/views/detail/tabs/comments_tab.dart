import 'package:flutter/material.dart';
import 'package:flutter_html_v3/flutter_html.dart';
import 'package:get/get.dart';
import 'package:rns_app/app/features/tasks/domain/models/task_comment.dart';
import 'package:rns_app/app/features/tasks/presentation/controllers/detail_tabs/comment_tab_controller.dart';
import 'package:rns_app/app/features/tasks/presentation/controllers/tasks_detail_controller.dart';
import 'package:rns_app/app/uikit/app_animated_list_item.dart';
import 'package:rns_app/app/uikit/app_loader.dart';
import 'package:rns_app/app/uikit/empty_data_widget.dart';
import 'package:rns_app/app/utils/extensions.dart';
import 'package:rns_app/app/utils/helper_utils.dart';
import 'package:rns_app/configs/theme/miscellaneous.dart';
import 'package:rns_app/resources/resources.dart';

class CommentsTab extends GetView<CommentTabController> {
  const CommentsTab({super.key});

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
              ? EdgeInsets.only(bottom: 145.0 + Get.bottomBarHeight + Get.statusBarHeight)
              : EdgeInsets.only(bottom: 95.0 + Get.bottomBarHeight + Get.statusBarHeight),
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
                          key: ValueKey<int>(controller.data[index].id),
                          index: index,
                          alreadyRendered: controller.renderedIds.contains(controller.data[index].id),
                          child: _CommentWidget(
                            comment: controller.data[index],
                          ),
                        ),
                      ),
                    ])
                  : EmptyDataWidget(
                      message: 'tasks_error_emptyCommentTab'.tr,
                      refresh: TasksDetailController.to.getData,
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CommentWidget extends StatelessWidget {
  const _CommentWidget({
    required this.comment,
  });

  final TaskComment comment;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(AppIcons.userSampleIcon),
          const SizedBox(
            width: 16.0,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  comment.author,
                  style: context.textStyles.header3,
                ),
                const SizedBox(
                  height: 8.0,
                ),
                Text(
                  comment.dateCreate,
                  style: context.textStyles.subtitleSmall,
                ),
                const SizedBox(
                  height: 4.0,
                ),
                Text(
                  '№ ${comment.number}',
                  style: context.textStyles.header3,
                ),
                SelectableHtml(
                  data: comment.title,
                  onLinkTap: (url, context, attributes, element) => HelperUtils.openUrlLink(url),
                  style: {
                    '*': Style(
                      fontSize: FontSize(14.0),
                      padding: EdgeInsets.zero,
                      margin: Margins.zero,
                    ),
                  },
                  // ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
