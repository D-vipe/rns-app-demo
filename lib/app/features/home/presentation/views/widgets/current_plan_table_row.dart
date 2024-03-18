import 'package:flutter/material.dart';
import 'package:rns_app/app/utils/extensions.dart';

class CurrentPlanTableRow extends TableRow {
  factory CurrentPlanTableRow({
    LocalKey? key,
    required BuildContext context,
    required Color color,
    required String title,
    String? plan,
    String? fact,
    TextStyle? style,
  }) {
    return CurrentPlanTableRow.empty(
      key: key,
      decoration: BoxDecoration(
        color: color,
      ),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 10.0,
          ),
          child: SizedBox(
            height: 52.0,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                title,
                style: style ?? context.textStyles.subtitle,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 10.0,
          ),
          child: SizedBox(
            height: 52.0,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                plan ?? '',
                style: style ?? context.textStyles.subtitle,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 10.0,
          ),
          child: SizedBox(
            height: 52.0,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                fact ?? '',
                style: style ?? context.textStyles.subtitle,
              ),
            ),
          ),
        ),
      ],
    );
  }

  const CurrentPlanTableRow.empty({
    super.key,
    super.decoration,
    super.children,
  });
}
