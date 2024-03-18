import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rns_app/app/features/email/domain/models/receiver_type_enum.dart';
import 'package:rns_app/app/features/email/presentation/controllers/email_create_controller.dart';
import 'package:rns_app/app/utils/extensions.dart';
import 'package:rns_app/configs/theme/miscellaneous.dart';

class EmployeesEmailSelectWidget extends GetView<EmailCreateController> {
  const EmployeesEmailSelectWidget({super.key, required this.type});

  final ReceiverType type;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppConstraints.screenPadding, vertical: 16.0),
      decoration: BoxDecoration(
        color: context.colors.backgroundPrimary,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16.0),
          topRight: Radius.circular(16.0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'messages_title_employeeMailBox'.tr.toUpperCase(),
            style: context.textStyles.header2,
          ),
          const SizedBox(
            height: 15,
          ),
          Expanded(
            child: Obx(
              () => ListView.separated(
                padding: const EdgeInsets.only(bottom: 25.0),
                itemCount: controller.employeesMailBoxes.length,
                itemBuilder: (context, index) {
                  Animation<Offset> itemAnimation = Tween<Offset>(
                    begin: Offset(-1.0 * (index + 1), 0.0),
                    end: const Offset(0.0, 0.0),
                  ).animate(
                    CurvedAnimation(
                      parent: controller.bottomSheetListAnimation,
                      curve: Curves.fastEaseInToSlowEaseOut,
                    ),
                  );
                  return SlideTransition(
                    position: itemAnimation,
                    child: TextButton(
                      style: ButtonStyle(
                        padding: MaterialStateProperty.resolveWith(
                          (states) => EdgeInsets.zero,
                        ),
                      ),
                      onPressed: () => controller.changeAdditionalFields(controller.employeesMailBoxes[index], type: type),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          controller.employeesMailBoxes[index].title,
                          style: context.textStyles.header3,
                        ),
                      ),
                    ),
                  );
                },
                separatorBuilder: (BuildContext context, int index) => Container(
                  height: 1.0,
                  color: context.colors.inputBackground,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
