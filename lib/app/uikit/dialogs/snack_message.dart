import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:rns_app/app/utils/extensions.dart';
import 'package:rns_app/resources/resources.dart';

class SnackBarMessage extends StatelessWidget {
  final String message;
  final String iconAsset;

  const SnackBarMessage({
    super.key,
    required this.message,
    required this.iconAsset,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 14.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              SvgPicture.asset(iconAsset),
              const SizedBox(
                width: 16.0,
              ),
            ],
          ),
          Expanded(
            child: Text(
              message,
              style: context.textStyles.body.copyWith(color: context.colors.white),
            ),
          ),
          const SizedBox(
            width: 16.0,
          ),
          GestureDetector(
            onTap: () => Get.back(),
            child: SvgPicture.asset(AppIcons.clear,
                colorFilter: ColorFilter.mode(
                  context.colors.white,
                  BlendMode.srcIn,
                )),
          )
        ],
      ),
    );
  }
}
