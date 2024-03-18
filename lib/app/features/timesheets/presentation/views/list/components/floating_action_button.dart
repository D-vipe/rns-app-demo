import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:rns_app/app/features/timesheets/presentation/controllers/timesheets_controller.dart';
import 'package:rns_app/app/utils/extensions.dart';
import 'package:rns_app/configs/routes/app_pages.dart';
import 'package:rns_app/resources/resources.dart';

class TsFloatingActionButton extends GetView<TimeSheetController> {
  const TsFloatingActionButton({super.key});

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
        onPressed: () {
          controller.currentRoute.value = Routes.TSCREATE;
          controller.delegate.toNamed(controller.currentRoute.value);
        },
        icon: SvgPicture.asset(
          AppIcons.dateRange,
          colorFilter: ColorFilter.mode(
            context.colors.white,
            BlendMode.srcIn,
          ),
        ),
        label: Text(
          'timeSheets_create'.tr,
          style: context.textStyles.bodyBold.copyWith(color: context.colors.white),
        ),
      ),
    );
  }
}
