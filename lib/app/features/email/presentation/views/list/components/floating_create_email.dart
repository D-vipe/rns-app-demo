import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:rns_app/app/features/email/presentation/controllers/email_controller.dart';
import 'package:rns_app/app/utils/extensions.dart';
import 'package:rns_app/configs/routes/app_pages.dart';
import 'package:rns_app/resources/resources.dart';

class CreateEmailButton extends StatelessWidget {
  const CreateEmailButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48.0,
      child: FloatingActionButton.extended(
        backgroundColor: context.colors.buttonActive,
        extendedPadding: const EdgeInsets.all(12.0),
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
        isExtended: true,
        onPressed: () => EmailController.to.currentRoute.value = Routes.EMAILCREATE,
        icon: SvgPicture.asset(
          AppIcons.localPostOffice,
          colorFilter: ColorFilter.mode(
            context.colors.white,
            BlendMode.srcIn,
          ),
        ),
        label: Text(
          'messages_title_create'.tr,
          style: context.textStyles.bodyBold.copyWith(color: context.colors.white),
        ),
      ),
    );
  }
}
