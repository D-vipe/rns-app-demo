import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:rns_app/app/uikit/app_button.dart';
import 'package:rns_app/app/utils/extensions.dart';
import 'package:rns_app/configs/theme/miscellaneous.dart';
import 'package:rns_app/resources/resources.dart';

class CustomSelectBottomWidget extends StatelessWidget {
  final void Function()? closeHandler;
  final void Function() clearHandler;
  final List<Widget> children;
  final String title;
  final void Function()? saveHandler;
  final bool? processing;
  final String? buttonLabel;
  final bool hideActionButton;

  const CustomSelectBottomWidget({
    super.key,
    this.closeHandler,
    required this.clearHandler,
    required this.title,
    required this.children,
    this.saveHandler,
    this.processing,
    this.buttonLabel,
    this.hideActionButton = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 45.0),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: context.colors.backgroundPrimary,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(36.0),
                topRight: Radius.circular(36.0),
              ),
            ),
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.only(
                bottom: 48.0,
                left: AppConstraints.screenPadding,
                right: AppConstraints.screenPadding,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 56,
                    child: Stack(
                      children: [
                        Positioned(
                          top: 16.0,
                          child: GestureDetector(
                            onTap: () => closeHandler != null ? closeHandler!() : Get.back(),
                            child: SvgPicture.asset(AppIcons.clear),
                          ),
                        ),
                        Center(
                          child: Text(
                            title,
                            style: context.textStyles.header1,
                          ),
                        ),
                        Positioned(
                          top: 20.0,
                          right: 0,
                          child: GestureDetector(
                            onTap: clearHandler,
                            child: Text(
                              'button_clear'.tr,
                              style: context.textStyles.body.copyWith(
                                color: context.colors.buttonActive,
                                decoration: TextDecoration.underline,
                                decorationColor: context.colors.buttonActive,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 24.0,
                  ),
                  ...children,
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 25.0,
            left: AppConstraints.screenPadding,
            right: AppConstraints.screenPadding,
            child: AnimatedOpacity(
              opacity: hideActionButton ? 0 : 1,
              duration: const Duration(milliseconds: 400),
              child: AppButton(
                label: buttonLabel ?? 'button_apply'.tr,
                onTap: saveHandler,
                processing: processing ?? false,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
