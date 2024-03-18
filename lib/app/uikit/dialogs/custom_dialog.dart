import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:rns_app/app/uikit/app_scalebox.dart';
import 'package:rns_app/app/utils/extensions.dart';
import 'package:rns_app/configs/theme/miscellaneous.dart';
import 'package:rns_app/resources/resources.dart';

class CustomDialog extends StatelessWidget {
  final Widget title;
  final Widget body;
  final List<Widget> actions;
  final bool dismissable;
  final double? height;
  final double? width;
  const CustomDialog({
    super.key,
    required this.title,
    required this.body,
    required this.dismissable,
    required this.actions,
    this.height,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: AppScaleBox(
        child: Container(
          width: width,
          height: height ?? 200,
          margin: const EdgeInsets.symmetric(horizontal: AppConstraints.screenPadding, vertical: 15.0),
          decoration: BoxDecoration(
            color: context.colors.backgroundPrimary,
            borderRadius: const BorderRadius.all(
              Radius.circular(18.0),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 73.0,
                padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
                decoration: BoxDecoration(
                  color: context.colors.inputBackground,
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(18.0),
                    topLeft: Radius.circular(18.0),
                  ),
                ),
                child: Stack(
                  children: [
                    Center(
                      child: title,
                    ),
                    if (dismissable)
                      Positioned(
                        child: GestureDetector(
                          onTap: () => Get.back(),
                          child: SvgPicture.asset(AppIcons.clear),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(
                height: 15.0,
              ),
              Padding(
                padding: const EdgeInsets.all(AppConstraints.screenPadding).copyWith(bottom: 0),
                child: body,
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [...actions],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
