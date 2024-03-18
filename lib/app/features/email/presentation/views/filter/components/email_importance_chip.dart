import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rns_app/app/features/general/domain/entities/enum_importance.dart';
import 'package:rns_app/app/features/email/presentation/controllers/email_filter_controller.dart';
import 'package:rns_app/app/utils/extensions.dart';
import 'package:rns_app/app/utils/helper_utils.dart';

class EmailImportanceChip extends GetView<EmailFilterController> {
  const EmailImportanceChip({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'messages_title_importance'.tr,
          style: context.textStyles.header2,
        ),
        const SizedBox(
          height: 6.0,
        ),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 400),
          child: Obx(() => Wrap(
                children: List.generate(
                  controller.importanceList.length,
                  (index) {
                    Animation<Offset>? itemAnimation;
                    itemAnimation = Tween<Offset>(
                      begin: Offset(-1.0 * (index + 1), 1.0 * (index + 1.5)),
                      end: const Offset(0.0, 0.0),
                    ).animate(
                      CurvedAnimation(
                        parent: controller.animationController,
                        curve: Curves.fastEaseInToSlowEaseOut,
                      ),
                    );
                    return SlideTransition(
                      position: itemAnimation,
                      child: InkWell(
                        onTap: () => controller.selectImportance(controller.importanceList[index]),
                        child: Container(
                          margin: const EdgeInsets.only(right: 6.0, bottom: 0.0),
                          child: Obx(
                            () => _ChipButton(
                              item: controller.importanceList[index],
                              index: index,
                              selected: controller.selectedImportance.contains(controller.importanceList[index]),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              )),
        )
      ],
    );
  }
}

class _ChipButton extends StatelessWidget {
  const _ChipButton({
    required this.item,
    required this.index,
    required this.selected,
  });

  final Importance item;
  final int index;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    Color _getImportanceBackground(Importance item) {
      switch (item) {
        case Importance.no:
          return context.colors.background;
        case Importance.low:
          return context.colors.importance.lowBg;
        case Importance.normal:
          return context.colors.importance.normalBg;
        case Importance.high:
          return context.colors.importance.highBg;
      }
    }

    return Chip(
      backgroundColor: selected ? _getImportanceBackground(item) : context.colors.inputBackground,
      padding: const EdgeInsets.all(6.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(28.0),
      ),
      side: BorderSide.none,
      label: Text(
        item.displayTitle,
        style: context.textStyles.body.copyWith(
          color: selected ? HelperUtils.getImportanceColor(context, item) : context.colors.black.withOpacity(.6),
        ),
      ),
    );
  }
}
