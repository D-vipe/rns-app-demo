import 'package:flutter/material.dart';
import 'package:rns_app/app/utils/extensions.dart';

class InfoItem extends StatelessWidget {
  final String keyText;
  final String valueText;

  const InfoItem({
    super.key,
    required this.keyText,
    required this.valueText,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            keyText,
            style: context.textStyles.subtitle,
          ),
        ),
        Text(
          valueText,
          style: context.textStyles.bodyBold,
        ),
      ],
    );
  }
}
