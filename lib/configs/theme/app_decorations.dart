import 'package:flutter/material.dart';
import 'package:rns_app/app/utils/extensions.dart';

class AppDecorations {
  static BoxDecoration modalSheet(BuildContext context) => BoxDecoration(
        color: Theme.of(context).canvasColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(18.0),
          topRight: Radius.circular(18.0),
        ),
        boxShadow: const [],
      );

  static BoxDecoration tsItem(BuildContext context) => BoxDecoration(
        color: context.colors.inputBackground,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: const [
          BoxShadow(
            blurRadius: 0,
            offset: Offset(0.0, 0.0),
            color: Color.fromRGBO(0, 0, 0, 0.1),
          ),
          BoxShadow(
            blurRadius: 3,
            offset: Offset(2.0, 2.0),
            color: Color.fromRGBO(0, 0, 0, 0.09),
          ),
          BoxShadow(
            blurRadius: 5,
            offset: Offset(9.0, 7.0),
            color: Color.fromRGBO(0, 0, 0, 0.01),
          ),
        ],
      );

  static BoxDecoration attachmentItem(BuildContext context) => BoxDecoration(
        color: context.colors.inputBackground,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: const [
          BoxShadow(
            blurRadius: 0,
            offset: Offset(0.0, 0.0),
            color: Color.fromRGBO(0, 0, 0, 0.1),
          ),
          BoxShadow(
            blurRadius: 3,
            offset: Offset(2.0, 2.0),
            color: Color.fromRGBO(0, 0, 0, 0.09),
          ),
          BoxShadow(
            blurRadius: 5,
            offset: Offset(9.0, 7.0),
            color: Color.fromRGBO(0, 0, 0, 0.01),
          ),
        ],
      );

  static BoxDecoration boxShadowDecoration(BuildContext context) => BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        // color: context.colors.background,
        boxShadow: [
          BoxShadow(
            blurRadius: 2,
            offset: const Offset(0, 0),
            color: context.colors.black.withOpacity(.2),
          ),
          BoxShadow(
            blurRadius: 8,
            offset: const Offset(0, 4),
            color: context.colors.black.withOpacity(.12),
          ),
        ],
      );

  static BoxDecoration doneIcon(BuildContext context) => BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(33)),
        color: context.colors.white,
        border: Border(
          top: BorderSide(color: context.colors.buttonActive, width: 1.0),
          bottom: BorderSide(color: context.colors.buttonActive, width: 1.0),
          left: BorderSide(color: context.colors.buttonActive, width: 1.0),
          right: BorderSide(color: context.colors.buttonActive, width: 1.0),
        ),
      );

  static BoxDecoration fileBoxDecoration(BuildContext context) => BoxDecoration(
        color: context.colors.inputBackground,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: const [
          BoxShadow(
            blurRadius: 3,
            offset: Offset(0.0, 1.0),
            color: Color.fromRGBO(0, 0, 0, 0.2),
          ),
          BoxShadow(
            blurRadius: 1,
            offset: Offset(0.0, 2.0),
            color: Color.fromRGBO(0, 0, 0, 0.12),
          ),
          BoxShadow(
            blurRadius: 1,
            offset: Offset(0.0, 1.0),
            color: Color.fromRGBO(0, 0, 0, 0.14),
          ),
        ],
      );
}
