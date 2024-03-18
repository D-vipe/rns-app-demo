import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:rns_app/app/features/email/presentation/controllers/email_detail_controller.dart';
import 'package:rns_app/app/features/general/domain/entities/app_file_model.dart';
import 'package:rns_app/app/utils/extensions.dart';
import 'package:rns_app/configs/theme/app_decorations.dart';
import 'package:rns_app/resources/resources.dart';

class AttachmentsWidget extends StatelessWidget {
  final List<Rx<AppFile>> attachments;
  const AttachmentsWidget({
    super.key,
    required this.attachments,
  });

  @override
  Widget build(BuildContext context) {
    return attachments.length > 2
        ? ExpandablePanel(
            theme: ExpandableThemeData(
                iconColor: context.colors.background, headerAlignment: ExpandablePanelHeaderAlignment.center),
            header: Text(
              'messages_title_attachments'.trParams({'count': attachments.length.toString()}),
              style: context.textStyles.subtitleSmall,
            ),
            collapsed: const SizedBox.shrink(),
            expanded: _AttachmentList(attachments: attachments),
          )
        : _AttachmentList(attachments: attachments);
  }
}

class _AttachmentList extends StatelessWidget {
  const _AttachmentList({
    required this.attachments,
  });

  final List<Rx<AppFile>> attachments;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (attachments.length <= 2)
          Container(
            margin: const EdgeInsets.only(bottom: 5.0),
            child: Text(
              'messages_title_attachments'.trParams({'count': attachments.length.toString()}),
              style: context.textStyles.subtitleSmall,
            ),
          ),
        ...List.generate(
          attachments.length,
          (index) => Obx(
            () => Container(
              key: ValueKey<String>('${index}_${attachments[index].value.title}'),
              padding: const EdgeInsets.all(8.0),
              margin: const EdgeInsets.only(bottom: 8.0),
              decoration: AppDecorations.attachmentItem(context),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 400),
                child: (attachments[index].value.saving)
                    ? SizedBox(
                        height: 28,
                        child: Center(
                          child: LinearProgressIndicator(
                            value: double.parse(attachments[index].value.downloadProgress) / 100,
                            backgroundColor: context.colors.background,
                            color: context.colors.buttonActive,
                          ),
                        ),
                      )
                    : Row(
                        children: [
                          Image.asset(
                            attachments[index].value.icon!,
                            width: 28.0,
                            height: 28.0,
                          ),
                          const SizedBox(
                            width: 8.0,
                          ),
                          Text(
                            attachments[index].value.title,
                            style: context.textStyles.header3,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(
                            width: 8.0,
                          ),
                          if (attachments[index].value.size.isNotEmpty)
                            Text(
                              attachments[index].value.size,
                              style: context.textStyles.body.copyWith(color: context.colors.background),
                            ),
                          Expanded(
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: GestureDetector(
                                onTap: () => attachments[index].value.downloaded
                                    ? EmailDetailController.to.openDownloadedFile(attachments[index].value)
                                    : EmailDetailController.to.downloadAttachment(attachments[index]),
                                child: AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 400),
                                  child: attachments[index].value.downloaded
                                      ? Icon(
                                          Icons.open_in_new,
                                          color: context.colors.background,
                                        )
                                      : SvgPicture.asset(
                                          AppIcons.saveAlt,
                                          colorFilter: ColorFilter.mode(
                                            context.colors.background,
                                            BlendMode.srcIn,
                                          ),
                                        ),
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
      ],
    );
  }
}
