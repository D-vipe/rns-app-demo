import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:rns_app/app/features/tasks/presentation/controllers/tasks_controller.dart';
import 'package:rns_app/app/utils/extensions.dart';
import 'package:rns_app/configs/routes/app_pages.dart';
import 'package:rns_app/resources/resources.dart';

class CreateTaskButton extends StatelessWidget {
  const CreateTaskButton({super.key});

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
        onPressed: () => TasksController.to.currentRoute.value = Routes.TASKSCREATE,
        icon: SvgPicture.asset(
          AppIcons.bookmarks,
          colorFilter: ColorFilter.mode(
            context.colors.white,
            BlendMode.srcIn,
          ),
        ),
        label: Text(
          'tasks_title_create'.tr,
          style: context.textStyles.bodyBold.copyWith(color: context.colors.white),
        ),
      ),
    );
  }
}
