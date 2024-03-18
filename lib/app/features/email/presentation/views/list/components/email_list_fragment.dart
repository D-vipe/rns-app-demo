import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:rns_app/app/features/email/domain/models/email_list_item.dart';
import 'package:rns_app/app/features/general/domain/entities/enum_importance.dart';
import 'package:rns_app/app/features/email/presentation/controllers/email_list_controller.dart';
import 'package:rns_app/app/features/email/presentation/views/list/components/batch_widget.dart';
import 'package:rns_app/app/uikit/app_animated_list_item.dart';
import 'package:rns_app/app/uikit/app_loader.dart';
import 'package:rns_app/app/uikit/empty_data_widget.dart';
import 'package:rns_app/app/uikit/general_models/slidable_widget_action.dart';
import 'package:rns_app/app/uikit/pulsing_dot.dart';
import 'package:rns_app/app/uikit/slide_lists/slide_list_item_alt.dart';
import 'package:rns_app/app/utils/extensions.dart';
import 'package:rns_app/app/utils/helper_utils.dart';
import 'package:rns_app/configs/theme/miscellaneous.dart';
import 'package:rns_app/resources/resources.dart';

class EmailListFragment extends GetView<EmailListController> {
  final bool incoming;
  const EmailListFragment({super.key, required this.incoming});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: context.colors.backgroundPrimary,
      width: double.infinity,
      height: Get.height,
      child: Obx(
        () => SingleChildScrollView(
          controller: incoming ? controller.incomingScrollController : controller.outgoingScrollController,
          physics: controller.disableScroll.value
              ? const NeverScrollableScrollPhysics()
              : const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          padding: GetPlatform.isAndroid
              ? EdgeInsets.only(bottom: 145.0 + Get.bottomBarHeight + Get.statusBarHeight)
              : EdgeInsets.only(bottom: 28.0 + Get.bottomBarHeight + Get.statusBarHeight),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 0.0, 0, 16.0),
            child: Obx(
              () => (incoming ? controller.incomingEmail.isNotEmpty : controller.outgoingEmail.isNotEmpty)
                  ? Column(children: [
                      EmailListController.to.refreshing.value
                          ? Padding(
                              padding: const EdgeInsets.only(bottom: 12.0, top: 16.0),
                              child: Loader(
                                size: 15,
                                btn: true,
                                color: context.colors.main,
                              ),
                            )
                          : const SizedBox.shrink(),
                      IgnorePointer(
                        ignoring: controller.refreshing.value,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: List.generate(
                            incoming ? controller.incomingEmail.length : controller.outgoingEmail.length,
                            (index) {
                              final EmailListItem item =
                                  incoming ? controller.incomingEmail[index] : controller.outgoingEmail[index];

                              return GestureDetector(
                                onTap: () => controller.batchMode.value
                                    ? controller.selectEmail(incoming, index)
                                    : controller.readEmail(
                                        id: item.id,
                                        from: item.title,
                                        incoming: incoming,
                                      ),
                                child: Column(
                                  children: [
                                    BatchSlidingWidget(
                                      batchMode: controller.batchMode.value,
                                      onChange: () => controller.selectEmail(incoming, index),
                                      selected: incoming
                                          ? controller.selectedEmails.contains(controller.incomingEmail[index])
                                          : controller.selectedEmails.contains(controller.outgoingEmail[index]),
                                      child: SlideListItemAlt(
                                        index: index,
                                        extentRatio: incoming ? .35 : .12,
                                        startExtentRatio: .25,
                                        enabled: !controller.batchMode.value,
                                        startActions: incoming
                                            ? [
                                                SlidableWidgetAction(
                                                  onTap: (_) => controller.replyTo(index, false),
                                                  icon: Icon(
                                                    Icons.reply,
                                                    color: context.colors.main,
                                                    size: 20,
                                                  ),
                                                ),
                                                SlidableWidgetAction(
                                                  onTap: (_) => controller.replyTo(index, true),
                                                  icon: Icon(
                                                    Icons.reply_all,
                                                    color: context.colors.main,
                                                  ),
                                                )
                                              ]
                                            : [],
                                        endActions: [
                                          if (incoming)
                                            SlidableWidgetAction(
                                              onTap: (_) => controller.toggleEmailRead(index),
                                              icon: controller.incomingEmail[index].unread
                                                  ? Icon(
                                                      Icons.mark_email_read,
                                                      color: context.colors.main,
                                                    )
                                                  : Icon(
                                                      Icons.mark_as_unread_rounded,
                                                      color: context.colors.main,
                                                    ),
                                            ),
                                          if (incoming)
                                            SlidableWidgetAction(
                                                icon: Icon(
                                                  Icons.flag,
                                                  color: item.importance == Importance.no
                                                      ? context.colors.main
                                                      : HelperUtils.getImportanceColor(context, item.importance),
                                                ),
                                                onTap: (_) => controller.toggleEmailImportance(index)),
                                          SlidableWidgetAction(
                                            onTap: (_) => controller.deleteEmail(index),
                                            icon: SvgPicture.asset(
                                              AppIcons.delete,
                                              width: 35.0,
                                              height: 35.0,
                                              colorFilter: ColorFilter.mode(
                                                context.colors.main,
                                                BlendMode.srcIn,
                                              ),
                                            ),
                                          )
                                        ],
                                        child: AppAnimatedListItem(
                                          key: ValueKey<int>(item.id),
                                          index: index,
                                          alreadyRendered: controller.renderedIds.contains(item.id),
                                          child: _EmailItemWidget(
                                            index: index,
                                            email: item,
                                            controller: controller,
                                            bactchMode: controller.batchMode.value,
                                            last: index ==
                                                (incoming
                                                    ? controller.incomingEmail.length - 1
                                                    : controller.outgoingEmail.length - 1),
                                            incoming: incoming,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      height: 1.0,
                                      margin: const EdgeInsets.symmetric(horizontal: AppConstraints.screenPadding),
                                      color: index ==
                                              (incoming
                                                  ? controller.incomingEmail.length - 1
                                                  : controller.outgoingEmail.length - 1)
                                          ? Colors.transparent
                                          : context.colors.background,
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ])
                  : EmptyDataWidget(
                      message: 'messages_error_emptyList'.tr,
                      refresh: null,
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

class _EmailItemWidget extends StatelessWidget {
  final EmailListItem email;
  final EmailListController controller;
  final int index;
  final bool last;
  final bool incoming;
  final bool bactchMode;
  const _EmailItemWidget({
    required this.email,
    required this.controller,
    required this.index,
    required this.last,
    required this.incoming,
    required this.bactchMode,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: AppConstraints.screenPadding),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (email.unread)
                      PulsingDotWidget(
                        visible: email.unread,
                        color: context.colors.success,
                      ),
                    Expanded(
                      child: Text(
                        email.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: context.textStyles.bodyBold
                            .copyWith(fontWeight: email.unread ? FontWeight.w600 : FontWeight.w400),
                      ),
                    ),
                  ],
                ),
                Text(
                  email.subTitle,
                  maxLines: bactchMode ? 2 : null,
                  overflow: bactchMode ? TextOverflow.ellipsis : null,
                  style: context.textStyles.bodyBold
                      .copyWith(fontWeight: email.unread ? FontWeight.w500 : FontWeight.w300, height: 1.2),
                ),
              ],
            ),
          ),
          const SizedBox(
            width: 5.0,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                HelperUtils.emailDateOrTime(email.created, false),
                style: context.textStyles.subtitleSmall,
                textAlign: TextAlign.end,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: Row(
                  children: [
                    if (email.hasAttachment)
                      SvgPicture.asset(
                        AppIcons.attachFile,
                        colorFilter: ColorFilter.mode(
                          context.colors.main,
                          BlendMode.srcIn,
                        ),
                      ),
                    if (email.importance != Importance.no && incoming)
                      Container(
                        margin: const EdgeInsets.only(left: 10.0),
                        child: Icon(
                          Icons.flag,
                          color: HelperUtils.getImportanceColor(context, email.importance),
                          size: 16.0,
                        ),
                      ),
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
