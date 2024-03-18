import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:rns_app/app/utils/extensions.dart';
import 'package:rns_app/resources/resources.dart';

class EmptyDataWidget extends StatelessWidget {
  const EmptyDataWidget({
    super.key,
    required this.message,
    this.title,
    this.refresh,
  });

  final String? title;
  final String message;
  final void Function()? refresh;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 37.0, vertical: 24.0),
          child: Text(
            title ?? 'error_noData'.tr,
            textAlign: TextAlign.center,
            style: context.textStyles.header1.copyWith(fontSize: 32.0),
          ),
        ),
        const SizedBox(
          height: 36.0,
        ),
        SvgPicture.asset(AppIcons.emptyDataPenguin),
        const SizedBox(
          height: 8.0,
        ),
        Container(
          constraints: const BoxConstraints(maxWidth: 212.0),
          child: Text(
            message,
            textAlign: TextAlign.center,
            style: context.textStyles.header3.copyWith(color: context.colors.background),
          ),
        ),
        const SizedBox(
          height: 10.0,
        ),
        if (refresh != null)
          GestureDetector(
            onTap: refresh,
            child: Text(
              'button_refresh'.tr,
              style: context.textStyles.body.copyWith(color: context.colors.buttonActive),
            ),
          )
      ],
    );
  }
}
