import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rns_app/app/features/tasks/domain/models/task_model.dart';
import 'package:rns_app/app/uikit/pulsing_dot.dart';
import 'package:rns_app/app/utils/extensions.dart';

class TasksListItem extends StatelessWidget {
  const TasksListItem({
    super.key,
    required this.item,
    required this.last,
  });

  final Task item;
  final bool last;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: last ? 0.0 : 8.0),
      padding: const EdgeInsets.fromLTRB(16.0, 18.0, 16.0, 0.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 1,
            child: _TaskNumber(item: item),
          ),
          const SizedBox(
            width: 16.0,
          ),
          Expanded(
            flex: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  // mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    if (item.isImportant)
                      Positioned(left: -12.5, top: 6.5, child: PulsingDotWidget(visible: item.isImportant)),
                    Text(
                      item.projectTitle,
                      style: context.textStyles.bodyBold.copyWith(height: 1.2),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ],
                ),
                if (item.statusTitle != null)
                  const SizedBox(
                    height: 8.0,
                  ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (item.statusTitle != null) _StatusWidget(item: item),
                    if (item.deadLineFormat != null)
                      Text(
                        item.deadLineFormat != null
                            ? item.deadLineFormat!
                            : DateFormat('dd.MM.yyyy').format(DateTime.now()),
                        style: context.textStyles.subtitleSmall.copyWith(
                            color: item.deadLineFormat != null
                                ? item.deadLine!.isBefore(DateTime.now())
                                    ? context.colors.error
                                    : context.colors.inputBackground
                                : Colors.transparent),
                      ),
                  ],
                ),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(bottom: 18.0, top: 8.0),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(width: 1.0, color: context.colors.background),
                    ),
                  ),
                  child: Text(
                    item.taskDescription,
                    style: context.textStyles.body.copyWith(
                      color: context.colors.background,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TaskNumber extends StatelessWidget {
  const _TaskNumber({
    required this.item,
  });

  final Task item;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: item.isPrioritet
            ? context.colors.contrast.withOpacity(.3)
            : item.isNew
                ? context.colors.success.withOpacity(.08)
                : context.colors.purple.withOpacity(.08),
        borderRadius: BorderRadius.circular(4.0),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 12.0),
      child: Center(
        child: Text(
          item.taskName,
          style: context.textStyles.subtitleSmall.copyWith(
              color: item.isPrioritet
                  ? context.colors.contrast
                  : item.isNew
                      ? context.colors.success
                      : context.colors.purple,
              fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}

class _StatusWidget extends StatelessWidget {
  const _StatusWidget({
    required this.item,
  });

  final Task item;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 3.0),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(16.0), color: context.colors.background),
          child: Text(
            item.statusTitle!,
            style: context.textStyles.subtitleSmall.copyWith(color: context.colors.black.withOpacity(.6)),
          ),
        ),
        const SizedBox(
          width: 5.0,
        ),
        if (item.isError)
          Icon(
            Icons.error_rounded,
            color: context.colors.main,
          ),
      ],
    );
  }
}
