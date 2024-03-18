import 'package:flutter/material.dart';
import 'package:rns_app/app/features/general/domain/entities/enum_importance.dart';
import 'package:rns_app/app/utils/extensions.dart';

class ImportanceWidget extends StatelessWidget {
  final Importance importance;
  const ImportanceWidget({
    super.key,
    required this.importance,
  });

  @override
  Widget build(BuildContext context) {
    Color bgColor = context.colors.inputBackground;
    Color textColor = context.colors.black.withOpacity(.6);

    void _getWidgetColor() {
      switch (importance) {
        case Importance.no:
          bgColor = context.colors.inputBackground;
          textColor = context.colors.black.withOpacity(.6);
          break;
        case Importance.low:
          bgColor = context.colors.success.withOpacity(.6);
          textColor = context.colors.success;
          break;
        case Importance.normal:
          bgColor = context.colors.buttonActive.withOpacity(.6);
          textColor = context.colors.buttonActive;
          break;
        case Importance.high:
          bgColor = context.colors.error.withOpacity(.6);
          textColor = context.colors.error;
          break;
      }
    }

    _getWidgetColor();

    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: const BorderRadius.all(
          Radius.circular(16.0),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Text(
        importance.displayTitle,
        style: context.textStyles.subtitleSmall.copyWith(color: textColor),
      ),
    );
  }
}
